---
name: comments-review
description: Code comment review and cleanup. Trims cruft from valid comments, deletes comments that are wrong, stale, or redundant, and flags comments that are really papering over code that should have been refactored (better names, extracted functions, named constants, types). Use whenever the user asks to review, clean up, tidy, or prune comments, docstrings, or TODOs in a diff, file, or PR, or says things like "too many comments", "these comments are noisy", "are these comments still right", or "de-slop this" — even if they don't say "review".
---

# Comments Review Skill

Your sole job is the comments. Do not review logic, style, naming, or tests
except where a comment points at them. Every comment in scope ends up in
exactly one of three buckets: **trim**, **kill**, or **refactor instead**.
Comments that are already tight and correct are left alone and not reported.

## Scope

- Default: comments added or changed in the current diff (`git diff` against
  the base branch, plus staged/unstaged changes). Pre-existing comments in
  untouched lines are out of scope unless the user points at a file/path.
- If the user gives a file, directory, or PR, review all comments there.
- Includes line comments, block comments, docstrings/JSDoc/KDoc/Javadoc,
  TODO/FIXME/HACK markers, and commented-out code.
- Excludes license headers, generated files, linter/compiler directives
  (`// eslint-disable`, `# type: ignore`, `//go:build`, `@SuppressWarnings`
  rationale aside), and comments the tooling parses (e.g. OpenAPI annotations).

Read the code each comment describes before judging it. A comment can only be
called wrong after checking what the code actually does.

## The test for every comment

A good comment says something the code cannot: **why** it is this way, a
non-obvious constraint, a gotcha, a link to the ticket/spec/incident, or the
contract of a public API. Ask: "If I deleted this, what would a competent
reader lose?" If the answer is "nothing", it goes.

## 1. Kill — delete outright

- **Wrong**: contradicts the code (says "returns null" but throws; names a
  parameter that no longer exists; describes old behaviour).
- **Stale**: references removed code, finished TODOs, closed tickets,
  past migrations ("temporary until v2 ships" when v2 shipped).
- **Narration**: restates the next line (`// increment counter`,
  `// loop over users`, `// call the API`).
- **Echo docstrings**: `getName() — Gets the name.` `@param id the id`.
  Delete the whole docstring if every part of it is an echo; keep it if the
  function is public API and the docstring carries real contract info.
- **Commented-out code**: version control already has it. Kill unless an
  adjacent comment explains why it must stay visible.
- **Change-log / authorship / journaling**: `// added by Ben 2024-03`,
  `// fixed bug`, `// updated to use new client`, `// now handles X`.
  That belongs in commit messages.
- **Conversation residue**: comments addressed to a reviewer or an AI
  session (`// as requested`, `// this is the fix for the issue above`,
  `// Note: I changed this to...`).
- **Section dividers and banners** that add no information
  (`// ===== helpers =====` in a 40-line file).
- **Orphaned TODOs** with no owner, ticket, or actionable content
  (`// TODO: improve this`).

## 2. Trim — keep the point, cut the cruft

The comment carries real information but is padded. Rewrite it to the
shortest form that keeps the meaning. Cruft to strip:

- Narration wrapped around the real "why" — keep only the why.
- Hedging and filler: "basically", "simply", "just", "note that",
  "it's important to", "we need to make sure that", "in order to".
- Restating the function/variable name before getting to the point.
- Multi-paragraph explanations where one sentence will do.
- Over-specific details that will rot (exact line numbers, "see the
  function below", current call-site counts).
- Docstring sections that only echo types/names, while keeping sections
  that add contract info (units, ranges, nullability, side effects, throws).

Preserve: ticket/issue links, spec references, warnings, units, invariants,
performance/security/concurrency caveats, and anything about *why not* the
obvious approach.

## 3. Refactor instead — the comment is a symptom

The comment exists because the code is unclear. The fix is to change the
code so the comment is unnecessary. Flag these; do not perform the refactor
unless the user asks. Common shapes:

| Comment pattern | Should have been |
|---|---|
| Explains what a variable/param holds (`// timeout in ms`) | Rename (`timeoutMs`) or use a typed value (`Duration`) |
| Labels a block (`// validate input`, `// build the request`) | Extract a well-named function |
| Explains a magic number/string (`// 86400 = one day`) | Named constant |
| Decodes a complex boolean (`// user is active and not banned`) | Extract to a named predicate / variable |
| Lists allowed values (`// "A", "B" or "C"`) | Enum / union type |
| Warns about call order (`// must call init() first`) | Constructor/builder that enforces it |
| Explains a flag argument (`process(x, true /* dryRun */)`) | Named param, options object, or two functions |
| Says "this is a hack" / "workaround" with no ticket | Fix it, or keep comment + add ticket (note which) |
| Documents what each branch of a long if/switch means | Polymorphism, lookup table, or extracted handlers |

A comment can be both "refactor instead" and still worth keeping until the
refactor lands — say so if that is the case.

## Judgement calls

- Public API docs (exported functions, library interfaces) earn more slack
  than private helpers: callers can't read the body. Trim, don't kill, unless
  pure echo.
- Respect project conventions. If the codebase requires docstrings on every
  public method, don't kill them — trim them.
- Regex, bit-twiddling, non-obvious algorithms, and workarounds for
  third-party bugs usually deserve comments. Lean toward keeping.
- When unsure whether a comment is wrong, say what you checked and mark it
  "verify" rather than guessing.

## Applying changes

- If the user asked to **review**: report only.
- If the user asked to **clean up / fix / prune / apply**: apply kills and
  trims directly to the files, then report what changed. Never apply
  "refactor instead" items without an explicit go-ahead — they change code,
  not comments.
- Never alter code behaviour while editing comments.

## Output

Group by bucket, then by file. Keep each entry to one or two lines.

```
## Kill (N)
- path/to/file.ts:42 — `// increment retry count` — narration of next line
- path/to/file.ts:88 — docstring on `getUser` — wrong: says returns null, actually throws NotFoundError

## Trim (N)
- path/to/file.py:17
  before: # Basically we need to make sure that we wait here because the upstream API rate-limits us to 10 req/s (see JIRA-123)
  after:  # Upstream rate-limits to 10 req/s (JIRA-123)

## Refactor instead (N)
- path/to/service.go:64 — `// 3 = max retries` → named constant `maxRetries`
- path/to/handler.kt:120 — `// validate the payload` labels a 25-line block → extract `validatePayload()`

## Summary
X comments reviewed · K killed · T trimmed · R refactor candidates · rest left as-is
```

If nothing needs changing, say so in one line.
