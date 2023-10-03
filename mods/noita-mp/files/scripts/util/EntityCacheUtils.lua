---@class EntityCacheUtils
---Utils class only for cache of entities.
local EntityCacheUtils = {

    --[[ Attributes ]]

}

function EntityCacheUtils:set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY,
                              currentHealth, maxHealth, fullySerialised, serialisedRootEntity)
    if self.utils:isEmpty(entityId) then
        error(("entityId must not be nil or empty!"):format(entityId), 2)
    end
    if self.utils:isEmpty(nuid) then
        error(("nuid must not be nil or empty!"):format(nuid), 2)
    end
    if self.utils:isEmpty(ownerGuid) then
        error(("ownerGuid must not be nil or empty!"):format(ownerGuid), 2)
    end
    if self.utils:isEmpty(ownerName) then
        error(("ownerName must not be nil or empty!"):format(ownerName), 2)
    end
    if self.utils:isEmpty(filepath) then
        error(("filepath must not be nil or empty!"):format(filepath), 2)
    end
    if self.utils:isEmpty(x) then
        error(("x must not be nil or empty!"):format(x), 2)
    end
    if self.utils:isEmpty(y) then
        error(("y must not be nil or empty!"):format(y), 2)
    end
    if self.utils:isEmpty(rotation) then
        error(("rotation must not be nil or empty!"):format(rotation), 2)
    end
    if self.utils:isEmpty(velX) then
        error(("velX must not be nil or empty!"):format(velX), 2)
    end
    if self.utils:isEmpty(velY) then
        error(("velY must not be nil or empty!"):format(velY), 2)
    end
    if self.utils:isEmpty(currentHealth) then
        error(("currentHealth must not be nil or empty!"):format(currentHealth), 2)
    end
    if self.utils:isEmpty(maxHealth) then
        error(("maxHealth must not be nil or empty!"):format(maxHealth), 2)
    end

    self.entityCache:set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation,
        velX, velY, currentHealth, maxHealth, fullySerialised, serialisedRootEntity)
end

---Constructor of the EntityCacheUtils class.
---@param entityCacheUtilsObject EntityCacheUtils|nil optional
---@param customProfiler CustomProfiler required
---@param entityCache EntityCache required
---@param utils Utils|nil optional
---@return EntityCacheUtils
function EntityCacheUtils:new(entityCacheUtilsObject, customProfiler, entityCache, utils)
    ---@class EntityCacheUtils
    entityCacheUtilsObject = setmetatable(entityCacheUtilsObject or self, EntityCacheUtils)

    local cpc = customProfiler:start("EntityCacheUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not entityCacheUtilsObject.customProfiler then
        ---@type CustomProfiler
        entityCacheUtilsObject.customProfiler = customProfiler
            or error("EntityCacheUtils:new requires 'customProfiler' as parameter!")
    end

    if not entityCacheUtilsObject.entityCache then
        ---@type EntityCache
        entityCacheUtilsObject.entityCache = entityCache or
            error("EntityCacheUtils:new requires 'entityCache' as parameter!")
    end
    if not entityCacheUtilsObject.utils then
        ---@type Utils
        entityCacheUtilsObject.utils = utils or
            require("Utils")
        --:new(nil, customProfiler)
    end

    entityCacheUtilsObject.customProfiler:stop("EntityCacheUtils:new", cpc)
    return entityCacheUtilsObject
end

return EntityCacheUtils
