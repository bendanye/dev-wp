---
type: llm
focus: trace
weight: 1
---

audit.md flags that the gateway stub returns {"ok": ...} while the real PayFastClient.charge returns {"status": "succeeded"/"declined", ...}, so checkout's result.get("ok") check would treat every real successful payment as failed
