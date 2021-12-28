local luaunit = require("luaunit")

local Guid = {}

function Guid.getGuid()
    local x = "%x"
    local t = { x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12) }
    local pattern = table.concat(t, '%-')
    print(luaunit.prettystr(pattern))
end

local function check()
    local pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local guid = "3F2504E0-4F89-41D3-9A0C-0305E82C3301"
    print(guid:match(pattern))
end

return Guid