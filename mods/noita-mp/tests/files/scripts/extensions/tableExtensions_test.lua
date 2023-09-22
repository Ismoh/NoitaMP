local lu = require("luaunit")
require("tableExtensions")

TestTableExtensions = {}

function TestTableExtensions:test_filter()
    -- Test filtering a table with a predicate function
    local t = {1, 2, 3, 4, 5}
    local filtered = table.filter(t, function(x) return x % 2 == 0 end)
    lu.assertEquals(filtered, {2, 4})
end

function TestTableExtensions:test_reduce()
    -- Test reducing a table with an accumulator function
    local t = {1, 2, 3, 4, 5}
    local reduced = table.reduce(t, function(acc, x) return acc + x end, 0)
    lu.assertEquals(reduced, 15)
end

function TestTableExtensions:test_flatten()
    -- Test flattening a nested table
    local t = {1, {2, 3}, {4, {5, 6}}}
    local flattened = table.flatten(t)
    lu.assertEquals(flattened, {1, 2, 3, 4, 5, 6})
end
