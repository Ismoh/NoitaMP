dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestInit_ = {}

function TestInit_:setUp()
    print("\nsetUp")
end

function TestInit_:tearDown()
    print("tearDown\n")
end