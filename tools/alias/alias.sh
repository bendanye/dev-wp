alias drma='docker rm $(docker ps -aq) --force'
alias dpsa="docker ps -a"

TOOLS_DIR="$(dirname "$0")"

alias ssif="$TOOLS_DIR/../search/search_string_in_files.sh"
alias stwt="$TOOLS_DIR/../stopwatch/stopwatch.sh"

alias cs="$TOOLS_DIR/../copy_screenshots/copy_screenshots.sh"
alias nc="$TOOLS_DIR/../new_card/new_card.sh"
alias od="$TOOLS_DIR/../open_directory/open.sh"
alias zcte="$TOOLS_DIR/../zip/zip_card_evidences.sh"

alias jc="$TOOLS_DIR/../jira/jira_card.sh"
alias jbw="$TOOLS_DIR/../jira/jira_board_web.sh"
alias jcua="$TOOLS_DIR/../jira/jira_upload_attachment.sh"

alias glint="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"
alias gop="$TOOLS_DIR/../gitlab/open_project.sh"
alias gopp="$TOOLS_DIR/../gitlab/open_project_pipeline.sh"
alias gomra="$TOOLS_DIR/../gitlab/open_mr_assigned.sh"
alias gomrr="$TOOLS_DIR/../gitlab/open_mr_reviewed.sh"
alias gopmra="$TOOLS_DIR/../gitlab/open_project_mr_assigned.sh"
alias gopmrr="$TOOLS_DIR/../gitlab/open_project_mr_reviewed.sh"
alias gpst="$TOOLS_DIR/../gitlab/poll_pipeline_status.sh"

alias pomot="$TOOLS_DIR/../pomodoro_timer/pomodoro_timer.sh"
alias pomotst="$TOOLS_DIR/../pomodoro_timer/status.sh"
alias pomotdsum="$TOOLS_DIR/../pomodoro_timer/day_summary.sh"

alias devwp="cd $TOOLS_DIR/../../"
