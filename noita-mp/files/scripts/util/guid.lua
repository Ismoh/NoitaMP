local luaunit = require("luaunit")

local Guid = {}

--- Generates a GUID.
--- @return string guid
function Guid.getGuid()
    local x = "%x"
    local t = {x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12)}
    local guid = table.concat(t, "%-")
    print("guid.lua | guid = " .. guid .. " or " .. luaunit.prettystr(guid))
    return guid
end

--- Validates a guid.
--- @param guid string
--- @return boolean isValid
function Guid.valid(guid)
    local pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    --local guid = "3F2504E0-4F89-41D3-9A0C-0305E82C3301"
    local isValid = guid:match(pattern)
    print(isValid)
    return isValid ~= "fail"
end

return Guid
