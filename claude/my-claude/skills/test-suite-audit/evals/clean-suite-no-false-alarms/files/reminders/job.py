from datetime import date

from .mailer import Mailer
from .store import InvoiceStore


def send_overdue_reminders(store: InvoiceStore, mailer: Mailer, today: date) -> int:
    sent = 0
    for inv in store.unpaid_due_before(today):
        mailer.send(inv.email, f"Invoice {inv.id} is overdue", f"Your invoice was due on {inv.due:%d %b %Y}.")
        store.mark_reminded(inv.id)
        sent += 1
    return sent
