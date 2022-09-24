dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")

TestInitPackageLoading = {}

function TestInitPackageLoading:setUp()
    print("\nsetUp")
end

function TestInitPackageLoading:tearDown()
    print("tearDown\n")
end