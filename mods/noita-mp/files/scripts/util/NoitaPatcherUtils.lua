---@class NoitaPatcherUtils
local NoitaPatcherUtils = {
    --[[ Imports ]]

    base64 = nil,
    ---@type CustomProfiler
    customProfiler = nil,
    ---@type noitapatcher
    ---docs: https://dexter.xn--dpping-wxa.eu/NoitaPatcher/Example.html#example
    np = nil,

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
    local encodedBase64 = self.base64.encode(self.np.SerializeEntity(entityId))
    self.customProfiler:stop("NoitaPatcherUtils.serializeEntity", cpc)
    return encodedBase64
end

---Deserialize an entity from a base64 string and create it at the given position.
---@param entityId number
---@param serializedEntityString base64 encoded string
---@param x number
---@param y number
---@return number
function NoitaPatcherUtils:deserializeEntity(entityId, serializedEntityString, x, y)
    local cpc = self.customProfiler:start("NoitaPatcherUtils.deserializeEntity")
    local decoded = self.base64.decode(serializedEntityString)
    local entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    self.customProfiler:stop("NoitaPatcherUtils.deserializeEntity", cpc)
    return entityId
end

---NoitaPatcherUtils constructor.
---@param noitaPatcherUtils NoitaPatcherUtils|nil
---@param base64 base64|nil
---@param customProfiler CustomProfiler required
---@param noitaPatcher noitapatcher required
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(noitaPatcherUtils, base64, customProfiler, noitaPatcher)
    local noitaPatcherUtils = noitaPatcherUtils or self or {} -- Use self if this is called as a class constructor
    setmetatable(noitaPatcherUtils, self)
    self.__index = self

    local cpc = self.customProfiler:start("EntityUtils:new")

    -- Initialize all imports to avoid recursive imports
    self.base64 = base64 or require("base64")
    self.customProfiler = customProfiler or error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    self.np = noitaPatcher or error("NoitaPatcherUtils:new requires a NoitaPatcher object", 2)

    self.customProfiler:stop("EntityUtils:new", cpc)

    return noitaPatcherUtils
end

return NoitaPatcherUtils
