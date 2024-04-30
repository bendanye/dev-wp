alias drma='docker rm $(docker ps -aq) --force'
alias dpsa="docker ps -a"
alias caf="caffeinate -dims"

TOOLS_DIR="$(dirname "$0")"

alias ssif="$TOOLS_DIR/../search/search_string_in_files.sh"
alias stopwatch="$TOOLS_DIR/../stopwatch/stopwatch.sh"
alias cdtimer="$TOOLS_DIR/../countdown_timer/countdown_timer.sh"

alias cs="$TOOLS_DIR/../card_management/copy_screenshots.sh"
alias nc="$TOOLS_DIR/../card_management/new_card.sh"
alias od="$TOOLS_DIR/../card_management/open_card_directory.sh"
alias zcte="$TOOLS_DIR/../card_management/zip_card_evidences.sh"

alias joc="$TOOLS_DIR/../jira/jira_card.sh"
alias job="$TOOLS_DIR/../jira/jira_board_web.sh"
alias jcua="$TOOLS_DIR/../jira/jira_upload_attachment.sh"

alias gop="$TOOLS_DIR/../git/open_project_in_browser.sh"
# alias gop="$TOOLS_DIR/../gitlab/open_project.sh"
alias glint="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"
alias gopp="$TOOLS_DIR/../gitlab/open_project_pipeline.sh"
alias gomra="$TOOLS_DIR/../gitlab/open_mr_assigned.sh"
alias gomrr="$TOOLS_DIR/../gitlab/open_mr_reviewed.sh"
alias gopmra="$TOOLS_DIR/../gitlab/open_project_mr_assigned.sh"
alias gopmrr="$TOOLS_DIR/../gitlab/open_project_mr_reviewed.sh"
alias gpst="$TOOLS_DIR/../gitlab/poll_pipeline_status.sh"

alias focus="$TOOLS_DIR/../focus/focus.sh"
alias tt="$TOOLS_DIR/../time_tracker/time_tracker.sh"
alias ttst="$TOOLS_DIR/../time_tracker/status.sh"
alias ttds="$TOOLS_DIR/../time_tracker/day_summary.sh"
alias ttws="$TOOLS_DIR/../time_tracker/weekly_summary.sh"
alias ttt="$TOOLS_DIR/../time_tracker/task.sh"
alias ttdat="python3 $TOOLS_DIR/../time_tracker/display_all_tasks.py"
alias ttcct="$TOOLS_DIR/../time_tracker/change_task.sh CURRENT"
alias ttdft="python3 $TOOLS_DIR/../time_tracker/focus_task.py d"
alias ttwft="python3 $TOOLS_DIR/../time_tracker/focus_task.py w"

alias dwp="cd $TOOLS_DIR/../../"
alias gwp="cd ~/IdeaProjects"
alias ewp="cd ~/SelfExploration"
