---NetworkVscUtils for getting and setting values in VariableStorageComponents of Noita-API
---@class NetworkVscUtils
local NetworkVscUtils            = {

    --[[ Attributes ]]

    componentNameOfNuid          = "noita-mp.nc_nuid",
    componentNameOfNuidDebugger  = "nuid_debug.lua",
    componentNameOfNuidUpdater   = "nuid_updater.lua",
    componentNameOfOwnersGuid    = "noita-mp.nc_owner.guid",
    componentNameOfOwnersName    = "noita-mp.nc_owner.name",
    componentNameOfSpawnX        = "noita-mp.nc_spawn.x",
    componentNameOfSpawnY        = "noita-mp.nc_spawn.y",
    name                         = "name",
    valueString                  = "value_string",
    variableStorageComponentName = "VariableStorageComponent",
}

---Adds a VariableStorageComponent for the owners name.
---@private
---@param self NetworkVscUtils
---@param entityId number Id of an entity provided by Noita
---@param ownerName string This is the owner of an entity. Owners name.
local addOrUpdateVscForOwnerName = function(self, entityId, ownerName)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateVscForOwnerName")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerName", cpc)
        return
    end

    if not ownerName or ownerName == "" then
        error(("Unable to update VSC on entity (%s), when ownerName is '%s'"):format(entityId, ownerName), 2)
        ownerName = tostring(ownerName)
    end

    local compId, compOwnerName = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName, self.name, self.componentNameOfOwnersName,
        self.valueString)
    if compId then
        ComponentSetValue2(compId, self.valueString, ownerName)
        self.logger:debug(self.logger.channels.vsc,
            ("Owner.name(%s) was set to already existing VSC(%s, %s) on entity(%s). Previous owner name = %s"):format(ownerName,
                NetworkVscUtils.componentNameOfOwnersName, compId, entityId, compOwnerName))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerName", cpc)
        return compId
    else
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name         = self.componentNameOfOwnersName,
            value_string = ownerName
        })
        ComponentAddTag(compId, "enabled_in_hand")
        ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!"):format(
                NetworkVscUtils.componentNameOfOwnersName, ownerName, compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerName", cpc)
        return compId
    end

    error("Unable to add ownerNameVsc!", 2)
    self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerName", cpc)
    return nil
end

---
---@private
---@param self NetworkVscUtils
---@param entityId number required
---@param ownerGuid string required
---@return number compId
local addOrUpdateVscForOwnerGuid = function(self, entityId, ownerGuid)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateVscForOwnerGuid")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerGuid", cpc)
        return -1
    end

    if not ownerGuid or ownerGuid == "" then
        error(("Unable to update VSC on entity (%s), when ownerGuid is '%s'"):format(entityId, ownerGuid), 2)
        ownerGuid = tostring(ownerGuid)
    end

    local compId, compOwnerGuid = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName, self.name, self.componentNameOfOwnersGuid,
        self.valueString)
    if compId then
        ComponentSetValue2(compId, self.valueString, ownerGuid)
        self.logger:debug(self.logger.channels.vsc,
            ("Owner.guid(%s) was set to already existing VSC(%s, %s) on entity(%s). Previous owner guid = %s"):format(ownerGuid,
                self.componentNameOfOwnersGuid, compId, entityId, compOwnerGuid))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerGuid", cpc)
        return compId
    else
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name         = self.componentNameOfOwnersGuid,
            value_string = ownerGuid
        })
        ComponentAddTag(compId, "enabled_in_hand")
        ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!"):format(self.componentNameOfOwnersName, ownerGuid,
                compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerGuid", cpc)
        return compId or -1
    end

    error("Unable to add ownerGuidVsc!")
    self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForOwnerGuid", cpc)
    return -1
end

