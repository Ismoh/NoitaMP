local util   = require("util")
local socket = require("socket")
local uuid   = require("uuid")

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
------------------------------------------------------------------------------------------------------------------------
if require then
    if not CustomProfiler then
        require("CustomProfiler")
    end
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    CustomProfiler       = {}
    CustomProfiler.start = function(functionName)
        --Logger.trace(Logger.channels.guid,
        --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.start(functionName %s)")
        --                    :format(functionName))
    end
    CustomProfiler.stop  = function(functionName, customProfilerCounter)
        --Logger.trace(Logger.channels.guid,
        --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.stop(functionName %s, customProfilerCounter %s)")
        --                    :format(functionName, customProfilerCounter))
    end
end

------------------------------------------------------------------------------------------------------------------------
--- GuidUtils
------------------------------------------------------------------------------------------------------------------------
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
    local cpc = CustomProfiler.start("GuidUtils:getGuid")
    if not util.IsEmpty(inUsedGuids) and #inUsedGuids > 0 then
        for i = 1, #inUsedGuids do
            if not GuidUtils.isPatternValid(inUsedGuids[i]) then
                error(("Already in used guid '%s' is not a valid guid!"):format(inUsedGuids[i]), 2)
            end
        end

        ---@cast inUsedGuids table
        table.insertAllButNotDuplicates(self.cached_guid, inUsedGuids)
        Logger.debug(Logger.channels.guid, ("Guid:getGuid() - inUsedGuids: %s"):format(util.pformat(inUsedGuids)))
    end

    repeat
        uuid.randomseed(socket.gettime() * 10000)
        guid = uuid()
    until self:isUnique(guid) and self.isPatternValid(guid)
    table.insert(self.cached_guid, guid)

    CustomProfiler.stop("GuidUtils:getGuid", cpc)
    return guid
end

--- Validates a guid only on its pattern.
--- @param guid string
--- @return boolean true if GUID-pattern matches
function GuidUtils.isPatternValid(guid)
    local cpc = CustomProfiler.start("GuidUtils.isPatternValid")
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
    CustomProfiler.stop("GuidUtils.isPatternValid", cpc)
    return is_valid
end

--- Validates if the given guid is unique or already generated.
--- @param guid string
--- @return boolean true if GUID is unique.
function GuidUtils:isUnique(guid)
    local cpc = CustomProfiler.start("GuidUtils:isUnique")
    if guid == nil or guid == "" or type(guid) ~= "string" then
        error("'guid' is nil, empty or not a string.", 2)
    end
    local is_unique = true
    if table.contains(self.cached_guid, guid) == true then
        is_unique = false
    end
    CustomProfiler.stop("GuidUtils:isUnique", cpc)
    return is_unique
end

function GuidUtils.toNumber(guid)
    local cpc = CustomProfiler.start("GuidUtils.toNumber")
    if not GuidUtils.isPatternValid(guid) then
        error(("Guid '%s' is not a valid guid!"):format(guid), 2)
    end
    local guidWithoutDashes = string.gsub(guid, "%-", "")
    guidWithoutDashes       = guidWithoutDashes:upper()
    local number            = tonumber(guidWithoutDashes, 16)
    CustomProfiler.stop("GuidUtils.toNumber", cpc)
    return number
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.GuidUtils = GuidUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return GuidUtils
