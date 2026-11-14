---
name: edge-case-analyzer
description: Edge case analysis of existing code. Traces how a function, class, module, endpoint, or script behaves on unusual inputs and states (empty, null, boundary, malformed, huge, duplicate, concurrent, failing dependencies, time/locale quirks) and reports concrete inputs that break it, with evidence and suggested fixes. Use whenever the user asks to find edge cases, corner cases, "what could break this", "what inputs would fail", "is this robust", "harden this", "stress-test this logic", or wants a robustness check of code that already exists, even if it is not part of a diff and even if they don't say "edge case". For reviewing a pending change for release readiness, prefer qa-review; for judging test quality, prefer unit-test-review.
---

# Edge Case Analyzer

## Purpose

Find the inputs and situations under which existing code misbehaves: crashes,
returns a wrong answer, corrupts state, hangs, or silently drops data.

The value of this analysis is in being concrete. "Null input may cause issues"
is noise the reader can't act on. "`parse_amount("1,000")` returns `1` because
`int()` stops at the comma — line 42" is a finding they can reproduce, test,
and fix. Every finding should be specific enough to turn into a failing test.

This is an analysis skill. Do not modify production code unless the user asks
for fixes; writing throwaway probe scripts or tests in a scratch location to
confirm a suspicion is encouraged.

## Workflow

### 1. Pin down the target and its contract

Identify exactly what is being analysed: a function, class, file, module,
endpoint, CLI, or job. If the user pointed vaguely ("check the billing code"),
pick the entry points that take external input and say which ones you chose.

Then work out the contract — what the code is *supposed* to do — from, in
order of trust:

1. Explicit specs, docs, docstrings, type signatures, API schemas.
2. Existing tests (they show what the author thought mattered).
3. Callers (how it is actually used, and what they pass in).
4. Names and the obvious intent of the code.

An edge case is only a bug relative to a contract. When the contract is
genuinely unclear (e.g. should an empty list return 0 or raise?), report it as
an **ambiguity** rather than a defect, and say what each reasonable reading
implies.

### 2. Map the input space

List every source of variation that reaches the code, not just parameters:

- Arguments and their types, including optional/default values.
- Fields of objects, records, request bodies, config, env vars.
- External reads: files, DB rows, HTTP responses, queues, caches, clock,
  randomness, locale/timezone, filesystem state.
- Prior state: is this the first call, a repeated call, a call after a failure?
- Concurrency: can two callers be in here at once?

Check where validation happens. Input that is validated upstream by every
caller is lower risk than input that arrives raw — look at the callers before
assuming either way.

### 3. Generate candidate edge cases

Walk each input through the categories in
[references/edge-case-catalog.md](references/edge-case-catalog.md). Read it the
first time you use this skill in a session; it lists the specific values and
situations worth trying per category (numbers, strings, collections, time,
I/O, concurrency, state) plus language-specific traps.

Don't apply the catalog mechanically. Prioritise cases that the code's own
structure hints at:

- **Every branch condition** — what happens exactly at, just below, and just
  above the threshold? Is `<` vs `<=` right?
- **Every loop** — zero iterations, one iteration, very many, early exit.
- **Every index, slice, division, parse, cast** — out of range, zero, invalid
  format, overflow, precision loss.
- **Every external call** — failure, timeout, empty/partial/unexpected
  response, being called twice.
- **Every assumption written as a comment or variable name** ("always
  non-empty", `sortedItems`) — what if it's false?
- **Every early return / exception handler** — is state left half-updated?
  Is the exception swallowed? Does a broad `catch` hide a real failure?

### 4. Trace each candidate through the code

For each candidate, follow it line by line to an outcome. Classify:

- **Crash** — unhandled exception, panic, segfault, process exit.
- **Wrong result** — returns or persists an incorrect value without error.
- **Silent data loss / corruption** — input dropped, truncated, partially
  written, duplicated.
- **Hang / resource blowup** — infinite loop, unbounded memory, quadratic
  blowup on realistic sizes, leaked handles/connections.
- **Security-relevant** — injection, path traversal, auth bypass, leaking
  data across users/tenants through an edge path.
- **Handled** — the code deals with it correctly. Keep a short list of these;
  it shows the reader what you checked and stops them wondering.

Discard candidates that the trace shows are unreachable (e.g. the type system
or an upstream validator rules them out) — but say so briefly if a reader
would naturally worry about them.

### 5. Confirm when it's cheap

A trace can be wrong; a run can't. When the code can be executed safely in
isolation (pure functions, parsers, utilities, code with an existing test
harness), write a small probe — a scratch script or a temporary test — and run
it with the suspect input. Report the actual output.

Don't run anything that touches real databases, external services, production
config, or deletes/overwrites files. In those cases, rely on the trace and say
the finding is unconfirmed.

Mark each finding:

- **Confirmed** — reproduced by running code; include the command/output.
- **Traced** — follows clearly from reading the code, not executed.
- **Suspected** — plausible but depends on something you couldn't verify
  (runtime config, caller behaviour, library internals). Say what would
  settle it.

### 6. Prioritise

Rank by impact × likelihood, not by how clever the edge case is.

- **HIGH** — realistic input causes crash, wrong persisted data, data loss,
  or a security problem.
- **MEDIUM** — wrong result or crash on input that is uncommon but legitimate,
  or a failure that's handled but poorly (misleading error, partial state).
- **LOW** — needs contrived input, or the impact is cosmetic.

An empty string reaching a public API is realistic. A 2^63 element list is
not. A leap day *will* happen. Be honest about likelihood — a long list of
theoretical LOWs buries the one HIGH that matters.

## Output format

Use this structure:

```markdown
# Edge Case Analysis: <target>

## Scope
What was analysed (files/functions/entry points), the contract you inferred
and where it came from, and anything deliberately excluded.

## Summary
2–4 sentences: overall robustness, the most important problems, counts by
severity.

## Findings

### [HIGH] <short title naming the input and the failure>
- **Location:** `path/to/file.ext:line` (function name)
- **Input / situation:** the exact value or scenario, e.g. `items=[]`,
  `"2024-02-29"`, "DB returns zero rows", "called twice concurrently".
- **What happens:** the traced or observed behaviour, step by step if
  non-obvious.
- **Expected:** what the contract says should happen.
- **Status:** Confirmed / Traced / Suspected (+ probe output if confirmed).
- **Suggested fix:** a concise direction or small snippet.
- **Test to add:** one-line description or short test code that would fail
  today.

(repeat, most severe first)

## Ambiguities
Behaviours where the contract is unclear and the owner needs to decide.

## Checked and handled
Brief bullet list of edge cases that the code already handles correctly.

## Suggested test cases
A compact table or list of the edge-case tests worth adding, ordered by
priority, if not already covered under findings.
```

Never invent line numbers, outputs, or behaviour you didn't trace. If the
target is large, it's fine to analyse the highest-risk entry points thoroughly
and list the rest as not covered, rather than skimming everything shallowly.

## Principles

1. **Concrete over generic.** A specific input and outcome beats a category name.
2. **Contract first.** Know what "correct" means before calling something a bug.
3. **Follow the code's own seams.** Branches, loops, casts, and external calls
   are where edge cases live.
4. **Verify cheaply when you can.** Running a probe beats arguing from reading.
5. **Rank honestly.** Realistic and damaging beats exotic and harmless.
6. **Show your coverage.** Listing what's handled makes the analysis trustworthy.
