---
type: llm
focus: trace
weight: 1
---

audit.md flags test_total_with_tax and/or test_tax_rate as tautological because the expected value is computed with production code (compute_tax / TAX_RATE)
