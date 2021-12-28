#!/usr/bin/env lua

dofile("noita-mp/files/lib/external/init_package_loading.lua")

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
    local guid = Guid.getGuid()
    lu.assertNotIsNil(guid)
    lu.assertIsTrue(Guid.valid(guid))
end