from datetime import timedelta


def get_last_monday(specified_date):
    return specified_date - timedelta(days=specified_date.weekday())


def get_last_working_date(specified_date):
    weekday = specified_date.weekday()

    if weekday == 0:
        last_working_day = specified_date - timedelta(days=3)
    else:
        last_working_day = specified_date - timedelta(days=1)

    return last_working_day
