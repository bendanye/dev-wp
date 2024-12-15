import pytest

from common_functions import get_last_monday
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
