-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

--if not EntityUtils then
--   EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
--end

-----------------
-- NetworkVscUtils:
-----------------
--- class for getting and setting values in VariableStorageComponents of Noita-API
NetworkVscUtils = {}

--#region Global private variables

local idcounter = 0

--#endregion

--#region Global private functions

local function isEmpty(var)
    -- if you change this also change NetworkVscUtils.lua
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

--- Checks if an entity already has a specific VariableStorageComponent.
--- @param entityId number Id of an entity provided by Noita
--- @param componentTypeName string "VariableStorageComponent", "LuaComponent", etc
--- @param fieldNameForMatch string Components attribute to match the specific component you are searching for: "name", "script_source_file", "etc". component.name = "brah": 'name' -> fieldNameForMatch
--- @param matchValue string The components attribute value, you want to match to: component.name = "brah": 'brah' -> matchValue Have a look on NetworkVscUtils.componentNameOf___
--- @param fieldNameForValue string "name", "script_source_file", "etc"
--- @return number|boolean compId The specific componentId, which contains the searched value or false if there isn't any Component
--- @return string value The components value
local function checkIfSpecificVscExists(entityId, componentTypeName, fieldNameForMatch, matchValue, fieldNameForValue)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    local componentIds = EntityGetComponentIncludingDisabled(entityId, componentTypeName) or {}
    if isEmpty(componentIds) then
        logger:debug(logger.channels.vsc, "Entity(%s) does not have any %s. Returning nil.", entityId,
                     componentTypeName)
        return false
    end

    for i = 1, #componentIds do
        local componentId = componentIds[i]
        -- get the components name
        local compName    = tostring(ComponentGetValue2(componentId, fieldNameForMatch))
        if string.find(compName, matchValue, 1, true) then
            --compName == matchValue then
            -- if the name of the component match to the one we are searching for, then get the value
            local value = tostring(ComponentGetValue2(componentId, fieldNameForValue))
            NetworkVscUtils.enableComponent(entityId, componentId)
            -- return componentId and value
            return componentIds[i], value
        end
    end
    logger:warn(logger.channels.vsc, "Looks like the %s.%s does not exists on entity(%s). Returning nil!",
                componentTypeName, fieldNameForMatch, entityId)
    return false
end

--- Adds a VariableStorageComponent for the owners name.
---@param entityId number Id of an entity provided by Noita
---@param ownerName string This is the owner of an entity. Owners name.
local function addOrUpdateVscForOwnerName(entityId, ownerName)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    if not ownerName or ownerName == "" then
        logger:error(logger.channels.vsc,
                     ("Unable to update VSC on entity (%s), when ownerName is '%s'"):format(entityId, ownerName))
        ownerName = tostring(ownerName)
    end

    local compId, compOwnerName = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfOwnersName, NetworkVscUtils.valueString)
    if compId then
        ComponentSetValue2(compId, NetworkVscUtils.valueString, ownerName)
        logger:debug(logger.channels.vsc,
                     "Owner.name(%s) was set to already existing VSC(%s, %s) on entity(%s). Previous owner name = %s",
                     ownerName,
                     NetworkVscUtils.componentNameOfOwnersName,
                     compId,
                     entityId,
                     compOwnerName
        )
        return compId
    else
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name         = NetworkVscUtils.componentNameOfOwnersName,
            value_string = ownerName
        })
        logger:debug(logger.channels.vsc,
                     "VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
                     NetworkVscUtils.componentNameOfOwnersName,
                     ownerName,
                     compId,
                     entityId
        )
        return compId
    end

    logger:error("Unable to add ownerNameVsc! Returning nil!")
    return nil
end

local function addOrUpdateVscForOwnerGuid(entityId, ownerGuid)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    if not ownerGuid or ownerGuid == "" then
        logger:error(logger.channels.vsc,
                     ("Unable to update VSC on entity (%s), when ownerGuid is '%s'"):format(entityId, ownerGuid))
        ownerGuid = tostring(ownerGuid)
    end

    local compId, compOwnerGuid = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfOwnersGuid, NetworkVscUtils.valueString)
    if compId then
        ComponentSetValue2(compId, NetworkVscUtils.valueString, ownerGuid)
        logger:debug(logger.channels.vsc,
                     "Owner.guid(%s) was set to already existing VSC(%s, %s) on entity(%s). Previous owner guid = %s",
                     ownerGuid,
                     NetworkVscUtils.componentNameOfOwnersGuid,
                     compId,
                     entityId,
                     compOwnerGuid
        )
        return compId
    else
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name         = NetworkVscUtils.componentNameOfOwnersGuid,
            value_string = ownerGuid
        })
        logger:debug(logger.channels.vsc,
                     "VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
                     NetworkVscUtils.componentNameOfOwnersName,
                     ownerGuid,
                     compId,
                     entityId
        )
        return compId
    end

    logger:error("Unable to add ownerGuidVsc! Returning nil!")
    return nil
end

