---
name: test-suite-audit
description: Audits an existing test suite (or a directory/module of it) for tests that give false confidence — tautological tests that cannot fail, tests so coupled to internal structure that they break on harmless refactors, and mocks/stubs/fakes whose behaviour does not match the real dependency. Reports individual tests and recurring patterns as groups, with evidence and fixes. Use whenever the user asks to audit, assess, or clean up their tests, asks "are my tests any good", "which tests are useless", "why do tests pass but prod breaks", "our tests break on every refactor", "too much mocking", "do these mocks reflect reality", or wants to find low-value, brittle, or misleading tests — even if they don't name these three categories. For reviewing whether a specific diff is adequately tested, prefer unit-test-review.
---

# Test Suite Audit

## Purpose

Find tests that look like protection but aren't. Three failure modes, each
answering a different question:

| Category | The question | Symptom in the wild |
|---|---|---|
| **Tautological** | Could this test ever fail? | Green suite, bug ships anyway |
| **Structure-sensitive** | Would it break under a refactor that keeps behaviour identical? | Every refactor turns 40 tests red, nobody trusts red |
| **Stub/reality mismatch** | Does the fake behave like the real thing? | Tests pass, integration/prod fails on the exact path "covered" |

A test can be in more than one. Coverage gaps (behaviour with *no* test) are
out of scope — that is `unit-test-review` / `qa-review` territory. Only mention
a gap if fixing a finding naturally exposes it.

This is an analysis skill. Don't edit tests or production code unless the user
asks for fixes. Temporary probes to confirm a finding are encouraged (see
step 5).

## Workflow

### 1. Map the suite

Establish quickly, without reading every file:

- Language(s), test framework(s), mocking library, how tests are run.
- Where tests live, rough count of files/tests, and how they're split
  (unit / integration / e2e / contract). Integration and e2e tests are rarely
  tautological via mocks but can still be structure-sensitive (e.g. brittle
  selectors, exact-HTML snapshots).
- Shared fixtures, factories, fakes, `conftest.py`, test helpers, custom
  matchers — problems here multiply across every test that uses them, so they
  are high-leverage to inspect.

If the user named a directory, module, or file, stay inside it (but still read
the production code and real dependencies the tests touch). If the suite is
large, say which slice you audited and why (e.g. most-mocked modules, core
domain, recently churned), rather than skimming everything shallowly.

### 2. Scan for signals

Use grep to find candidates cheaply, then read them. Language-specific
patterns are in [references/signals.md](references/signals.md) — read it the
first time you use this skill in a session. Signals are leads, not findings:
`verify(...)` is fine when the call *is* the behaviour (sending an email,
publishing an event); `Mock()` without a spec is fine if the test never relies
on its shape.

### 3. Judge each candidate against the real code

The core move is always: **open the production code and the real
dependency, and compare.** A test can only be called tautological, brittle, or
mismatched relative to what the code actually does.

#### Tautological — can't fail, or can only fail for irrelevant reasons

- **Asserts the stub**: stubs `repo.find()` to return X, then asserts the
  result is X, with the unit under test merely passing it through (or not
  being called at all).
- **Mirrors the implementation**: expected value is computed by the same
  formula/function as the code (`expected = price * TAX_RATE` copied from
  prod, or calling the prod helper to build the expectation).
- **No meaningful assertion**: no assert at all, only `assertNotNull`,
  `toBeDefined`, `assert result`, "doesn't throw" where throwing was never the
  risk, or `assertTrue(true)`.
- **Swallowed failure**: assertions inside a `try` with a broad `catch`,
  inside a callback/promise that's never awaited, inside a loop over an empty
  collection, or after an early `return`.
- **Tests the framework/language**: asserting a dataclass stores its fields,
  a getter returns what the setter set, a DI container wires a bean, an enum
  has its values.
- **Mocks the unit under test**: the class being tested is itself mocked or
  partially mocked (spy) so the real logic never runs.
- **Rubber-stamped snapshots**: large snapshots nobody reads, regenerated on
  every change; the "assertion" is whatever the code currently produces.
- **Unsatisfiable expectation**: e.g. Python `mock.assert_called_once_wiht(...)`
  (typo silently passes on old `Mock`), `expect(x)` with no matcher, missing
  `assertThat(...).isTrue()` terminal in fluent assertion chains.

The litmus test: **mentally delete or invert the key line of production
logic. Does the test go red?** If not, it's tautological.

#### Too structure-sensitive — breaks on behaviour-preserving changes

- **Interaction-verification of internals**: `verify(helper).step1()`,
  `verify(helper).step2()`, `inOrder`, exact `times(n)` on collaborators whose
  calls aren't the externally visible behaviour.
- **Reaching into privates**: reflection, `_private` attribute access,
  `@VisibleForTesting` widened methods, `Whitebox`, `ReflectionTestUtils`,
  `jest.spyOn(obj, 'privateMethod')`, rewire.
- **Mocking things that should be real**: value objects, DTOs, data
  classes, pure functions, collections, the module's own internal helpers.
- **Over-precise assertions on incidental output**: full error message text,
  exact log lines, full JSON/HTML equality where only some fields matter,
  ordering of an unordered result, float equality without tolerance, CSS
  selectors tied to layout (`div > div:nth-child(3)`).
- **One test file per class, one test per method**, mirroring structure
  instead of behaviour, so moving a method between classes means rewriting
  tests that should not have cared.
- **Patch targets coupled to import paths** (`@patch('pkg.mod.helper')`) for
  code that is an internal detail rather than a boundary.

The litmus test: **imagine an obvious refactor (rename a private method,
inline a helper, split a class, reorder two independent calls). Does the test
go red while the feature still works?** If yes, it's structure-sensitive.
Name the specific refactor in the finding.

