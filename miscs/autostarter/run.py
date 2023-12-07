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
# or
# >
# pip install -r requirements.txt
#
# Run
# -------
# > python run.py --log=merged --slots 1 2
#

import argparse
import os
import pyautogui
import pygetwindow as gw
import shutil
import subprocess
import time
import re

GIT_DIR = os.path.dirname(__file__)
CONFIG_PATH = GIT_DIR + r'\config_test.xml'

# default options
NOITA_DIR = r'C:\Program Files (x86)\Steam\steamapps\common\Noita'
SAVE_SLOT = [1, 2]
GAME_MODE = 4
LOG = 'off'

def main():
    ap = argparse.ArgumentParser(description="Start 2 instances of noita to test/debug NoitaMP")
    ap.add_argument("--dev", "-d", help="use noita_dev.exe", action="store_true", default=False)
    ap.add_argument("--log", "-l", help="logging mode (default %s)"%LOG, choices=['off', 'on', 'merged'], default=LOG)
    ap.add_argument("--noita-dir", "-n", help="path to noita directory (default %s)"%NOITA_DIR, default=NOITA_DIR)
    ap.add_argument("--slots", "-s", type=int, nargs="*", help="comma separated save slot list to load on each instance (1-indexed, default %s)"%SAVE_SLOT, default=SAVE_SLOT)
    ap.add_argument("--gamemode", "-g", type=int, help="NoitaMP game mode index in the New Game menu (0-indexed, default %d)"%GAME_MODE, default=GAME_MODE)
    ap.add_argument("--update", "-u", action="store_true", help="update NoitaMP in Noita install by deleting and copying the mod from git", default=False)
    ap.add_argument("--kill", "-k", action="store_true", help="kill any running Noita instances", default=False)

    args = ap.parse_args()

    if args.dev:
        setup_dev_env(args.noita_dir)
        noita_bin = args.noita_dir + r'\noita_dev.exe'
        noita2_bin = args.noita_dir + r'\noita2_dev.exe'
        args.log = 'off'
    else:
        noita_bin = args.noita_dir + r'\noita.exe'
        noita2_bin = args.noita_dir + r'\noita2.exe'

    make_client_exe(noita_bin, noita2_bin)
    write_config(CONFIG_PATH)

    if args.kill:
        kill_process("noita_dev.exe")
        kill_process("noita2_dev.exe")
        kill_process("noita.exe")
        kill_process("noita2.exe")
        time.sleep(1)

    if args.update:
        update_mod(args.noita_dir)

    server_window, server_dev_console = start_exe(noita_bin,  mode=args.gamemode, slot=args.slots[0], config=CONFIG_PATH)
    client_window, client_dev_console = start_exe(noita2_bin, mode=args.gamemode, slot=args.slots[1], config=CONFIG_PATH)

    server_window.moveTo(0, 0)
    if server_dev_console:
        server_dev_console.moveTo(server_window.left, server_window.top + server_window.height)

    client_window.moveTo(server_window.left+server_window.width+30, 0)
    if client_dev_console:
        client_dev_console.moveTo(client_window.left, client_window.top + client_window.height)

    if args.log == 'merged':
        server_log = LogPoll(args.noita_dir + r'\logger.txt', prefix='\x1b[31m[SERVER]\x1b[0m ')
        client_log = LogPoll(args.noita_dir + r'\logge2.txt', prefix='\x1b[32m[CLIENT]\x1b[0m ')
        while True:
            server_log.read_and_print()
            client_log.read_and_print()
            time.sleep(.5)
    elif args.log == 'on':
        start_log_console(args.noita_dir + r'\logger.txt',
                          args.noita_dir + r'\logge2.txt',
                          pos_y=server_window.top+server_window.height)


def update_mod(noita_dir):
    mod = find_git_root() + r'\mods\noita-mp'
    noitamp_dir = noita_dir + r'\mods\noita-mp'
    if os.path.exists(noitamp_dir):
        print("removing old mod files...")
        shutil.rmtree(noitamp_dir)
    print("copying mod files from git...")
    shutil.copytree(mod, noitamp_dir)

def start_exe(exe, mode, slot, config):
    fn = os.path.basename(exe)
    #start = {x._hWnd: x for x in gw.getAllWindow() if re.search(r'^(Noita -|(noita|noita2)(_dev)?\.exe)', x.title)}
    start = {x._hWnd: x for x in gw.getAllWindows() if re.search(r'^Noita -', x.title)}
    start_con = {x._hWnd: x for x in gw.getAllWindows() if re.search(r'^%s'%fn, x.title)}

    con_win = None
    gam_win = None

    os.chdir(os.path.dirname(exe))
    os.system('start "" %s -no_logo_splashes -windowed -config "%s" -gamemode %d -save_slot %d'%(fn, config, mode, slot))
    os.chdir(GIT_DIR)

    print("waiting for %s window to pop up..."%fn)
    while True:
        if gam_win is None:
            now = gw.getWindowsWithTitle('Noita - ')
            if len(now) > len(start):
                for x in now:
                    if x._hWnd not in start.keys():
                        gam_win = x

        if 'dev' in fn:
            if con_win is None:
                now_con = gw.getWindowsWithTitle(fn)
                if len(now_con) > len(start_con):
                    for x in now_con:
                        if x._hWnd not in start_con.keys():
                            con_win = x

            if gam_win and con_win:
                return gam_win, con_win
        else:
            if gam_win:
                return gam_win, con_win

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


def start_log_console(log_client, log_server, pos_y=0):
    log_dir = os.path.dirname(log_client)
    log_client_fn = os.path.basename(log_client)
    log_server_fn = os.path.basename(log_server)
    subprocess.run(["wt.exe", "--pos", "0,%d"%pos_y,
                    "nt",       "-d", log_dir, "powershell.exe", "-command", 'Get-Content -Path "%s" -Wait'%log_server_fn, ';',
                    "sp", "-V", "-d", log_dir, "powershell.exe", "-command", 'Get-Content -Path "%s" -Wait'%log_client_fn,
                    ])
    print("ok")


class LogPoll:
    def __init__(self, path, prefix):
        self._path = path
        self._last_offset = 0
        self._prefix = prefix
        self._need_prefix = False

    def read_and_print(self):
        with open(self._path, "r") as f:
            f.seek(self._last_offset, 0)
            buf = f.read()
            end = ''
            if len(buf) > 0:
                if buf[-1] == '\n':
                    buf = buf[:-1]
                    end = '\n'
                    nextpref = True
                else:
                    nextpref = False
                buf = buf.replace('\n', '\n'+self._prefix)
                if self._need_prefix:
                    buf = self._prefix + buf
                else:
                    self._need_prefix = nextpref
                print(buf, end=end)
                self._last_offset = f.tell()

def setup_dev_env(noita_dir):
    if os.path.exists(noita_dir + r'\wang_gen.exe'):
        return
    os.chdir(noita_dir + r'\tools_modding')
    os.system('copy *.* ..')
    os.chdir(noita_dir)
    os.system('data_wak_unpack')

def kill_process(path):
    exe = os.path.basename(path)
    os.system('taskkill /im %s'%exe)

def find_git_root():
    d = os.path.dirname(__file__)
    while d:
        if os.path.exists(d + r'\.git'):
            return d
        d = os.path.realpath(d + r'\..')

if __name__ == '__main__':
    main()
