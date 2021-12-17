#!/usr/bin/env lua
local lu = require('luaunit')
local fu = require("noita-mp/files/scripts/util/file_util")

function testReplacePathSeparatorWindows()
    _G.is_windows = true -- TODO: mock this on a better way: https://olivinelabs.com/busted/#spies-mocks-stubs
    local path = "/test/path/123"
    local result = fu.ReplacePathSeparator(path)

    lu.assertNotEquals(path, result)
    lu.assertEquals("\\test\\path\\123", result)
end

function testReplacePathSeparatorUnix()
    _G.is_windows = false -- TODO: mock this on a better way: https://olivinelabs.com/busted/#spies-mocks-stubs
    local path = "\\test\\path\\123"
    local result = fu.ReplacePathSeparator(path)

    lu.assertNotEquals(path, result)
    lu.assertEquals("/test/path/123", result)
end

os.exit(lu.LuaUnit.run())