---
---@private
---@param self NetworkVscUtils
---@param entityId number required
---@param nuid number required
---@return number compId
local addOrUpdateVscForNuid      = function(self, entityId, nuid)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateVscForNuid")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForNuid", cpc)
        return -1
    end

    if self.server:amIServer() and not nuid or nuid == "" then
        error(("Unable to update VSC on entity (%s), when nuid is '%s'"):format(entityId, nuid), 2)
    end

    local compId, compNuid = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName, self.name, self.componentNameOfNuid,
        "value_int")
    if compNuid == 0 or compNuid == -1 then
        compNuid = nil
    end

    if compId and nuid == compNuid then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForNuid", cpc)
        return compId
    end

    if compNuid and compNuid ~= "" and compNuid ~= -1 and compNuid ~= "-1" and compNuid ~= 0 and compNuid ~= "0" then
        error(("It is not possible to re-set a nuid(%s) on a entity(%s), which already has one set(%s)! Returning nil!")
            :format(nuid, entityId, compNuid), 2)
    end

    if not self.utils:isEmpty(nuid) and nuid > 0 then
        self.globalsUtils:setNuid(nuid, entityId)
    end

    -- There already might be a nuid vsc without any nuid set, think of a client shooting projectiles
    if compId and self.utils:isEmpty(compNuid) or compNuid == -1 or compNuid == 0 or compNuid == "-1" or compNuid == "0" then
        ComponentSetValue2(compId, "value_int", nuid)
        self.logger:debug(self.logger.channels.vsc,
            ("Nuid(%s) was set to already existing VSC(%s, %s) on entity(%s)"):format(nuid, self.componentNameOfNuid, compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForNuid", cpc)
        return compId or -1
    end

    -- If compId isn't set, there is no vsc already added
    if not compId then
        compId = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name      = self.componentNameOfNuid,
            value_int = nuid
        })
        ComponentAddTag(compId, "enabled_in_hand")
        ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!"):format(NetworkVscUtils.componentNameOfNuid, nuid,
                compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForNuid", cpc)
        return compId or -1
    end

    error("Unable to add nuidVsc!", 2)
    self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForNuid", cpc)
    return -1
end

---
---@private
---@param self NetworkVscUtils required
---@param entityId number required
---@param spawnX number required
---@return number|false|nil
local addOrUpdateVscForSpawnX    = function(self, entityId, spawnX)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateVscForSpawnX")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnX", cpc)
        return
    end


    local compIdX, compSpawnX = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName, self.name, self.componentNameOfSpawnX,
        "value_float")

    if not self.utils:isEmpty(compIdX) and not self.utils:isEmpty(compSpawnX) then
        return compIdX
    end

    if type(compSpawnX) == "number" and compSpawnX < 0 then
        compSpawnX = nil
    end

    -- There already might be a vsc without any value set
    if compIdX and self.utils:isEmpty(compSpawnX) then
        ComponentSetValue2(compIdX, "value_float", spawnX)
        self.logger:debug(self.logger.channels.vsc,
            ("SpawnX(%s) was set to already existing VSC(%s, %s) on entity(%s)"):format(spawnX, NetworkVscUtils.componentNameOfSpawnX, compIdX,
                entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnX", cpc)
        return compIdX
    end

    -- If compId isn't set, there is no vsc. Add one!
    if not compIdX then
        compIdX = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name        = NetworkVscUtils.componentNameOfSpawnX,
            value_float = spawnX
        })
        -- ComponentAddTag(compId, "enabled_in_hand")
        -- ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!"):format(NetworkVscUtils.componentNameOfSpawnX,
                spawnX, compIdX, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnX", cpc)
        return compIdX
    end

    error("Unable to add spawnXVsc!", 2)
    self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnX", cpc)
    return nil
end

