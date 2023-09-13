---@class NoitaPatcherUtils
local NoitaPatcherUtils = {
}

local base64 = require("base64")
local CustomProfiler = require("CustomProfiler")
local md5 = require("md5")

-- see https://dexter.xn--dpping-wxa.eu/NoitaPatcher/Example.html#example

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end

function OnProjectileFiredPost() end

---Serialize an entity to a base64 and md5 string.
---@param entityId any
---@return string base64
---@return string md5
function NoitaPatcherUtils:serializeEntity(entityId)
    local cpc = CustomProfiler.start("NoitaPatcherUtils.serializeEntity")
    local encodedBase64 = base64.encode(_G.np.SerializeEntity(entityId))
    --local md5Hash = md5.sumhexa(encodedBase64)
    CustomProfiler.stop("NoitaPatcherUtils.serializeEntity", cpc)
    return encodedBase64 --, md5Hash
end

function NoitaPatcherUtils:deserializeEntity(entityId, serializedEntityString, x, y)
    local cpc = CustomProfiler.start("NoitaPatcherUtils.deserializeEntity")
    local decoded = base64.decode(serializedEntityString)
    local entityId = _G.np.DeserializeEntity(entityId, decoded, x, y)
    CustomProfiler.stop("NoitaPatcherUtils.deserializeEntity", cpc)
    return entityId
end

---NoitaPatcherUtils constructor.
---@param t NoitaPatcherUtils|nil
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(t)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

return NoitaPatcherUtils