#### Stubs don't match reality — the fake lies

For each stub/mock/fake of a dependency, find the real implementation (the
production class, the library's source or types, the API schema/contract,
recorded fixtures, the DB schema) and compare:

- **Shape**: returned field names, nesting, types (`"id": 1` vs real
  `"id": "abc"`), `null` vs empty list vs missing key, pagination wrapper,
  response envelope, `Optional` vs nullable.
- **Signature**: stubbed method doesn't exist, takes different arguments,
  is sync in the stub but async for real (or vice versa). Un-specced mocks
  (`Mock()` without `spec`/`autospec`, `jest.fn()` cast `as any`) will happily
  accept all of these.
- **Error behaviour**: stub raises an exception type the real dependency
  never raises, or the real one raises/returns errors the stub never models
  (timeouts, 404 → `None` vs exception, rate limits, constraint violations).
- **Semantics of fakes**: in-memory repos that don't enforce uniqueness,
  transactions, ordering, case-sensitivity, or cascades that the real DB does;
  fake clocks/queues that deliver synchronously when the real one is async.
- **Stale stubs**: the real interface changed (field renamed, endpoint
  versioned) and the stub was never updated — check git history of both
  when in doubt.
- **Impossible states**: a stub returns a combination the real system cannot
  produce, so the test exercises a branch prod never hits while the branch
  prod *does* hit is untested.

The litmus test: **if you swapped the stub for the real dependency, would the
test still pass for the same reason?** Cite the line in the real code (or
schema/types) that shows the difference.

### 4. Group recurring patterns

Many problems are systemic: a shared fixture with the wrong shape, a team
habit of `verify`-ing every collaborator, a helper that builds expectations
with the prod function. Report these once as a **group** with a count, a
representative example or two, and the list of affected tests/files — not as
twenty near-identical findings. Shared fixtures and fakes deserve a group even
when only one is wrong, because every consumer inherits the lie.

### 5. Confirm when it's cheap

A trace can be wrong; a run can't. Ways to confirm without lasting changes:

- **Mutation probe** (tautology): temporarily break the relevant prod line,
  run just that test, observe it still passes, restore. Only do this on files
  with no uncommitted changes (check `git status` first), and restore with
  `git checkout -- <file>` (or from a copy you made) immediately after.
- **Refactor probe** (structure-sensitivity): same idea with a
  behaviour-preserving change.
- **Reality probe** (stubs): call the real pure dependency, inspect its type
  definitions/schema, or check recorded fixtures/contract files.

Never run probes that touch real databases, external services, or production
config. If tests are slow or the environment isn't set up, rely on reading and
mark findings accordingly.

Mark each finding **Confirmed** (probe run; include command + result),
**Traced** (clear from reading test and real code), or **Suspected** (depends
on something you couldn't check; say what would settle it).

### 6. Prioritise

Rank by how much false confidence the test creates for code that matters.

- **HIGH** — the test is the only thing "covering" important behaviour
  (money, auth, data integrity, a known past bug) and it cannot catch a
  regression there; or a stub mismatch hides a failure mode that will happen
  in prod.
- **MEDIUM** — tautological/mismatched tests on less critical paths;
  structure-sensitivity widespread enough to materially slow refactoring or
  train people to blindly update tests.
- **LOW** — isolated brittleness, trivial tautologies on trivial code
  (often the fix is simply deleting the test).

Be honest: deleting a useless test is a perfectly good recommendation, and
"this mock-heavy test is fine because the interaction *is* the contract" is a
perfectly good conclusion.

## Output format

```markdown
# Test Suite Audit: <scope>

## Scope
What was audited (paths, frameworks, test counts), what was sampled vs read
fully, what was excluded and why.

## Summary
3–5 sentences: overall health, the systemic patterns, counts per category and
severity, and the single most important thing to fix.

## Systemic patterns
### [SEVERITY] <pattern name> — <N> tests across <M> files
- **Category:** Tautological / Structure-sensitive / Stub mismatch
- **Pattern:** what the tests do, in one or two sentences.
- **Example:** `path/to/test_file.ext:line` (`test_name`) with a short excerpt.
- **Why it's a problem:** concrete — the regression it misses, the refactor
  it blocks, or the real behaviour it misrepresents (cite real code line).
- **Affected:** list of tests/files (or the grep that finds them).
- **Fix:** the general remedy, with a before/after sketch if helpful.

## Individual findings
### [SEVERITY] <test name> — <short claim>
- **Location:** `path/to/test_file.ext:line`
- **Category:**
- **Evidence:** what the test does vs what the real code/dependency does,
  with line references to both.
- **Status:** Confirmed / Traced / Suspected (+ probe output if confirmed)
- **Fix:** rewrite direction, or "delete".

(most severe first)

## Looked fine
Brief notes on areas checked that hold up — e.g. "payment tests use the real
`Money` type and assert on outcomes; mocks limited to the HTTP gateway with
specs". This tells the reader what was covered and keeps the audit credible.

## Suggested next steps
Short, ordered list: which group to fix first, any tooling that would prevent
recurrence (autospec, strict stubs, contract tests, `assertions` lint rules,
mutation testing on the core module).
```

Never invent line numbers, test names, or probe results. Quote short excerpts
so the reader can verify without opening the file.

## Principles

1. **Compare against reality.** Every claim is relative to the production
   code or the real dependency — open it.
2. **Use the litmus tests.** Delete-the-logic, refactor-it, swap-in-the-real-thing.
3. **Patterns over instances.** Group systemic issues; fix the fixture, not 30 tests.
4. **Don't flag style.** A test you'd write differently isn't a finding unless it
   fits one of the three categories.
5. **Rank by false confidence on important code.** A useless test on a getter
   matters far less than a useless test on the refund path.
