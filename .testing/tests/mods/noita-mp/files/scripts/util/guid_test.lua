#!/usr/bin/env lua
dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")
local Guid = require("guid")

TestGuid = {}

function TestGuid:setUp()
    print("\nsetUp")
    -- Mock Noita Api global functions
    _G.DebugGetIsDevBuild = function()
        return false
    end

    --- Mocked in guid_test.lua
    --- @param id string
    --- @return nil nil Returns nil in this case.
    _G.ModSettingGet = function(id)
        return nil
    end
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
