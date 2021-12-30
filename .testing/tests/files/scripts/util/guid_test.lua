#!/usr/bin/env lua

dofile("noita-mp/files/lib/external/init_package_loading.lua")
dofile("noita-mp/files/scripts/util/table_extensions.lua")

local lu = require("luaunit")
local Guid = require("guid")

TestGuid = {}

function TestGuid:setUp()
    print("\nsetUp")
end

function TestGuid:tearDown()
    print("tearDown\n")
end

function TestGuid:testGetGuid()
    local guid = Guid:getGuid()
    lu.assertNotIsNil(guid)
    lu.assertIsTrue(Guid.isPatternValid(guid))

    lu.assertIsFalse(Guid.isPatternValid(""))
    lu.assertIsFalse(Guid.isPatternValid(nil))

    local number = tonumber(1)
    lu.assertIsFalse(Guid.isPatternValid(number))
end

function TestGuid:testRandomness()
    local t = {}
    for i = 1, 10, 1 do
        local new_guid = Guid:getGuid()
        lu.assertIsFalse(table.contains(t, new_guid))
        table.insert(t, new_guid)
    end
end

os.exit(lu.LuaUnit.run())
