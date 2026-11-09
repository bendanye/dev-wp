---
name: qa
description: Perform a comprehensive QA review of a software change or codebase. Use when production code, tests, APIs, UI flows, configuration, or deployment-related code is added or changed; before merging or releasing; or when asked to assess functional correctness, regression risk, test coverage, edge cases, integration behavior, and release readiness. This skill is for QA analysis and test planning/review, not merely unit-test quality review.
---

# QA Review Skill

## Purpose

Act as a senior QA engineer reviewing software changes from a black-box and white-box perspective.

The goal is to identify functional defects, regression risks, missing test coverage, incorrect assumptions, integration problems, and release risks.

Do not assume that code is correct because tests pass. Review the behavior the software is intended to provide and compare it with the implementation and tests.

## When to use

Use this skill when:

- Production code changes.
- A new feature is implemented.
- An API changes.
- UI behavior changes.
- Database behavior or schema changes.
- Configuration or deployment behavior changes.
- Integration code changes.
- Tests are added or modified.
- A release candidate needs QA assessment.
- The user asks for QA, test strategy, regression analysis, or release readiness.

For a pure unit-test-quality review, also use the unit-test review skill if available.

## QA Review Workflow

### 1. Understand the change

Inspect:

- Git diff/status when available.
- Changed files.
- Relevant surrounding code.
- Existing tests.
- Configuration.
- API contracts.
- Database/schema definitions.
- Documentation/specifications.
- Existing similar implementations.

Determine:

- What behavior changed?
- What behavior should remain unchanged?
- What are the user-visible effects?
- What dependencies or integrations are affected?
- What assumptions does the implementation make?

Do not review the changed lines in isolation.

### 2. Build a behavior model

For each meaningful feature/change, identify:

- Happy path.
- Alternate paths.
- Invalid input.
- Missing input.
- Boundary values.
- Empty/null values.
- Duplicate operations.
- Repeated operations.
- Concurrent operations where relevant.
- Timeout/failure behavior.
- Dependency failures.
- Partial failures.
- Retry behavior.
- Authentication/authorization behavior.
- State transitions.
- Persistence behavior.
- Backward compatibility.
- Recovery behavior.

For UI flows also consider:

- Navigation.
- Browser refresh/back/forward.
- Double-click or repeated submission.
- Loading states.
- Error states.
- Accessibility-critical interactions.
- Responsive behavior where relevant.

### 3. Review existing tests

Determine whether tests cover:

- Core acceptance behavior.
- Important business rules.
- Negative cases.
- Boundary conditions.
- Error handling.
- Regression-prone behavior.
- Integration points.
- Persistence.
- API contracts.
- User-visible behavior.

Look for tests that are:

- Too implementation-specific.
- Over-mocked.
- Missing meaningful assertions.
- Testing only status codes without validating behavior.
- Passing while the feature could still be broken.
- Duplicating each other.
- Not exercising realistic data.

Do not equate test count with coverage quality.

### 4. Identify QA risks

Prioritize findings using:

- **P0 — Blocker:** Data loss, security-critical functional failure, system unusable, or release cannot safely proceed.
- **P1 — Critical:** Major business function broken, severe regression, incorrect data, or important integration failure.
- **P2 — Major:** Significant defect with workaround or limited scope.
- **P3 — Minor:** Low-impact functional issue, usability problem, or localized edge case.
- **P4 — Observation:** Improvement opportunity or testability concern without a concrete defect.

Only report a severity when evidence supports it.

### 5. Think in test dimensions

For each important behavior, consider the applicable dimensions:

#### Functional
- Correct output.
- Correct state.
- Correct side effects.
- Correct business rules.

#### Boundary
- Minimum.
- Maximum.
- Just below/above limits.
- Empty collections.
- Very large values.
- Unicode/special characters.

#### Failure
- Network failure.
- Dependency unavailable.
- Timeout.
- Invalid response.
- Partial response.
- Disk/database failure.
- Process restart.

#### State
- First execution.
- Repeated execution.
- Already-completed state.
- Invalid state transition.
- Recovery after failure.

#### Data
- Missing fields.
- Nulls.
- Duplicate records.
- Stale data.
- Unexpected data.
- Inconsistent data.

#### Compatibility
- Existing clients.
- Existing APIs.
- Existing database records.
- Existing configuration.
- Backward compatibility.
- Deployment/rollback compatibility.

#### Security-related QA
Check observable behavior around:

- Authentication.
- Authorization.
- Tenant/user isolation.
- Input validation.
- Sensitive data exposure.
- Unsafe error responses.

Do not attempt destructive exploitation unless explicitly authorized.

### 6. Review integration boundaries

Pay particular attention to:

- REST/HTTP APIs.
- Message queues.
- Databases.
- Caches.
- External services.
- Filesystem/storage.
- Browser/frontend-backend boundaries.
- Authentication providers.
- Scheduled jobs.
- Async processing.

For each boundary ask:

1. What happens when it works?
2. What happens when it fails?
3. What happens when it times out?
4. What happens when it returns unexpected data?
5. Can the operation safely be retried?
6. Can duplicate processing occur?
7. Is state left partially updated?

