local NoitaPatcherUtils = {}

local np = require("noitapatcher")

-- see https://dexter.xn--dpping-wxa.eu/NoitaPatcher/Example.html#example

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end
function OnProjectileFiredPost() end

function NoitaPatcherUtils.serializeEntity(entityId)
    return np.SerializeEntity(entityId)
end

return NoitaPatcherUtils