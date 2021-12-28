-- https://stackoverflow.com/questions/23013973/lua-pattern-for-guid
-- https://gist.github.com/jrus/3197011
-- https://stackoverflow.com/a/32353223/3493998

local Guid = {}

--- Generates a GUID.
--- @return string guid
function Guid.getGuid()
    math.randomseed(os.clock() * 123456789000, os.time() * 1000)

    local x = "x"
    local t = {x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12)}
    local guid = table.concat(t, "-")
    guid =
        string.gsub(
        guid,
        x,
        function(c)
            -- math.randomseed(os.clock() * 123456789000, os.time() * 1000)
            local is_digit = math.random(0, 1)
            if is_digit == 1 then
                return Guid.getRandomRange_0_to_9()
            end
            return Guid.getRandomRange_aA_to_fF()
        end
    )
    print("guid.lua | guid = " .. guid .. " is valid = " .. tostring(Guid.isValid(guid)))
    return guid
end

function Guid.getRandomRange_0_to_9()
    --math.randomseed(os.clock() * 123456789, os.time() * 1000)
    return math.random(0, 9)
end

function Guid.getRandomRange_aA_to_fF()
    local chars = {"a", "b", "c", "d", "e", "f"}

    --math.randomseed(os.clock() * 123456789, os.time() * 1000)
    local char_index = math.random(1, 6)

    local char = chars[char_index]

    --math.randomseed(os.clock() * 123456789, os.time() * 1000)
    local uppercase = math.random(0, 1)

    if uppercase == 1 then
        char = string.upper(char)
    end
    return char
end

--- Validates a guid.
--- @param guid string
--- @return boolean isValid
function Guid.isValid(guid)
    local pattern = "%x%x%x%x%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x%x%x%x%x"
    --local guid = "3F2504E0-4F89-41D3-9A0C-0305E82C3301"
    local is_valid = guid:match(pattern)
    print(tostring(is_valid))
    if is_valid ~= 1 or is_valid ~= "true" or is_valid ~= true then
        is_valid = false
    end
    return is_valid
end

return Guid
