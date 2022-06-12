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

function NoitaComponentUtils.setEntityData(entityId, x, y, rotation, velocity)
    EntityApplyTransform(entityId, x, y, rotation, 1, 1)

    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    if velocityCompId then
        ComponentSetValue2(velocityCompId, "mVelocity", velocity.x or velocity[1], velocity.y or velocity[2])
    else
        logger:warn(logger.channels.entity, "Unable to get VelocityComponent.")
        --EntityAddComponent2(entityId, "VelocityComponent", {})
    end
end

--- Fetches data like position, rotation, velocity and filename
--- @param entityId number
--- @return number x
--- @return number y
--- @return number rotation
--- @return table velocity { x, y }
--- @return string filename
function NoitaComponentUtils.getEntityData(entityId)
    -- owner?
    local x, y, rotation = EntityGetTransform(entityId)
    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    local velocity       = { 0, 0 }
    if velocityCompId then
        local velocityX, velocityY = ComponentGetValue2(velocityCompId, "mVelocity")
        velocity                   = { velocityX, velocityY }
    end
    local filename = EntityGetFilename(entityId)
    return x, y, rotation, velocity, filename
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
