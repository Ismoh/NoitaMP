-- https://github.com/luarocks/luarocks/wiki/Config-file-format
rocks_trees =
{
    {
        name = "system",
        root = "D:/a/NoitaMP/NoitaMP/Lua/",
        bin_dir = "D:/a/NoitaMP/NoitaMP/Lua/bin",
        lib_dir = "D:/a/NoitaMP/NoitaMP/Lua/lib",
        lua_dir = "D:/a/NoitaMP/NoitaMP/Lua"
    }
}
variables =
{
    --PREFIX = "D:/a/NoitaMP/NoitaMP/.building/luarocks-3.8.0", -- The installation prefix of the rock (absolute path inside the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/"
    LUADIR = "D:/a/NoitaMP/NoitaMP/Lua", -- Directory for storing Lua modules written in Lua (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/lua/"
    LIBDIR = "D:/a/NoitaMP/NoitaMP/Lua/lib", -- Directory for storing Lua modules written in C (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/lib/"
    BINDIR = "D:/a/NoitaMP/NoitaMP/Lua/bin", -- Directory for storing command-line scripts (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/bin/"
    --CONFDIR = "D:/a/NoitaMP/NoitaMP/.building/LuaJIT-2.0.4/src/lua/config", -- Directory for storing configuration files for a module (absolute path inside the rock entry of the rocks tree). Example: "/home/hisham/.luarocks/5.1/foo/1.0-1/conf/"
    LUALIB = "lua51.dll",
    --CC = "wlc32.exe",
    --CPP = "clang++.exe",
    --LD = "wlc32.exe"
}
verbose = true