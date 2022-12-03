#!/usr/bin/env lua
dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu            = require("luaunit")

TestServer = {}

function TestServer:setUp()
    print("\nsetUp")
end

function TestServer:tearDown()
    print("tearDown\n")
end

function TestServer:test()
    --
end

os.exit(lu.LuaUnit.run())