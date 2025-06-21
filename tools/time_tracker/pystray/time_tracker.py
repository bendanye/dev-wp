from pystray import Icon, MenuItem, Menu
from PIL import Image, ImageDraw, ImageFont

import threading
import time
import os

UPDATE_SECONDS = 1

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(SCRIPT_DIR)


def create_time_tracker_icon():
    timer_file = f"{SCRIPT_DIR}/../../pomodoro_timer/timer"
    if not os.path.isfile(timer_file):
        return create_icon("NO", "black")

    with open(timer_file, "r") as file:
        line = file.readline().strip()
        start_str = line.split(",")[0]

        start = int(start_str)
        end = int(time.time())
        duration = end - start
        minutes = duration // 60

        if minutes < 25:
            return create_icon(str(minutes), "black")
        elif minutes < 50:
            return create_icon(str(minutes), "darkgreen")
        else:
            return create_icon(str(minutes), "darkred")


def create_icon(text, text_color):
    image = Image.new("RGB", (64, 64), "white")
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype(f"{SCRIPT_DIR}/ARIAL.TTF", 40)
    draw.text((7, 5), text, fill=text_color, font=font, align="center")
    return image


def update_icon(icon):
    while icon.visible:
        icon.icon = create_time_tracker_icon()
        time.sleep(UPDATE_SECONDS)


def quit_action(icon, item):
    icon.stop()


def delayed_start(icon):
    time.sleep(0.5)
    threading.Thread(target=update_icon, args=(icon,), daemon=True).start()


def main():
    icon = Icon(
        "Time Tracker Icon",
        icon=create_time_tracker_icon(),
        menu=Menu(MenuItem("Quit", quit_action)),
    )

    threading.Timer(1, delayed_start, args=(icon,)).start()
    icon.run()


if __name__ == "__main__":
    main()
