---
name: observability-review
description: Observability review methodology covering logging, metrics, distributed tracing, OpenTelemetry, context propagation, health checks, and production troubleshooting readiness. Use when auditing a service or codebase for how well it can be monitored and debugged in production; for a narrower review of logging in a diff, use logging-review.
---

# Observability Code Review

## Purpose

Review an existing software codebase for observability quality and identify gaps that could make the system difficult to monitor, troubleshoot, debug, or operate in production.

Cover:
- Logging
- Metrics
- Distributed tracing
- Trace/context propagation
- Logs/metrics/traces correlation
- Error observability
- HTTP/API observability
- Database observability
- Messaging/event observability
- External dependency observability
- Background jobs and scheduled tasks
- Security-aware observability
- Health/readiness/liveness
- OpenTelemetry implementation
- Production troubleshooting capability

Review as an experienced SRE/platform/observability engineer. Do not assume more telemetry is always better; evaluate usefulness, correctness, consistency, correlation, safety, cost, and production suitability.

## Review Workflow

### 1. Understand the System

Identify languages, frameworks, services/modules, APIs, databases, brokers, caches, external APIs, workers, scheduled jobs, deployment/container/Kubernetes configuration, and existing logging/metrics/tracing/OpenTelemetry libraries.

Inspect manifests and common directories such as `package.json`, `pom.xml`, `build.gradle`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Dockerfile`, `docker-compose.yml`, `helm/`, `k8s/`, `terraform/`, `src/`, `app/`, and `config/`.

### 2. Inventory Existing Observability

Create an internal inventory covering:

```text
Logging:
- Framework
- Structured logging
- Log levels
- Correlation IDs
- Trace IDs
- Sensitive-data filtering

Metrics:
- Framework
- Business metrics
- Technical metrics
- HTTP metrics
- Dependency metrics

Tracing:
- Framework
- Automatic instrumentation
- Manual instrumentation
- Context propagation
- Sampling

OpenTelemetry:
- SDK
- Instrumentations
- Exporter
- Resource attributes
- Propagator
- Processor

Health:
- Liveness
- Readiness
- Dependency health

Errors:
- Exception logging
- Error metrics
- Error tracing
- Error correlation
```

Do not report missing functionality until the repository has been sufficiently searched.

## Logging Review

### Critical events

Check startup/shutdown, configuration failures, authentication/authorization failures, important business operations, dependency failures, database failures, message failures, background-job failures, retry exhaustion, circuit breakers, unexpected exceptions, and fatal errors.

Flag important failure paths that provide insufficient diagnostic information.

### Structured logging

Prefer structured, machine-readable logs with consistent fields, severity, error objects, request identifiers, and trace identifiers.

Do **not** automatically flag `console.log()` or `console.error()`. Determine whether they are intentionally the application's logging mechanism and then assess their quality.

### Log levels

Check for errors logged as INFO, normal events logged as ERROR, important failures logged at DEBUG, permanently enabled debug logging, and excessive INFO logging on high-volume paths.

### Error logging

Prefer preserving the original exception and stack trace:

```javascript
logger.error({
  err,
  operation,
  requestId
}, "Failed to call customer service");
```

Flag patterns that only retain `err.message` when that loses useful diagnostic context.

### Sensitive information

Flag passwords, access/refresh tokens, API keys, authorization headers, cookies, session identifiers, payment-card data, PII, credentials, secrets, private keys, and unsafe full request/response logging.

Prefer redaction, allowlists, field filtering, sampling, and controlled debugging.

### Noise

Look for meaningless or repetitive logs, high-cardinality values, large payloads, and logging inside high-frequency loops. Do not judge quality by log count alone.

## Metrics Review

### Golden signals

Check application-level visibility for:

- Latency: HTTP, DB, dependency, message processing
- Traffic: requests, messages, jobs, business transactions
- Errors: HTTP errors, dependency failures, exceptions, job/message failures
- Saturation: pools, thread/worker usage, queues, CPU/memory where application-level visibility is needed

### Cardinality

Flag potentially unbounded metric labels such as `userId`, `requestId`, `traceId`, `sessionId`, email, order/transaction IDs, and raw URLs with query strings.

Prefer bounded dimensions such as route, method, status code, service, and operation.

### Business metrics

Identify important domain outcomes that need operational visibility, but do not force business metrics into applications where they are not relevant.

## Distributed Tracing Review

Check whether important request paths cover:

```text
incoming request
  -> handler/controller
  -> service
  -> database
  -> external API
  -> message publishing/consumption
