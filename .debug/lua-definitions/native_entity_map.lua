--- How to use NativeEntityMap: `local NativeEntityMap = require("lua_noitamp_native")`
---@meta 'NativeEntityMap'
---@class NativeEntityMap
local NativeEntityMap = {}

--- Clear all existing mappings
--- No return value.
function NativeEntityMap.removeAllMappings() end

--- Return Nuid associated with @serialized_string entity or nil if no mappings exist.
---@param serialized_string string binaryString
---@return number nuid|nil
function NativeEntityMap.getNuidBySerializedString(serialized_string) end

--- Return EntityId associated with @serialized_string entity or nil if no mappings exist.
---@param serialized_string string binaryString
---@return number entity_id|nil
function NativeEntityMap.getEntityIdBySerializedString(serialized_string) end

--- Set the Nuid of @serialized_string to @nuid
---@param serialized_string string binaryString
---@param nuid number nuid
function NativeEntityMap.setMappingOfNuidToSerialisedString(serialized_string, nuid) end

--- Set the entity id of @serialized_string to @entity_id
---@param serialized_string string binaryString
---@param entity_id number entity_id
function NativeEntityMap.setMappingOfEntityIdToSerialisedString(serialized_string, entity_id) end

--- Remove the entity mapping for @entity_id. If that entity has an
--- existing nuid mapping remove that too. Remove any reference to
--- the serialized_string associated with the entity.
---@param entity_id number entity_id
function NativeEntityMap.removeMappingOfEntityId(entity_id) end

--- Remove the entity mapping for @nuid. If that entity has an
--- existing entity_id mapping remove that too. Remove any reference to
--- the serialized_string associated with the entity.
---@param nuid number nuid
function NativeEntityMap.removeMappingOfNuid(nuid) end

--- Return the number of existing mappings stored in the system.
function NativeEntityMap.getSerializedStringCount() end

--- Return the number of bytes consumed by the stored mappings. (approximation).
function NativeEntityMap.getMemoryUsage() end

--- Remove all mappings and clear all ressources.
function NativeEntityMap.removeAllMappings() end
