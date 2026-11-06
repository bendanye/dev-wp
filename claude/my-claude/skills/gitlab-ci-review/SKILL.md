---
name: gitlab-ci-review
description: Review GitLab CI/CD configuration and reusable GitLab CI template files for correctness, security, reliability, performance, maintainability, and unintended pipeline behavior. Use when reviewing .gitlab-ci.yml, GitLab CI YAML templates, included CI files, reusable jobs, hidden jobs, extends, anchors, rules, workflow, needs, artifacts, caches, variables, deployments, or changes that affect GitLab pipelines.
---

# GitLab CI Review Skill

## Purpose

Perform a rigorous engineering review of GitLab CI/CD configuration and reusable CI/CD templates.

This skill is intended for:

- `.gitlab-ci.yml`
- `.gitlab-ci.yaml`
- files included through `include:`
- `.gitlab-ci/*.yml` and `.gitlab-ci/*.yaml`
- reusable CI/CD templates
- hidden/template jobs such as `.build`, `.test`, `.deploy`
- jobs using `extends`
- YAML anchors and aliases
- child and downstream pipeline configuration
- CI configuration changed in a Git diff
- CI configuration used by multiple repositories

The primary goal is to identify defects that can cause:

- pipelines to run when they should not
- pipelines not to run when they should
- duplicate pipelines
- jobs running in the wrong pipeline type
- incorrect job ordering
- broken `needs:` relationships
- incorrect inheritance
- secret exposure
- unsafe deployments
- unreliable retries
- lost artifacts
- inefficient pipelines
- cache corruption
- difficult-to-maintain templates
- breaking changes for consumers of shared templates

Do not treat every style preference as a defect. Prioritize correctness, security, reliability, and operational impact.

---

# Review Principles

## 1. Review behavior, not just YAML syntax

A syntactically valid GitLab CI file can still be operationally wrong.

Always reason about:

- which pipelines are created
- which jobs are included
- which jobs are skipped
- which jobs depend on which other jobs
- what variables are available
- what artifacts are available
- what happens when a job fails
- what happens when a job is retried
- what happens in merge-request, branch, tag, scheduled, web, API, and downstream pipelines
- how the template behaves when consumed by another project

## 2. Treat templates as APIs

A reusable CI template is effectively an interface consumed by other projects.

Review:

- job names
- hidden jobs
- variables
- defaults
- expected artifacts
- expected dependencies
- `extends`
- `rules`
- documented customization points
- protected variables
- assumptions about runner tags
- assumptions about images
- assumptions about repository structure

A change that is harmless to the template itself can still be breaking for consumers.

## 3. Prefer explicit behavior

Flag configuration where GitLab behavior is technically valid but difficult to reason about.

Prefer:

- `rules:` over legacy `only:` / `except:`
- explicit `workflow:rules` when pipeline creation needs control
- explicit `needs:` where DAG behavior matters
- explicit artifact paths
- explicit cache keys
- explicit variable intent
- explicit deployment conditions

Do not flag legacy syntax solely because it is old if there is no meaningful risk in the current context. Explain modernization as a maintainability recommendation unless it creates a correctness or compatibility issue.

## 4. Avoid false positives

Do not report a finding merely because:

- a job has no `needs:`
- a job has no cache
- a job has no artifacts
- a job has `allow_failure`
- a variable is not defined in the same file
- a template uses inheritance
- a runner tag is not visible
- a job has a long script
- a job uses Docker

Consider the surrounding configuration and intended behavior.

If information is unavailable, explicitly state the assumption.

---

# Severity Model

Use exactly these severity levels.

## CRITICAL

Immediate or potentially severe impact.

Examples:

- credentials or secrets exposed in logs/configuration
- deployment can occur unintentionally in production
- security control can be bypassed
- destructive command can run in unintended pipeline contexts
- template change can cause widespread production-impacting behavior
- CI configuration permits arbitrary untrusted code to access highly privileged credentials

## HIGH

Significant correctness, security, reliability, or operational problem.

Examples:

