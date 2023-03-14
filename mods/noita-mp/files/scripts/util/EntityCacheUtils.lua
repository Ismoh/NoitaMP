---
--- Created by Ismoh
--- DateTime: 06.03.2023 14:03
---

------------------------------------------------------------------------------------------------------------------------
--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
------------------------------------------------------------------------------------------------------------------------
if require then
    if not util then
        util = require("util")
    end
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    if not util then
        util = dofile("mods/noita-mp/files/scripts/util/util.lua")
    end

    if not CustomProfiler then
        CustomProfiler = {}
        ---@diagnostic disable-next-line: duplicate-set-field
        function CustomProfiler.start(functionName)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.start(functionName %s)")
            --                    :format(functionName))
            return -1
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        function CustomProfiler.stop(functionName, customProfilerCounter)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.stop(functionName %s, customProfilerCounter %s)")
            --                    :format(functionName, customProfilerCounter))
            return -1
        end
    end
end

----------------------------------------
--- EntityCache
----------------------------------------
--EntityCache.set      = function(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY, currentHealth, maxHealth)
--
--end

----------------------------------------
--- EntityCacheUtils
----------------------------------------
--- Utils class only for cache of entities.
EntityCacheUtils     = {}

EntityCacheUtils.set = function(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, velX, velY, currentHealth, maxHealth)
    if util.IsEmpty(entityId) then
        error(("entityId must not be nil or empty!"):format(entityId), 2)
    end
    if util.IsEmpty(nuid) then
        error(("nuid must not be nil or empty!"):format(nuid), 2)
    end
    if util.IsEmpty(ownerGuid) then
        error(("ownerGuid must not be nil or empty!"):format(ownerGuid), 2)
    end
    if util.IsEmpty(ownerName) then
        error(("ownerName must not be nil or empty!"):format(ownerName), 2)
    end
    if util.IsEmpty(filepath) then
        error(("filepath must not be nil or empty!"):format(filepath), 2)
    end
    if util.IsEmpty(x) then
        error(("x must not be nil or empty!"):format(x), 2)
    end
    if util.IsEmpty(y) then
        error(("y must not be nil or empty!"):format(y), 2)
    end
    if util.IsEmpty(rotation) then
        error(("rotation must not be nil or empty!"):format(rotation), 2)
    end
    if util.IsEmpty(velX) then
        error(("velX must not be nil or empty!"):format(velX), 2)
    end
    if util.IsEmpty(velY) then
        error(("velY must not be nil or empty!"):format(velY), 2)
    end
    if util.IsEmpty(currentHealth) then
        error(("currentHealth must not be nil or empty!"):format(currentHealth), 2)
    end
    if util.IsEmpty(maxHealth) then
        error(("maxHealth must not be nil or empty!"):format(maxHealth), 2)
    end

    EntityCache.set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation,
                    velX, velY, currentHealth, maxHealth)
end