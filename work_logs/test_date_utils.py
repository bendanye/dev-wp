import pytest

from date_utils import get_last_monday, get_last_working_date
from datetime import datetime


@pytest.mark.parametrize(
    "specified_date,expected_date",
    [
        (datetime(2024, 12, 9), datetime(2024, 12, 9)),
        (datetime(2024, 12, 12), datetime(2024, 12, 9)),
        (datetime(2024, 12, 15), datetime(2024, 12, 9)),
    ],
)
def test_get_last_monday_should_get(specified_date, expected_date):
    assert expected_date == get_last_monday(specified_date)


def test_get_last_working_date_should_get_yesterday():
    assert get_last_working_date(datetime(2024, 12, 10)) == datetime(2024, 12, 9)


def test_get_last_working_date_should_get_friday_when_today_is_monday():
    assert get_last_working_date(datetime(2024, 12, 9)) == datetime(2024, 12, 6)
