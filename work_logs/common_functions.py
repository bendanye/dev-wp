from datetime import timedelta


def get_last_monday(specified_date):
    return specified_date - timedelta(days=specified_date.weekday())
