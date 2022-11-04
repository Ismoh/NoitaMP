---
--- Created by Ismoh.
--- DateTime: 01.11.2022 21:12
---

--- This simply patches Lua 5.1 # operator to Lua 5.2's # operator.
--- Have a look on http://www.lua.org/manual/5.2/manual.html#2.4 (Lua 5.2 manual) and search for "len": the # operation.
--- In addition compare the operators here: https://stackoverflow.com/a/25716924/3493998
getmetatable("#").__len = function(op) --- TODO: REMOVE THIS FILE
    if type(op) == "string" then
        return string.len(op)      -- primitive string length
    else
        local h = getmetatable(op).__len
        if h then
            return (h(op))       -- call handler with the operand
        elseif type(op) == "table" then
            return #op              -- primitive table length
        else
            -- no handler available: error
            error("Unable to get length of " .. type(op), 2)
        end
    end
end