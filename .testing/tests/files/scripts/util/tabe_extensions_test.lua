#!/usr/bin/env lua

dofile_once("noita-mp/files/lib/external/init_package_loading.lua")
dofile_once("mods/noita-mp/files/util/table_extensions.lua")

local lu = require("luaunit")

TestTableExtensions = {}

function TestTableExtensions:setUp()
    print("\nsetUp")
end

function TestTableExtensions:tearDown()
    print("tearDown\n")
end

function TestTableExtensions:testTableContains()
    local t = {"ball", "flag", "line"}

    lu.assertIsTrue(table.contains(t, "ball"))
    lu.assertIsTrue(table.contains(t, "flag"))
    lu.assertIsTrue(table.contains(t, "line"))

    lu.assertIsTrue(table.contains(t, "paint", "line"))
    lu.assertIsTrue(table.contains(t, "ball", "line"))

    lu.assertIsFalse(table.contains(t, "balls"))
    lu.assertIsFalse(table.contains(t, "paint"))
end

os.exit(lu.LuaUnit.run())
