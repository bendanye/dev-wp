---
name: generate-spec
description: Generates a structured technical specification document from requirements, notes, or a feature discussion. Use when the user asks to write a spec, create a technical specification, or document feature requirements before implementation.
---

# Generate Spec

1. Gather context from the user prompt, codebase, or conversation. Do not invent requirements; list unknowns under Open Questions.
2. Read templates/spec-template.md if present.
3. Write the specification to specs/<feature-slug>.md (or a path specified by the user), covering:
   - Summary & Measurable Goals
   - Non-Goals
   - Architecture & Design
   - Edge Cases & Failure Modes
   - Security Considerations
   - Acceptance Criteria & Open Questions
