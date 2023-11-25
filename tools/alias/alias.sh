alias drma='docker rm $(docker ps -aq) --force'
alias dpsa="docker ps -a"

TOOLS_DIR="$(dirname "$0")"

alias cs="$TOOLS_DIR/../copy_screenshots/copy_screenshots.sh"
alias nc="$TOOLS_DIR/../new_card/new_card.sh"
alias od="$TOOLS_DIR/../open_directory/open.sh"

alias jc="$TOOLS_DIR/../jira/jira_card.sh"
alias jbw="$TOOLS_DIR/../jira/jira_board_web.sh"

alias glint="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"
alias gop="$TOOLS_DIR/../gitlab/open_project.sh"
alias gopp="$TOOLS_DIR/../gitlab/open_project_pipeline.sh"

alias pomot="$TOOLS_DIR/../pomodoro_timer/pomodoro_timer.sh"