- jobs run for unintended pipeline sources
- duplicate pipelines are likely
- incorrect `needs:` can make jobs fail or bypass intended sequencing
- protected deployment controls are missing
- artifact required by downstream job is not reliably available
- unsafe use of untrusted merge-request code with privileged variables
- cache configuration can produce cross-branch contamination with meaningful consequences

## MEDIUM

Important issue that should normally be addressed.

Examples:

- fragile rule combinations
- unreliable retry behavior
- excessive pipeline execution
- unnecessary serialization
- poor artifact retention
- ambiguous variable behavior
- maintainability problems likely to cause future CI defects

## LOW

Minor issue or improvement.

Examples:

- unnecessary duplication
- unclear naming
- avoidable shell complexity
- documentation gaps
- modernization opportunity without current functional impact

## INFO

Observation or recommendation that is not necessarily a defect.

Examples:

- optional optimization
- useful documentation suggestion
- architectural observation
- consistency improvement

---

# Review Workflow

Follow this workflow in order.

## Step 1 — Discover CI configuration

Identify:

- root `.gitlab-ci.yml`
- YAML files under likely CI/template directories
- included local files
- included remote/project/component templates when visible
- hidden jobs
- anchors
- reusable blocks
- child pipelines
- downstream pipelines

If reviewing a diff, inspect both changed files and the configuration they interact with.

Do not assume the changed file is self-contained.

## Step 2 — Build a configuration model

Before reporting findings, understand:

### Pipeline creation

Inspect:

- `workflow:`
- `workflow:rules`
- pipeline source conditions
- branch/tag conditions
- merge-request conditions
- schedules
- API/web/manual pipeline sources

### Jobs

For each relevant job determine:

- stage
- rules
- needs
- dependencies
- extends
- image
- services
- tags
- variables
- artifacts
- cache
- retry
- timeout
- allow_failure
- environment
- resource_group
- trigger
- when
- manual behavior

### Template inheritance

Resolve, as far as practical:

- `extends`
- YAML anchors
- aliases
- `default:`
- `inherit:`
- variable inheritance
- rule inheritance
- script inheritance

When full resolution is impossible, identify the uncertainty.

## Step 3 — Analyze pipeline sources

Consider at least:

- push pipelines
- merge-request pipelines
- tag pipelines
- scheduled pipelines
- manually created pipelines
- web/API-triggered pipelines
- parent/child pipelines
- multi-project/downstream pipelines

Look specifically for accidental overlap.

Example risk:

```yaml
workflow:
  rules:
    - if: '$CI_COMMIT_BRANCH'

job:
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH'
```

This may result in both branch and merge-request pipelines depending on the repository configuration.

Do not automatically call this a defect. Determine whether duplicate pipelines are actually possible and whether they are intended.

## Step 4 — Review security

Check:

### Secrets

Look for:

- passwords
- access tokens
- private keys
- API keys
- cloud credentials
- embedded credentials in URLs
- secrets echoed to logs
- secrets passed through unsafe command-line arguments

Do not reproduce actual secret values in the review.

### Variable protection

Check whether sensitive variables are appropriately:

- masked
- protected
- scoped
- unavailable to untrusted merge requests when appropriate

### Untrusted code

Pay special attention to:

- fork merge requests
- merge-request pipelines
- pipeline variables
- user-controlled variables
- scripts checked into the repository
- dynamic shell commands

Ask:

> Can untrusted repository content execute with privileged credentials?

### Shell safety

Look for:

- unsafe variable expansion
- unquoted variables where quoting matters
- `eval`
- dynamically constructed commands
- `curl | sh`
- downloading and executing unverified scripts
- destructive commands
- weak validation of user-controlled CI variables

Do not mechanically flag every shell variable. Explain the actual risk.

### Docker/container security

Review:

- privileged containers
- Docker socket exposure
- unrestricted Docker-in-Docker
- mutable image tags
- untrusted images
- registry authentication
- image provenance where relevant

Prefer immutable image references where practical.

---

# GitLab CI Rule Review

## `workflow:rules`

Check whether pipeline creation is intentional.

Look for:

- branch + merge-request duplication
- catch-all rules such as `when: always`
- rules that unintentionally enable schedules or web pipelines
- conditions that exclude required pipeline types
- inconsistent use of `CI_PIPELINE_SOURCE`

A common concern:

