#!/usr/bin/env python3
#
# Install
# -------
#
# 1. Install python if not already installed.
# This can be done by just running "python", it will open the windows store to install
#
# 2. Install dependencies
# > pip install pyautogui pygetwindow opencv-python
#

import pyautogui
import pygetwindow as gw
import os
import time

GIT_DIR = os.path.dirname(__file__)
NOITA_DIR = r'C:\Program Files (x86)\Steam\steamapps\common\Noita'

CONFIG_PATH = GIT_DIR + r'\config_test.xml'
NOITA_BIN = NOITA_DIR + r'\noita.exe'

def main():
    write_config(CONFIG_PATH)

    # start server instance
    os.chdir(NOITA_DIR)
    os.system('start "" noita.exe -windowed -config "%s"'%(CONFIG_PATH))
    os.chdir(GIT_DIR)
    time.sleep(3)

    server_window = find_noita_window()
    server_window.moveTo(0, 0)
    time.sleep(0.5)

    noita_click(server_window, 'newgame-btn.png')
    noita_click(server_window, 'noitamp-btn.png', confidence=0.5)
    noita_click(server_window, 'world2-btn.png')

    # start client instance
    os.chdir(NOITA_DIR)
    os.system('start "" noita.exe -windowed -config "%s"'%(CONFIG_PATH))
    os.chdir(GIT_DIR)
    time.sleep(3)

    client_window = find_noita_window(exclude=[server_window])
    client_window.moveTo(server_window.left+server_window.width+30, 0)
    time.sleep(0.5)

    noita_click(client_window, 'newgame-btn.png')
    noita_click(client_window, 'noitamp-btn.png', confidence=0.5)
    noita_click(client_window, 'world2-btn.png')


    time.sleep(60)

def noita_click(window, img, confidence=0.8, sleep=0.5):
    game = pyautogui.screenshot(region=(window.left, window.top, window.width, window.height))
    r = pyautogui.locate(img, game, confidence=confidence)
    print("located btn at", r)
    p = pyautogui.center(r)
    print("center at", p)
    print("abs", window.top+p.y, window.left+p.x)
    pyautogui.moveTo(window.left+p.x, window.top+p.y)
    pyautogui.click(window.left+p.x, window.top+p.y)
    time.sleep(sleep)

def find_noita_window(exclude=None):
    winlist = gw.getWindowsWithTitle('Noita - Build')
    if exclude:
        for w in winlist:
            if w not in exclude:
                return w
    return winlist[0]

def write_config(path):
    with open(path, "w+") as f:
        print("""
    <Config
    	vsync="2"

    	sounds="1"

    	record_events="0"
    	do_a_playback="0"

      	report_fps="0"
      	event_recorder_flush_every_frame="0"


    	fullscreen="0"
    	display_id="0"

    	internal_size_w="1280"
    	internal_size_h="720"

    	joysticks_enabled="1"
    	gamepad_mode="-1"

    	ui_report_damage="1"

    	application_rendered_cursor="0"
    	is_default_config="0"

      has_been_started_before="1"
      last_started_game_version_hash="3cb5b0870058b819c65ca3288fdfc6c2cf554021"
      mods_disclaimer_accepted="1"
      mods_sandbox_enabled="0"
      mods_sandbox_warning_done="1"
      config_format_version="14"
      mods_active_privileged="1"
    >
    </Config>
        """, file=f)

if __name__ == '__main__':
    main()
