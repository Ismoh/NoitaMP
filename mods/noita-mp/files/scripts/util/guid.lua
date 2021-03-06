-- https://stackoverflow.com/questions/23013973/lua-pattern-for-guid
-- https://gist.github.com/jrus/3197011
-- https://stackoverflow.com/a/32353223/3493998

local util = require("util")
local logger = _G.logger

local Guid = {
    cached_guid = {},
    getRandomRange_0_to_9 = function()
        return math.random(0, 9)
    end,
    getRandomRange_aA_to_fF = function()
        local chars = {"a", "b", "c", "d", "e", "f"}
        local char_index = math.random(1, 6)
        return string.upper(chars[char_index])
    end
}

--- Generates a pseudo GUID. Does not fulfil RFC standard! Should generate unique GUIDs, but repeats if there is a duplicate.
--- @return string guid
function Guid:getGuid()
    math.randomseed(os.clock() * 123456789000, os.time() * 1000)

    local x = "x"
    local t = {x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12)}
    local guid = table.concat(t, "-")
    local is_valid = false
    local is_unique = false

    local counter = 0
    repeat
        guid =
            string.gsub(
            guid,
            x,
            function(c)
                local is_digit = math.random(0, 1)
                if is_digit == 1 then
                    return self.getRandomRange_0_to_9()
                end
                return self.getRandomRange_aA_to_fF()
            end
        )
        is_valid = self.isPatternValid(guid)
        is_unique = self:isUnique(guid)
        logger:debug(
            "GUID (%s) is valid=%s and unique=%s. Generating GUID run-number %s",
            guid,
            is_valid,
            is_unique,
            counter
        )

        counter = counter + 1
        if counter > 100 then
            local msg =
                string.format("Tried to generate GUID %s times. Stopped it for now! This is a serious bug!", counter)
            logger:error(msg)
            error(msg, 2)
            break
        end

        util.Sleep(2)
    until is_valid and is_unique

    table.insert(self.cached_guid, guid)
    util.pprint(
        "guid.lua | guid = " ..
            guid .. " is valid = " .. tostring(is_valid) .. " and is unique = " .. tostring(is_unique)
    )
    return guid
end

--- Validates a guid only on its pattern.
--- @param guid string
--- @return boolean true if GUID-pattern matches
function Guid.isPatternValid(guid)
    if type(guid) ~= "string" then
        return false
    end
    if util.IsEmpty(guid) then
        return false
    end

    local is_valid = false
    local pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local match = guid:match(pattern)

    if match == guid then
        is_valid = true
    end
    return is_valid
end

--- Validates if the given guid is unique or already generated.
--- @param guid string
--- @return boolean true if GUID is unique.
function Guid:isUnique(guid)
    if guid == nil or guid == "" or type(guid) ~= "string" then
        util.pprint("guid.lua | guid is nil, empty or not a string. Returning false!")
        return false
    end
    local is_unique = true
    if table.contains(self.cached_guid, guid) == true then
        util.pprint("guid.lua | guid (" .. guid .. ") isn't unique, therefore it's not valid!")
        is_unique = false
    end
    return is_unique
end

return Guid
