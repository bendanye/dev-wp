---
tags: [skill-creator]
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

our checkout tests are all green but i don't really trust them. can you go through the test suite in this repo and find tests that are tautological, too tied to the implementation, or where the mocks don't behave like the real thing? write the findings up in audit.md

Input files: orders/, tests/, requirements.txt