```yaml
workflow:
  rules:
    - if: '$CI_COMMIT_BRANCH'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
```

Analyze whether branch pipelines and merge-request pipelines overlap.

## Job `rules`

Check:

- ordering
- mutually exclusive conditions
- fallback rules
- `when: never`
- `when: manual`
- `allow_failure`
- tag vs branch logic
- merge-request behavior
- scheduled pipelines
- protected branches/tags

Be especially careful with a final unconditional rule:

```yaml
- when: always
```

It may make a job run in pipeline contexts that earlier rules did not explicitly consider.

## Legacy `only` / `except`

Flag only when there is a meaningful correctness, maintainability, or consistency concern.

Prefer migration guidance rather than treating legacy syntax itself as a bug.

---

# Dependency and DAG Review

## `needs:`

Check:

- referenced job exists
- dependency is available in the same pipeline
- optional dependencies use `optional: true` where required
- dependencies do not create impossible graphs
- jobs do not unintentionally bypass required stages
- artifact behavior is understood when using `needs`

Watch for a job that depends on an artifact-producing job which may be skipped.

## `dependencies:`

Review whether it is necessary and whether artifact flow is correct.

Identify redundant or conflicting use of:

- `needs`
- `dependencies`
- stages

## Stages

Check whether stages accurately represent intended ordering.

Do not recommend removing stages simply because `needs:` can create a DAG.

The important question is whether the actual execution graph matches the intended workflow.

---

# Artifacts Review

Check:

- paths
- expiration
- artifact size
- reports
- dependencies
- downstream availability
- whether artifacts are uploaded on failure when needed

Pay attention to:

```yaml
artifacts:
  when: on_success
```

If debugging or downstream processing requires failed-job output, determine whether `when: always` is appropriate.

Check whether sensitive files are accidentally published as artifacts.

Examples:

- `.env`
- credentials
- generated private keys
- cloud configuration
- tokens
- debug dumps containing secrets

---

# Cache Review

Review:

- cache key design
- branch isolation
- lockfile-based keys
- protected vs unprotected branch separation where relevant
- cache paths
- cache policy
- cross-job cache interactions
- possibility of cache poisoning
- whether cache is actually beneficial

Be suspicious of overly broad keys such as:

```yaml
cache:
  key: global
```

if multiple branches, jobs, operating systems, architectures, or dependency versions can share incompatible content.

Prefer deterministic keys based on relevant inputs, for example:

```yaml
cache:
  key:
    files:
      - package-lock.json
```

Do not require this exact form in every project.

---

# Variable Review

Review:

- global variables
- job variables
- `default:variables`
- inherited variables
- environment-scoped variables
- protected variables
- variables passed to child pipelines
- variable expansion
- user-supplied pipeline variables

Check for:

- accidental overrides
- misleading names
- duplicated configuration
- secrets stored as ordinary variables
- variables exposed in artifacts or logs
- variables that unexpectedly change behavior

Remember that variables can originate outside the YAML file.

Do not report "undefined variable" solely because it is not declared locally.

---

# Shell Script Review

Review commands for:

- quoting
- error handling
- command chaining
- pipe failure behavior
- unsafe interpolation
- destructive operations
- portability
- hidden dependencies
- unnecessary duplication

Pay attention to:

```bash
command1 | command2
```

where failure of `command1` may not cause the job to fail depending on the shell configuration.

Consider whether:

```bash
set -euo pipefail
```

or an equivalent robust approach is appropriate.

Do not blindly recommend it if the script intentionally relies on non-zero exit codes.

Review:

- `|| true`
- `set +e`
- broad error suppression
- `allow_failure`

Distinguish intentional handling from accidental failure masking.

---

# Docker and Image Review

Check:

- image tags
- digest pinning where security/reproducibility requires it
- image source
- trust boundaries
- Docker-in-Docker
- runner compatibility
- services
- registry credentials

Flag:

```yaml
image: node:latest
```

as a reproducibility concern when appropriate.

Do not automatically classify mutable tags as HIGH. Severity depends on how the image is used.

For production deployment or security-sensitive builds, recommend immutable image references where practical.

---

# Runner Review

Check:

