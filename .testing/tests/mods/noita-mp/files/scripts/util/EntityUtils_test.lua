dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestEntityUtils = {}

function TestEntityUtils:setUp()
    print("\nsetUp")
end

function TestEntityUtils:tearDown()
    print("tearDown\n")
end