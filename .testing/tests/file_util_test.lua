#!/usr/bin/env lua
local lu = require('luaunit')
local fu = require("noita-mp/files/scripts/util/file_util")

TestFileUtil = {}

function TestFileUtil:setUp()
    print("\n")
end

function TestFileUtil:testPlatformValues()
    local path_separator = package.config:sub(1,1)
    local windows = string.find(path_separator, '\\') or false
    local unix = string.find(path_separator, '/') or false

    print("_G.path_separator = " .. _G.path_separator)
    print("_G.is_windows = " .. tostring(_G.is_windows))
    print("_G.is_unix" .. tostring(_G.is_unix))

    lu.assertEquals(_G.path_separator, path_separator)
    lu.assertEquals(_G.is_windows, windows)
    lu.assertEquals(_G.is_unix, unix)
end

function TestFileUtil:testReplacePathSeparatorOnWindows()
    local old = _G.is_windows
    _G.is_windows = true -- TODO: is there a better way to mock?

    local path_unix = "/test/path/123"
    local path_windows = fu.ReplacePathSeparator(path_unix)

    print("path_unix = " .. path_unix)
    print("path_windows = " .. path_windows)
    lu.assertNotEquals(path_unix, path_windows)
    lu.assertEquals([[\test\path\123]], path_windows)

    _G.is_windows = old
end

function TestFileUtil:testReplacePathSeparatorOnUnix()
    local old = _G.is_windows
    _G.is_windows = false -- TODO: is there a better way to mock?

    local path_windows = "\\test\\path\\123"
    local path_unix = fu.ReplacePathSeparator(path_windows)

    print("path_windows = " .. path_windows)
    print("path_unix = " .. path_unix)
    lu.assertNotEquals(path_windows, path_unix)
    lu.assertEquals("/test/path/123", path_unix)

    _G.is_windows = old
end

function TestFileUtil:testRemoveTrailingPathSeparator()
    local path = tostring(_G.path_separator .. "persistent" .. _G.path_separator .. "flags" .. _G.path_separator)
    local result = fu.RemoveTrailingPathSeparator(path)

    print("path = " .. path)
    print("result = " .. result)

    lu.assertNotEquals(path, result)
    lu.assertEquals(_G.path_separator .. "persistent" .. _G.path_separator .. "flags", result)
end

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectory()
    print("_G.is_windows = " .. tostring(_G.is_windows))
    print("_G.is_unix = " .. tostring(_G.is_unix))
    print("_G.path_separator = " .. _G.path_separator)

    lu.assertIsNil(_G.noita_root_directory_path, "_G.noita_root_directory_path already set, but should be nil!")
    fu.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(_G.noita_root_directory_path, "_G.noita_root_directory_path must not be nil!")
end

os.exit(lu.LuaUnit.run())