- runner tags
- Docker executor assumptions
- shell executor assumptions
- privileged mode
- architecture
- OS-specific commands
- required tools

If runner configuration is outside the repository, do not invent facts.

Instead say:

> This template assumes runners provide X. Verify that all consuming runners satisfy this requirement.

---

# Deployment Review

Deployment jobs require additional scrutiny.

Check:

- `environment:`
- production environment names
- protected environments
- `when: manual`
- `rules`
- branch/tag restrictions
- deployment variables
- `resource_group`
- concurrency
- rollback behavior
- idempotency
- credentials
- approval controls

Look for production deployment jobs that can execute from:

- arbitrary branches
- merge requests
- forks
- schedules
- manually supplied variables

unless explicitly intended.

If multiple deployment jobs can target the same environment concurrently, consider whether `resource_group` or another concurrency mechanism is needed.

Do not assume manual deployment is sufficient protection by itself.

---

# Trigger and Downstream Pipeline Review

Review:

- `trigger:`
- child pipelines
- multi-project pipelines
- forwarding variables
- strategy
- artifact availability
- downstream permissions

Check for:

- sensitive variables being forwarded unnecessarily
- downstream pipeline triggering loops
- missing dependencies
- assumptions about branch/tag names
- failure propagation problems

---

# Template and Reusability Review

Treat reusable templates as public interfaces.

Check:

## Naming

Job names should communicate intent.

Avoid names that are likely to collide with consumer jobs unless that collision is intentional.

## Extension points

Identify whether consumers are expected to override:

- `variables`
- `rules`
- `script`
- `before_script`
- `after_script`
- `needs`
- `artifacts`
- `cache`
- `tags`

Check whether inheritance makes these overrides safe.

## Hidden jobs

Hidden jobs should generally represent reusable configuration.

Flag confusing cases where a hidden job appears to be intended as an executable job or vice versa.

## Defaults

Review whether `default:` introduces surprising behavior across unrelated jobs.

Particularly inspect:

- `before_script`
- `after_script`
- `image`
- `interruptible`
- `retry`
- `timeout`
- `tags`

A global default can silently affect consumers.

## Consumer compatibility

When changing a shared template, ask:

- Could existing consumers depend on the old job name?
- Could consumers depend on old variables?
- Could rules cause a previously available job to disappear?
- Could artifacts disappear?
- Could `needs` change scheduling?
- Could the image/tool version change?
- Could a deployment become automatic?
- Could a job start requiring a new runner tag?

---

# Performance Review

Look for:

- unnecessary repeated installation
- excessive artifact transfers
- overly broad caches
- jobs serialized unnecessarily
- missing `needs:` where DAG parallelism is clearly beneficial
- duplicate builds
- redundant checkout/setup work
- expensive jobs running for documentation-only changes
- pipelines triggered unnecessarily

Do not optimize at the expense of clarity or reliability.

A slower but predictable pipeline may be preferable to a highly optimized fragile pipeline.

---

# Reliability Review

Check:

- retries
- timeouts
- flaky external dependencies
- failure masking
- artifact retention
- idempotency
- cancellation behavior
- interruptibility
- concurrency
- deployment locking

Review whether:

```yaml
retry: 2
```

is actually safe.

Retrying a non-idempotent deployment can be dangerous.

Distinguish transient failures from deterministic failures.

---

# `rules:changes` Review

When `changes:` is used, check:

- paths are correct
- important shared files are included
- template changes trigger appropriate consumers/jobs
- changes to configuration or lockfiles trigger relevant jobs
- behavior on non-push pipeline sources is understood

Be cautious with templates that use `changes:` because path evaluation can behave differently depending on pipeline source.

---

# Include Review

Inspect:

```yaml
include:
  - local:
  - project:
  - remote:
  - template:
  - component:
```

Check:

- referenced file existence when verifiable
- version/ref pinning
- remote dependency risk
- project dependency
- component inputs
- unexpected overrides
- circular or confusing inclusion
- security implications

For remote or project includes, consider reproducibility and supply-chain risk.

Do not claim an include is broken unless its availability can be established.

---

# YAML Review

Check for:

