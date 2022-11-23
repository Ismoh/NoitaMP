#!/usr/bin/env lua
dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu            = require("luaunit")

TestNetworkUtils = {}

function TestNetworkUtils:setUp()
    print("\nsetUp")
end

function TestNetworkUtils:tearDown()
    print("tearDown\n")
end

function TestNetworkUtils:testAlreadySent()
    local event = NetworkUtils.events.newNuid.name

    NetworkUtils.alreadySent(event, data, peer, who)
end

os.exit(lu.LuaUnit.run())