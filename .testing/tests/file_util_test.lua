#!/usr/bin/env lua
local lu = require('luaunit')
local fu = require("noita-mp/files/scripts/util/file_util")

TestFileUtil = {}

function TestFileUtil:setUp()
end

function TestFileUtil:testReplacePathSeparatorOnWindows()
    _G.is_windows = true -- TODO: is there a better way to mock?

    local path_unix = "/test/path/123"
    local path_windows = fu.ReplacePathSeparator(path_unix)

    print("path_unix = " .. path_unix)
    print("path_windows = " .. path_windows)
    lu.assertNotEquals(path_unix, path_windows)
    lu.assertEquals([[\test\path\123]], path_windows)
end

function TestFileUtil:testReplacePathSeparatorOnUnix()
    _G.is_windows = false -- TODO: is there a better way to mock?

    local path_windows = "\\test\\path\\123"
    local path_unix = fu.ReplacePathSeparator(path_windows)

    print("path_windows = " .. path_windows)
    print("path_unix = " .. path_unix)
    lu.assertNotEquals(path_windows, path_unix)
    lu.assertEquals("/test/path/123", path_unix)
end

function TestFileUtil:testRemoveTrailingPathSeparator()
    local path = tostring(_G.path_separator .. "persistent" .. _G.path_separator .. "flags" .. _G.path_separator)
    local result = fu.RemoveTrailingPathSeparator(path)

    print("path = " .. path)
    print("result = " .. result)

    lu.assertNotEquals(path, result)
    lu.assertEquals("\\persistent\\flags", result)
end

os.exit(lu.LuaUnit.run())