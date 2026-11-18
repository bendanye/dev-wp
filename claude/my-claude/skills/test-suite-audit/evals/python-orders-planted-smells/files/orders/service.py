from .pricing import total_with_tax
from .repository import Order


class CheckoutService:
    def __init__(self, repo, gateway, notifier):
        self.repo = repo
        self.gateway = gateway
        self.notifier = notifier

    def get_order(self, order_id: int) -> Order | None:
        order = self.repo.get(order_id)
        if order is None:
            return None
        return order

    def _load(self, order_id):
        return self.repo.get(order_id)

    def _price(self, order, code):
        return total_with_tax(order.subtotal_cents, code)

    def checkout(self, order_id: int, card_token: str, code: str | None = None) -> str:
        order = self._load(order_id)
        if order is None:
            return "not_found"
        amount = self._price(order, code)
        result = self.gateway.charge(amount, card_token)
        if result.get("ok"):
            order.status = "paid"
            self.repo.save(order)
            self.notifier.send(order.customer_id, "Payment received")
            return "paid"
        order.status = "payment_failed"
        self.repo.save(order)
        return "payment_failed"
