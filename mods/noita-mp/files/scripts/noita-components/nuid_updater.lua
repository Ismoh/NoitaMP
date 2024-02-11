dofile_once("mods/noita-mp/files/scripts/init/init_.lua")

---@type NoitaMpSettings
noitaMpSettings = noitaMpSettings or {}
noitaMpSettings.customProfiler = {
    start = function() end,
    stop = function() end,
}

---@type Logger
logger = logger or
    dofile_once("mods/noita-mp/files/scripts/util/Logger.lua")
    :new(nil, noitaMpSettings)

---@type Client
client = client or {
    isConnected = function(self)
        return false
    end
}

---@type GlobalsUtils
globalsUtils = globalsUtils or
    dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")
    :new(nil, logger.noitaMpSettings.customProfiler, logger, client, {
        isEmpty = function(self, var)
            if var == nil then
                return true
            end
            if var == "" then
                return true
            end
            if type(var) == "table" and not next(var) then
                return true
            end
            return false
        end
    })

---@type Server
server = server or {}

---@type NetworkVscUtils
networkVscUtils = networkVscUtils or
    dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
    :new(nil, noitaMpSettings, noitaMpSettings.customProfiler, logger, server, globalsUtils, {
        isEmpty = function(self, var)
            if var == nil then
                return true
            end
            if var == "" then
                return true
            end
            if type(var) == "table" and not next(var) then
                return true
            end
            return false
        end
    })

local executeOnAdded = GetValueBool("executeOnAdded", 1)

if executeOnAdded then
    logger:debug(logger.channels.nuid, "nuid_updater.lua added..")
    local currentEntityId = GetUpdatedEntityID()
    if not EntityGetIsAlive(currentEntityId) then
        return
    end
    local ownerName, ownerGuid, nuid   = networkVscUtils:getAllVscValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = globalsUtils:getNuidEntityPair(nuid)
    if not nuid and globalsNuid then
        nuid = globalsNuid
    end
    if currentEntityId ~= globalsEntityId and nuid then
        globalsUtils:setNuid(nuid, currentEntityId)
        logger:debug(logger.channels.nuid, ("nuid in noitas global storage was set: nuid = %s and entity_id = %s"):format(nuid, currentEntityId))
        SetValueBool("executeOnAdded", 0)
    end
end

if not executeOnAdded then
    logger:debug(logger.channels.nuid, "nuid_updater.lua remove..")
    local currentEntityId              = GetUpdatedEntityID()
    local ownerName, ownerGuid, nuid   = networkVscUtils:getAllVscValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = globalsUtils:getNuidEntityPair(nuid)

    if not globalsEntityId then
        globalsEntityId = currentEntityId
    end

    globalsUtils:setNuid(nuid, tonumber(currentEntityId * -1))
    globalsUtils:setDeadNuid(nuid)
    logger:debug(logger.channels.nuid, ("Entity (%s) was killed and nuid (%s) in noitas global storage was updated: old=%s and new=-%s")
        :format(currentEntityId, nuid, globalsEntityId, tonumber(globalsEntityId * -1)))
end
