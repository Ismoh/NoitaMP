#!/usr/bin/env lua
local lu = require('luaunit')
local fu = require("noita-mp/files/scripts/util/file_util")

function testReplacePathSeparatorWindows()
    _G.is_windows = true -- TODO: is there a better way to mock?
    local path = "/test/path/123" -- unix path separator
    local result = fu.ReplacePathSeparator(path)

    print("path = " .. path)
    print("result = " .. result)
    lu.assertNotEquals(path, result)
    lu.assertEquals([[\test\path\123]], result)
end

function testReplacePathSeparatorUnix()
    _G.is_windows = false -- TODO: is there a better way to mock?
    local path = [[\test\path\123]] -- windows path separator
    local result = fu.ReplacePathSeparator(path)

    print("path = " .. path)
    print("result = " .. result)
    lu.assertNotEquals(path, result)
    lu.assertEquals("/test/path/123", result)
end

os.exit(lu.LuaUnit.run())