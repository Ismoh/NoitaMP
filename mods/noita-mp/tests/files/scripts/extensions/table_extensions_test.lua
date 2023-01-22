local params = ...

local lu            = require("luaunit")

TestTableExtensions = {}

function TestTableExtensions:setUp()
    -- Make absolutely sure, that the already mocked Noita API function is not overwritten
    local mockedModSettingGet = ModSettingGet
    ModSettingGet    = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "off", "OFF" }
        end

        mockedModSettingGet(id)
    end
end

function TestTableExtensions:tearDown()

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
    Logger.debug(Logger.channels.testing, tostring(t))

    table.insert(t, 3)
    Logger.debug(Logger.channels.testing, tostring(t))
    t[4] = 4
    Logger.debug(Logger.channels.testing, tostring(t))
    t[5] = 5
    Logger.debug(Logger.channels.testing, tostring(t))
    table.insert(t, 6)
    Logger.debug(Logger.channels.testing, tostring(t))
    table.remove(t, 1)
    Logger.debug(Logger.channels.testing, tostring(t))

    lu.assertEquals(t[1], 2)
    lu.assertEquals(#t, 5)
    lu.assertEquals(t[5], 6)

    local t2 = { 1, 2, nil, 4, nil, 6 }
    table.setNoitaMpDefaultMetaMethods(t2)
    Logger.debug(Logger.channels.testing, tostring(t2))

    table.insert(t2, 7)
    Logger.debug(Logger.channels.testing, tostring(t2))
    t2[3] = 3
    Logger.debug(Logger.channels.testing, tostring(t2))
    t2[5] = 5
    Logger.debug(Logger.channels.testing, tostring(t2))
    table.remove(t2, 2)
    Logger.debug(Logger.channels.testing, tostring(t2))
    table.remove(t2, 4)
    Logger.debug(Logger.channels.testing, tostring(t2))
    table.remove(t2, 6)
    Logger.debug(Logger.channels.testing, tostring(t2))

    lu.assertEquals(t2[1], 1)
    lu.assertEquals(#t2, 5)
    lu.assertEquals(t2[5], 7)
end

lu.LuaUnit.run(params)
