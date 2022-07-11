dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestInit = {}

function TestInit:setUp()
    print("\nsetUp")
end

function TestInit:tearDown()
    print("tearDown\n")
end