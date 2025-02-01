from datetime import datetime

from task_utils import get_last_working_day_tasks

WORK_LOG_DIRECTORY = "examples"


def test_get_last_working_day_tasks_should_get_yesterday_when_not_empty():
    specified_date = datetime(2024, 12, 25)
    assert get_last_working_day_tasks(WORK_LOG_DIRECTORY, specified_date) == [
        "\n",
        "\n",
        "- [ABCD-1234] testing\n",
        "\n",
        "  - i worked on testing portion\n",
        "\n",
        "- [ABCD-2233] testing 22\n",
        "\n",
        "  - i checked on how testing 22 outcome\n",
        "\n",
        "- troubleshooting something\n",
    ]


def test_get_last_working_day_tasks_should_get_the_last_working_day_when_yesterday_is_empty():
    specified_date = datetime(2024, 12, 26)
    assert get_last_working_day_tasks(WORK_LOG_DIRECTORY, specified_date) == [
        "\n",
        "\n",
        "- [ABCD-1234] testing\n",
        "\n",
        "  - i worked on testing portion\n",
        "\n",
        "- [ABCD-2233] testing 22\n",
        "\n",
        "  - i checked on how testing 22 outcome\n",
        "\n",
        "- troubleshooting something\n",
    ]
