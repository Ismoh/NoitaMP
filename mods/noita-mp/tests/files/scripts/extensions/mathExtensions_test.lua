-- Thanks GitHub Copilot chat for writing this test.

local lu = require("luaunit")
require("mathExtensions")

TestMathExtensions = {}

function TestMathExtensions:test_sign()
    -- Test that sign returns 1 for positive numbers
    lu.assertEquals(math.sign(5), 1)
    lu.assertEquals(math.sign(0.1), 1)

    -- Test that sign returns -1 for negative numbers
    lu.assertEquals(math.sign(-5), -1)
    lu.assertEquals(math.sign(-0.1), -1)

    -- Test that sign raises an error for non-number values
    lu.assertErrorMsgContains("Unable to get sign", math.sign, "hello")
end

function TestMathExtensions:test_round()
    -- Test rounding to the nearest integer
    lu.assertEquals(math.round(5), 5)
    lu.assertEquals(math.round(5.4), 5)
    lu.assertEquals(math.round(5.5), 6)
    lu.assertEquals(math.round(5.9), 6)

    -- Test rounding to a specified bracket
    lu.assertEquals(math.round(119.68, 6.4), 121.6)
    lu.assertEquals(math.round(119.68, 0.01), 119.68)
    lu.assertEquals(math.round(119.68, 0.1), 119.7)
    lu.assertEquals(math.round(119.68, 100), 100)
    lu.assertEquals(math.round(119.68, 1000), 0)

    -- Test that round raises an error for non-number values
    lu.assertErrorMsgContains("Unable to round", math.round, "hello")
end
