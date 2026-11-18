---
tags: [skill-creator]
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

the ProfileService tests in this repo break whenever someone refactors and yet we still shipped a bug where every profile showed up blank. audit the tests and tell me which ones are worthless, which are brittle, and whether the api mocks are realistic. put the report in audit.md

Input files: package.json, src/, test/, contracts/
