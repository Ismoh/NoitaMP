--- EntityCache.
local EntityCache = {}

--- Created by Ismoh
--- DateTime: 06.03.2023 14:03
---


--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:

if require then
    if not Utils then
        Utils = require("Utils")
    end
else
    -- -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    -- if not Utils then
    --     Utils = dofile("mods/noita-mp/files/scripts/util/Utils.lua")
    -- end

    -- if not CustomProfiler then
    --     ---@type CustomProfiler
    --     CustomProfiler = {}

    --     ---@diagnostic disable-next-line: duplicate-doc-alias
    --     ---@alias CustomProfiler.start function(functionName: string): number
    --     ---@diagnostic disable-next-line: duplicate-set-field
    --     function CustomProfiler.start(functionName)
    --         --Logger.trace(Logger.channels.entity,
    --         --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.start(functionName %s)")
    --         --                    :format(functionName))
    --         return -1
    --     end

    --     ---@diagnostic disable-next-line: duplicate-set-field
    --     function CustomProfiler.stop(functionName, customProfilerCounter)
    --         --Logger.trace(Logger.channels.entity,
    --         --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.stop(functionName %s, customProfilerCounter %s)")
    --         --                    :format(functionName, customProfilerCounter))
    --         return -1
    --     end
    -- end
end

EntityCache.usingC     = false -- not _G.disableLuaExtensionsDLL
EntityCache.cache      = {}
EntityCache.set        = function(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY,
                                  currentHealth, maxHealth, fullySerialised, serialisedRootEntity)
    local cpc = CustomProfiler.start("EntityCache.set")
    if EntityCache.usingC then
        return EntityCacheC.set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY, currentHealth,
            maxHealth)
    end
    if not EntityCache.cache[entityId] then
        EntityCache.cache[entityId] = {
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
        if Utils.IsEmpty(fullySerialised) or fullySerialised == true then
            --EntityCache.cache[entityId].fullySerialised = true
            --EntityCache.cache[entityId].serialisedRootEntity = nil -- free a bit memory
        else
            EntityCache.cache[entityId].fullySerialised = fullySerialised
            EntityCache.cache[entityId].serialisedRootEntity = serialisedRootEntity
        end
    end
    CustomProfiler.stop("EntityCache.set", cpc)
end

EntityCache.contains   = function(entityId)
    if EntityCache.cache[entityId] then
        return true
    end
    return false
end

EntityCache.get        = function(entityId)
    local cpc = CustomProfiler.start("EntityCache.get")
    if EntityCache.usingC then
        return EntityCacheC.get(entityId)
    end
    if not EntityCache.cache then
        EntityCache.cache = {}
        return nil
    end
    if EntityCache.cache[entityId] then
        CustomProfiler.stop("EntityCache.get", cpc)
        return EntityCache.cache[entityId]
    end
    CustomProfiler.stop("EntityCache.get", cpc)
    return nil
end

EntityCache.getNuid    = function(nuid)
    local cpc = CustomProfiler.start("EntityCache.getNuid")
    if EntityCache.usingC then
        return EntityCacheC.getNuid(nuid)
    end
    error("EntityCache.getNuid requires the luaExtensions dll to be enabled", 2)
end

EntityCache.delete     = function(entityId)
    local cpc = CustomProfiler.start("EntityCache.delete")
    if EntityCache.usingC then
        return EntityCacheC.delete(entityId)
    end
    EntityCache.cache[entityId] = nil
    CustomProfiler.stop("EntityCache.delete", cpc)
end

EntityCache.deleteNuid = function(nuid)
    local cpc = CustomProfiler.start("EntityCache.deleteNuid")
    if EntityCache.usingC then
        return EntityCacheC.deleteNuid(nuid)
    end
    for entry in pairs(EntityCache) do
        if entry.nuid == nuid then
            EntityCache.cache[entry.entityId] = nil
        end
    end
    CustomProfiler.stop("EntityCache.deleteNuid", cpc)
end

EntityCache.size       = function()
    local cpc = CustomProfiler.start("EntityCache.size")
    if EntityCache.usingC then
        CustomProfiler.stop("EntityCache.size", cpc)
        return EntityCacheC.size()
    end
    local size = 0
    for i, entry in pairs(EntityCache.cache) do
        if EntityGetIsAlive(entry.entityId) then
            size = size + 1
        else
            OnEntityRemoved(entry.entityId, entry.nuid)
        end
    end
    CustomProfiler.stop("EntityCache.size", cpc)
    return size
end

EntityCache.usage      = function()
    if not EntityCache.usingC then
        error("EntityCache.usage requires the luaExtensions dll to be enabled", 2)
    end
    return EntityCacheC.usage()
end

return EntityCache
