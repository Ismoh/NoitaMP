local Utils  = require("Utils")
local socket = require("socket")
local uuid   = require("uuid")


--- 'Imports'
local CustomProfiler = nil


--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:

if require then
    if not CustomProfiler then
        CustomProfiler = require("CustomProfiler")
    end
else
    ---@type CustomProfiler
    CustomProfiler       = {}

    ---@diagnostic disable-next-line: duplicate-doc-alias
    ---@alias CustomProfiler.start function(functionName: string): number
    ---@diagnostic disable-next-line: duplicate-set-field
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


--- GuidUtils
---@class GuidUtils
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
function GuidUtils:getGuid(inUsedGuids) -- TODO: rename to generateGuid
    local cpc = CustomProfiler.start("GuidUtils:getGuid")
    if not Utils.IsEmpty(inUsedGuids) and #inUsedGuids > 0 then
        for i = 1, #inUsedGuids do
            if not GuidUtils.isPatternValid(inUsedGuids[i]) then
                error(("Already in used guid '%s' is not a valid guid!"):format(inUsedGuids[i]), 2)
            end
        end

        ---@cast inUsedGuids table
        table.insertAllButNotDuplicates(self.cached_guid, inUsedGuids)
        Logger.debug(Logger.channels.guid, ("Guid:getGuid() - inUsedGuids: %s"):format(Utils.pformat(inUsedGuids)))
    end

    repeat
        uuid.randomseed(socket.gettime() * 10000)
        guid = uuid()
    until self:isUnique(guid) and self.isPatternValid(guid)
    table.insert(self.cached_guid, guid)

    CustomProfiler.stop("GuidUtils:getGuid", cpc)
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

    if clientOrServer.utils.IsEmpty(guid) or self.isPatternValid(tostring(guid)) == false then
        guid = self:getGuid()
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

--- Validates a guid only on its pattern.
--- @param guid string
--- @return boolean true if GUID-pattern matches
function GuidUtils.isPatternValid(guid)
    local cpc = CustomProfiler.start("GuidUtils.isPatternValid")
    if type(guid) ~= "string" then
        return false
    end
    if Utils.IsEmpty(guid) then
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

--- Returns the current local GUID.
--- @deprecated Use MinaUtils.getLocalMinaGuid instead!
--- @return string Guid
function GuidUtils:getCurrentLocalGuid()
    local cpc = CustomProfiler.start("GuidUtils:getCurrentLocalGuid")
    if whoAmI() == Server.iAm then
        CustomProfiler.stop("GuidUtils:getCurrentLocalGuid", cpc)
        return Server.guid
    end
    CustomProfiler.stop("GuidUtils:getCurrentLocalGuid", cpc)
    return Client.guid
end

return GuidUtils
