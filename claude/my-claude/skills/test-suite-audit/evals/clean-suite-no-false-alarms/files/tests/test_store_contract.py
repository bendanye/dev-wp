"""Runs the same behavioural checks against the fake and (in CI) the real store."""
import os
from datetime import date

import pytest

from reminders.store import InMemoryInvoiceStore, Invoice, PostgresInvoiceStore

SEED = [
    Invoice("late", "x@e.com", date(2025, 1, 5), False),
    Invoice("early", "y@e.com", date(2025, 1, 2), False),
    Invoice("paid", "z@e.com", date(2025, 1, 1), True),
]


def _stores():
    yield InMemoryInvoiceStore(SEED)
    if os.environ.get("PG_DSN"):
        import psycopg
        conn = psycopg.connect(os.environ["PG_DSN"])
        # seeding omitted for brevity: CI fixture loads SEED into a temp schema
        yield PostgresInvoiceStore(conn)


@pytest.mark.parametrize("store", list(_stores()))
def test_returns_unpaid_ordered_by_due(store):
    assert [i.id for i in store.unpaid_due_before(date(2025, 2, 1))] == ["early", "late"]


@pytest.mark.parametrize("store", list(_stores()))
def test_mark_reminded_excludes_from_next_query(store):
    store.mark_reminded("early")
    assert [i.id for i in store.unpaid_due_before(date(2025, 2, 1))] == ["late"]