---
---@private
---@param self NetworkVscUtils required
---@param entityId number required
---@param spawnY number required
---@return number|false|nil
local addOrUpdateVscForSpawnY    = function(self, entityId, spawnY)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateVscForSpawnY")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnY", cpc)
        return
    end


    local compIdY, compSpawnY = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfSpawnY, "value_float")
    if not self.utils:isEmpty(compIdY) and not self.utils:isEmpty(compSpawnY) then
        return compIdY
    end

    if type(compSpawnY) == "number" and compSpawnY < 0 then
        compSpawnY = nil
    end

    -- There already might be a vsc without any value set
    if compIdY and self.utils:isEmpty(compSpawnY) then
        ComponentSetValue2(compIdY, "value_float", spawnY)
        self.logger:debug(self.logger.channels.vsc,
            ("SpawnY(%s) was set to already existing VSC(%s, %s) on entity(%s)"):format(spawnY, NetworkVscUtils.componentNameOfSpawnY, compIdY,
                entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnX", cpc)
        return compIdY
    end

    -- If compId isn't set, there is no vsc. Add one!
    if not compIdY then
        compIdY = EntityAddComponent2(entityId, "VariableStorageComponent", {
            name        = self.componentNameOfSpawnY,
            value_float = spawnY
        })
        -- ComponentAddTag(compId, "enabled_in_hand")
        -- ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc, ("VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!")
            :format(self.componentNameOfSpawnY, spawnY, compIdY, entityId))
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnY", cpc)
        return compIdY
    end

    error("Unable to add spawnYVsc!", 2)
    self.customProfiler:stop("NetworkVscUtils.addOrUpdateVscForSpawnY", cpc)
    return nil
end

---Adds a LuaComponent for the nuid debugger.
---@private
---@param self NetworkVscUtils required
---@param entityId number Id of an entity provided by Noita
---@return number compId
local addNuidDebugger            = function(self, entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.addNuidDebugger")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addNuidDebugger", cpc)
        return -1
    end
    local compId, compOwnerName = self:checkIfSpecificVscExists(
        entityId, "LuaComponent", "script_source_file",
        self.componentNameOfNuidDebugger, "script_source_file")
    if compId then
        self.logger:debug(self.logger.channels.vsc, ("Entity(%s) already has a nuid debugger."):format(entityId))
        self.customProfiler:stop("NetworkVscUtils.addNuidDebugger", cpc)
        return compId
    else
        compId = EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file    = "mods/noita-mp/files/scripts/noita-components/nuid_debug.lua",
            execute_every_n_frame = 1,
        })
        ComponentAddTag(compId, "enabled_in_hand")
        ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("LuaComponent (%s = %s) added with noita componentId = %s to entityId = %s!"):format(self.componentNameOfNuidDebugger, "nuid_debug.lua",
                compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addNuidDebugger", cpc)
        return compId or -1
    end

    error("Unable to add nuid debugger!", 2)
    self.customProfiler:stop("NetworkVscUtils.addNuidDebugger", cpc)
    return -1
end

---Adds a LuaComponent for the nuid updater.
---@private
---@param self NetworkVscUtils required
---@param entityId number Id of an entity provided by Noita
---@return number compId
local addNuidUpdater             = function(self, entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.addNuidUpdater")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addNuidUpdater", cpc)
        return -1
    end
    local compId, compOwnerName = self:checkIfSpecificVscExists(
        entityId, "LuaComponent", "script_source_file",
        self.componentNameOfNuidUpdater, "script_source_file")
    if compId then
        self.logger:debug(self.logger.channels.vsc, ("Entity(%s) already has a nuid updater."):format(entityId))
        self.customProfiler:stop("NetworkVscUtils.addNuidUpdater", cpc)
        return compId
    else
        compId = EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file    = "mods/noita-mp/files/scripts/noita-components/nuid_updater.lua",
            execute_on_added      = true,
            execute_on_removed    = true,
            execute_every_n_frame = -1, -- = -1 -> execute only on add/remove/event
        })
        ComponentAddTag(compId, "enabled_in_hand")
        ComponentAddTag(compId, "enabled_in_world")
        self.logger:debug(self.logger.channels.vsc,
            ("LuaComponent (%s = %s) added with noita componentId = %s to entityId = %s!")
            :format(self.componentNameOfNuidUpdater, "nuid_updater.lua", compId, entityId))
        self.customProfiler:stop("NetworkVscUtils.addNuidUpdater", cpc)
        return compId or -1
    end

    error("Unable to add nuid updater!", 2)
    self.customProfiler:stop("NetworkVscUtils.addNuidUpdater", cpc)
    return -1
end

---
---@private
---@param self NetworkVscUtils required
---@param entityId number required
---@return number|false|nil
---@return number|false|nil
---@return number|false|nil
---@return number|false|nil
---@return number|false|nil
local getNetworkComponents       = function(self, entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.getNetworkComponents")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.getNetworkComponents", cpc)
        return
    end
    local ownerNameCompId                            = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfOwnersName, self.valueString)
    local ownerGuidCompId                            = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfOwnersGuid, self.valueString)
    local nuidCompId                                 = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfNuid, self.valueString)
    local componentIdForNuidDebugger, scriptFileName = self:checkIfSpecificVscExists(entityId, "LuaComponent",
        "script_source_file", self.componentNameOfNuidDebugger, "script_source_file")
    local componentIdForNuidUpdater, scriptFileName  = self:checkIfSpecificVscExists(entityId, "LuaComponent",
        "script_source_file", self.componentNameOfNuidUpdater, "script_source_file")

    self.customProfiler:stop("NetworkVscUtils.getNetworkComponents", cpc)
    return ownerNameCompId, ownerGuidCompId, nuidCompId, componentIdForNuidDebugger, componentIdForNuidUpdater
