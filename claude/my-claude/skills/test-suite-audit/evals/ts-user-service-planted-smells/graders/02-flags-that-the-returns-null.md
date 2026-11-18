---
type: llm
focus: trace
weight: 1
---

audit.md flags that the 'returns null when user does not exist' test stubs getUser to resolve null whereas the real client throws HttpError 404 (contracts/get-user-404.json)
