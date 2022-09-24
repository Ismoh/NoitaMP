dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestNetworkVscUtils = {}

function TestNetworkVscUtils:setUp()
    print("\nsetUp")
end

function TestNetworkVscUtils:tearDown()
    print("tearDown\n")
end