local NoitaPatcherUtils = {}

local np = require("noitapatcher")
local base64 = require("base64")
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
function NoitaPatcherUtils.serializeEntity(entityId)
    local cpc = CustomProfiler.start("NoitaPatcherUtils.serializeEntity")
    local binaryString = np.SerializeEntity(entityId)
    local encoded = base64.encode(binaryString)
    local hash = md5.sumhexa(encoded)
    CustomProfiler.stop("NoitaPatcherUtils.serializeEntity", cpc)
    return encoded, hash
end

function NoitaPatcherUtils.deserializeEntity(entityId, serializedEntityString, x, y)
    local cpc = CustomProfiler.start("NoitaPatcherUtils.deserializeEntity")
    local decoded = base64.decode(serializedEntityString)
    local entityId = np.DeserializeEntity(entityId, decoded, x, y)
    CustomProfiler.stop("NoitaPatcherUtils.deserializeEntity", cpc)
    return entityId
end

return NoitaPatcherUtils
