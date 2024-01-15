---@class NoitaPatcherUtils
local NoitaPatcherUtils = {

    --[[ Attributes ]]
}

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end

function OnProjectileFiredPost() end

--- Serialize an entity to a binary string.
---@param entityId number
---@return string binaryString serialized entity in binary format
function NoitaPatcherUtils:serializeEntity(entityId)
    local binaryString = self.np.SerializeEntity(entityId)
    if not self.nativeEntityMap.getEntityIdBySerializedString(binaryString) then
        self.nativeEntityMap.setMappingOfEntityIdToSerialisedString(binaryString, entityId)
    end
    return binaryString
end

--- Deserialize an entity from a serialized binary string and create or update it at the given position.
---@param entityId number mostly an empty entity, but required
---@param binaryString string serialized entity in binary format
---@param x number|nil x position to create entity at, but optional.
---@param y number|nil y position to create entity at, but optional.
---@return number entityId of the created entity
function NoitaPatcherUtils:deserializeEntity(entityId, binaryString, x, y)
    if self.nativeEntityMap.getEntityIdBySerializedString(binaryString) then
        entityId = self.nativeEntityMap.getEntityIdBySerializedString(binaryString)
        self.logger:warn(("Entity(%s) already exists, returning existing entity(%s)"):format(entityId, entityId))
        --return entityId TODO: double check if we can 'update' the entity by deserialising the new binaryString into the same entity again
    end

    entityId = self.np.DeserializeEntity(entityId, binaryString, x, y)
    if not entityId or self.utils:isEmpty(entityId) then
        error(("Failed to deserialize entity(%s) from binary string: %s"):format(entityId, binaryString), 2)
    end
    return entityId
end

---NoitaPatcherUtils constructor.
---@param customProfiler CustomProfiler required
---@param np noitapatcher required
---@param logger Logger required
---@param nativeEntityMap NativeEntityMap|nil optional
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(customProfiler, np, logger, nativeEntityMap)
    ---@class NoitaPatcherUtils
    local noitaPatcherUtilsObject = setmetatable(self, NoitaPatcherUtils)

    if not customProfiler then
        error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    if require and not np then
        error("NoitaPatcherUtils:new requires a noitapatcher object, when require is available!", 2)
    end

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not noitaPatcherUtilsObject.customProfiler then
        ---@type CustomProfiler
        noitaPatcherUtilsObject.customProfiler = customProfiler or error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    if not noitaPatcherUtilsObject.np then
        ---@type noitapatcher
        noitaPatcherUtilsObject.np = np or error("NoitaPatcherUtils:new requires a NoitaPatcher object", 2)
    end

    if not noitaPatcherUtilsObject.utils then
        ---@type Utils
        noitaPatcherUtilsObject.utils = require("Utils"):new()
    end

    if not noitaPatcherUtilsObject.logger then
        ---@type Logger
        noitaPatcherUtilsObject.logger = logger or error("NoitaPatcherUtils:new requires a Logger object", 2)
    end

    if not noitaPatcherUtilsObject.nativeEntityMap then
        ---@type NativeEntityMap
        noitaPatcherUtilsObject.nativeEntityMap = nativeEntityMap or require("lua_noitamp_native")
    end

    return noitaPatcherUtilsObject
end

return NoitaPatcherUtils
