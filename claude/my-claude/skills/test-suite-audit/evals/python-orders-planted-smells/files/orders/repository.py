import sqlite3
from dataclasses import dataclass


class OrderNotFound(Exception):
    pass


@dataclass
class Order:
    id: int
    customer_id: int
    subtotal_cents: int
    status: str = "new"


class OrderRepository:
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn

    def get(self, order_id: int) -> Order:
        row = self.conn.execute(
            "SELECT id, customer_id, subtotal_cents, status FROM orders WHERE id = ?",
            (order_id,),
        ).fetchone()
        if row is None:
            raise OrderNotFound(order_id)
        return Order(*row)

    def save(self, order: Order) -> None:
        self.conn.execute(
            "UPDATE orders SET status = ? WHERE id = ?", (order.status, order.id)
        )
