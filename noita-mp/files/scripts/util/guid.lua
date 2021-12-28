-- https://stackoverflow.com/questions/23013973/lua-pattern-for-guid
-- https://gist.github.com/jrus/3197011
-- https://stackoverflow.com/a/32353223/3493998

local Guid = {
    cached_guid = {}
}

--- Generates a pseudo GUID. Does not fulfil RFC standard!
--- @return string guid
function Guid.getGuid()
    math.randomseed(os.clock() * 123456789000, os.time() * 1000)

    local x = "x"
    local t = {x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12)}
    local guid = table.concat(t, "-")
    local is_valid = false
    local is_unique = false

    repeat
        guid =
            string.gsub(
            guid,
            x,
            function(c)
                local is_digit = math.random(0, 1)
                if is_digit == 1 then
                    return Guid.getRandomRange_0_to_9()
                end
                return Guid.getRandomRange_aA_to_fF()
            end
        )
        is_valid = Guid.isPatternValid(guid)
        is_unique = Guid.isUnique(guid)
    until is_valid and is_unique

    table.insert(Guid.cached_guid, guid)
    print("guid.lua | guid = " .. guid .. " is valid = " .. tostring(is_valid) .. " and is unique = " .. tostring(is_unique))
    return guid
end

function Guid.isUnique(guid)
    local is_unique = true
    if table.contains(Guid.cached_guid, guid) == true then
        print("guid.lua | guid (" .. guid .. ") isn't unique, therefore it's not valid!")
        is_unique = false
    end
    return is_unique
end

function Guid.getRandomRange_0_to_9()
    return math.random(0, 9)
end

function Guid.getRandomRange_aA_to_fF()
    local chars = {"a", "b", "c", "d", "e", "f"}
    local char_index = math.random(1, 6)
    return string.upper(chars[char_index])
end

--- Validates a guid only on its pattern.
--- @param guid string
--- @return boolean isValid
function Guid.isPatternValid(guid)
    local is_valid = false
    local pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local match = guid:match(pattern)

    if match == guid then
        is_valid = true
    end
    return is_valid
end

return Guid
