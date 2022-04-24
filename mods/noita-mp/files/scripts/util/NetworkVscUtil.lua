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

--- Checks if an entity already has a specific VariableStorageComponent.
--- @param entityId number Id of an entity provided by Noita
--- @param componentNameOf string Have a look on NetworkVscUtils.componentNameOf___
--- @return integer compId The specific componentId, which contains the searched value
--- @return string value The components value
local function checkIfSpecificVscExists(entityId, componentNameOf)
   local componentIds = EntityGetComponentIncludingDisabled(entityId, NetworkVscUtils.variableStorageComponentName) or {}
   for compId = 1, #componentIds do
      -- get the components name
      local compName = tostring(ComponentGetValue2(compId, NetworkVscUtils.name))
      if compName == componentNameOf then
         -- if the name of the component match to the one we are searching for, then get the value
         local value = tostring(ComponentGetValue2(compId, NetworkVscUtils.valueString))
         -- return componentId and value
         return compId, value
      end
   end
   logger.warning("Unable to get value (with name %s) of %s. Returning nil!", componentNameOf)
   return nil
end

local function addVscForOwnerName(entityId, ownerName)


end

local function addVscForOwnerGuid(entityId, ownerGuid)

end

local function addVscForNuid(entityId, nuid)
   local compId, compNuid = checkIfSpecificVscExists(entityId, NetworkVscUtils.componentNameOfNuid)
   if compNuid then
      error(("It is not possible to re-set a nuid(%s) on a entity(%s), which already has one set(%s)! Returning nil!"):format(nuid, entityId, compNuid), 2)
   end

   -- There already might be a nuid vsc without any nuid set, think of a client shooting projectiles
   if compId and not compNuid then
      ComponentSetValue2(compId, NetworkVscUtils.valueString, nuid)
      logger.debug(
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
      logger.debug(
         "VariableStorageComponent (%s = %s) added with noita componentId = %s to entityId = %s!",
         NetworkVscUtils.componentNameOfNuid,
         nuid,
         compId,
         entityId
      )
      return compId
   end

   logger.error("Unable to add nuidVsc! Returning nil!")
   return nil
end

--#endregion

--#region Global public variables

NetworkVscUtils.variableStorageComponentName = "VariableStorageComponent"
NetworkVscUtils.name = "name"
NetworkVscUtils.valueString = "value_string"
NetworkVscUtils.componentNameOfOwnersUsername = "noita-mp.nc_owner.username"
NetworkVscUtils.componentNameOfOwnersGuid = "noita-mp.nc_owner.guid"
NetworkVscUtils.componentNameOfNuid = "noita-mp.nc_nuid"

--#endregion

--#region Global public functions

function NetworkVscUtils.addAllVscs(entityId, ownerName, ownerGuid, nuid)
   local componentIdForOwnerName = addVscForOwnerName(entityId, ownerName)
   local componentIdForOwnerGuid = addVscForOwnerGuid(entityId, ownerGuid)
   local componentIdForNuid = addVscForNuid(entityId, nuid)

   return componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid
end

--#endregion

return NetworkVscUtils
