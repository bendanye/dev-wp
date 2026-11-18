---
type: llm
focus: trace
weight: 1
---

audit.md flags that `notifier.send.assert_called_once` (no parentheses) in test_checkout_success_marks_paid_and_notifies never executes, so the notification is not actually checked
