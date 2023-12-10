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
import hashlib
import os
import re
import shutil
import subprocess
import time

import pyautogui
import pygetwindow as gw
from PIL import Image


def get_git_root(path: str) -> str:
    filesystem_root = os.path.abspath('.').split(os.path.sep)[0] + os.path.sep
    while not os.path.exists(path + r'\.git'):
        if path == filesystem_root:
            raise LookupError("Git dir not found. Probably the repo is downloaded as zip.")
        path = os.path.realpath(path + r'\..')
    return path


CURRENT_DIR = os.getcwd()
GIT_DIR = get_git_root(CURRENT_DIR)
SCRIPT_DIR = os.path.dirname(__file__)
CONFIG_PATH = SCRIPT_DIR + r'\config_test.xml'
LUA_ORIG_SHA1 = '1a8bce6cb7acc4575ed114ce1a685ae540a5e9be'

# default options
NOITA_DIR = r'C:\Program Files (x86)\Steam\steamapps\common\Noita'
SAVE_SLOT = [1, 2]
GAME_MODE = 4
LOG = 'off'
LUA_VER = 'latest'


class ProgramArgs(argparse.Namespace):
    dev: bool
    log: str
    noita_dir: str
    slots: list[int]
    gamemode: int
    update: bool
    kill: bool
    lua: str


def main() -> None:
    arg_parser = argparse.ArgumentParser(description="Start 2 instances of noita to test/debug NoitaMP")
    arg_parser.add_argument("--dev", "-d",
                            help="use noita_dev.exe",
                            action="store_true",
                            default=False)
    arg_parser.add_argument("--log", "-l",
                            help=f"logging mode, only applies to non-dev mode (default {LOG})",
                            choices=['off', 'on', 'merged'],
                            default=LOG)
    arg_parser.add_argument("--noita-dir", "-n",
                            metavar="DIR",
                            help=f"path to noita directory (default {NOITA_DIR})",
                            default=NOITA_DIR)
    arg_parser.add_argument("--slots", "-s",
                            type=int,
                            nargs="*",
                            help=f"comma separated save slot list to load on each instance (1-indexed, default {SAVE_SLOT})",
                            default=SAVE_SLOT)
    arg_parser.add_argument("--gamemode", "-g",
                            metavar="N",
                            type=int,
                            help=f"NoitaMP game mode index in the New Game menu (0-indexed, default {GAME_MODE})",
                            default=GAME_MODE)
    arg_parser.add_argument("--update", "-u",
                            action="store_true",
                            help="update NoitaMP in Noita install by deleting and copying the mod from git",
                            default=False)
    arg_parser.add_argument("--kill", "-k",
                            action="store_true",
                            help="kill any running Noita instances",
                            default=False)
    arg_parser.add_argument("--lua",
                            choices=lua_choices(),
                            help=f"Lua version to use (default {LUA_VER})",
                            default=LUA_VER)

    cli_args = arg_parser.parse_args(namespace=ProgramArgs())

    if cli_args.dev:
        setup_dev_env(cli_args.noita_dir)
        noita_bin = cli_args.noita_dir + r'\noita_dev.exe'
        noita2_bin = cli_args.noita_dir + r'\noita2_dev.exe'
        cli_args.log = 'off'
    else:
        noita_bin = cli_args.noita_dir + r'\noita.exe'
        noita2_bin = cli_args.noita_dir + r'\noita2.exe'

    if cli_args.kill:
        kill_process("noita_dev.exe")
        kill_process("noita2_dev.exe")
        kill_process("noita.exe")
        kill_process("noita2.exe")
        time.sleep(1)

    make_client_exe(noita_bin, noita2_bin)
    update_lua(cli_args.noita_dir, cli_args.lua)
    write_config(CONFIG_PATH)

    if cli_args.update:
        update_mod(cli_args.noita_dir)

    server_window, server_dev_console = start_exe(noita_bin,
                                                  mode=cli_args.gamemode,
                                                  slot=cli_args.slots[0],
                                                  config_path=CONFIG_PATH)
    client_window, client_dev_console = start_exe(noita2_bin,
                                                  mode=cli_args.gamemode,
                                                  slot=cli_args.slots[1],
                                                  config_path=CONFIG_PATH)

    server_window.moveTo(0, 0)
    if server_dev_console:
        server_dev_console.moveTo(server_window.left, server_window.top + server_window.height)

    client_window.moveTo(server_window.left + server_window.width + 30, 0)
    if client_dev_console:
        client_dev_console.moveTo(client_window.left, client_window.top + client_window.height)

    if cli_args.log == 'merged':
        server_log = LogPoll(cli_args.noita_dir + r'\logger.txt', prefix='\x1b[31m[SERVER]\x1b[0m ')
        client_log = LogPoll(cli_args.noita_dir + r'\logger2.txt', prefix='\x1b[32m[CLIENT]\x1b[0m ')
        while True:
            server_log.read_and_print()
            client_log.read_and_print()
            time.sleep(.5)
    elif cli_args.log == 'on':
        start_log_console(cli_args.noita_dir + r'\logger.txt',
                          cli_args.noita_dir + r'\logger2.txt',
                          pos_y=server_window.top + server_window.height)


