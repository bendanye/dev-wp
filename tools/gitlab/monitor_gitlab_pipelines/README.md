# Monitor GitLab Pipelines

This is to show the status of the specified GitLab project's Pipelines to see if is success, running, failed using [Xbar](https://xbarapp.com/).

## Setup

1. Make sure you have `jq` and `xbar` installed
2. Make sure you have setup a `gitlab.env` file in the `tools` directory
3. Run `./setup_for_xbar.sh`
4. Enter the list of projects to check their pipeline status in `gitlab_build.1m.sh`

## Running

Go to xbar plugin folders and run `gitlab_build.1m.sh` and make sure you can see the following similar output

```shell
GP | color=lightgreen
---
backend-mid-app - success | color=darkgreen href=https://gitlab.com/mern1/backend-mid-app/-/pipelines
```
