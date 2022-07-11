dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestStringExtensions = {}

function TestStringExtensions:setUp()
    print("\nsetUp")
end

function TestStringExtensions:tearDown()
    print("tearDown\n")
end