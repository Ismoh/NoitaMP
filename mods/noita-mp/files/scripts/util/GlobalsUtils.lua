---@class GlobalsUtils
---Class for GlobalsSetValue and GlobalsGetValue
---Deprecated Use VariableStorageComponents instead!
---@deprecated Use VariableStorageComponents instead!
local GlobalsUtils = {
    --[[ Attributes ]]
    deadNuidsKey       = "deadNuids",
    nuidKeyFormat      = "nuid = %s",
    nuidKeySubstring   = "nuid = ",
    nuidValueFormat    = "entityId = %s",
    nuidValueSubstring = "entityId = ",
}



---Parses key and value string to nuid and entityId.
---@param xmlKey string self.nuidKeyFormat = "nuid = %s"
---@param xmlValue string self.nuidValueFormat = "entityId = %s"
---@return number|nil nuid
---@return number|nil entityId
function GlobalsUtils:parseXmlValueToNuidAndEntityId(xmlKey, xmlValue)
    if type(xmlKey) ~= "string" then
        error(("xmlKey(%s) is not type of string!"):format(xmlKey), 2)
    end
    if type(xmlValue) ~= "string" then
        error(("xmlKeyValue(%s) is not type of string!"):format(xmlValue), 2)
    end

    local nuid      = nil
    local foundNuid = string.find(xmlKey, self.nuidKeySubstring, 1, true)
    if foundNuid ~= nil then
        nuid = tonumber(string.sub(xmlKey, self.nuidKeySubstring:len()))
    else
        self.logger:info(self.logger.channels.globals, ("Unable to get nuid number of key string (%s)."):format(xmlKey))
        return nil, nil
    end

    local entityId = nil
    if xmlValue and xmlValue ~= "" then
        -- can be empty or nil, when there is no entityId stored in Noitas Globals
        local foundEntityId = string.find(xmlValue, self.nuidValueSubstring, 1, true)
        if foundEntityId ~= nil then
            entityId = tonumber(string.sub(xmlValue, self.nuidValueSubstring:len()))
        else
            error(("Unable to get entityId number of value string (%s)."):format(xmlValue), 2)
        end
    end

    if self.utils:isEmpty(entityId) then
        if self.client:isConnected() then
            self.client:sendLostNuid(nuid)
        end
    end
    return nuid, entityId
end

function GlobalsUtils:setNuid(nuid, entityId, componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid)
    GlobalsSetValue(self.nuidKeyFormat:format(nuid), self.nuidValueFormat:format(entityId))        -- also change stuff in nuid_updater.lua
end

function GlobalsUtils:setDeadNuid(nuid)
    local oldDeadNuids = GlobalsGetValue(self.deadNuidsKey, "")
    if oldDeadNuids == "" then
        GlobalsSetValue(self.deadNuidsKey, nuid)
    else
        GlobalsSetValue(self.deadNuidsKey, ("%s,%s"):format(oldDeadNuids, nuid))
    end
end

function GlobalsUtils:getDeadNuids()
    local globalsValue = GlobalsGetValue(self.deadNuidsKey, "")
    local deadNuids    = string.split(globalsValue, ",") or {}
    if table.contains(deadNuids, "nil") then
        --table.remove(deadNuids, table.indexOf(deadNuids, "nil"))
        table.removeByValue(deadNuids, "nil")
    end
    return deadNuids
end

function GlobalsUtils:removeDeadNuid(nuid)
    local globalsValue    = GlobalsGetValue(self.deadNuidsKey, "")
    local deadNuids       = string.split(globalsValue, ",")
    local contains, index = table.contains(deadNuids, nuid)
    if contains then
        table.remove(deadNuids, index)
        if not next(deadNuids) then
            -- if deadNuids is empty
            GlobalsSetValue(self.deadNuidsKey, "")
        else
            GlobalsSetValue(self.deadNuidsKey, table.concat(deadNuids, ","))
        end
    end
end

---Builds a key string by nuid and returns nuid and entityId found by the globals.
---@param nuid number
---@return number|nil nuid, number|nil entityId
function GlobalsUtils:getNuidEntityPair(nuid)
    if self.utils:isEmpty(nuid) then
        --print("Nuid is nil. Unable to return entityId then!")
        return nil, nil
        --error(("nuid(%s) is empty!"):format(nuid), 2)
    end
    if type(nuid) ~= "number" then
        error(("nuid(%s) is not type of number!"):format(nuid), 2)
    end
    local key                          = self.nuidKeyFormat:format(nuid)
    local value                        = GlobalsGetValue(key)
    local nuidGlobals, entityIdGlobals = self:parseXmlValueToNuidAndEntityId(key, value)
    return nuidGlobals, entityIdGlobals
end

function GlobalsUtils:setUpdateGui(bool)
    local key = "updateGui"
    local value = GlobalsSetValue(key, tostring(bool))
    return value
end

function GlobalsUtils:getUpdateGui()
    local key = "updateGui"
    local value = GlobalsGetValue(key)
    return value
end

---Constructor of the class. This is mandatory!
---@param globalsUtilsObject GlobalsUtils|nil optional
---@param customProfiler CustomProfiler required
---@param logger Logger required
---@param client Client|nil optional
---@param utils Utils required
---@return GlobalsUtils
function GlobalsUtils:new(globalsUtilsObject, customProfiler, logger, client, utils)
    ---@class GlobalsUtils
    globalsUtilsObject = setmetatable(globalsUtilsObject or self, GlobalsUtils)

    if not customProfiler then
        error("GlobalsUtils:new requires customProfiler as parameter!")
    end

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not globalsUtilsObject.customProfiler then
        ---@type CustomProfiler
        globalsUtilsObject.customProfiler = customProfiler
    end
    if not globalsUtilsObject.logger then
        ---@type Logger
        globalsUtilsObject.logger = logger or
            error("GlobalsUtils:new requires logger as parameter!")
    end
    if not globalsUtilsObject.client then
        ---@type Client
        globalsUtilsObject.client = client
        if not globalsUtilsObject.client then
            globalsUtilsObject.logger:warn(globalsUtilsObject.logger.channels.initialize, "Make sure to set globalsUtilsObject.client later on!")
        end
    end
    if not globalsUtilsObject.utils then
        ---@type Utils
        globalsUtilsObject.utils = utils or
            error("GlobalsUtils:new requires utils as parameter!")
    end

    return globalsUtilsObject
end

return GlobalsUtils
