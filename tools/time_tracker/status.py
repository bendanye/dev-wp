import os
import time
import sys

if os.name == "nt":
    import msvcrt
else:
    import termios
    import tty
    import select


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    timer_file = os.path.join(script_dir, "../pomodoro_timer/timer")

    if not os.path.isfile(timer_file):
        print("Timer not started!")
        return

    while True:
        with open(timer_file, "r") as file:
            start, task = file.read().strip().split(",")
            start = int(start)

        end = int(time.time())
        duration = end - start
        minutes, seconds = divmod(duration, 60)

        if task == "MISC":
            message = f"\r Currently at my desk for {minutes} minutes and {seconds} seconds (press space to exit) "
        else:
            message = f"\r Currently at my desk focusing on {task} for {minutes} minutes and {seconds} seconds (press space to exit) "

        print(message, end="", flush=True)

        try:
            key = input_timeout(1)
            if key == " ":
                break
        except TimeoutError:
            continue


def input_timeout(timeout):
    if os.name == "nt":
        start_time = time.time()
        while (time.time() - start_time) < timeout:
            if msvcrt.kbhit():  # Check if a key has been pressed
                return msvcrt.getch().decode("utf-8")  # Read the key and decode it
    else:
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            rlist, _, _ = select.select([sys.stdin], [], [], timeout)
            if rlist:
                return sys.stdin.read(1)
            else:
                raise TimeoutError
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


if __name__ == "__main__":
    main()
