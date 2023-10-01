---GuidUtils is just for generating and validating GUIDs. Guids are used for identifying clients and servers.
---@class GuidUtils
local GuidUtils = {

    --[[ Attributes ]]
    cached_guid = {},
}

---Returns the cached guids.
---@return table cached_guid
function GuidUtils:getCachedGuids()
    return self.cached_guid
end

---Adds a guid to the cache.
---@param guid string required
function GuidUtils:addGuidToCache(guid)
    if self.utils:IsEmpty(guid) then
        error("'guid' must not be nil or empty!", 2)
    end
    table.insertIfNotExist(self.cached_guid, guid)
end

---Generates a pseudo GUID. Does not fulfil RFC standard! Should generate unique GUIDs, but repeats if there is a duplicate.
---Based on https://github.com/Tieske/uuid !
---Formerly known as 'getGuid()'.
---@param inUsedGuids table|nil list of already used GUIDs
---@return string guid
function GuidUtils:generateNewGuid(inUsedGuids)
    local cpc = self.customProfiler:start("GuidUtils:getGuid")
    if inUsedGuids and not self.utils:IsEmpty(inUsedGuids) and #inUsedGuids > 0 then
        for i = 1, #inUsedGuids do
            if inUsedGuids[i] and
                not self:isPatternValid(inUsedGuids[i]) then
                error(("Already in used guid '%s' is not a valid guid!"):format(inUsedGuids[i]), 2)
            end
        end

        table.insertAllButNotDuplicates(self.cached_guid, inUsedGuids)
        self.logger:debug(self.logger.channels.guid, ("Guid:getGuid() - inUsedGuids: %s"):format(self.utils.pformat(inUsedGuids)))
    end

    local guid = nil
    repeat
        self.uuid.randomseed(self.socket.gettime() * 10000)
        guid = self.uuid()
    until self:isUnique(guid) and self:isPatternValid(guid)
    table.insert(self.cached_guid, guid)

    self.customProfiler:stop("GuidUtils:getGuid", cpc)
    return guid
end

---Sets the guid of a client or the server.
---@param client Client|nil Either client
---@param server Server|nil or server must be set!
---@param guid string|nil guid can be optional. If not set, a new guid will be generated and set.
function GuidUtils:setGuid(client, server, guid)
    if not client and not server then
        error("'client' and 'server' cannot be set at the same time!", 2)
    end

    local clientOrServer = client or server or error("Either 'client' or 'server' must be set!", 2)
    local cpc = clientOrServer.customProfiler:start("GuidUtils:setGuid")

    if self.utils:IsEmpty(guid) or self:isPatternValid(tostring(guid)) == false then
        guid = self:generateNewGuid()
        clientOrServer.noitaMpSettings:set("noita-mp.guid", guid)
        clientOrServer.guid = guid
        clientOrServer.logger:debug(clientOrServer.logger.channels.network, ("%s's guid set to %s!"):format(clientOrServer, guid))
    else
        clientOrServer.logger:debug(clientOrServer.logger.channels.network, ("%s's guid was already set to %s!"):format(clientOrServer, guid))
    end

    if DebugGetIsDevBuild() then
        guid = guid .. clientOrServer.iAm
    end
    clientOrServer.customProfiler:stop("GuidUtils:setGuid", cpc)
end

---Validates a guid only on its pattern.
---@param guid string required
---@return boolean true if GUID-pattern matches
function GuidUtils:isPatternValid(guid)
    local cpc = self.customProfiler:start("GuidUtils.isPatternValid")
    if type(guid) ~= "string" then
        return false
    end
    if self.utils:IsEmpty(guid) then
        return false
    end

    local is_valid = false
    local pattern  = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local match    = guid:match(pattern)

    if match == guid then
        is_valid = true
    end
    self.customProfiler:stop("GuidUtils.isPatternValid", cpc)
    return is_valid
end

---Validates if the given guid is unique or already generated.
---@param guid string
---@return boolean true if GUID is unique.
function GuidUtils:isUnique(guid)
    local cpc = self.customProfiler:start("GuidUtils:isUnique")
    if guid == nil or guid == "" or type(guid) ~= "string" then
        error("'guid' is nil, empty or not a string.", 2)
    end
    local is_unique = true
    if table.contains(self.cached_guid, guid) == true then
        is_unique = false
    end
    self.customProfiler:stop("GuidUtils:isUnique", cpc)
    return is_unique
end

function GuidUtils:toNumber(guid)
    local cpc = self.customProfiler:start("GuidUtils.toNumber")
    if not self:isPatternValid(guid) then
        error(("Guid '%s' is not a valid guid!"):format(guid), 2)
    end
    local guidWithoutDashes = string.gsub(guid, "%-", "")
    guidWithoutDashes       = guidWithoutDashes:upper()
    local number            = tonumber(guidWithoutDashes, 16)
    self.customProfiler:stop("GuidUtils.toNumber", cpc)
    return number
end

function GuidUtils:new(guidUtilsObject, customProfiler, fileUtils, logger, noitaMpSettings, plotly, socket, utils, winapi)
    ---@class GuidUtils
    guidUtilsObject = setmetatable(guidUtilsObject or self, GuidUtils)

    if not customProfiler then
        error("GuidUtils:new requires a CustomProfiler object", 2)
    end

    local cpc = customProfiler:start("GuidUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not guidUtilsObject.customProfiler then
        ---@type CustomProfiler
        guidUtilsObject.customProfiler = customProfiler
    end

    if not guidUtilsObject.utils then
        ---@type Utils
        guidUtilsObject.utils = utils or
            require("Utils")
        --:new()
    end

    if not guidUtilsObject.logger then
        ---@type Logger
        guidUtilsObject.logger = logger or
            require("Logger")
            :new(nil, customProfiler)
    end

    if not guidUtilsObject.uuid then
        guidUtilsObject.uuid = require("uuid")
    end

    if not guidUtilsObject.socket then
        guidUtilsObject.socket = socket or require("socket")
    end

    --[[ Attributes ]]

    customProfiler:stop("GuidUtils:new", cpc)
    return guidUtilsObject
end

return GuidUtils
