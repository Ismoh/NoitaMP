-- Used to extend default lua implementations of string

--- Extends @var to the @length with @char. Example 1: "test", 6, " " = "test  " | Example 2: "verylongstring", 5, " " = "veryl"
---@param var string any string you want to extend or cut
---@param length number
---@param char any
---@param makeItVisible? boolean
---@return string
string.ExtendOrCutStringToLength = function(var, length, char, makeItVisible)
    if type(var) ~= "string" then
        var = tostring(var)
    end
    if type(length) ~= "number" then
        error("length is not a number.", 2)
    end
    if type(char) ~= "string" or string.len(char) > 1 then
        error("char is not a character. string.len(char) > 1 = " .. string.len(char), 2)
    end

    local returnString = ""

    local len          = string.len(var)

    if len > length then
        returnString = var:sub(1, length)
        if makeItVisible then
            -- check if you want to add ".." -> "longString" -> "longStr.."
            returnString = returnString:sub(1, length - 2)
            returnString = returnString .. ".."
        end
    else
        for i = 1, length, 1 do
            local char_of_var = var:sub(i, i)
            if char_of_var ~= "" then
                returnString = returnString .. char_of_var
            else
                returnString = returnString .. char
            end
        end
    end
    return returnString
end

string.trim                      = function(s)
    if type(s) ~= "string" then
        error("Unable to trim(s), because s is not a string.", 2)
    end
    -- http://lua-users.org/wiki/StringTrim -> trim12(s)
    local from = s:match "^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end

-- http://lua-users.org/wiki/SplitJoin
-- Function: Split a string with a pattern, Take Two
-- Compatibility: Lua-5.1
string.split                     = function(str, pat)
    local t         = {}
    local fpat      = "(.-)" .. pat
    local last_end  = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end  = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

--- Contains on lower case
--- @param str string String
--- @param pattern string String, Char, Regex
--- @return boolean found: 'true' if found, else 'false'.
string.contains                  = function(str, pattern)
    if not str or str == "" then
        error("str must not be nil!", 2)
    end
    if not pattern or pattern == "" then
        error("pattern must not be nil!", 2)
    end
    local found = string.find(str:lower(), pattern:lower(), 1, true)
    if not found or found < 1 then
        return false
    else
        return true
    end
end
