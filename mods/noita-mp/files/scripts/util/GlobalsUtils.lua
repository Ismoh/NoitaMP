-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

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
        --Logger.trace(Logger.channels.globals,
        --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.start(functionName %s)")
        --                    :format(functionName))
    end
    CustomProfiler.stop  = function(functionName, customProfilerCounter)
        --Logger.trace(Logger.channels.globals,
        --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.stop(functionName %s, customProfilerCounter %s)")
        --                    :format(functionName, customProfilerCounter))
    end
end

-----------------
--- GlobalsUtils:
-----------------
--- class for GlobalsSetValue and GlobalsGetValue
GlobalsUtils                    = {}

--- key for nuid
GlobalsUtils.nuidKeyFormat      = "nuid = %s"
GlobalsUtils.nuidKeySubstring   = "nuid = "
GlobalsUtils.nuidValueFormat    = "entityId = %s"
GlobalsUtils.nuidValueSubstring = "entityId = "
GlobalsUtils.deadNuidsKey       = "deadNuids"

--- Parses key and value string to nuid and entityId.
--- @param xmlKey string GlobalsUtils.nuidKeyFormat = "nuid = %s"
--- @param xmlValue string GlobalsUtils.nuidValueFormat = "entityId = %s"
--- @return number nuid
--- @return number entityId
function GlobalsUtils.parseXmlValueToNuidAndEntityId(xmlKey, xmlValue)
    local cpc = CustomProfiler.start("GlobalsUtils.parseXmlValueToNuidAndEntityId")
    if type(xmlKey) ~= "string" then
        error(("xmlKey(%s) is not type of string!"):format(xmlKey), 2)
    end
    if type(xmlValue) ~= "string" then
        error(("xmlKeyValue(%s) is not type of string!"):format(xmlValue), 2)
    end

    local nuid      = nil
    local foundNuid = string.find(xmlKey, GlobalsUtils.nuidKeySubstring, 1, true)
    if foundNuid ~= nil then
        nuid = tonumber(string.sub(xmlKey, GlobalsUtils.nuidKeySubstring:len()))
    else
        Logger.info(Logger.channels.globals, "Unable to get nuid number of key string (%s).", xmlKey)
        return nil, nil
    end

    local entityId = nil
    if xmlValue and xmlValue ~= "" then
        -- can be empty or nil, when there is no entityId stored in Noitas Globals
        local foundEntityId = string.find(xmlValue, GlobalsUtils.nuidValueSubstring, 1, true)
        if foundEntityId ~= nil then
            entityId = tonumber(string.sub(xmlValue, GlobalsUtils.nuidValueSubstring:len()))
        else
            error(("Unable to get entityId number of value string (%s)."):format(xmlValue), 2)
        end
    end

    if entityId == nil or entityId == "" then
        if _G.whoAmI then
            -- _G.whoAmI can be nil, when executed in Noita Components,
            -- because those does not have access to globals
            if _G.whoAmI() == _G.Client.iAm and _G.Client.isConnected() then
                _G.Client.sendLostNuid(nuid)
            end
        end
    end
    CustomProfiler.stop("GlobalsUtils.parseXmlValueToNuidAndEntityId", cpc)
    return nuid, entityId
end

function GlobalsUtils.setNuid(nuid, entityId, componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid)
    local cpc = CustomProfiler.start("GlobalsUtils.setNuid")
    GlobalsSetValue(GlobalsUtils.nuidKeyFormat:format(nuid),
                    GlobalsUtils.nuidValueFormat:format(entityId)) -- also change stuff in nuid_updater.lua
    CustomProfiler.stop("GlobalsUtils.setNuid", cpc)
end

function GlobalsUtils.setDeadNuid(nuid)
    local cpc          = CustomProfiler.start("GlobalsUtils.setDeadNuid")
    local oldDeadNuids = GlobalsGetValue(GlobalsUtils.deadNuidsKey, "")
    if oldDeadNuids == "" then
        GlobalsSetValue(GlobalsUtils.deadNuidsKey, nuid)
    else
        GlobalsSetValue(GlobalsUtils.deadNuidsKey, ("%s,%s"):format(oldDeadNuids, nuid))
    end
    CustomProfiler.stop("GlobalsUtils.setDeadNuid", cpc)
end

function GlobalsUtils.getDeadNuids()
    local cpc          = CustomProfiler.start("GlobalsUtils.getDeadNuids")
    local globalsValue = GlobalsGetValue(GlobalsUtils.deadNuidsKey, "")
    local deadNuids    = string.split(globalsValue, ",") or {}
    if table.contains(deadNuids, "nil") then
        --table.remove(deadNuids, table.indexOf(deadNuids, "nil"))
        table.removeByValue(deadNuids, "nil")
    end
    CustomProfiler.stop("GlobalsUtils.getDeadNuids", cpc)
    return deadNuids
end

function GlobalsUtils.removeDeadNuid(nuid)
    local cpc             = CustomProfiler.start("GlobalsUtils.removeDeadNuid")
    local globalsValue    = GlobalsGetValue(GlobalsUtils.deadNuidsKey, "")
    local deadNuids       = string.split(globalsValue, ",")
    local contains, index = table.contains(deadNuids, nuid)
    if contains then
        table.remove(deadNuids, index)
        if not next(deadNuids) then
            -- if deadNuids is empty
            GlobalsSetValue(GlobalsUtils.deadNuidsKey, "")
        else
            GlobalsSetValue(GlobalsUtils.deadNuidsKey, table.concat(deadNuids, ","))
        end
    end
    CustomProfiler.stop("GlobalsUtils.removeDeadNuid", cpc)
end

--- Builds a key string by nuid and returns nuid and entityId found by the globals.
--- @param nuid number
--- @return number nuid, number entityId
function GlobalsUtils.getNuidEntityPair(nuid)
    local cpc            = CustomProfiler.start("GlobalsUtils.getNuidEntityPair")
    local key            = GlobalsUtils.nuidKeyFormat:format(nuid)
    local value          = GlobalsGetValue(key)
    local nuid, entityId = GlobalsUtils.parseXmlValueToNuidAndEntityId(key, value)
    CustomProfiler.stop("GlobalsUtils.getNuidEntityPair", cpc)
    return nuid, entityId
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.GlobalsUtils = GlobalsUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return GlobalsUtils
