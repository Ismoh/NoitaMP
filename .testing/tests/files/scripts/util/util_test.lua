#!/usr/bin/env lua
dofile("noita-mp/files/scripts/init/init_.lua")

local lu = require("luaunit")
local util = require("util")

TestUtil = {}

function TestUtil:setUp()
    print("\nsetUp")
end

function TestUtil:tearDown()
    print("tearDown\n")
end

function TestUtil:testSleep()
    lu.assertErrorMsgContains("Unable to wait if parameter 'seconds' isn't a number:", util.Sleep, "seconds")

    local seconds_to_wait = 4
    local timestamp_before = os.clock()
    util.Sleep(seconds_to_wait)
    local timestamp_after = os.clock()
    local diff = timestamp_before + seconds_to_wait
    logger:debug("timestamp_before=%s, timestamp_after=%s, diff=%s", timestamp_before, timestamp_after, diff)
    lu.assertEquals(diff, timestamp_after)
end

function TestUtil:testIsEmpty()
    local tbl = {}
    table.insert(tbl, "1234")
    lu.assertIsFalse(util.IsEmpty(tbl))

    lu.assertIsTrue(util.IsEmpty(nil))
    lu.assertIsTrue(util.IsEmpty(""))
    lu.assertIsTrue(util.IsEmpty({}))
end

function TestUtil:testExtendAndCutStringToLength()
    lu.assertErrorMsgEquals("var is not a string.", util.ExtendAndCutStringToLength, 1)
    lu.assertErrorMsgEquals("length is not a number.", util.ExtendAndCutStringToLength, "var", "length")
    lu.assertErrorMsgContains(
        "char is not a character. string.len(char) > 1 = ",
        util.ExtendAndCutStringToLength,
        "var",
        1,
        "character"
    )

    local expected = "12345"
    local actual = util.ExtendAndCutStringToLength("12345678910", 5, " ")
    lu.assertEquals(actual, expected)

    local expected2 = "1234      "
    local actual2 = util.ExtendAndCutStringToLength("1234", 10, " ")
    lu.assertEquals(actual2, expected2)
end

os.exit(lu.LuaUnit.run())
