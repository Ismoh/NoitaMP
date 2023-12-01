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
import shutil
import argparse


GIT_DIR = os.path.dirname(__file__)
CONFIG_PATH = GIT_DIR + r'\config_test.xml'

# default options
NOITA_DIR = r'C:\Program Files (x86)\Steam\steamapps\common\Noita'
SAVE_SLOT = 1
GAME_MODE = 4

def main():
    ap = argparse.ArgumentParser(description="Start 2 instances of noita to test/debug NoitaMP")
    ap.add_argument("--noita-dir", "-n", help="path to noita directory (default %s)"%NOITA_DIR, default=NOITA_DIR)
    ap.add_argument("--slot", "-s", type=int, help="save slot to load on each instance (0-indexed, default %d)"%SAVE_SLOT, default=SAVE_SLOT)
    ap.add_argument("--gamemode", "-g", type=int, help="NoitaMP game mode index in the New Game menu (0-indexed, default %d)"%GAME_MODE, default=GAME_MODE)
    args = ap.parse_args()

    noita_bin = args.noita_dir + r'\noita.exe'
    noita2_bin = args.noita_dir + r'\noita2.exe'

    make_client_exe(noita_bin, noita2_bin)
    write_config(CONFIG_PATH)

    server_window = start_exe(noita_bin,  mode=args.gamemode, slot=args.slot, config=CONFIG_PATH)
    client_window = start_exe(noita2_bin, mode=args.gamemode, slot=args.slot, config=CONFIG_PATH)

    server_window.moveTo(0, 0)
    client_window.moveTo(server_window.left+server_window.width+30, 0)

    time.sleep(60)

def start_exe(exe, mode, slot, config):
    start = {x._hWnd: x for x in gw.getWindowsWithTitle('Noita - Build')}

    os.chdir(os.path.dirname(exe))
    fn = os.path.basename(exe)
    os.system('start "" %s -no_logo_splashes -windowed -config "%s" -gamemode %d -save_slot %d'%(fn, config, mode, slot))
    os.chdir(GIT_DIR)

    print("waiting for %s window to pop up..."%fn)
    while True:
        now = gw.getWindowsWithTitle('Noita - Build')
        if len(now) > len(start):
            for x in now:
                if x._hWnd not in start.keys():
                    return x
        time.sleep(0.2)

def make_client_exe(original_exe, new_client_exe):
    if os.path.exists(new_client_exe):
        return

    shutil.copyfile(original_exe, new_client_exe)
    with open(new_client_exe, "rb+") as f:
        buf = f.read()
        offset = buf.find(b'logger.txt')
        f.seek(offset, 0)
        f.write(b'logge2.txt')

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