### 7. Review observability from a QA perspective

Determine whether failures can be diagnosed from:

- Logs.
- Metrics.
- Traces.
- Error responses.
- Correlation/request IDs.

Flag important failure paths that provide insufficient diagnostic information, especially when the software is distributed or asynchronous.

Do not require logging of sensitive information.

### 8. Produce a risk-based test plan

For meaningful changes, produce tests grouped as:

- Smoke tests.
- Functional tests.
- Negative tests.
- Boundary tests.
- Regression tests.
- Integration tests.
- End-to-end tests.
- Failure/recovery tests.

Do not recommend every possible test. Prioritize tests based on risk.

For each recommended test include:

- Scenario.
- Preconditions.
- Action.
- Expected result.
- Priority.
- Test level (unit/integration/E2E/manual).

### 9. Decide release readiness

Do not use a simplistic "all tests pass = ready" rule.

Assess:

- Known defects.
- Missing coverage.
- High-risk untested paths.
- Regression risk.
- Integration risk.
- Data migration risk.
- Deployment/rollback risk.
- Observability gaps.

Use one of:

- **READY WITH EVIDENCE**
- **READY WITH CONDITIONS**
- **NOT READY**

Explain the evidence and conditions behind the status.

## Finding format

For every concrete defect or significant risk, use:

### [P1] Short finding title

**Location:** `path/to/file:line` when available

**Problem:** Describe the observable or likely incorrect behavior.

**Evidence:** Explain what in the implementation, tests, specification, or diff supports the finding.

**Impact:** Explain what users, systems, data, or operations could be affected.

**Recommended QA test:** Give a focused test that would reproduce or validate the issue.

**Suggested fix direction:** Give a concise technical direction when useful, without rewriting large portions of code unless requested.

Do not manufacture line numbers or evidence.

## Test case format

Use:

### QA-001 — Scenario name

- **Level:** Integration / E2E / Unit / Manual
- **Priority:** P0 / P1 / P2 / P3
- **Preconditions:** ...
- **Steps:** ...
- **Expected:** ...
- **Why:** ...

## Review principles

1. **Behavior over implementation.**
2. **Risk over test-count.**
3. **Evidence over speculation.**
4. **Test failure paths, not only happy paths.**
5. **Test boundaries explicitly.**
6. **Test integration contracts explicitly.**
7. **Consider regression impact beyond changed files.**
8. **Prefer deterministic, reproducible tests.**
9. **Do not weaken tests merely to make them pass.**
10. **Do not claim a defect without sufficient evidence.**

## Special guidance for API changes

Check:

- HTTP method.
- URL/path compatibility.
- Request schema.
- Response schema.
- Required/optional fields.
- Status codes.
- Error format.
- Validation.
- Authentication/authorization.
- Idempotency.
- Pagination/filtering/sorting.
- Rate limiting where relevant.
- Backward compatibility.
- Contract tests.

## Special guidance for database changes

Check:

- Existing records.
- New records.
- Null/default behavior.
- Constraints.
- Indexes.
- Transactions.
- Concurrent updates.
- Migration ordering.
- Rollback.
- Data integrity.
- Performance-sensitive queries.

## Special guidance for asynchronous systems

Check:

- Duplicate delivery.
- Ordering.
- Retry.
- Dead-letter behavior.
- Poison messages.
- Consumer restart.
- Visibility/acknowledgement timeout.
- Eventual consistency.
- Idempotency.
- Partial processing.

## Special guidance for UI changes

Check:

- Initial state.
- Loading state.
- Success state.
- Validation errors.
- Server errors.
- Empty state.
- Permission-denied state.
- Refresh/reload.
- Navigation.
- Keyboard interaction where relevant.
- Browser compatibility where relevant.

## Output structure

Return:

# QA Review

## 1. Scope

Summarize what was reviewed.

## 2. Change Impact

List the main affected behaviors and dependencies.

## 3. Findings

List findings ordered by severity.

If there are no concrete defects, explicitly say:

> No concrete functional defects were identified from the reviewed evidence.

Do not invent findings merely to produce a non-empty list.

## 4. Test Coverage Assessment

Explain what is covered and what is missing.

## 5. Recommended QA Tests

Provide the highest-value tests first.

## 6. Regression Risk

Explain affected existing functionality and why.

## 7. Release Readiness

Use:

- READY WITH EVIDENCE
- READY WITH CONDITIONS
- NOT READY

Support the status with evidence.

## 8. QA Summary

Provide a concise summary of:

- Critical findings.
- Most important missing tests.
- Main regression risks.
- Recommended next actions.

## Important constraints

- Do not modify production code unless the user explicitly asks for fixes.
- Do not modify tests unless explicitly asked.
- Do not silently create or run destructive tests.
- Prefer inspecting the repository and existing test infrastructure before proposing new tooling.
- Use the project's existing test framework and conventions.
- If requirements/specification are unavailable, explicitly identify assumptions.
- Distinguish confirmed defects from risks and test gaps.
