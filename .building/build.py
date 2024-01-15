#!/usr/bin/env python3
import subprocess
import os
import argparse
import shutil

def get_git_root() -> str:
    path = os.path.dirname(__file__)
    parent = ""
    while not os.path.exists(path + r'\.git'):
        parent = os.path.realpath(path + r'\..')
        if parent == path:
            raise LookupError("Git dir not found. Always use git repo.")
        else:
            path = parent
    return path

CURRENT_DIR = os.getcwd()
GIT_DIR = get_git_root()
SCRIPT_DIR = os.path.dirname(__file__)
NOITA_DIR = r'C:\Program Files (x86)\Steam\steamapps\common\Noita'
LUA_MODULES_DIR = os.path.join(GIT_DIR, r"mods\noita-mp\lua_modules\lib\lua\5.1")
LUA_DLL = os.path.join(SCRIPT_DIR, r"LuaJIT\src\lua51.dll")
LUA_LIB = os.path.join(SCRIPT_DIR, r"LuaJIT\src\lua51.lib")

# get the system visual studio config
VS_PATH = subprocess.check_output(['vswhere.exe', '-latest', '-products', '*', '-requires', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', '-property', 'installationPath'], cwd=SCRIPT_DIR).decode('utf-8').strip()
VSDEVCMD_PATH = os.path.join(VS_PATH, r'Common7\Tools\vsdevcmd.bat')

def main():
    ap = argparse.ArgumentParser("lua dependency rebuilder. By default rebuild everything with the current state of LuaJIT dir.")
    ap.add_argument("--lua-version", help="LuaJIT version to checkout and rebuild with (git rev or branch) Uncertain? Do 'git log' in .building/LuaJIT!")
    ap.add_argument("--build", choices=["all", "lua", "enet", "native"], help="Only rebuild one project (default all)", default="all")
    ap.add_argument("--install-lua", action="store_true", help="Copy lua dll to noita game directory (default False)", default=False)
    ap.add_argument("--noita-dir", help=f"Path to noita game dir (default {NOITA_DIR})", default=NOITA_DIR)
    args = ap.parse_args()

    lua_dll = lua_enet = lua_noitamp_native = None

    if args.build in ['lua', 'all']:
        lua_dll = build_lua(args.lua_version)
        if not lua_dll:
            err("LUA BUILD FAILED!")
            exit(1)

    if args.build in ['enet', 'all']:
        lua_enet = build_lua_enet()
        if not lua_enet:
            err("LUA ENET BUILD FAILED!")
            exit(1)

    if args.build in ['native', 'all']:
        lua_noitamp_native = build_lua_noitamp_native()
        if not lua_noitamp_native:
            err("LUA NOITAMP NATIVE BUILD FAILED!")
            exit(1)

    msg("ALL BUILD OK!")
    if lua_enet:
        copy_file(lua_enet, LUA_MODULES_DIR)
    if lua_noitamp_native:
        copy_file(lua_noitamp_native, LUA_MODULES_DIR)
    if args.install_lua and lua_dll:
        copy_file(lua_dll, args.noita_dir)

def build_lua(version=None, debug=True) -> str | None:
    git_cmd = ""
    if version is not None:
        git_cmd = f"&& git checkout {version}"
    if debug:
        debug = "debug"
    else:
        debug = ""

    build_dir = os.path.join(SCRIPT_DIR, "LuaJIT")
    rmtree(LUA_DLL)
    rmtree(LUA_LIB)
    cmd = f'""{VSDEVCMD_PATH}"" && cd LuaJIT {git_cmd} && cd src && msvcbuild.bat {debug}'
    print(cmd)
    os.system(cmd)

    return find_dll(build_dir, "lua51.dll")

def build_lua_enet() -> str | None:
    cmds = [
        rf'""{VSDEVCMD_PATH}""',
        r'cd lua-enet',
        r'cmake -G \"Visual\ Studio\ 17\ 2022\" -A Win32 -DLUA_LIBRARIES=..\LuaJIT\src\lua51.lib -DLUA_INCLUDE_DIR=..\LuaJIT\src -B build',
        r'cd build',
        r'msbuild lua-enet.sln'
    ]

    build_dir = os.path.join(SCRIPT_DIR, "lua-enet", "build")
    rmtree(build_dir)
    print('\n'.join(cmds))
    os.system(' && '.join(cmds))
    return find_dll(build_dir, "enet.dll")

def build_lua_noitamp_native() -> str | None:
    cmds = [
        rf'""{VSDEVCMD_PATH}""',
        r'cd lua_noitamp_native',
        r'cmake -A Win32 -DLUA_SHARED=..\LuaJIT\src\lua51.dll -DLUA_LIBRARIES=..\LuaJIT\src\lua51.lib -DLUA_INCLUDE_DIR=..\LuaJIT\src -B build',
        r'cd build',
        r'msbuild lua_noitamp_native.sln'
    ]

    build_dir = os.path.join(SCRIPT_DIR, "lua_noitamp_native", "build")
    rmtree(build_dir)
    print('\n'.join(cmds))
    os.system(' && '.join(cmds))
    return find_dll(build_dir, "lua_noitamp_native.dll")

def rmtree(path: str):
    if os.path.exists(path):
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.unlink(path)

def copy_file(src: str, dst: str):
    if os.path.isdir(dst):
        dst = os.path.join(dst, os.path.basename(src))
    print("COPY", os.path.basename(src), "->", dst)
    if os.path.exists(dst) and not os.path.isdir(dst):
        rmtree(dst)
    shutil.copyfile(src, dst)

def find_dll(dir: str, name: str) -> str | None:
    for root, dirs, names in os.walk(dir):
        if name in names:
            return os.path.join(root, name)
    return None

def msg(s: str):
    print(f"\x1b[32m{s}\x1b[0m")

def err(s: str):
    print(f"\x1b[31m{s}\x1b[0m")

if __name__ == "__main__":
    main()
