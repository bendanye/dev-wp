---
type: llm
focus: trace
weight: 1
---

audit.md flags that 'propagates server errors' never actually asserts, because the promise with the .catch assertion is not awaited or returned (noting the 503 vs 500 mismatch would go unnoticed)
