dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestInitLogger = {}

function TestInitLogger:setUp()
    print("\nsetUp")
end

function TestInitLogger:tearDown()
    print("tearDown\n")
end

os.exit(lu.LuaUnit.run())
