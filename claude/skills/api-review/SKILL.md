---
name: api-review
description: API review methodology. Use when reviewing changes to HTTP/REST, gRPC or GraphQL endpoints, controllers, request/response models, OpenAPI specs, or public library interfaces, for contract correctness, validation, compatibility, errors, and security.
---

# API Review Skill

## Check

- API naming and consistency
- Request/response contracts
- Input validation
- Required vs optional fields
- Backward compatibility
- HTTP semantics/status codes where applicable
- Error response consistency
- Authentication and authorization boundaries
- Sensitive data exposure
- Pagination/filtering/sorting conventions
- Idempotency where relevant
- Versioning/deprecation
- Timeout/retry behavior where API clients are involved
- Documentation/contract alignment
- Consistency with existing APIs

## Severity

- CRITICAL: security, data loss/corruption, severe breakage, severe reliability
- HIGH: significant correctness or operational problem likely to hit production
- MEDIUM: maintainability or moderate operational/design gap
- LOW: minor improvement

## Rules

Do not flag an issue merely because you prefer a different design.
Compare against repository conventions and actual requirements.

For each finding provide:
- severity
- location
- concrete problem
- impact
- recommendation
