from dataclasses import dataclass
from jira import JIRA
from dotenv import load_dotenv

import os
import sys
import urllib3


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

ENV_DIR = "."


@dataclass(frozen=True)
class JiraEnv:
    url: str
    token: str
    issue_prefix: str


def main(card_number: str, file_name: str) -> None:
    jira_env = _read_from_jira_env_file(f"{ENV_DIR}/jira.env")
    working_dir = _read_from_source_env_file(f"../../source.env")

    attachment_path = f"{working_dir}/{card_number}/{file_name}"

    if not os.path.isfile(attachment_path):
        raise ValueError(f"{attachment_path} is not a file or does not exists")

    jira = JIRA(
        options={"server": jira_env.url, "verify": False},
        token_auth=jira_env.token,
    )

    issue_id = f"{jira_env.issue_prefix}-{card_number}"

    # issue = jira.issue(issue_id)
    # for attachment in issue.fields.attachment:
    #     print(
    #         "ID: {id}, Name: '{filename}', size: {size}".format(
    #             id=attachment.id, filename=attachment.filename, size=attachment.size
    #         )
    #     )

    jira.add_attachment(
        issue=issue_id,
        attachment=attachment_path,
    )

    print(f"Uploaded {file_name} successfully")


def _read_from_jira_env_file(env_path: str) -> JiraEnv:
    load_dotenv(dotenv_path=env_path, override=True)

    token = os.environ["JIRA_AUTH_TOKEN"]
    url = os.environ["JIRA_URL"]
    issue_prefix = os.environ["JIRA_ISSUE_PREFIX"]

    return JiraEnv(url=url, token=token, issue_prefix=issue_prefix)


def _read_from_source_env_file(env_path: str) -> str:
    load_dotenv(dotenv_path=env_path, override=True)
    return os.environ["WORKING_DIR"]


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise ValueError("Expecting card number and the file as arguments")

    main(card_number=sys.argv[1], file_name=sys.argv[2])
