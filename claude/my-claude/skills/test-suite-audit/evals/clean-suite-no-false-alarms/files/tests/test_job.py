from datetime import date
from unittest.mock import create_autospec

from reminders.job import send_overdue_reminders
from reminders.mailer import Mailer
from reminders.store import InMemoryInvoiceStore, Invoice

TODAY = date(2025, 3, 10)


def inv(id, due, paid=False, reminded=False):
    return Invoice(id, f"{id}@example.com", due, paid, reminded)


def test_emails_each_overdue_unpaid_invoice_once():
    store = InMemoryInvoiceStore([inv("a", date(2025, 3, 1)), inv("b", date(2025, 3, 9))])
    mailer = create_autospec(Mailer, instance=True)

    assert send_overdue_reminders(store, mailer, TODAY) == 2

    recipients = sorted(c.args[0] for c in mailer.send.call_args_list)
    assert recipients == ["a@example.com", "b@example.com"]


def test_skips_paid_not_yet_due_and_already_reminded():
    store = InMemoryInvoiceStore([
        inv("paid", date(2025, 3, 1), paid=True),
        inv("future", date(2025, 3, 10)),
        inv("done", date(2025, 3, 1), reminded=True),
    ])
    mailer = create_autospec(Mailer, instance=True)

    assert send_overdue_reminders(store, mailer, TODAY) == 0
    mailer.send.assert_not_called()


def test_running_twice_does_not_double_send():
    store = InMemoryInvoiceStore([inv("a", date(2025, 3, 1))])
    mailer = create_autospec(Mailer, instance=True)

    send_overdue_reminders(store, mailer, TODAY)
    send_overdue_reminders(store, mailer, TODAY)

    assert mailer.send.call_count == 1


def test_subject_names_the_invoice():
    store = InMemoryInvoiceStore([inv("INV-42", date(2025, 2, 1))])
    mailer = create_autospec(Mailer, instance=True)

    send_overdue_reminders(store, mailer, TODAY)

    _, subject, body = mailer.send.call_args.args
    assert "INV-42" in subject
    assert "01 Feb 2025" in body
