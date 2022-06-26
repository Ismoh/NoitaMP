-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

-----------------
--- NoitaComponentUtils:
-----------------
NoitaComponentUtils = {}

--#region Global private variables

--#endregion

--#region Global private functions

--#endregion

--#region Global public variables

function NoitaComponentUtils.setEntityData(entityId, x, y, rotation, velocity, health)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    local hpCompId = EntityGetFirstComponentIncludingDisabled(entityId, "DamageModelComponent")
    if hpCompId then
        ComponentSetValue2(hpCompId, "hp", math.round(tonumber(health.current), 0.01))
        ComponentSetValue2(hpCompId, "max_hp", math.round(tonumber(health.max), 0.01))
    else
        logger:debug(logger.channels.entity, ("Unable to get DamageModelComponent, because entity (%s) might not" ..
                "have any DamageModelComponent."):format(entityId))
    end

    EntityApplyTransform(entityId, x, y, rotation, 1, 1)

    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    if velocityCompId then
        ComponentSetValue2(velocityCompId, "mVelocity", velocity.x or velocity[1], velocity.y or velocity[2])
    else
        logger:debug(logger.channels.entity, ("Unable to get VelocityComponent, because entity (%s) might not" ..
                "have any VelocityComponent."):format(entityId))
        --EntityAddComponent2(entityId, "VelocityComponent", {})
    end
end

--- Fetches data like position, rotation, velocity, health and filename
--- @param entityId number
--- @return string filename
--- @return table health { current, max }
--- @return number rotation
--- @return table velocity { x, y }
--- @return number x
--- @return number y
function NoitaComponentUtils.getEntityData(entityId)
    local compOwnerName,
    compOwnerGuid, compNuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
    local hpCompId          = EntityGetFirstComponentIncludingDisabled(entityId, "DamageModelComponent")
    local hpCurrent         = math.round(tonumber(ComponentGetValue2(hpCompId, "hp") or 0) * 25, 0.01)
    local hpMax             = math.round(tonumber(ComponentGetValue2(hpCompId, "max_hp") or 0) * 25, 0.01)
    local health            = { current = hpCurrent, max = hpMax }
    local x, y, rotation    = EntityGetTransform(entityId)
    local velocityCompId    = EntityGetFirstComponent(entityId, "VelocityComponent")
    local velocity          = { 0, 0 }
    if velocityCompId then
        local velocityX, velocityY = ComponentGetValue2(velocityCompId, "mVelocity")
        velocity                   = { math.round(velocityX, 0.1), math.round(velocityY, 0.1) }
    end
    local filename = EntityGetFilename(entityId)

    return compOwnerName, compOwnerGuid, compNuid, filename, health, math.round(rotation, 0.1), velocity,
    math.round(x, 0.1), math.round(y, 0.1)
end

function NoitaComponentUtils.getEntityDataByNuid(nuid)
    local nNuid, entityId = GlobalsUtils.getNuidEntityPair(nuid)
    return NoitaComponentUtils.getEntityData(entityId)
end

--#endregion

--#region Global public functions

--#endregion


-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NoitaComponentUtils = NoitaComponentUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NoitaComponentUtils
