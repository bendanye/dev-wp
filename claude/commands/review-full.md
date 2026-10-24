---
description: Run a comprehensive software review across all review dimensions in parallel
argument-hint: "[branch | commit range | paths]"
---

Run a comprehensive review of the code changes.

Scope: $ARGUMENTS
(If no scope is given above, review uncommitted changes (`git diff HEAD` plus
untracked files). If there are none, review the current branch against the
default branch.)

## Process

1. Inspect the diff for the scope above and decide which dimensions apply.
2. Launch the applicable reviewer agents **in parallel, in a single message**,
   passing each the same scope:
   - `api-reviewer`
   - `design-reviewer`
   - `unit-test-reviewer`
   - `logging-reviewer`
3. If GitLab CI files changed (`.gitlab-ci.yml`, included CI YAML), also apply
   the `gitlab-ci-review` skill to those files.
4. Once all reviews return, verify each finding against the actual code and
   drop any that don't hold up.
5. Merge duplicate findings and produce one report in the format below.

Do not modify code.

## Severity

- CRITICAL: security, data loss/corruption, severe breakage, severe reliability
- HIGH: significant correctness, important test gaps, major observability/design problems
- MEDIUM: maintainability, moderate test/operational/design gaps
- LOW: minor improvements

## Final report

# Software Review

## Summary
- Overall assessment:
- Critical / High / Medium / Low findings:

## Findings

### [SEVERITY] Title
**Category:** API / Design / Unit Test / Logging / CI
**Location:** `path:line`

**Problem** ...
**Why it matters** ...
**Recommendation** ...

## Review Results
- API Review: PASS / FINDINGS / NOT APPLICABLE
- Design Review: PASS / FINDINGS / NOT APPLICABLE
- Unit Test Review: PASS / FINDINGS / NOT APPLICABLE
- Logging Review: PASS / FINDINGS / NOT APPLICABLE
- GitLab CI Review: PASS / FINDINGS / NOT APPLICABLE

## Final Assessment
APPROVE / APPROVE WITH COMMENTS / CHANGES REQUESTED
