local params = ...

local lu   = require("luaunit")

TestConfig = {}

function TestConfig:setUp()
    print("\n setUp")
end

function TestConfig:tearDown()

end

lu.LuaUnit.run(params)