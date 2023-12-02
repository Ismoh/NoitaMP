---@class NoitaPatcherUtils
local NoitaPatcherUtils = {

    --[[ Attributes ]]
}

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end

function OnProjectileFiredPost() end

--- Serialize an entity to a base64 and md5 string.
---@param entityId number
---@return string base64String base64 encoded string
function NoitaPatcherUtils:serializeEntity(entityId)
    local binaryString = self.np.SerializeEntity(entityId)
    local base64String = self.base64.encode(binaryString)
    return base64String
end

--- Deserialize an entity from a serialized base64 string and create it at the given position.
---@param entityId number mostly an empty entity, but required
---@param base64String string serialized entity in base64 format
---@param x number|nil x position to create entity at, but optional.
---@param y number|nil y position to create entity at, but optional.
---@return number entityId of the created entity
function NoitaPatcherUtils:deserializeEntity(entityId, base64String, x, y)
    local decoded = self.base64.decode(base64String)
    entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    if not entityId or self.utils:isEmpty(entityId) then
        error(("Failed to deserialize entity(%s) from base64 string: %s"):format(entityId, base64String), 2)
    end
    return entityId
end

---NoitaPatcherUtils constructor.
---@param customProfiler CustomProfiler required
---@param np noitapatcher required
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(customProfiler, np)
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
        noitaPatcherUtilsObject.utils = require("Utils"):new(nil)
    end

    if not self.base64 then
        self.base64 = require("base64_ffi")
    end

    return noitaPatcherUtilsObject
end

return NoitaPatcherUtils
