from datetime import datetime

from read_utils import get_tasks, get_goals

WORK_LOG_DIRECTORY = "examples"


def test_get_tasks_should_get_list_when_task_is_entered():
    specified_date = datetime(2024, 12, 24)
    assert get_tasks(WORK_LOG_DIRECTORY, specified_date) == [
        "- [ABCD-1234] testing\n",
        "  - i worked on testing portion\n",
        "\n",
        "- [ABCD-2233] testing 22\n",
        "  - i checked on how testing 22 outcome\n",
        "\n",
        "- troubleshooting something\n",
    ]


def test_get_tasks_should_get_empty_list_with_specified_date_when_nothing_is_entered():
    specified_date = datetime(2024, 12, 25)
    assert get_tasks(WORK_LOG_DIRECTORY, specified_date) == []


def test_get_goals_should_get_list_when_goal_is_entered():
    specified_date = datetime(2024, 12, 23)
    assert get_goals(WORK_LOG_DIRECTORY, specified_date) == [
        "- to get things done\n",
    ]


def test_get_goals_should_get_empty_list_with_specified_date_when_nothing_is_entered():
    specified_date = datetime(2024, 12, 25)
    assert get_goals(WORK_LOG_DIRECTORY, specified_date) == []