end


---Checks if an entity already has a specific VariableStorageComponent.
---@param entityId number Id of an entity provided by Noita
---@param componentTypeName string "VariableStorageComponent", "LuaComponent", etc
---@param fieldNameForMatch string Components attribute to match the specific component you are searching for: "name", "script_source_file", "etc". component.name = "brah": 'name' -> fieldNameForMatch
---@param matchValue string The components attribute value, you want to match to: component.name = "brah": 'brah' -> matchValue Have a look on NetworkVscUtils.componentNameOf___
---@param fieldNameForValue string "name", "script_source_file", "etc"
---@return number|false|nil compId The specific componentId, which contains the searched value or false if there isn't any Component
---@return string|nil value The components value
function NetworkVscUtils:checkIfSpecificVscExists(entityId, componentTypeName, fieldNameForMatch, matchValue, fieldNameForValue)
    local cpc = self.customProfiler:start("NetworkVscUtils.checkIfSpecificVscExists")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.checkIfSpecificVscExists", cpc)
        return false, nil
    end

    local componentIds = EntityGetComponentIncludingDisabled(entityId, componentTypeName) or {}
    if self.utils:isEmpty(componentIds) then
        self.logger:debug(self.logger.channels.vsc, ("Entity(%s) does not have any %s. Returning nil."):format(entityId, componentTypeName))
        self.customProfiler:stop("NetworkVscUtils.checkIfSpecificVscExists", cpc)
        return false, nil
    end

    for i = 1, #componentIds do
        local componentId = componentIds[i]
        -- get the components name
        local compName    = tostring(ComponentGetValue2(componentId, fieldNameForMatch))
        if string.find(compName, matchValue, 1, true) then
            -- if the name of the component match to the one we are searching for, then get the value
            local value = ComponentGetValue2(componentId, fieldNameForValue)
            self.customProfiler:stop("NetworkVscUtils.checkIfSpecificVscExists", cpc)
            return componentIds[i], value
        end
    end
    self.logger:trace(self.logger.channels.vsc,
        ("Looks like the %s.%s does not exists on entity(%s). Returning nil!"):format(componentTypeName, fieldNameForMatch, entityId))
    self.customProfiler:stop("NetworkVscUtils.checkIfSpecificVscExists", cpc)
    return false, nil
end

---Simply adds or updates all needed Network Variable Storage Components.
---@param entityId number Id of an entity provided by Noita
---@param ownerName string Owners name. Cannot be nil.
---@param ownerGuid string Owners guid. Cannot be nil.
---@param nuid number|nil Network unique identifier. Can only be nil on clients, but not on server.
---@param spawnX number|nil X position of the entity, when spawned. Can only be set once! Can be nil.
---@param spawnY number|nil Y position of the entity, when spawned. Can only be set once! Can be nil.
---@return integer|nil componentIdForOwnerName
---@return integer|nil componentIdForOwnerGuid
---@return integer|nil componentIdForNuid
---@return integer|nil componentIdForNuidDebugger
---@return integer|nil componentIdForNuidDebugger
---@return integer|nil componentIdForSpawnX
---@return integer|nil componentIdForSpawnY
function NetworkVscUtils:addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid, spawnX, spawnY)
    local cpc = self.customProfiler:start("NetworkVscUtils.addOrUpdateAllVscs")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.addOrUpdateAllVscs", cpc)
        return
    end

    if self.server:amIServer() and self.utils:isEmpty(nuid) then
        error("You are not allowed to add a empty or nil nuid, when beeing server!", 2)
    end

    local componentIdForOwnerName    = addOrUpdateVscForOwnerName(self, entityId, ownerName)
    local componentIdForOwnerGuid    = addOrUpdateVscForOwnerGuid(self, entityId, ownerGuid)
    local componentIdForNuid         = addOrUpdateVscForNuid(self, entityId, nuid)
    local componentIdForNuidDebugger = addNuidDebugger(self, entityId)
    local componentIdForNuidUpdater  = addNuidUpdater(self, entityId)
    local componentIdForSpawnX       = addOrUpdateVscForSpawnX(self, entityId, spawnX)
    local componentIdForSpawnY       = addOrUpdateVscForSpawnY(self, entityId, spawnY)

    if not componentIdForOwnerName or not componentIdForOwnerGuid or not componentIdForNuid or not componentIdForNuidDebugger
        or not componentIdForNuidUpdater or not componentIdForSpawnX or not componentIdForSpawnY then
        error(
            ("Something terrible went wrong! A component id for a Network Vsc was nil. OwnerNameCompId = %s, OwnerGuidCompId = %s, NuidCompId = %s, NuidDebuggerCompId = %s, NuidUpdaterCompId = %s")
            :format(componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid,
                componentIdForNuidDebugger, componentIdForNuidUpdater), 2)
    end

    self.customProfiler:stop("NetworkVscUtils.addOrUpdateAllVscs", cpc)
    return componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid, componentIdForNuidDebugger, componentIdForNuidUpdater,
        componentIdForSpawnX, componentIdForSpawnY
