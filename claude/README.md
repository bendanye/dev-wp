# Claude

A collection of tools to support my development environment using Claude Code.

## Install

```bash
./copy_to_global.sh
```

Copies `agents/`, `commands/` and `skills/` into `~/.claude/`, making them available in every project.

## Commands

| Command | What it does |
|---|---|
| `/review-full [scope]` | Runs the API, design, unit-test and logging reviewers in parallel (plus GitLab CI review if CI files changed) and merges them into one report |
| `/review-api [scope]` | API contract, validation, compatibility and security review |
| `/review-design [scope]` | Architecture and code design review |
| `/review-tests [scope]` | Unit-test coverage and quality review |
| `/review-logging [scope]` | Critical production logging review |

`scope` is optional: a branch, commit range or paths. By default the reviewers look at uncommitted changes, or the current branch vs the default branch if there are none.

## Skills

`api-review`, `design-review`, `unit-test-review`, `logging-review`, `gitlab-ci-review`, `observability-review`. Claude picks these up automatically when relevant, or you can invoke them directly (e.g. `/gitlab-ci-review`).
