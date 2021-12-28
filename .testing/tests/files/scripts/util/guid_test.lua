#!/usr/bin/env lua

dofile("noita-mp/files/lib/external/init_package_loading.lua")

local lu = require("luaunit")
local guid = require("guid")

TestGuid = {}

function TestGuid:setUp()
    print("\nsetUp")
end

function TestGuid:tearDown()
    print("tearDown\n")
end

function TestGuid:testGetGuid()
    guid.getGuid()
end