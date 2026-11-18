---
type: llm
focus: trace
weight: 1
---

audit.md flags that repo.get is stubbed to return None although the real OrderRepository.get raises OrderNotFound, so the not-found tests exercise a state production never produces
