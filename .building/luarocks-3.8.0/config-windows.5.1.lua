-- https://github.com/luarocks/luarocks/wiki/Config-file-format
rocks_trees =
{
    {
        name = "system",
        root = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/",
        bin_dir = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/",
        lib_dir = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/lua/",
        lua_dir = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/"
    }
}
variables =
{
    PREFIX = "D:/a/NoitaMP/NoitaMP/.building/luarocks-3.8.0", -- The installation prefix of the rock (absolute path inside the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/"
    LUADIR = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/lua/", -- Directory for storing Lua modules written in Lua (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/lua/"
    LIBDIR = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/", -- Directory for storing Lua modules written in C (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/lib/"
    BINDIR = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/", -- Directory for storing command-line scripts (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/bin/"
    CONFDIR = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/lua/config", -- Directory for storing configuration files for a module (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/conf/"
    LUALIB = "lua51.lib",
    CC = "wlc32.exe",
    CPP = "clang++.exe",
    LD = "wlc32.exe"
}
external_deps_patterns =
{
    bin = {
            "?.exe",
            "?.bat"
        },
    lib = {
            "lib?.a",
            "lib?.dll.a",
            "?.dll.a",
            "?.lib",
            "lib?.lib"
        },
    include = {
            "?.h"
        }
}
verbose = true