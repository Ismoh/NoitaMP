-- Thanks GitHub Copilot chat for writing this test.

local lu = require("luaunit")
require("stringExtensions")

TestStringExtensions = {}

function TestStringExtensions:test_ExtendOrCutStringToLength()
    -- Test extending a short string
    lu.assertEquals(string.ExtendOrCutStringToLength("test", 6, " "), "test  ")

    -- Test cutting a long string
    lu.assertEquals(string.ExtendOrCutStringToLength("verylongstring", 5, " "), "veryl")

    -- Test making the cut visible
    lu.assertEquals(string.ExtendOrCutStringToLength("verylongstring", 5, " ", true), "ver..")
end

function TestStringExtensions:test_trim()
    -- Test trimming whitespace from a string
    lu.assertEquals(string.trim("  hello  "), "hello")

    -- Test trimming a string with no whitespace
    lu.assertEquals(string.trim("hello"), "hello")

    -- Test trimming a non-string value
    lu.assertErrorMsgContains("Unable to trim", string.trim, {})
end

function TestStringExtensions:test_split()
    -- Test splitting a string with a delimiter
    lu.assertEquals(string.split("hello,world", ","), {"hello", "world"})

    -- Test splitting a string with no delimiter
    lu.assertEquals(string.split("hello world", ","), {"hello world"})

    -- Test splitting a non-string value
    lu.assertErrorMsgContains("Unable to split", string.split, {}, ",")
end

function TestStringExtensions:test_contains()
    -- Test finding a substring in a string
    lu.assertTrue(string.contains("hello world", "world"))

    -- Test finding a character in a string
    lu.assertTrue(string.contains("hello world", "o"))

    -- Test finding a regex pattern in a string
    lu.assertTrue(string.contains("hello world", "w.rld"))

    -- Test not finding a pattern in a string
    lu.assertFalse(string.contains("hello world", "goodbye"))

    -- Test searching a non-string value
    lu.assertErrorMsgContains("str must not be nil", string.contains, nil, "world")

    -- Test searching with a nil pattern
    lu.assertErrorMsgContains("pattern must not be nil", string.contains, "hello world", nil)
end
