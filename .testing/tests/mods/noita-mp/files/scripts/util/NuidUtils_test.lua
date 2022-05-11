dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestNuidUtils = {}

function TestNuidUtils:setUp()
    print("\nsetUp")
end

function TestNuidUtils:tearDown()
    print("tearDown\n")
end