```

### Context propagation

Review HTTP, REST, gRPC, Kafka, RabbitMQ/AMQP, queues, async workers, scheduled jobs, callbacks, and other async boundaries. Look for W3C Trace Context (`traceparent`), baggage, and suitable correlation mechanisms.

Flag cases where a trace starts correctly but disappears across an important boundary.

### Manual spans

Check parent context, span naming, useful attributes, exception recording, span status, span lifecycle, excessive span creation, and sensitive attributes.

Good pattern:

```javascript
const span = tracer.startSpan("processOrder");
try {
  await processOrder();
  span.setStatus({ code: SpanStatusCode.OK });
} catch (err) {
  span.recordException(err);
  span.setStatus({ code: SpanStatusCode.ERROR });
  throw err;
} finally {
  span.end();
}
```

### Automatic instrumentation

If OpenTelemetry is used, assess operationally significant libraries such as HTTP frameworks, Axios/Fetch, databases, Redis, Kafka/AMQP/RabbitMQ, and gRPC. Do not recommend instrumentation merely because a library exists.

### Span attributes

Check useful semantic attributes such as `service.name`, `deployment.environment`, `http.request.method`, `http.response.status_code`, `db.system`, `db.operation.name`, `messaging.system`, and `messaging.destination.name`.

Never recommend secrets, authorization data, full bodies, tokens, or PII as span attributes.

## Logs ↔ Traces Correlation

Treat correlation as a high-priority area. Determine whether logs contain `trace_id` and `span_id` or an equivalent mechanism, and whether engineers can navigate:

```text
log -> trace
trace -> logs
```

If only an application-specific request ID exists, assess whether it is sufficient for the architecture.

## HTTP/API Observability

Review request duration, status, route, method, request/error counts, dependency latency, correlation, and trace propagation.

Avoid full authorization headers, cookies, request bodies, or response bodies unless explicitly justified and protected.

Check metric route normalization. Prefer `/users/{userId}/orders/{orderId}` over concrete IDs as metric dimensions.

## Database Observability

Review query latency, connection failures, pool exhaustion, timeouts, retries, transaction failures, slow queries, and database tracing.

Where appropriate inspect connection-pool min/max, active/idle connections, wait time, and query duration. Avoid recommending unsafe SQL parameter logging.

## Messaging Observability

For Kafka/RabbitMQ/AMQP/etc. review publish/consume counts, processing latency, failures, retry behavior, dead-letter handling, queue depth/lag, message correlation, and trace propagation.

## External Dependencies

For REST/SOAP/AWS/internal/third-party services, review dependency name, operation, duration, status, timeout, retry count, error information, and trace context. Avoid sensitive request/response logging.

## Background Jobs

For cron, scheduled jobs, workers, queue consumers, async processing, and batch jobs, ensure telemetry can answer:

- Did it run?
- When did it run?
- How long did it take?
- Did it succeed?
- Why did it fail?
- How many items were processed?
- How many failed?

Prefer aggregate metrics over logging every item in large batches.

## Health and Readiness

Review `/health`, `/healthz`, `/readiness`, `/ready`, and `/liveness` endpoints where applicable.

Check separation of liveness/readiness, meaningful dependency checks, safe responses, and reasonable check load. Do not recommend putting every dependency into liveness.

## OpenTelemetry Review

If OpenTelemetry exists, inspect SDK initialization, resources, service name, environment, exporter, processor, sampler, propagator, instrumentation, context manager, and shutdown handling.

Consider at least:

```text
service.name
service.version
deployment.environment
```

Review exporter endpoint, timeout, retry, TLS/authentication, and failure behavior. Telemetry backend failure should normally not crash or block the application.

For production, assess whether `BatchSpanProcessor` is more appropriate than `SimpleSpanProcessor`. Review sampling for production volume, high-volume endpoints, errors, and important business transactions.

## Configuration

Look for environment/configuration-driven settings such as:

```text
OTEL_SERVICE_NAME
OTEL_EXPORTER_OTLP_ENDPOINT
OTEL_TRACES_SAMPLER
LOG_LEVEL
ENABLE_OTEL
ENABLE_REQUEST_LOGGING
```

Flag hard-coded endpoints/credentials, production debug mode, impossible-to-disable instrumentation, and inconsistent environment configuration.

## Failure Behavior

Assess what happens when the collector, tracing backend, metrics backend, or logging backend is unavailable.

Flag telemetry failure that can block requests, crash the process, exhaust memory, create unbounded queues, or introduce severe latency.

## Production Troubleshooting Scenarios

Evaluate whether telemetry can answer:

### HTTP 500
Which endpoint, request, service, trace, dependency, exception, database, and duration?

### Slow request
Total duration versus application, database, external API, and queue latency?

### Database outage
Connection failures, timeouts, affected operations, error rate, and pool exhaustion?

### Message failure
Message/consumer, processing duration, failure reason, retry count, trace, and dead-letter status?

### High application latency
Can engineers distinguish CPU/memory pressure, DB latency, external API latency, pool exhaustion, queue backlog, and application code?

If not, identify the missing telemetry.

## Severity Model

### CRITICAL
Major incidents are extremely difficult to diagnose or there is a major security/operational risk. Examples: secrets exposed in logs, no telemetry around critical failures, critical trace context loss, or telemetry failure crashing the application.

### HIGH
Significant operational problem. Examples: critical APIs lack useful error telemetry, database failures cannot be diagnosed, logs cannot be correlated with traces, important async processing is invisible, or high-cardinality metrics create major risk.

### MEDIUM
Meaningful improvement opportunity such as missing latency metrics, missing dependency instrumentation, inconsistent fields, useful business metrics, or poor error context.

### LOW
Minor naming, logging, or optional-attribute improvements.

## Finding Format

Every finding must use:

```markdown
### [SEVERITY] Finding title

