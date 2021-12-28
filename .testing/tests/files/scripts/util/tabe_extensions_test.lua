#!/usr/bin/env lua

dofile("noita-mp/files/lib/external/init_package_loading.lua")
dofile("noita-mp/files/scripts/util/table_extensions.lua")

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
    local t2 = { 23, 35, 57, 74, 56 }

    lu.assertIsTrue(table.contains(t, "ball"))
    lu.assertIsTrue(table.contains(t, "flag"))
    lu.assertIsTrue(table.contains(t, "line"))

    lu.assertIsTrue(table.contains(t2, 2))
    lu.assertIsTrue(table.contains(t2, 4))

    lu.assertIsFalse(table.contains(t, "balls"))
    lu.assertIsFalse(table.contains(t, "balls"))

    lu.assertIsFalse(table.contains(t2, 0))
    lu.assertIsFalse(table.contains(t2, 10))
end

function TestTableExtensions:testTableContainsAll()
    local t = {"ball", "flag", "line"}

    lu.assertIsTrue(table.containsAll(t, "ball"))
    lu.assertIsTrue(table.containsAll(t, "flag"))
    lu.assertIsTrue(table.containsAll(t, "line"))
    lu.assertIsTrue(table.containsAll(t, "ball", "line"))

    lu.assertIsFalse(table.containsAll(t, "paint", "line"))
    lu.assertIsFalse(table.containsAll(t, "balls"))
    lu.assertIsFalse(table.containsAll(t, "paint"))
end

os.exit(lu.LuaUnit.run())
