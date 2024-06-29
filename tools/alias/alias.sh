alias drma='docker rm $(docker ps -aq) --force'
alias drmdn='docker rm $(docker ps -aq -f status=exited -f status=created -f status=dead -f status=paused) --force'
alias dpsa="docker ps -a"
alias dpsadn="docker ps -a --filter \"status=exited\" --filter \"status=created\" --filter \"status=dead\" --filter \"status=paused\""
alias caf="caffeinate -dims"
alias ll="ls -al"
alias zshrc="vi ~/.zshrc"
alias hm="cd ~"
alias c="clear"
alias rmf="rm -rf"
alias ..="cd .."

TOOLS_DIR="$(dirname "$0")"

alias ob="$TOOLS_DIR/../browser/browser.sh"
alias obcg="$TOOLS_DIR/../browser/browser.sh cgpt"
alias obhm="$TOOLS_DIR/../browser/browser.sh hm"

alias dicrm="$TOOLS_DIR/../docker/docker_remove_container_and_image.sh"
alias dloi="$TOOLS_DIR/../docker/docker_container_logs_by_image_name.sh"

alias kp="$TOOLS_DIR/../networking/kill_port.sh"

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

if [ -f "$TOOLS_DIR/../gitlab.env" ]; then
    alias gop="$TOOLS_DIR/../gitlab/open_project_page.sh PROJECT"
    alias gopmra="$TOOLS_DIR/../gitlab/open_project_page.sh MR_ASSIGNED"
    alias gopmrr="$TOOLS_DIR/../gitlab/open_project_page.sh MR_REVIEWED"
    alias gopp="$TOOLS_DIR/../gitlab/open_project_page.sh PIPELINE"
    alias gopc="$TOOLS_DIR/../gitlab/open_project_page.sh COMMITS"
    alias gopr="$TOOLS_DIR/../gitlab/open_project_page.sh SETTINGS_REPOSITORY"
    alias gomra="$TOOLS_DIR/../gitlab/open_page.sh MR_ASSIGNED"
    alias gomrr="$TOOLS_DIR/../gitlab/open_page.sh MR_REVIEWED"
    alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    alias glint="$TOOLS_DIR/../gitlab/ci_linter/ci_linter.sh"
    alias gpst="$TOOLS_DIR/../gitlab/poll_pipeline_status.sh"
    alias gmst="$TOOLS_DIR/../gitlab/get_mirror_status.sh"
else
    alias gop="$TOOLS_DIR/../git/open_project_in_browser.sh"
fi
alias gclc="$TOOLS_DIR/../git/copy_last_commit_msg.sh"

alias tt="$TOOLS_DIR/../time_tracker/time_tracker.sh"
alias ttst="$TOOLS_DIR/../time_tracker/status.sh"
alias ttds="$TOOLS_DIR/../time_tracker/day_summary.sh"
alias ttdsa="$TOOLS_DIR/../time_tracker/day_summary.sh -a ALL_TASKS"
alias ttdse="$TOOLS_DIR/../time_tracker/day_summary.sh -a EXCLUDE_TASKS"
alias ttws="$TOOLS_DIR/../time_tracker/weekly_summary.sh"
alias ttwse="$TOOLS_DIR/../time_tracker/weekly_summary.sh -a ALL_TASKS"
alias ttwse="$TOOLS_DIR/../time_tracker/weekly_summary.sh -a EXCLUDE_TASKS"
alias ttt="$TOOLS_DIR/../time_tracker/task.sh"
alias ttdat="python3 $TOOLS_DIR/../time_tracker/display_all_tasks.py"
alias ttcct="$TOOLS_DIR/../time_tracker/change_task.sh CURRENT"
alias ttdft="python3 $TOOLS_DIR/../time_tracker/focus_task.py d"
alias ttwft="python3 $TOOLS_DIR/../time_tracker/focus_task.py w"
alias ttctt="$TOOLS_DIR/../time_tracker/change_today_tracking_file.sh EDIT"
alias ttcth="$TOOLS_DIR/../time_tracker/change_today_tracking_file.sh HALF"

alias dwp="cd $TOOLS_DIR/../../"
alias ewp="cd ~/SelfExploration"

if [ -f "$TOOLS_DIR/../source.env" ]; then
    source "$TOOLS_DIR/../source.env"
    alias gwp="cd $GIT_PROJECT_DIR"
else
    alias gwp="cd ~/IdeaProjects"
fi