end

---Returns all Network Vsc values by its entity id.
---@param entityId number Entity Id provided by Noita
---@return string? ownerName, string? ownerGuid, number? nuid - nuid can be nil
function NetworkVscUtils:getAllVscValuesByEntityId(entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.getAllVscValuesByEntityId")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.getAllVscValuesByEntityId", cpc)
        return
    end
    local ownerNameCompId, ownerGuidCompId, nuidCompId, _, _ = getNetworkComponents(self, entityId)
    self.customProfiler:stop("NetworkVscUtils.getAllVscValuesByEntityId", cpc)
    if ownerNameCompId and ownerGuidCompId then
        return self:getAllVcsValuesByComponentIds(ownerNameCompId, ownerGuidCompId, nuidCompId)
    else
        --error(("getAllVcsValuesByEntityId: Got unexpected nil id. entityId, = %s ownerNameCompId = %s, ownerGuidCompId = %s, nuidCompId = %s")
        --              :format(entityId, ownerNameCompId, ownerGuidCompId, nuidCompId), 2)
    end
end

---Returns all Network Vsc values by its component ids.
---@param ownerNameCompId number Component Id of the OwnerNameVsc
---@param ownerGuidCompId number Component Id of the OwnerGuidVsc
---@param nuidCompId number Component Id of the NuidVsc
---@return string ownerName
---@return string ownerGuid
---@return number nuid
function NetworkVscUtils:getAllVcsValuesByComponentIds(ownerNameCompId, ownerGuidCompId, nuidCompId)
    local cpc           = self.customProfiler:start("NetworkVscUtils.getAllVcsValuesByComponentIds")
    local compOwnerName = ComponentGetValue2(ownerNameCompId, NetworkVscUtils.valueString)
    local compOwnerGuid = ComponentGetValue2(ownerGuidCompId, NetworkVscUtils.valueString)
    local compNuid      = ComponentGetValue2(nuidCompId, "value_int")

    if compNuid == 0 or compNuid == -1 then
        compNuid = nil
    end

    if self.utils:isEmpty(compOwnerName) then
        error(("Something really bad went wrong! compOwnerName must not be empty: %s"):format(compOwnerName), 2)
    end
    if self.utils:isEmpty(compOwnerGuid) then
        error(("Something really bad went wrong! compOwnerGuid must not be empty: %s"):format(compOwnerGuid), 2)
    end

    self.customProfiler:stop("NetworkVscUtils.getAllVcsValuesByComponentIds", cpc)
    return compOwnerName, compOwnerGuid, compNuid
end

