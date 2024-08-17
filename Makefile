focus:
	./tools/focus/focus.sh

time-tracker:
	./tools/time_tracker/time_tracker.sh

time-tracker-today-summary:
	./tools/time_tracker/day_summary.sh

time-tracker-today-focus-task:
	cd ./tools/time_tracker && python3 focus_task.py d

time-tracker-weekly-summary:
	./tools/time_tracker/weekly_summary.sh

time-tracker-weekly-focus-task:
	cd ./tools/time_tracker && python3 focus_task.py w

kata-daily-summary:
	./katas/daily_summary.sh

kata-daily-schedule:
	./katas/daily_schedule.sh

kata-all-daily-summary:
	./katas/all_daily_summary.sh

kata-all-weekly-summary:
	./katas/all_weekly_summary.sh

command-kata:
	cd katas/kata-in-terminal && python3 src/main.py --folder_path command-kata-main

command-kata-from-incorrect-answers:
	cd katas/kata-in-terminal && python3 src/main.py --folder_path command-kata-main --question_option "incorrect_ans"

shortcut-terminal-kata:
	./katas/shortcut-kata/terminal/start.sh

shortcut-browser-kata:
	./katas/shortcut-kata/browser/start.sh

shortcut-vi-kata:
	./katas/shortcut-kata/vi/start.sh

shortcut-mac-kata:
	./katas/shortcut-kata/mac/start.sh

code-kata:
	cd ./katas/code-kata/ && ./start.sh -l rand -t problem-solving -d rand

code-kata-easy:
	cd ./katas/code-kata/ && ./start.sh -l rand -t problem-solving -d easy

refactoring-kata:
	cd ./katas/refactoring-kata-main/ && ./start.sh

autocomplete-docker-kata:
	./katas/autocomplete-kata-main/docker/start.sh