- invalid structure
- incorrect indentation
- accidental scalar vs list values
- duplicate keys
- YAML anchors used incorrectly
- confusing quoting
- strings interpreted unexpectedly
- booleans/numbers unintentionally parsed as YAML values

Pay particular attention to values such as:

```yaml
on:
yes:
no:
true:
false:
```

and shell expressions containing special characters.

YAML validity alone is not enough; review GitLab's expected schema as well.

---

# Common Anti-Patterns

Look for these patterns, but only report them when they have meaningful impact.

### 1. Unconditional execution

```yaml
rules:
  - when: always
```

Potential issue: job executes in unexpected pipeline contexts.

### 2. Broad branch execution

```yaml
rules:
  - if: '$CI_COMMIT_BRANCH'
```

Potential issue: runs for every branch when narrower behavior is intended.

### 3. Mutable build image

```yaml
image: node:latest
```

Potential issue: non-reproducible builds.

### 4. Global cache

```yaml
cache:
  key: global
```

Potential issue: incompatible cache sharing or cache poisoning.

### 5. Failure suppression

```bash
some_command || true
```

Potential issue: hides real failures.

### 6. Secret logging

```bash
echo "$DEPLOY_TOKEN"
```

Potential issue: credential disclosure.

### 7. Dynamic shell execution

```bash
eval "$USER_COMMAND"
```

Potential issue: arbitrary command execution.

### 8. Unsafe privileged merge-request execution

A merge-request job executes repository-controlled scripts while privileged credentials are available.

Potential issue: credential exfiltration.

### 9. Unprotected deployment

A production deployment job can execute from an arbitrary branch or pipeline source.

Potential issue: unintended deployment.

### 10. Artifact secret leakage

```yaml
artifacts:
  paths:
    - .
```

Potential issue: sensitive files may be published.

---

# Review Output

Produce a concise but complete review.

Use this structure:

```text
# GitLab CI Review

## Summary

- Files reviewed:
- Pipeline types considered:
- Findings:
  - Critical: X
  - High: X
  - Medium: X
  - Low: X
  - Info: X

## Findings

### [SEVERITY] CI-XXX-001 — Short title

File:
Line:
Category:

Problem:
Explain the concrete behavior.

Why it matters:
Explain the operational/security/correctness impact.

Recommendation:
Give a practical fix.

Example:
```yaml
...
```

### [SEVERITY] CI-XXX-002 — ...
```

Then:

```text
## Positive Observations

Mention meaningful strengths such as:

- explicit deployment controls
- good use of reusable templates
- appropriate cache isolation
- clear DAG dependencies
- safe secret handling
- good pipeline-source control

## Review Assumptions

Document anything that could not be verified, such as:

- external runner configuration
- protected variable settings
- protected environment configuration
- remote include contents
- project-level CI settings
```

Do not include generic praise just to fill the section.

---

# Finding IDs

Use IDs in this format:

`CI-<CATEGORY>-NNN`

Recommended categories:

- `SEC` — security
- `RULE` — rules/workflow
- `DAG` — dependencies/stages
- `ART` — artifacts
- `CACHE` — cache
- `VAR` — variables
- `SHELL` — shell/script
- `IMG` — container/image
- `DEPLOY` — deployment
- `TRIGGER` — triggers/downstream
- `TPL` — template/reusability
- `PERF` — performance
- `REL` — reliability
- `YAML` — YAML/schema
- `INCLUDE` — includes

Example:

`CI-SEC-001`

Finding IDs should be unique within the review.

---

# Diff-Aware Review Mode

When reviewing a Git diff:

1. Review changed CI lines first.
2. Understand surrounding configuration.
3. Trace dependencies from changed jobs.
4. Inspect related `workflow`, `rules`, `needs`, `extends`, variables, artifacts, and includes.
5. Identify behavior changes, not merely changed lines.
6. Check whether the change is backward compatible for template consumers.
7. Do not report unrelated pre-existing problems unless:
   - they interact with the change, or
   - they are critical/high-risk.

Clearly distinguish:

- introduced finding
- pre-existing finding
- interaction with existing configuration

Recommended labels:

```text
Introduced by this change
Pre-existing
Exposed by this change
```

---

# Template Change Compatibility