def update_mod(noita_dir: str):
    mod = GIT_DIR + r'\mods\noita-mp'
    noitamp_dir = noita_dir + r'\mods\noita-mp'
    if os.path.exists(noitamp_dir):
        print("removing old mod files...")
        shutil.rmtree(noitamp_dir)
    print("copying mod files from git...")
    shutil.copytree(mod, noitamp_dir)


def start_exe(exe_path: str, mode: int, slot: int, config_path: str) -> tuple[gw.Win32Window, gw.Win32Window | None]:
    filename = os.path.basename(exe_path)
    # start = {x._hWnd: x for x in gw.getAllWindow() if re.search(r'^(Noita -|(noita|noita2)(_dev)?\.exe)', x.title)}
    windows: list[gw.Win32Window] = gw.getAllWindows()
    exe_gui_windows: dict[int, gw.Win32Window] = {window._hWnd: window for window in windows if
                                                  re.search(r'^Noita -', window.title)}
    exe_cli_windows: dict[int, gw.Win32Window] = {window._hWnd: window for window in windows if
                                                  re.search(fr'^{filename}', window.title)}

    cli_window = None
    game_window = None

    os.chdir(os.path.dirname(exe_path))
    print(f'cmd line: {filename} -no_logo_splashes -windowed -config "{config_path}" -gamemode {mode} -save_slot {slot}')
    os.system(f'start "" {filename} -no_logo_splashes -windowed -config "{config_path}" -gamemode {mode} -save_slot {slot}')
    # os.system('start "" %s -no_logo_splashes -windowed -config "%s"'%(fn, config))
    os.chdir(CURRENT_DIR)

    print(f"waiting for {filename} window to pop up...")
    while True:
        if game_window is None:
            noita_windows = gw.getWindowsWithTitle('Noita - ')
            if len(noita_windows) > len(exe_gui_windows):
                for window in noita_windows:
                    if window._hWnd not in exe_gui_windows.keys():
                        game_window = window

        if 'dev' in filename:
            if cli_window is None:
                cli_windows = gw.getWindowsWithTitle(filename)
                if len(cli_windows) > len(exe_cli_windows):
                    for window in cli_windows:
                        if window._hWnd not in exe_cli_windows.keys():
                            cli_window = window

            if game_window and cli_window:
                return game_window, cli_window
        else:
            if game_window:
                return game_window, cli_window

        time.sleep(0.2)


def make_client_exe(original_exe_path: str, new_client_exe_path: str) -> None:
    if os.path.exists(new_client_exe_path):
        return

    if not os.path.exists(original_exe_path):
        raise LookupError(f"Game not found at {original_exe_path}")

    shutil.copyfile(original_exe_path, new_client_exe_path)
    with open(new_client_exe_path, "rb+") as f:
        buffer = f.read()
        offset = buffer.find(b'logger.txt')
        f.seek(offset, 0)
        f.write(b'logger2.txt')


def version_key(version: str):
    desc = ""
    if "-" in version:
        version, desc = version.split("-")
    n = [0] * 10
    for i, subversion in enumerate(version.split(".")):
        n[i] = int(subversion)
    return n + [desc]


def sha1_file(path: str) -> str:
    with open(path, "rb") as f:
        return hashlib.sha1(f.read()).hexdigest()


def list_all_luajit() -> dict[str, str]:
    lua_dlls = {}
    for root, _, filenames in os.walk(GIT_DIR):
        for filename in filenames:
            if filename != 'lua51.dll':
                continue
            fullpath = os.path.join(root, filename)
            versions = find_luajit_version(fullpath)
            if versions is not None:
                lua_dlls[fullpath] = versions
    if not lua_dlls:
        raise LookupError("Luajit versions not found. Probably lua dll is missing.")
    return lua_dlls


def lua_choices() -> list[str]:
    return ['latest', 'original'] + sorted(list(set(list_all_luajit().values())), key=version_key, reverse=True)


def find_luajit_version(dll_path: str) -> str | None:
    with open(dll_path, "rb") as f:
        data = f.read()
        version_search = re.search(rb'LuaJIT (\d.+?)\x00', data)
        if not version_search:
            return None
        return version_search.group(1).decode('ascii')


