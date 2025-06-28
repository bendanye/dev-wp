alias drma='docker rm $(docker ps -aq) --force'
alias drmdn='docker rm $(docker ps -aq -f status=exited -f status=created -f status=dead -f status=paused) --force'
alias drmd='docker rmi $(docker images -f "dangling=true" -q)'
alias dpsa="docker ps -a"
alias dpsadn="docker ps -a --filter \"status=exited\" --filter \"status=created\" --filter \"status=dead\" --filter \"status=paused\""
alias ll="ls -al"
alias hm="cd ~"
alias c="clear"
alias rmf="rm -rf"
alias ..="cd .."

if [[ $OSTYPE == "darwin"* ]]; then
    alias caf="caffeinate -dims"
    alias zshrc="vi ~/.zshrc"
    alias cfn='basename `pwd` | pbcopy'
    alias ccp='echo `pwd` | pbcopy'

    ALIAS_SCRIPT_DIR="$(dirname "$0")"
elif [[ $OSTYPE == "msys" || $OSTYPE == "cygwin"* ]]; then
    alias cfn='basename `pwd` | clip'
    alias ccp='echo `pwd` | clip'

    echo "Please uncomment and set ALIAS_SCRIPT_DIR for windowa"
    ALIAS_SCRIPT_DIR=""
fi

# alias dpt="$ALIAS_SCRIPT_DIR/../../other_tools/yet-another-dev-productivity-tools/run.sh"

alias phn="python3 $ALIAS_SCRIPT_DIR/../../other_tools/public-holiday/get_dates.py 1"

alias taska="sh task-todo/add_task.sh"
alias taskui="sh task-todo/ui.sh"

alias ob="$ALIAS_SCRIPT_DIR/../browser/browser.sh"
alias obcg="$ALIAS_SCRIPT_DIR/../browser/browser.sh cgpt"
alias obhm="$ALIAS_SCRIPT_DIR/../browser/browser.sh hm"
alias obdpt="$ALIAS_SCRIPT_DIR/../browser/browser.sh dpt"

alias dicrm="$ALIAS_SCRIPT_DIR/../docker/docker_remove_container_and_image.sh"
alias dloi="$ALIAS_SCRIPT_DIR/../docker/docker_container_logs_by_image_name.sh"

alias kp="$ALIAS_SCRIPT_DIR/../networking/kill_port.sh"

alias datecal="python3 $ALIAS_SCRIPT_DIR/../calculator/date_calculator.py"
alias epochcal="sh $ALIAS_SCRIPT_DIR/../calculator/epoch_calculator.sh"
alias epochconvert="sh $ALIAS_SCRIPT_DIR/../epoch/epoch_to_date_converter.sh"

alias ssif="$ALIAS_SCRIPT_DIR/../search/search_string_in_files.sh"
alias ffn="$ALIAS_SCRIPT_DIR/../search/find_by_file_name.sh"
alias stopwatch="$ALIAS_SCRIPT_DIR/../stopwatch/stopwatch.sh"
alias cdtimer="$ALIAS_SCRIPT_DIR/../countdown_timer/countdown_timer.sh"

alias comm="$ALIAS_SCRIPT_DIR/../communication/communications.sh"
alias commOn="$ALIAS_SCRIPT_DIR/../communication/communications.sh on"
alias commOff="$ALIAS_SCRIPT_DIR/../communication/communications.sh off"

alias cgwp="$ALIAS_SCRIPT_DIR/../git/open_vscode.sh"
alias cwlc="$ALIAS_SCRIPT_DIR/../../work_logs/open_work_log.sh current"
alias cwlp="$ALIAS_SCRIPT_DIR/../../work_logs/open_work_log.sh previous"

alias cs="$ALIAS_SCRIPT_DIR/../card_management/copy_screenshots.sh"
alias nc="$ALIAS_SCRIPT_DIR/../card_management/new_card.sh"
alias od="$ALIAS_SCRIPT_DIR/../card_management/open_card_directory.sh"
alias zcte="$ALIAS_SCRIPT_DIR/../card_management/zip_card_evidences.sh"
alias vicm="$ALIAS_SCRIPT_DIR/../card_management/card_management_list.sh"
alias vicn="$ALIAS_SCRIPT_DIR/../card_management/open_notes.sh"

alias joc="$ALIAS_SCRIPT_DIR/../jira/jira_card.sh"
alias job="$ALIAS_SCRIPT_DIR/../jira/jira_board_web.sh"
alias jcua="$ALIAS_SCRIPT_DIR/../jira/jira_upload_attachment.sh"

