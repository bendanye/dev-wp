#/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

_time_tracker_task_completions()
{
  for OUTPUT in $(python3 $SCRIPT_DIR/../time_tracker/display_all_tasks.py NO_HEADER)
  do
    COMPREPLY+=("$OUTPUT")
  done
}

_docker_image_name_completions()
{
  for OUTPUT in $(docker images --format "{{.Repository}}:{{.Tag}}")
  do
    COMPREPLY+=("$OUTPUT")
  done
}

_git_project_completions()
{
  if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
  else
    GIT_PROJECT_DIR="$HOME/IdeaProjects"
  fi

  for OUTPUT in $(ls "$GIT_PROJECT_DIR")
  do
    COMPREPLY+=("$OUTPUT")
  done
}

_browser_keys_completions()
{
  for OUTPUT in $(grep -E '^[^#;]' "$SCRIPT_DIR/../browser/url.properties" | cut -d'=' -f1 | cut -d':' -f1)
  do
    COMPREPLY+=("$OUTPUT")
  done
}

# source autocomplete.sh
# complete -F _time_tracker_task_completions time_tracker.sh
# complete -F _time_tracker_task_completions change_task.sh

# complete -F _docker_image_name_completions docker_container_logs_by_image_name.sh
# complete -F _docker_image_name_completions docker_remove_container_and_image.sh

# complete -F _git_project_completions open_project_mr_assigned.sh
# complete -F _git_project_completions open_project_mr_reviewed.sh
# complete -F _git_project_completions open_project_pipeline.sh
# complete -F _git_project_completions open_project.sh
# complete -F _git_project_completions poll_pipeline_status.sh
# complete -F _git_project_completions ci_linter.sh

# complete -F _browser_keys_completions browser.sh