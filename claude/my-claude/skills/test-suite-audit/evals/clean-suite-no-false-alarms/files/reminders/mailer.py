import smtplib
from email.message import EmailMessage


class Mailer:
    def __init__(self, host: str):
        self.host = host

    def send(self, to: str, subject: str, body: str) -> None:
        msg = EmailMessage()
        msg["To"], msg["Subject"] = to, subject
        msg.set_content(body)
        with smtplib.SMTP(self.host) as s:
            s.send_message(msg)
