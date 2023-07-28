local NoitaPatcherUtils = {}

local np = require("noitapatcher")
local base64 = require("base64")

-- see https://dexter.xn--dpping-wxa.eu/NoitaPatcher/Example.html#example

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end
function OnProjectileFiredPost() end

---comment
---@param entityId number
---@return string encoded
function NoitaPatcherUtils.serializeEntity(entityId)
    local binaryString = np.SerializeEntity(entityId)
    local encoded = base64.encode(binaryString)
    return encoded
end

function NoitaPatcherUtils.deserializeEntity(entityId, serializedEntityString, x, y)
    local decoded = base64.decode(serializedEntityString)
    return np.DeserializeEntity(entityId, decoded, x, y)
end

return NoitaPatcherUtils