"""Thin client for the PayFast payment API."""
import requests


class GatewayError(Exception):
    pass


class PayFastClient:
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url
        self.api_key = api_key

    def charge(self, amount_cents: int, card_token: str) -> dict:
        """Returns the decoded PayFast JSON body, e.g.

            {"id": "ch_123", "status": "succeeded", "amount": 1299}
            {"id": "ch_124", "status": "declined", "decline_code": "insufficient_funds"}

        Raises GatewayError on non-2xx responses.
        """
        resp = requests.post(
            f"{self.base_url}/v1/charges",
            json={"amount": amount_cents, "source": card_token},
            headers={"Authorization": f"Bearer {self.api_key}"},
            timeout=10,
        )
        if resp.status_code >= 300:
            raise GatewayError(resp.text)
        return resp.json()