local function addOrUpdateVscForNuid(entityId, nuid)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    if _G.whoAmI() == _G.Server.iAm and not nuid or nuid == "" then
        logger:error(logger.channels.vsc,
                     ("Unable to update VSC on entity (%s), when nuid is '%s'"):format(entityId, nuid))
    end

    local compId, compNuid = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfNuid, NetworkVscUtils.valueString)
    if compNuid and compNuid ~= "" then
        error(("It is not possible to re-set a nuid(%s) on a entity(%s), which already has one set(%s)! Returning nil!"):format(nuid,
                                                                                                                                entityId,
                                                                                                                                compNuid),
              2)
    end

    -- There already might be a nuid vsc without any nuid set, think of a client shooting projectiles
    if compId and not compNuid or compNuid == "" then
        ComponentSetValue2(compId, NetworkVscUtils.valueString, nuid)
        logger:debug(logger.channels.vsc,
                     "Nuid(%s) was set to already existing VSC(%s, %s) on entity(%s)",
                     nuid,
                     NetworkVscUtils.componentNameOfNuid,
                     compId,
                     entityId
        )
        return compId
    end

    -- If compId isn't set, there is no vsc already added
    if not compId then
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name         = NetworkVscUtils.componentNameOfNuid,
            value_string = nuid
        })
        logger:debug(logger.channels.vsc,
                     "VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
                     NetworkVscUtils.componentNameOfNuid,
                     nuid,
                     compId,
                     entityId
        )
        return compId
    end

    logger:error("Unable to add nuidVsc! Returning nil!")
    return nil
end

--- Adds a LuaComponent for the nuid debugger.
---@param entityId number Id of an entity provided by Noita
local function addNuidDebugger(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local compId, compOwnerName = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidDebugger, "script_source_file")
    if compId then
        logger:debug(logger.channels.vsc, "Entity(%s) already has a nuid debugger.")
        return compId
    else
        compId = EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file     = "mods/noita-mp/files/scripts/noita-components/nuid_debug.lua",
            script_enabled_changed = "mods/noita-mp/files/scripts/noita-components/lua_component_enabler.lua",
            execute_every_n_frame  = 1,
        })
        logger:debug(logger.channels.vsc,
                     "LuaComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
                     NetworkVscUtils.componentNameOfNuidDebugger,
                     "nuid_debug.lua",
                     compId,
                     entityId
        )
        return compId
    end

    logger:error("Unable to add nuid debugger! Returning nil!")
    return nil
end

--- Adds a LuaComponent for the nuid updater.
---@param entityId number Id of an entity provided by Noita
local function addNuidUpdater(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local compId, compOwnerName = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidUpdater, "script_source_file")
    if compId then
        logger:debug(logger.channels.vsc, "Entity(%s) already has a nuid updater.")
        return compId
    else
        compId = EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file     = "mods/noita-mp/files/scripts/noita-components/nuid_updater.lua",
            script_enabled_changed = "mods/noita-mp/files/scripts/noita-components/lua_component_enabler.lua",
            execute_on_added       = true,
            execute_on_removed     = true,
            execute_every_n_frame  = -1, -- = -1 -> execute only on add/remove/event
        })
        logger:debug(logger.channels.vsc,
                     "LuaComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
                     NetworkVscUtils.componentNameOfNuidUpdater,
                     "nuid_updater.lua",
                     compId,
                     entityId
        )
        return compId
    end

    logger:error("Unable to add nuid updater! Returning nil!")
    return nil
end

local function getNetworkComponents(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local ownerNameCompId                            = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfOwnersName, NetworkVscUtils.valueString)
    local ownerGuidCompId                            = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfOwnersGuid, NetworkVscUtils.valueString)
    local nuidCompId                                 = checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfNuid, NetworkVscUtils.valueString)
    local componentIdForNuidDebugger, scriptFileName = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidDebugger, "script_source_file")
    local componentIdForNuidUpdater, scriptFileName  = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidUpdater, "script_source_file")

    return ownerNameCompId, ownerGuidCompId, nuidCompId, componentIdForNuidDebugger, componentIdForNuidUpdater
end

--#endregion

--#region Global public variables

NetworkVscUtils.variableStorageComponentName = "VariableStorageComponent"
NetworkVscUtils.name                         = "name"
NetworkVscUtils.valueString                  = "value_string"
NetworkVscUtils.componentNameOfOwnersName    = "noita-mp.nc_owner.name"
NetworkVscUtils.componentNameOfOwnersGuid    = "noita-mp.nc_owner.guid"
NetworkVscUtils.componentNameOfNuid          = "noita-mp.nc_nuid"
NetworkVscUtils.componentNameOfNuidDebugger  = "nuid_debug.lua"
NetworkVscUtils.componentNameOfNuidUpdater   = "nuid_updater.lua"


--#endregion

--#region Global public functions

