local util   = require("util")
local socket = require("socket")
local uuid   = require("uuid")

local GuidUtils = {
    cached_guid = {},
}

function GuidUtils:getCachedGuids()
    return self.cached_guid
end

function GuidUtils:addGuidToCache(guid)
    table.insertIfNotExist(self.cached_guid, guid)
end

--- Generates a pseudo GUID. Does not fulfil RFC standard! Should generate unique GUIDs, but repeats if there is a duplicate.
--- Based on https://github.com/Tieske/uuid !
--- @param inUsedGuids table? list of already used GUIDs
--- @return string guid
function GuidUtils:getGuid(inUsedGuids)
    if not util.IsEmpty(inUsedGuids) and #inUsedGuids > 0 then
        ---@cast inUsedGuids table
        table.insertAllButNotDuplicates(self.cached_guid, inUsedGuids)
        Logger.debug(Logger.channels.guid, ("Guid:getGuid() - inUsedGuids: %s"):format(util.ToString(inUsedGuids)))
    end

    repeat
        uuid.randomseed(socket.gettime() * 10000)
        guid = uuid()
    until self:isUnique(guid) and self.isPatternValid(guid)

    table.insert(self.cached_guid, guid)

    return guid
end

--- Validates a guid only on its pattern.
--- @param guid string
--- @return boolean true if GUID-pattern matches
function GuidUtils.isPatternValid(guid)
    if type(guid) ~= "string" then
        return false
    end
    if util.IsEmpty(guid) then
        return false
    end

    local is_valid = false
    local pattern  = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local match    = guid:match(pattern)

    if match == guid then
        is_valid = true
    end
    return is_valid
end

--- Validates if the given guid is unique or already generated.
--- @param guid string
--- @return boolean true if GUID is unique.
function GuidUtils:isUnique(guid)
    if guid == nil or guid == "" or type(guid) ~= "string" then
        error("'guid' is nil, empty or not a string.", 2)
    end
    local is_unique = true
    if table.contains(self.cached_guid, guid) == true then
        is_unique = false
    end
    return is_unique
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.GuidUtils = GuidUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return GuidUtils
