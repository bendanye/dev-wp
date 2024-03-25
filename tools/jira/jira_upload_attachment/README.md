# Jira Upload attachment

This contains script to upload attachment to a specified Jira issue.

## Setup

1. Create `jira.env` in the current directory and put the following contents in the file

```
JIRA_URL=""
JIRA_ISSUE_PREFIX=""
JIRA_AUTH_TOKEN=""
```

2. Run the following program to install the required packages

```shell
pip install -r requirements.txt
```

## Execute

Run the following command to upload attachment to a Jira issue.

```shell

ID="<<the issue number>>"
ATTACHMENT="<<The absolute path of the file to upload>>"

python3.8 jira_upload_attachment.py "$ID" "$ATTACHMENT"
```
