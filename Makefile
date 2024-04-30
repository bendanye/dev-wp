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
