-- Used to extend default lua implementations of string

string.trim = function(s)
    if type(s) ~= "string" then
        error("Unable to trim(s), because s is not a string.", 2)
    end
    -- http://lua-users.org/wiki/StringTrim -> trim12(s)
    local from = s:match "^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end
