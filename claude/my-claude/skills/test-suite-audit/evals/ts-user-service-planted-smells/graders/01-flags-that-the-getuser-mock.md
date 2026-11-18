---
type: llm
focus: trace
weight: 1
---

audit.md flags that the getUser mock returns a flat {id, name, plan} object while the real API contract (contracts/get-user-200.json) wraps the user in {data: {...}} and uses displayName, explaining the blank-profile bug
