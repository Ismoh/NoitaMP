---@class NoitaPatcherUtils
local NoitaPatcherUtils = {

    --[[ Attributes ]]
}

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end

function OnProjectileFiredPost() end

---Serialize an entity to a base64 and md5 string.
---@param entityId number
---@return string encodedBase64
function NoitaPatcherUtils:serializeEntity(entityId)
    local cpc = self.customProfiler:start("NoitaPatcherUtils.serializeEntity")
    local binaryString = self.np.SerializeEntity(entityId)
    --local encodedBase64 = self.base64.encode(binaryString, nil, false)
    if not self.base64_fast then
        self.base64_fast = require("base64_fast")
    end
    local encodedBase64 = self.base64_fast.encode(binaryString)
    self.customProfiler:stop("NoitaPatcherUtils.serializeEntity", cpc)
    return encodedBase64
    --return binaryString
end

---Deserialize an entity from a base64 string and create it at the given position.
---@param entityId number
---@param serializedEntityString base64 encoded string
---@param x number
---@param y number
---@return number
function NoitaPatcherUtils:deserializeEntity(entityId, serializedEntityString, x, y)
    local cpc = self.customProfiler:start("NoitaPatcherUtils.deserializeEntity")
    --local decoded = self.base64.decode(serializedEntityString, nil, false)
    --local entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    if not self.base64_fast then
        self.base64_fast = require("base64_fast")
    end
    local decoded = self.base64_fast.decode(serializedEntityString)
    local entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    self.customProfiler:stop("NoitaPatcherUtils.deserializeEntity", cpc)
    return entityId
end

---NoitaPatcherUtils constructor.
---@param noitaPatcherUtilsObject NoitaPatcherUtils|nil
---@param base64 base64|nil
---@param customProfiler CustomProfiler required
---@param np noitapatcher required
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(noitaPatcherUtilsObject, base64, customProfiler, np)
    ---@class NoitaPatcherUtils
    noitaPatcherUtilsObject = setmetatable(noitaPatcherUtilsObject or self, NoitaPatcherUtils)

    if not customProfiler then
        error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    local cpc = customProfiler:start("NoitaPatcherUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not noitaPatcherUtilsObject.base64 then
        ---@type base64
        noitaPatcherUtilsObject.base64 = base64 or require("base64")
    end

    if not noitaPatcherUtilsObject.customProfiler then
        ---@type CustomProfiler
        noitaPatcherUtilsObject.customProfiler = customProfiler or error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    if not noitaPatcherUtilsObject.np then
        ---@type noitapatcher
        noitaPatcherUtilsObject.np = np or error("NoitaPatcherUtils:new requires a NoitaPatcher object", 2)
    end

    customProfiler:stop("EntityUtils:new", cpc)

    return noitaPatcherUtilsObject
end

return NoitaPatcherUtils
