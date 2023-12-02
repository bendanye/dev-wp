alias drma='docker rm $(docker ps -aq) --force'
alias dpsa="docker ps -a"

TOOLS_DIR="$(dirname "$0")"

alias ssif="$TOOLS_DIR/../search/search_string_in_files.sh"

alias cs="$TOOLS_DIR/../copy_screenshots/copy_screenshots.sh"
alias nc="$TOOLS_DIR/../new_card/new_card.sh"
alias od="$TOOLS_DIR/../open_directory/open.sh"
alias zcte="$TOOLS_DIR/../zip/zip_card_evidences.sh"

alias jc="$TOOLS_DIR/../jira/jira_card.sh"
alias jbw="$TOOLS_DIR/../jira/jira_board_web.sh"

alias glint="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"
alias gop="$TOOLS_DIR/../gitlab/open_project.sh"
alias gopp="$TOOLS_DIR/../gitlab/open_project_pipeline.sh"
alias gpst="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"

alias pomot="$TOOLS_DIR/../pomodoro_timer/pomodoro_timer.sh"
alias pomotst="$TOOLS_DIR/../pomodoro_timer/status.sh"
alias pomotsum="$TOOLS_DIR/../pomodoro_timer/summary.sh"

alias devwp="cd $TOOLS_DIR/../../"
