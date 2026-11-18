from unittest.mock import MagicMock, patch

from orders.repository import Order
from orders.service import CheckoutService


def make_service():
    repo = MagicMock()
    gateway = MagicMock()
    notifier = MagicMock()
    return CheckoutService(repo, gateway, notifier), repo, gateway, notifier


def test_get_order_returns_order():
    svc, repo, _, _ = make_service()
    order = Order(id=1, customer_id=7, subtotal_cents=1000)
    repo.get.return_value = order
    assert svc.get_order(1) == order


def test_get_order_missing_returns_none():
    svc, repo, _, _ = make_service()
    repo.get.return_value = None
    assert svc.get_order(99) is None


def test_checkout_success_marks_paid_and_notifies():
    svc, repo, gateway, notifier = make_service()
    repo.get.return_value = Order(id=1, customer_id=7, subtotal_cents=1000)
    gateway.charge.return_value = {"ok": True, "id": "ch_1"}

    assert svc.checkout(1, "tok_visa") == "paid"
    notifier.send.assert_called_once


def test_checkout_declined():
    svc, repo, gateway, notifier = make_service()
    repo.get.return_value = Order(id=1, customer_id=7, subtotal_cents=1000)
    gateway.charge.return_value = {"ok": False}

    assert svc.checkout(1, "tok_visa") == "payment_failed"
    notifier.send.assert_not_called()


def test_checkout_order_not_found():
    svc, repo, _, _ = make_service()
    repo.get.return_value = None
    assert svc.checkout(42, "tok_visa") == "not_found"


@patch.object(CheckoutService, "_price", return_value=1090)
@patch.object(CheckoutService, "_load")
def test_checkout_calls_steps_in_order(mock_load, mock_price):
    svc, repo, gateway, _ = make_service()
    mock_load.return_value = Order(id=1, customer_id=7, subtotal_cents=1000)
    gateway.charge.return_value = {"ok": True}

    svc.checkout(1, "tok_visa", "WELCOME10")

    mock_load.assert_called_once_with(1)
    mock_price.assert_called_once_with(mock_load.return_value, "WELCOME10")
    gateway.charge.assert_called_once_with(1090, "tok_visa")
    assert repo.save.call_count == 1


def test_checkout_charges_discounted_total():
    svc, repo, gateway, _ = make_service()
    repo.get.return_value = Order(id=1, customer_id=7, subtotal_cents=10_000)
    gateway.charge.return_value = {"ok": True}

    svc.checkout(1, "tok_visa", "WELCOME10")

    gateway.charge.assert_called_once_with(9_810, "tok_visa")
