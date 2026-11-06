---
name: unit-test-review
description: Unit-test review methodology. Use whenever production code or unit tests change, including bug fixes, to assess whether tests meaningfully protect the changed behavior.
---

# Unit Test Review Skill

## Trigger condition

This review should be considered whenever:
- production code changes
- unit tests change
- a new production behavior is introduced
- a bug fix changes behavior

A production-code change does not need to add a test mechanically, but the
review must explicitly determine whether existing tests sufficiently protect
the changed behavior.

## Check

### Coverage
- normal path
- boundary values
- invalid input
- error/failure paths
- important branches
- regression scenarios

### Assertions
- assertions verify behavior, not implementation trivia
- assertions are meaningful and sufficiently specific
- tests do not pass while the intended behavior is broken

### Test isolation
- independent tests
- no accidental ordering dependency
- deterministic data
- controlled external dependencies

### Mocks
- mocks are used where appropriate
- mocks do not hide the behavior being tested
- avoid excessive mocking of implementation details

### Maintainability
- clear test names
- useful fixtures
- minimal duplication
- readable setup
- stable tests

### Regression value
For bug fixes, ensure a test would fail under the old broken behavior.

## Severity

HIGH:
- important changed behavior has no meaningful test protection
- regression-prone bug fix has no regression test
- tests can pass while important behavior is broken

MEDIUM:
- significant edge/failure path missing
- weak assertions
- fragile isolation

LOW:
- readability or minor maintainability issues

## Output

For every finding provide location, severity, missing/weak behavior,
why it matters, and recommended test scenario.
