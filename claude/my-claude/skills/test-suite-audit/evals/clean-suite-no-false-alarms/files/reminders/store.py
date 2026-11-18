from dataclasses import dataclass
from datetime import date
from typing import Protocol


@dataclass(frozen=True)
class Invoice:
    id: str
    email: str
    due: date
    paid: bool
    reminded: bool = False


class InvoiceStore(Protocol):
    def unpaid_due_before(self, day: date) -> list[Invoice]: ...
    def mark_reminded(self, invoice_id: str) -> None: ...


class PostgresInvoiceStore:
    """Production store. Returns invoices ordered by due date; never returns paid
    or already-reminded invoices; returns [] when nothing matches."""

    def __init__(self, conn):
        self.conn = conn

    def unpaid_due_before(self, day: date) -> list[Invoice]:
        rows = self.conn.execute(
            "SELECT id, email, due, paid, reminded FROM invoices "
            "WHERE paid = false AND reminded = false AND due < %s ORDER BY due",
            (day,),
        ).fetchall()
        return [Invoice(*r) for r in rows]

    def mark_reminded(self, invoice_id: str) -> None:
        self.conn.execute("UPDATE invoices SET reminded = true WHERE id = %s", (invoice_id,))


class InMemoryInvoiceStore:
    """Test fake mirroring PostgresInvoiceStore semantics."""

    def __init__(self, invoices: list[Invoice]):
        self._by_id = {i.id: i for i in invoices}

    def unpaid_due_before(self, day: date) -> list[Invoice]:
        hits = [i for i in self._by_id.values() if not i.paid and not i.reminded and i.due < day]
        return sorted(hits, key=lambda i: i.due)

    def mark_reminded(self, invoice_id: str) -> None:
        i = self._by_id[invoice_id]
        self._by_id[invoice_id] = Invoice(i.id, i.email, i.due, i.paid, True)