**Location**
`path/to/file.js:123`

**Category**
Logging / Metrics / Tracing / Correlation / OpenTelemetry / Security / Health / Dependency

**Problem**
Explain what is wrong.

**Why it matters**
Explain operational impact.

**Evidence**
Show relevant code or exact implementation evidence.

**Recommendation**
Give a concrete recommendation.

**Example**
Provide a concise implementation example when useful.

**Priority**
CRITICAL / HIGH / MEDIUM / LOW
```

Do not produce vague findings such as "Improve logging." Findings must cite concrete code locations and explain the incident-diagnosis impact.

## Positive Findings

Also identify good practices, for example:

```text
✓ Trace context is propagated across HTTP calls
✓ Database calls are instrumented
✓ Logs contain trace_id and span_id
✓ Errors record exceptions on spans
✓ Metrics use bounded route labels
✓ Sensitive fields are redacted
✓ BatchSpanProcessor is used in production
✓ Health and readiness are separated
```

## Coverage Matrix

Produce:

| Area | Coverage | Quality | Risk |
|---|---|---|---|
| Logging | Good/Partial/Poor | Good/Partial/Poor | Low/Medium/High |
| Error logging | | | |
| Metrics | | | |
| HTTP tracing | | | |
| Database tracing | | | |
| Messaging tracing | | | |
| Context propagation | | | |
| Log/trace correlation | | | |
| External dependencies | | | |
| Background jobs | | | |
| Health checks | | | |
| OpenTelemetry | | | |
| Security/redaction | | | |
| Production readiness | | | |

## Overall Score

Provide a 0–100 evidence-based score using this suggested weighting:

```text
Logging                    15%
Metrics                    15%
Tracing                   15%
Context propagation       15%
Correlation               10%
Error observability       10%
Dependency observability  10%
Security                  5%
Health/readiness           5%
```

Do not give a high score merely because OpenTelemetry is installed.

## Final Output

Use this structure:

```markdown
# Observability Review

## Executive Summary

## Overall Score
XX / 100

## Critical Findings

## High Findings

## Medium Findings

## Low Findings

## Positive Observability Practices

## Observability Coverage Matrix

## Production Incident Readiness

### Can we diagnose HTTP failures?
### Can we diagnose latency?
### Can we diagnose database failures?
### Can we diagnose messaging failures?
### Can we correlate logs and traces?

## Top 5 Recommendations

## Suggested Implementation Roadmap

### Phase 1 — Critical
### Phase 2 — High Value
### Phase 3 — Improvements
```

## Review Commands

When useful, search for observability patterns:

```bash
grep -R "console.log" .
grep -R "console.error" .
grep -R "logger\." .
grep -R "trace" .
grep -R "span" .
grep -R "meter" .
grep -R "counter" .
grep -R "histogram" .
grep -R "OpenTelemetry" .
grep -R "@opentelemetry" .
grep -R "traceparent" .
grep -R "requestId" .
grep -R "correlation" .
grep -R "health" .
grep -R "readiness" .
grep -R "liveness" .
```

Node.js:

```bash
grep -R "@opentelemetry" package.json package-lock.json src/
grep -R "winston\|pino\|bunyan" package.json src/
```

Java:

```bash
grep -R "opentelemetry\|micrometer" pom.xml build.gradle src/
grep -R "LoggerFactory\|Slf4j\|Logger" src/
```

Python:

```bash
grep -R "opentelemetry" requirements.txt pyproject.toml src/
grep -R "logging\|structlog" src/
```

Use repository-specific tools where available instead of relying exclusively on grep.

## Definition of Done

- [ ] Existing observability architecture identified
- [ ] Logging reviewed
- [ ] Error handling reviewed
- [ ] Metrics reviewed
- [ ] Distributed tracing reviewed
- [ ] Context propagation reviewed
- [ ] Log/trace correlation reviewed
- [ ] Database observability reviewed
- [ ] Messaging observability reviewed
- [ ] External dependency observability reviewed
- [ ] Background jobs reviewed
- [ ] Health/readiness reviewed
- [ ] OpenTelemetry configuration reviewed
- [ ] Sensitive-data exposure reviewed
- [ ] Cardinality and telemetry cost considered
- [ ] Production failure scenarios evaluated
- [ ] Findings have evidence and file locations
- [ ] Findings have severity
- [ ] Top recommendations prioritized
- [ ] Overall observability score calculated