if [ -f "$ALIAS_SCRIPT_DIR/../gitlab.env" ]; then
    alias gop="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh PROJECT"
    alias gopb="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh PROJECT_BRANCH"
    alias gopbr="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh BRANCHES"
    alias gopmr="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh MR"
    alias gopmrb="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh MR_BRANCH"
    alias gopmra="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh MR_ASSIGNED"
    alias gopmrr="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh MR_REVIEWED"
    alias gopp="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh PIPELINE"
    alias goppb="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh PIPELINE_BRANCH"
    alias gopc="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh COMMITS"
    alias gopcb="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh COMMITS_BRANCH"
    alias gopr="$ALIAS_SCRIPT_DIR/../gitlab/open_project_page.sh SETTINGS_REPOSITORY"
    alias gomra="$ALIAS_SCRIPT_DIR/../gitlab/open_page.sh MR_ASSIGNED"
    alias gomrr="$ALIAS_SCRIPT_DIR/../gitlab/open_page.sh MR_REVIEWED"
    alias glint="$ALIAS_SCRIPT_DIR/../gitlab/ci_linter/ci_linter.sh"
    alias gpst="$ALIAS_SCRIPT_DIR/../gitlab/poll_pipeline_status.sh"
    alias gmst="$ALIAS_SCRIPT_DIR/../gitlab/get_mirror_status.sh"
else
    alias gop="$ALIAS_SCRIPT_DIR/../git/open_project_in_browser.sh"
fi

# alias gl="$ALIAS_SCRIPT_DIR/../git/git_pull_and_check.sh"
alias gclc="$ALIAS_SCRIPT_DIR/../git/copy_last_commit_msg.sh"
alias gwp="$ALIAS_SCRIPT_DIR/../git/goto_directory.sh"
alias ggpcw="$ALIAS_SCRIPT_DIR/../git/get_all_projects_commit_within_specified.sh"
alias glo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ghm="cd \"\$(git rev-parse --show-toplevel)\""
alias gulc="git reset --soft HEAD~1"

alias hg="$ALIAS_SCRIPT_DIR/../git/keyword_finder/run_keyword_finder.sh git"
alias hglog="$ALIAS_SCRIPT_DIR/../git/keyword_finder/run_keyword_finder.sh glog"
alias hcm="$ALIAS_SCRIPT_DIR/../card_management/keyword_finder/run_keyword_finder.sh list"
alias htt="$ALIAS_SCRIPT_DIR/../time_tracker/keyword_finder/run_keyword_finder.sh dat"
alias ha="$ALIAS_SCRIPT_DIR/../alias/keyword_finder/run_keyword_finder.sh list"

alias tt="$ALIAS_SCRIPT_DIR/../time_tracker/time_tracker.sh"
alias ttst="python3 $ALIAS_SCRIPT_DIR/../time_tracker/status.py SHOW"
alias ttstl="python3 $ALIAS_SCRIPT_DIR/../time_tracker/status.py LOOP"
alias ttds="$ALIAS_SCRIPT_DIR/../time_tracker/day_summary.sh -a EXCLUDE_TASKS"
alias ttdsa="$ALIAS_SCRIPT_DIR/../time_tracker/day_summary.sh -a ALL_TASKS"
alias ttdse="$ALIAS_SCRIPT_DIR/../time_tracker/day_summary.sh -a EXCLUDE_TASKS"
alias ttws="$ALIAS_SCRIPT_DIR/../time_tracker/weekly_summary.sh -a EXCLUDE_TASKS"
alias ttwse="$ALIAS_SCRIPT_DIR/../time_tracker/weekly_summary.sh -a ALL_TASKS"
alias ttwse="$ALIAS_SCRIPT_DIR/../time_tracker/weekly_summary.sh -a EXCLUDE_TASKS"
alias ttt="python3 $ALIAS_SCRIPT_DIR/../time_tracker/task_summary.py"
alias ttdat="python3 $ALIAS_SCRIPT_DIR/../time_tracker/display_all_tasks.py"
alias ttcct="python3 $ALIAS_SCRIPT_DIR/../time_tracker/change_task.py CURRENT"
alias ttdft="python3 $ALIAS_SCRIPT_DIR/../time_tracker/focus_task.py d"
alias ttwft="python3 $ALIAS_SCRIPT_DIR/../time_tracker/focus_task.py w"
alias ttpft="python3 $ALIAS_SCRIPT_DIR/../time_tracker/focus_task.py p"
alias ttctt="$ALIAS_SCRIPT_DIR/../time_tracker/change_today_tracking_file.sh EDIT"
alias ttcth="$ALIAS_SCRIPT_DIR/../time_tracker/change_today_tracking_file.sh HALF"
alias ttptt="$ALIAS_SCRIPT_DIR/../time_tracker/change_previous_tracking_file.sh"
alias ttstt="python3 $ALIAS_SCRIPT_DIR/../time_tracker/split_last_task.py"
alias ttclt="python3 $ALIAS_SCRIPT_DIR/../time_tracker/change_last_task_minutes.py"

alias dwp="cd $ALIAS_SCRIPT_DIR/../../"
alias ewp="cd ~/SelfExploration"