---Returns true, componentId and nuid if the entity has a NetworkVsc.
---@param entityId number entityId provided by Noita
---@return boolean isNetworkEntity
---@return number componentId
---@return number|nil nuid
function NetworkVscUtils:isNetworkEntityByNuidVsc(entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.isNetworkEntityByNuidVsc")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.isNetworkEntityByNuidVsc", cpc)
        return false, -1, -1
    end
    local componentId, value = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfNuid, "value_int")
    local nuid = tonumber(value)
    if self.utils:isEmpty(componentId) or self.utils:isEmpty(nuid) then
        self.customProfiler:stop("NetworkVscUtils.isNetworkEntityByNuidVsc", cpc)
        return false, -1, -1
    end
    self.customProfiler:stop("NetworkVscUtils.isNetworkEntityByNuidVsc", cpc)
    if not componentId then
        componentId = -1
    end
    if nuid == 0 or nuid == -1 then
        value = nil
    end
    return true, componentId, nuid
end

---Checks if the nuid Vsc exists, if so returns nuid
---@param entityId number
---@return boolean has retruns 'false, -1': Returns false, if there is no NuidVsc or nuid is empty.
---@return number|nil nuid Returns 'true, nuid', if set.
function NetworkVscUtils:hasNuidSet(entityId)
    local cpc               = self.customProfiler:start("NetworkVscUtils.hasNuidSet")
    local nuidCompId, value = self:checkIfSpecificVscExists(entityId, self.variableStorageComponentName,
        self.name, self.componentNameOfNuid, "value_int")
    local nuid              = tonumber(value)

    if not nuidCompId then
        self.customProfiler:stop("NetworkVscUtils.hasNuidSet", cpc)
        return false, -1
    end
    if self.utils:isEmpty(nuid) or nuid == 0 or nuid == -1 then
        self.customProfiler:stop("NetworkVscUtils.hasNuidSet", cpc)
        return false, nuid
    end
    self.customProfiler:stop("NetworkVscUtils.hasNuidSet", cpc)
    return true, nuid
end

function NetworkVscUtils:hasNetworkLuaComponents(entityId)
    local cpc = self.customProfiler:start("NetworkVscUtils.hasNetworkLuaComponents")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NetworkVscUtils.hasNetworkLuaComponents", cpc)
        return
    end
    local has                  = false
    local nuid_debugger, value = self:checkIfSpecificVscExists(entityId, "LuaComponent",
        "script_source_file", self.componentNameOfNuidDebugger, "script_source_file")
    local nuid_updater, value  = self:checkIfSpecificVscExists(entityId, "LuaComponent",
        "script_source_file", self.componentNameOfNuidUpdater, "script_source_file")

    if nuid_debugger and nuid_updater then
        has = true
    end
    self.customProfiler:stop("NetworkVscUtils.hasNetworkLuaComponents", cpc)
    return has
end

function NetworkVscUtils:new(networkVscUtilsObject, customProfiler, logger, server, globalsUtils, utils)
    ---@class NetworkVscUtils
    networkVscUtilsObject = setmetatable(networkVscUtilsObject or self, NetworkVscUtils)

    if not customProfiler then
        error("NetworkVscUtils:new needs a CustomProfiler parameter!", 2)
    end
    local cpc = customProfiler:start("NetworkVscUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not networkVscUtilsObject.customProfiler then
        ---@see CustomProfiler
        ---@type CustomProfiler
        networkVscUtilsObject.customProfiler = customProfiler or error("NetworkVscUtils:new needs a CustomProfiler parameter!", 2)
    end

    if not networkVscUtilsObject.logger then
        ---@see Logger
        ---@type Logger
        networkVscUtilsObject.logger = logger or
            require("Logger")
            :new(nil, customProfiler)
    end

    if not networkVscUtilsObject.server then
        ---@see Server
        ---@type Server
        networkVscUtilsObject.server = server or error("NetworkVscUtils:new needs a Server parameter!", 2)
    end

    if not networkVscUtilsObject.globalsUtils then
        ---@see GlobalsUtils
        ---@type GlobalsUtils
        networkVscUtilsObject.globalsUtils = globalsUtils or error("NetworkVscUtils:new needs a GlobalsUtils parameter!", 2)
    end

    if not networkVscUtilsObject.utils then
        ---@see Utils
        ---@type Utils
        networkVscUtilsObject.utils = utils or error("NetworkVscUtils:new needs a Utils parameter!", 2)
    end

    --[[ Attributes ]]

    customProfiler:stop("NetworkVscUtils:new", cpc)
    return networkVscUtilsObject
end

return NetworkVscUtils