For shared templates, explicitly perform a compatibility review.

Check whether the change modifies:

- job names
- job visibility
- variables
- default values
- rules
- stages
- needs
- artifacts
- cache behavior
- runner requirements
- images
- commands
- environment names
- deployment behavior

Potential breaking changes include:

```yaml
.build:
```

changing to:

```yaml
.build-image:
```

when consumers use:

```yaml
my_build:
  extends: .build
```

or changing a variable:

```yaml
variables:
  NODE_VERSION: "20"
```

in a way that invalidates consumers.

Treat reusable templates as versioned interfaces when they are shared across repositories.

---

# Security-Sensitive Review Mode

If the configuration involves:

- production deployment
- cloud credentials
- signing keys
- package publishing
- container registry credentials
- infrastructure deployment
- privileged runners
- protected variables

increase scrutiny.

Explicitly answer:

1. What code is trusted?
2. What code is untrusted?
3. Which credentials are available?
4. Which pipeline sources can access them?
5. Can a merge request or branch-controlled script access them?
6. Can a user-controlled variable alter privileged behavior?
7. Can the deployment target be changed by untrusted input?
8. Are artifacts/logs exposing sensitive information?

Do not assume GitLab project settings that are not visible in the repository.

---

# Review Quality Gate

Before finalizing the review, verify:

- [ ] Pipeline creation behavior considered
- [ ] Merge-request vs branch pipeline behavior considered
- [ ] `workflow:rules` reviewed
- [ ] Job `rules` reviewed
- [ ] `needs` reviewed
- [ ] `extends` and inheritance reviewed
- [ ] Includes reviewed
- [ ] Variables reviewed
- [ ] Secrets reviewed
- [ ] Shell commands reviewed
- [ ] Artifacts reviewed
- [ ] Cache reviewed
- [ ] Images reviewed
- [ ] Runner assumptions reviewed
- [ ] Deployment controls reviewed
- [ ] Trigger/downstream behavior reviewed
- [ ] Performance considered
- [ ] Reliability considered
- [ ] Shared-template compatibility considered
- [ ] Diff impact considered when applicable
- [ ] Findings have severity and concrete remediation
- [ ] No unsupported assumptions presented as facts

---

# Automatic Review Trigger Guidance

This skill should be invoked when:

- `.gitlab-ci.yml` changes
- `.gitlab-ci.yaml` changes
- CI YAML under a template/configuration directory changes
- a file referenced by `include:` changes
- a reusable CI job changes
- a hidden CI template job changes
- `rules:` or `workflow:` changes
- deployment CI configuration changes
- CI variables or secrets configuration in repository files changes
- Docker/build images used by CI change
- `needs:` / stages / artifacts / cache configuration changes

For a code-review agent, classify the change as CI-related if it modifies GitLab pipeline behavior even when the changed file is not named `.gitlab-ci.yml`.

---

# What Not To Do

Do not:

- invent GitLab behavior
- assume project-level settings
- assume runner configuration
- expose secrets in review output
- reproduce credential values
- recommend disabling security controls just to make a pipeline pass
- recommend `|| true` as a generic fix
- recommend `allow_failure: true` as a generic fix
- recommend retries for non-idempotent operations without analysis
- report every legacy syntax choice as a defect
- report every missing optimization as a finding
- treat style preferences as correctness issues
- claim an external include is valid without verification
- claim a pipeline is secure solely because variables are masked
- claim a deployment is protected solely because it is manual

---

# Recommended Remediation Style

Every actionable finding should answer:

1. What is wrong?
2. Where is it?
3. Why does it matter?
4. How should it be fixed?
5. What behavior should the fix preserve?

Prefer minimal, practical changes.

When proposing YAML, ensure the example is consistent with the surrounding configuration.

If multiple valid solutions exist, explain the trade-off rather than declaring one universally correct.

---

# Final Review Classification

At the end, provide one of:

```text
REVIEW RESULT: NO SIGNIFICANT ISSUES FOUND
```

or

```text
REVIEW RESULT: ISSUES FOUND
```

Do not use subjective labels such as "excellent", "poor", "best", or numerical scores.

The result is a statement about whether significant review findings were identified, not a quality ranking.