--- Simply adds or updates all needed Network Variable Storage Components.
---@param entityId number Id of an entity provided by Noita
---@param ownerName string Owners name. Cannot be nil.
---@param ownerGuid string Owners guid. Cannot be nil.
---@param nuid number Network unique identifier. Can only be nil on clients, but not on server.
---@return integer|nil componentIdForOwnerName
---@return integer|nil componentIdForOwnerGuid
---@return integer|nil componentIdForNuid
function NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    if _G.whoAmI() == _G.Server.iAm and isEmpty(nuid) then
        error("You are not allowed to add a empty or nil nuid, when beeing server!", 2)
    end

    local componentIdForOwnerName    = addOrUpdateVscForOwnerName(entityId, ownerName)
    local componentIdForOwnerGuid    = addOrUpdateVscForOwnerGuid(entityId, ownerGuid)
    local componentIdForNuid         = addOrUpdateVscForNuid(entityId, nuid)
    local componentIdForNuidDebugger = addNuidDebugger(entityId)
    local componentIdForNuidUpdater  = addNuidUpdater(entityId)

    if not componentIdForOwnerName or not componentIdForOwnerGuid or not componentIdForNuid or not componentIdForNuidDebugger or not componentIdForNuidUpdater then
        error(("Something terrible went wrong! A component id for a Network Vsc was nil. OwnerNameCompId = %s, OwnerGuidCompId = %s, NuidCompId = %s, NuidDebuggerCompId = %s, NuidUpdaterCompId = %s")
                      :format(componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid,
                              componentIdForNuidDebugger, componentIdForNuidUpdater), 2)
    end

    return componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid, componentIdForNuidDebugger, componentIdForNuidUpdater
end

--- Returns all Network Vsc values by its entity id.
--- @param entityId number Entity Id provided by Noita
--- @return string ownerName
--- @return string ownerGuid
--- @return number nuid
function NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local ownerNameCompId, ownerGuidCompId, nuidCompId, componentIdForNuidDebugger, componentIdForNuidUpdater = getNetworkComponents(entityId)
    return NetworkVscUtils.getAllVcsValuesByComponentIds(ownerNameCompId, ownerGuidCompId, nuidCompId)
end

--- Returns all Network Vsc values by its component ids.
---@param ownerNameCompId number Component Id of the OwnerNameVsc
---@param ownerGuidCompId number Component Id of the OwnerGuidVsc
---@param nuidCompId number Component Id of the NuidVsc
---@return string ownerName
---@return string ownerGuid
---@return number nuid
function NetworkVscUtils.getAllVcsValuesByComponentIds(ownerNameCompId, ownerGuidCompId, nuidCompId)
    local compOwnerName = ComponentGetValue2(ownerNameCompId, NetworkVscUtils.valueString)
    local compOwnerGuid = ComponentGetValue2(ownerGuidCompId, NetworkVscUtils.valueString)
    local compNuid      = ComponentGetValue2(nuidCompId, NetworkVscUtils.valueString)

    return compOwnerName, compOwnerGuid, tonumber(compNuid)
end

function NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    return checkIfSpecificVscExists(
            entityId, NetworkVscUtils.variableStorageComponentName, NetworkVscUtils.name,
            NetworkVscUtils.componentNameOfNuid, NetworkVscUtils.valueString)
end

--- Checks if the nuid Vsc exists, if so returns nuid
--- @param entityId number
--- @return boolean|number return false|nuid : Returns false, if there is no NuidVsc or nuid is empty. Returns nuid, if set.
function NetworkVscUtils.hasNuidSet(entityId)
    local nuidCompId, nuid = checkIfSpecificVscExists(entityId, NetworkVscUtils.variableStorageComponentName,
                                                      NetworkVscUtils.name,
                                                      NetworkVscUtils.componentNameOfNuid, NetworkVscUtils.valueString)

    if not nuidCompId then
        return false
    end
    if not nuid or nuid == "" then
        return false
    end
    return tonumber(nuid)
end

function NetworkVscUtils.hasNetworkLuaComponents(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local has                  = false
    local nuid_debugger, value = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidDebugger, "script_source_file")
    local nuid_updater, value  = checkIfSpecificVscExists(
            entityId, "LuaComponent", "script_source_file",
            NetworkVscUtils.componentNameOfNuidUpdater, "script_source_file")

    if nuid_debugger and nuid_updater then
        has = true
    end
    return has
end

function NetworkVscUtils.enableComponents(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    local ownerNameCompId, ownerGuidCompId, nuidCompId, componentIdForNuidDebugger, componentIdForNuidUpdater = getNetworkComponents(entityId)
    NetworkVscUtils.enableComponent(entityId, ownerNameCompId)
    NetworkVscUtils.enableComponent(entityId, ownerGuidCompId)
    NetworkVscUtils.enableComponent(entityId, nuidCompId)
    NetworkVscUtils.enableComponent(entityId, componentIdForNuidDebugger)
    NetworkVscUtils.enableComponent(entityId, componentIdForNuidUpdater)
end

function NetworkVscUtils.enableComponent(entityId, componentId)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end
    if not ComponentGetIsEnabled(componentId) then
        logger:warn(logger.channels.vsc, "Entity(%s) has a disabled network component(%s), turning it on!", entityId,
                    componentId)
        EntitySetComponentIsEnabled(entityId, componentId, true)
    end
end

--#endregion

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NetworkVscUtils = NetworkVscUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NetworkVscUtils
