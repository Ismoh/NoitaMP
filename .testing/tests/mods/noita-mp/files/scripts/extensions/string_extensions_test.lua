dofile("mods/noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")
local stringExtensions = dofile("mods/noita-mp/files/scripts/extensions/string_extensions.lua")

TestStringExtensions = {}

function TestStringExtensions:setUp()
    print("\nsetUp")
end

function TestStringExtensions:tearDown()
    print("tearDown\n")
end

function TestStringExtensions:testExtendAndCutStringToLength()
    lu.assertErrorMsgEquals("var is not a string.", stringExtensions.ExtendAndCutStringToLength, 1)
    lu.assertErrorMsgEquals("length is not a number.", stringExtensions.ExtendAndCutStringToLength, "var", "length")
    lu.assertErrorMsgContains(
        "char is not a character. string.len(char) > 1 = ",
        stringExtensions.ExtendAndCutStringToLength,
        "var",
        1,
        "character"
    )

    local expected = "12345"
    local actual = stringExtensions.ExtendAndCutStringToLength("12345678910", 5, " ")
    lu.assertEquals(actual, expected)

    local expected2 = "1234      "
    local actual2 = stringExtensions.ExtendAndCutStringToLength("1234", 10, " ")
    lu.assertEquals(actual2, expected2)
end

os.exit(lu.LuaUnit.run())
