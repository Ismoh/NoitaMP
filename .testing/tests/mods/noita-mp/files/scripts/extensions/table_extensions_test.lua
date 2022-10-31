#!/usr/bin/env lua
dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu            = require("luaunit")

TestTableExtensions = {}

function TestTableExtensions:setUp()
    print("\nsetUp")
end

function TestTableExtensions:tearDown()
    print("tearDown\n")
end

function TestTableExtensions:testTableContains()
    local t  = { "ball", "flag", "line" }
    local t2 = { 23, 35, 57, 74, 56 }

    lu.assertIsTrue(table.contains(t, "ball"))
    lu.assertIsTrue(table.contains(t, "flag"))
    lu.assertIsTrue(table.contains(t, "line"))

    lu.assertIsTrue(table.contains(t2, 23))
    lu.assertIsTrue(table.contains(t2, 57))

    lu.assertIsFalse(table.contains(t, "balls"))
    lu.assertIsFalse(table.contains(t, "balls"))

    lu.assertIsFalse(table.contains(t2, 0))
    lu.assertIsFalse(table.contains(t2, 4))
end

function TestTableExtensions:testTableContainsAll()
    local t = { "ball", "flag", "line" }

    lu.assertIsTrue(table.containsAll(t, "ball", "flag", "line"))
    lu.assertIsTrue(table.containsAll(t, "ball"))
    lu.assertIsTrue(table.containsAll(t, "flag"))
    lu.assertIsTrue(table.containsAll(t, "line"))
    lu.assertIsTrue(table.containsAll(t, "ball", "line"))

    lu.assertIsFalse(table.containsAll(t, "paint", "line"))
    lu.assertIsFalse(table.containsAll(t, "balls"))
    lu.assertIsFalse(table.containsAll(t, "paint"))
end

function TestTableExtensions:testSetNoitaMpDefaultMetaMethods()
    local t = { 1, 2 }
    table.setNoitaMpDefaultMetaMethods(t)

    table.insert(t, 3)
    t[4] = 4
    t[5] = 5
    table.insert(t, 6)
    table.remove(t, 1)

    lu.assertEquals(t[1], 2)
    lu.assertEquals(#t, 5)
    lu.assertEquals(t[5], 6)

    local t2 = { 1, 2, nil, 4, nil, 6 }
    table.setNoitaMpDefaultMetaMethods(t2)

    table.insert(t2, 7)
    t2[3] = 3
    t2[5] = 5
    table.remove(t2, 2)
    table.remove(t2, 4)
    table.remove(t2, 6)

    lu.assertEquals(t2[1], 1)
    lu.assertEquals(#t2, 4)
    lu.assertEquals(t2[5], nil)
end

os.exit(lu.LuaUnit.run())
