---@class EntityCache
local EntityCache = {
    --[[ Attributes ]]

    usingC = false, -- not _G.disableLuaExtensionsDLL
    cache  = {}
}

function EntityCache:set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY, currentHealth,
                         maxHealth, fullySerialised, serialisedRootEntity)
    local cpc = self.customProfiler:start("EntityCache.set")
    if self.usingC then
        return EntityCacheC.set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY, currentHealth,
            maxHealth)
    end
    if not self.cache[entityId] then
        self.cache[entityId] = {
            entityId      = entityId,
            nuid          = nuid,
            ownerGuid     = ownerGuid,
            ownerName     = ownerName,
            filename      = filepath,
            x             = x,
            y             = y,
            rotation      = rotation,
            velX          = velX,
            velY          = velY,
            currentHealth = currentHealth,
            maxHealth     = maxHealth
        }
        if self.utils:isEmpty(fullySerialised) or fullySerialised == true then
            --EntityCache.cache[entityId].fullySerialised = true
            --EntityCache.cache[entityId].serialisedRootEntity = nil -- free a bit memory
        else
            self.cache[entityId].fullySerialised = fullySerialised
            self.cache[entityId].serialisedRootEntity = serialisedRootEntity
        end
    end
    self.customProfiler:stop("EntityCache.set", cpc)
end

function EntityCache:contains(entityId)
    if self.cache[entityId] then
        return true
    end
    return false
end

function EntityCache:get(entityId)
    local cpc = self.customProfiler:start("EntityCache.get")
    if self.usingC then
        return EntityCacheC.get(entityId)
    end
    if not self.cache then
        self.cache = {}
        return nil
    end
    if self.cache[entityId] then
        self.customProfiler:stop("EntityCache.get", cpc)
        return self.cache[entityId]
    end
    self.customProfiler:stop("EntityCache.get", cpc)
    return nil
end

function EntityCache:getNuid(nuid)
    local cpc = self.customProfiler:start("EntityCache.getNuid")
    if self.usingC then
        return EntityCacheC.getNuid(nuid)
    end
    error("EntityCache.getNuid requires the luaExtensions dll to be enabled", 2)
end

function EntityCache:delete(entityId)
    local cpc = self.customProfiler:start("EntityCache.delete")
    if self.usingC then
        return EntityCacheC.delete(entityId)
    end
    self.cache[entityId] = nil
    self.customProfiler:stop("EntityCache.delete", cpc)
end

function EntityCache:deleteNuid(nuid)
    local cpc = self.customProfiler:start("EntityCache:deleteNuid")
    if self.usingC then
        return EntityCacheC.deleteNuid(nuid)
    end
    for entityId, entry in pairs(self.cache) do
        if entry.nuid == nuid then
            self.cache[entry.entityId] = nil
        end
    end
    self.customProfiler:stop("EntityCache:deleteNuid", cpc)
end

function EntityCache:size()
    local cpc = self.customProfiler:start("EntityCache.size")
    if self.usingC then
        self.customProfiler:stop("EntityCache.size", cpc)
        return EntityCacheC.size()
    end
    local size = 0
    for i, entry in pairs(self.cache) do
        if EntityGetIsAlive(entry.entityId) then
            size = size + 1
        else
            self.entityUtils:onEntityRemoved(entry.entityId, entry.nuid)
        end
    end
    self.customProfiler:stop("EntityCache.size", cpc)
    return size
end

function EntityCache:usage()
    if not self.usingC then
        error("EntityCache.usage requires the luaExtensions dll to be enabled", 2)
    end
    return EntityCacheC.usage()
end

---EntityCache constructor
---@param entityCacheObject EntityCache|nil optional
---@param customProfiler CustomProfiler required
---@param entityUtils EntityUtils|nil optional
---@param utils Utils|nil optional
---@return EntityCache
function EntityCache:new(entityCacheObject, customProfiler, entityUtils, utils)
    ---@class EntityCache
    entityCacheObject = setmetatable(entityCacheObject or self, EntityCache)

    local cpc = customProfiler:start("EntityUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not entityCacheObject.customProfiler then
        ---@type CustomProfiler
        entityCacheObject.customProfiler = customProfiler or
            error("EntityCache:new requires 'customProfiler' as parameter!")
    end

    if not entityCacheObject.entityUtils then
        ---@type EntityUtils
        entityCacheObject.entityUtils = entityUtils
    end

    if not entityCacheObject.utils then
        ---@type Utils
        entityCacheObject.utils = utils or
            require("Utils") --:new(nil, customProfiler)
    end

    entityCacheObject.customProfiler:stop("EntityUtils:new", cpc)
    return entityCacheObject
end

return EntityCache
