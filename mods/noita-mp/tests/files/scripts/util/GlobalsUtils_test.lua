dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestGlobalsUtils = {}

function TestGlobalsUtils:setUp()
    print("\nsetUp")
end

function TestGlobalsUtils:tearDown()
    print("tearDown\n")
end

os.exit(lu.LuaUnit.run())
