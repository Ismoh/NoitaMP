-- Used to extend default lua implementations of string

string.trim = function(s)
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
string.split = function(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
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
--- @return integer found 0 if not found. Greater 0 if found.
string.contains = function(str, pattern)
    return string.find(str:lower(), pattern:lower(), 1, true)
end