def update_lua(noita_dir: str, lua_version: str) -> None:
    dll_path = noita_dir + r'\lua51.dll'
    original_dll_path = dll_path + r'.bak'
    all_dlls = list_all_luajit()
    all_versions = {version: path for path, version in all_dlls.items()}
    dlls_hashes = {dll_path: sha1_file(dll_path) for dll_path in all_dlls}
    current_hash = sha1_file(dll_path)

    if (current_hash == LUA_ORIG_SHA1
            or current_hash not in dlls_hashes.values()
            and not os.path.exists(
                original_dll_path)):
        shutil.copyfile(dll_path, original_dll_path)

    if lua_version == 'latest':
        lua_version = sorted(all_versions.keys(), key=version_key, reverse=True)[0]
        selected_dll = all_versions[lua_version]
    elif lua_version == 'original':
        selected_dll = original_dll_path
        if not os.path.exists(original_dll_path):
            print("no original lua dll found, keeping current one")
            return
        original_lua_version = find_luajit_version(original_dll_path)
        if not original_lua_version:
            raise LookupError("Original dll selected and is missing.")
        lua_version = original_lua_version
    else:
        if lua_version not in all_versions.keys():
            print(f"unknown lua dll version {lua_version}, keeping current one")
            return
        selected_dll = all_versions[lua_version]

    print(f"using lua v{lua_version} ({selected_dll})")
    if not os.path.exists(selected_dll):
        print("cannot find it, keeping current one")
        return

    os.unlink(dll_path)
    shutil.copyfile(selected_dll, dll_path)


def noita_click(window: gw.Win32Window, img: str | Image.Image, confidence: float = 0.8, sleep: float = 0.5) -> None:
    game = pyautogui.screenshot(
        region=(window.left, window.top, window.width, window.height))
    r = pyautogui.locate(img, game, confidence=confidence)
    print("located btn at", r)
    p = pyautogui.center(r)
    print("center at", p)
    print("abs", window.top + p.y, window.left + p.x)
    pyautogui.moveTo(window.left + p.x, window.top + p.y)
    pyautogui.click(window.left + p.x, window.top + p.y)
    time.sleep(sleep)


def find_noita_window(exclude: list[gw.Win32Window] | None = None) -> gw.Win32Window:
    winlist = gw.getWindowsWithTitle('Noita - Build')
    if exclude:
        for window in winlist:
            if window not in exclude:
                return window
    raise LookupError("Noita window not found")


def write_config(path: str) -> None:
    config_string = """\
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
    """
    config_string = config_string.rstrip() + '\n'
    with open(path, "w+") as f:
        f.write(config_string)


def start_log_console(log_client_path: str, log_server_path: str, pos_y: int = 0) -> None:
    log_dir = os.path.dirname(log_client_path)
    log_client_filename = os.path.basename(log_client_path)
    log_server_filename = os.path.basename(log_server_path)
    subprocess.run(["wt.exe", "--pos", f"0,{pos_y}",
                    "nt", "-d", log_dir, "powershell.exe", "-command",
                    f'Get-Content -Path "{log_server_filename}" -Wait'
                    ';',
                    "sp", "-V", "-d", log_dir, "powershell.exe", "-command",
                    f'Get-Content -Path "{log_client_filename}" -Wait',
                    ])
    print("started logging subprocess")


class LogPoll:
    def __init__(self, path: str, prefix: str):
        self._path = path
        self._last_offset = 0
        self._prefix = prefix
        self._need_prefix = False

    def read_and_print(self):
        with open(self._path) as f:
            f.seek(self._last_offset, 0)
            buffer = f.read()
            end = ''
            if buffer:
                if buffer[-1] == '\n':
                    buffer = buffer[:-1]
                    end = '\n'
                    next_pref = True
                else:
                    next_pref = False
                buffer = buffer.replace('\n', '\n' + self._prefix)
                if self._need_prefix:
                    buffer = self._prefix + buffer
                else:
                    self._need_prefix = next_pref
                print(buffer, end=end)
                self._last_offset = f.tell()


def setup_dev_env(noita_dir: str) -> None:
    if os.path.exists(noita_dir + r'\wang_gen.exe'):
        return
    os.chdir(noita_dir + r'\tools_modding')
    os.system('copy *.* ..')
    os.chdir(noita_dir)
    os.system('data_wak_unpack')
    os.chdir(CURRENT_DIR)


def kill_process(path: str) -> None:
    exe_name = os.path.basename(path)
    os.system(f'taskkill /im {exe_name}')


if __name__ == '__main__':
    main()
