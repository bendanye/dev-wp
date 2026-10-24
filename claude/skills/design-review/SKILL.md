---
name: design-review
description: Software architecture and code design review methodology. Use when reviewing changes that add or restructure modules, classes, services, layers, or dependencies, for coupling, cohesion, abstractions, and maintainability.
---

# Design Review Skill

## Check

### Separation of concerns
- business logic vs transport
- persistence vs domain logic
- infrastructure vs application logic
- configuration vs implementation

### Coupling and cohesion
- unnecessary dependencies
- circular dependencies
- excessive knowledge between modules
- classes/modules doing unrelated jobs

### Abstractions
- premature abstractions
- missing abstractions causing duplication
- leaky abstractions
- inappropriate inheritance
- unnecessary indirection

### Maintainability
- complexity
- duplication
- unclear responsibilities
- hard-coded behavior
- difficult-to-test code

### Dependency direction
- stable components should not unnecessarily depend on volatile details
- avoid architecture violations

### Extensibility
- identify designs likely to make expected future changes unnecessarily costly

## Severity

- CRITICAL: security, data loss/corruption, severe breakage, severe reliability
- HIGH: significant correctness or operational problem likely to hit production
- MEDIUM: maintainability or moderate operational/design gap
- LOW: minor improvement

## Rules

Review the existing architecture, not an idealized architecture.
Do not recommend large rewrites without evidence.

Each finding must explain the concrete maintenance, correctness,
reliability, or extensibility impact.
