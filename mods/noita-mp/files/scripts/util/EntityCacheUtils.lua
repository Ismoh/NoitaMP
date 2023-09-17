---@class EntityCacheUtils
---Utils class only for cache of entities.
local EntityCacheUtils = {
    -- Imports
    utils = require("Utils"),
    entityCache = require("EntityCache"):new(),
    -- Attributes

}

function EntityCacheUtils:set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY,
                              currentHealth, maxHealth, fullySerialised, serialisedRootEntity)
    if self.utils.IsEmpty(entityId) then
        error(("entityId must not be nil or empty!"):format(entityId), 2)
    end
    if self.utils.IsEmpty(nuid) then
        error(("nuid must not be nil or empty!"):format(nuid), 2)
    end
    if self.utils.IsEmpty(ownerGuid) then
        error(("ownerGuid must not be nil or empty!"):format(ownerGuid), 2)
    end
    if self.utils.IsEmpty(ownerName) then
        error(("ownerName must not be nil or empty!"):format(ownerName), 2)
    end
    if self.utils.IsEmpty(filepath) then
        error(("filepath must not be nil or empty!"):format(filepath), 2)
    end
    if self.utils.IsEmpty(x) then
        error(("x must not be nil or empty!"):format(x), 2)
    end
    if self.utils.IsEmpty(y) then
        error(("y must not be nil or empty!"):format(y), 2)
    end
    if self.utils.IsEmpty(rotation) then
        error(("rotation must not be nil or empty!"):format(rotation), 2)
    end
    if self.utils.IsEmpty(velX) then
        error(("velX must not be nil or empty!"):format(velX), 2)
    end
    if self.utils.IsEmpty(velY) then
        error(("velY must not be nil or empty!"):format(velY), 2)
    end
    if self.utils.IsEmpty(currentHealth) then
        error(("currentHealth must not be nil or empty!"):format(currentHealth), 2)
    end
    if self.utils.IsEmpty(maxHealth) then
        error(("maxHealth must not be nil or empty!"):format(maxHealth), 2)
    end

    self.entityCache:set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation,
        velX, velY, currentHealth, maxHealth, fullySerialised, serialisedRootEntity)
end

function EntityCacheUtils:new(entityCacheUtilsObject, otherClassesIfRequireLoop)
    local entityCacheUtilsObject = entityCacheUtilsObject or {}
    setmetatable(entityCacheUtilsObject, self)
    self.__index = self
    return entityCacheUtilsObject
end

return EntityCacheUtils
