-- Thanks GitHub Copilot chat for writing this test.

local lu = require("luaunit")
require("globalExtensions")

TestGlobalExtensions = {}

function TestGlobalExtensions:test_orderedPairs()
    -- Test that orderedPairs returns keys in the correct order
    local t = {3, 1, 2}
    local keys = {}
    for key, value in orderedPairs(t) do
        table.insert(keys, key)
    end
    lu.assertEquals(keys, {1, 2, 3})
end

function TestGlobalExtensions:test_toBoolean()
    -- Test that toBoolean returns true for "true" and 1
    lu.assertTrue(toBoolean("true"))
    lu.assertTrue(toBoolean(1))

    -- Test that toBoolean returns false for "false" and 0
    lu.assertFalse(toBoolean("false"))
    lu.assertFalse(toBoolean(0))

    -- Test that toBoolean raises an error for non-string and non-number values
    lu.assertErrorMsgContains("Unable toBoolean", toBoolean, {})
end
