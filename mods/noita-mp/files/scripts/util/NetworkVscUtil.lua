-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.


-----------------
-- NetworkVscUtils:
-----------------
--- class for getting and setting values in VariableStorageComponents of Noita-API
NetworkVscUtils = {}

--#region Global private variables

local idcounter = 0

--#endregion

--#region Global private functions

local function isEmpty(var) -- if you change this also change NetworkVscUtil.lua
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
--- @param componentNameOf string Have a look on NetworkVscUtils.componentNameOf___
--- @return integer compId The specific componentId, which contains the searched value
--- @return string value The components value
local function checkIfSpecificVscExists(entityId, componentNameOf) -- if you change this, also change nuid_updater.lua
   ---@diagnostic disable-next-line: missing-parameter
   local componentIds = EntityGetComponentIncludingDisabled(entityId, NetworkVscUtils.variableStorageComponentName) or {}
   if isEmpty(componentIds) then
      logger:info("Entity(%s) does not have any %s. Returning nil.", entityId, NetworkVscUtils.variableStorageComponentName)
      return nil
   end
   for i = 1, #componentIds do
      -- get the components name
      local compName = tostring(ComponentGetValue2(componentIds[i], NetworkVscUtils.name))
      if compName == componentNameOf then
         -- if the name of the component match to the one we are searching for, then get the value
         local value = tostring(ComponentGetValue2(componentIds[i], NetworkVscUtils.valueString))
         -- return componentId and value
         return componentIds[i], value
      end
   end
   logger:warn("Looks like the %s.%s does not exists on entity(%s). Returning nil!", NetworkVscUtils.variableStorageComponentName, componentNameOf, entityId)
   return nil
end

--- Adds a VariableStorageComponent for the owners name.
---@param entityId number Id of an entity provided by Noita
---@param ownerName string This is the owner of an entity. Owners name.
local function addOrUpdateVscForOwnerName(entityId, ownerName)
   local compId, compOwnerName = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfOwnersName)
   if compId then
      ComponentSetValue2(compId, NetworkVscUtils.valueString, ownerName)
      logger:debug(
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
         name = NetworkVscUtils.componentNameOfOwnersName,
         value_string = ownerName
      })
      logger:debug(
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
   local compId, compOwnerGuid = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfOwnersGuid)
   if compId then
      ComponentSetValue2(compId, NetworkVscUtils.valueString, ownerGuid)
      logger:debug(
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
         name = NetworkVscUtils.componentNameOfOwnersGuid,
         value_string = ownerGuid
      })
      logger:debug(
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
   local compId, compNuid = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfNuid)
   if compNuid then
      error(("It is not possible to re-set a nuid(%s) on a entity(%s), which already has one set(%s)! Returning nil!"):format(nuid, entityId, compNuid), 2)
   end

   -- There already might be a nuid vsc without any nuid set, think of a client shooting projectiles
   if compId and not compNuid then
      ComponentSetValue2(compId, NetworkVscUtils.valueString, nuid)
      logger:debug(
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
         name = NetworkVscUtils.componentNameOfNuid,
         value_string = nuid
      })
      logger:debug(
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

--#endregion

--#region Global public variables

NetworkVscUtils.variableStorageComponentName = "VariableStorageComponent"
NetworkVscUtils.name = "name"
NetworkVscUtils.valueString = "value_string"
NetworkVscUtils.componentNameOfOwnersName = "noita-mp.nc_owner.name"
NetworkVscUtils.componentNameOfOwnersGuid = "noita-mp.nc_owner.guid"
NetworkVscUtils.componentNameOfNuid = "noita-mp.nc_nuid"

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

   if _G.whoAmI() == Server.SERVER and isEmpty(nuid) then
      error("You are not allowed to add a nuid, when beeing server!", 2)
   end

   local componentIdForOwnerName = addOrUpdateVscForOwnerName(entityId, ownerName)
   local componentIdForOwnerGuid = addOrUpdateVscForOwnerGuid(entityId, ownerGuid)
   local componentIdForNuid = addOrUpdateVscForNuid(entityId, nuid)

   if not componentIdForOwnerName or not componentIdForOwnerGuid or not componentIdForNuid then
      error(("Something terrible went wrong! A component id for a Network Vsc was nil. OwnerNameCompId = %s, OwnerGuidCompId = %s, NuidCompId = %s")
         :format(componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid), 2)
   end

   return componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid
end

--- Returns all Network Vsc values by its entity id.
---@param entityId number Entity Id provided by Noita
---@return string ownerName
---@return string ownerGuid
---@return number nuid
function NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
   local ownerNameCompId = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfOwnersName)
   local ownerGuidCompId = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfOwnersGuid)
   local nuidCompId = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfNuid)

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
   local compNuid = ComponentGetValue2(nuidCompId, NetworkVscUtils.valueString)

   return compOwnerName, compOwnerGuid, tonumber(compNuid)
end

--#endregion

return NetworkVscUtils
