kata-daily-summary:
	python3 ./katas/daily_summary.py

kata-daily-schedule:
	python3 ./katas/daily_schedule.py

kata-all-daily-summary:
	python3 ./katas/all_daily_summary.py

kata-all-weekly-summary:
	./katas/all_weekly_summary.sh

command-kata:
	cd katas/kata-in-terminal && python3 src/main.py --folder_path command-kata-main

command-kata-from-incorrect-answers:
	cd katas/kata-in-terminal && python3 src/main.py --folder_path command-kata-main --question_option "incorrect_ans"

shortcut-kata-exclude-ide:
	./katas/shortcut-kata/start_all_exclude_ide.sh

code-kata:
	cd ./katas/code-kata/ && ./start.sh -l rand -t problem-solving -d rand

code-kata-easy:
	cd ./katas/code-kata/ && ./start.sh -l rand -t problem-solving -d easy

refactoring-kata:
	cd ./katas/refactoring-kata-main/ && ./start.sh

autocomplete-docker-kata:
	./katas/autocomplete-kata-main/docker/start.sh
