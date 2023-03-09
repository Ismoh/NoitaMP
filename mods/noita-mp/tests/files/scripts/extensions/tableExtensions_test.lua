TestTableExtensions = {}

function TestTableExtensions:setUp()

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

function TestTableExtensions:testContentToString()
    local tbl         = { "asdf", 2, 234, "qwerty" }
    local expectedStr = "asdf,2,234,qwerty"
    local str         = table.contentToString(tbl)
    lu.assertEquals(str, expectedStr)

    local tbl2         = { "asdf", 2, 234, "qwerty", { "123asd", "456qwe" } }
    local expectedStr2 = "asdf,2,234,qwerty,123asd,456qwe"
    local str2         = table.contentToString(tbl2)
    lu.assertEquals(str2, expectedStr2)

    local tbl3         = { "asdf", 2, 234, "qwerty", { "123asd", "456qwe" }, { name = "name", guid = "guid" } }
    local expectedStr3 = "asdf,2,234,qwerty,123asd,456qwe,name,guid"
    local str3         = table.contentToString(tbl3)
    lu.assertEquals(str3, expectedStr3)

    local tbl4         = { { name = "test", guid = "guid" }, 1234, 3, 1.2, 3.4, 0.5, { 12, 3 } }
    local expectedStr4 = "test,guid,1234,3,1.2,3.4,0.5,12,3"
    local str4         = table.contentToString(tbl4)
    lu.assertEquals(str4, expectedStr4)
end