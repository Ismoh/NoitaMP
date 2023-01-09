local params = ...

local lu = require("luaunit")

TestInit = {}

function TestInit:setUp()

end

function TestInit:tearDown()

end

lu.LuaUnit.run(params)
