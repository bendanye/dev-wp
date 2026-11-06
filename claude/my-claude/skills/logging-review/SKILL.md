---
name: logging-review
description: Production logging review methodology. Use when reviewing changes to error handling, business operations, integrations, or background jobs, for missing critical logs, error context, log levels, correlation IDs, and sensitive data in logs.
---

# Logging Review Skill

## Check

### Critical operations
Determine whether important business/operational operations have enough
logging to reconstruct what happened.

### Errors
Check:
- errors are not silently swallowed
- useful context is logged
- stack traces are preserved where appropriate
- failure reasons are available

### Context
Where appropriate, logs should provide useful identifiers such as:
- operation
- request/correlation ID
- resource identifier
- relevant state
- failure reason

### Log levels
Evaluate appropriate use of:
- DEBUG
- INFO
- WARN
- ERROR

### Sensitive information
Look for accidental logging of:
- passwords
- authentication tokens
- API keys
- secrets
- sensitive personal data

### Console logging

`console.log` is NOT automatically a defect.

Determine whether it is:
- accepted by the project
- appropriately leveled or categorized
- sufficiently contextual
- suitable for production operation

If the project uses a structured logger, assess whether the changed code
bypasses it in a meaningful way.

### Operational usefulness
Ask:
"If this operation failed in production at 3 AM, would these logs help an
engineer determine what happened without attaching a debugger?"

## Avoid noise

Do not recommend logging every line or every variable.
Prefer high-value lifecycle, decision, warning, and failure events.

## Severity

- CRITICAL: security, data loss/corruption, severe breakage, severe reliability
- HIGH: significant correctness or operational problem likely to hit production
- MEDIUM: maintainability or moderate operational/design gap
- LOW: minor improvement

## Output

For each finding provide:
- severity
- location
- missing/inadequate log
- operational impact
- recommendation
