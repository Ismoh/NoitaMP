-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local CustomProfiler = require("CustomProfiler")
local EntityUtils = require("EntityUtils")

--- NoitaComponentUtils:
local NoitaComponentUtils = {}

---@param entityId number
---@param x number
---@param y number
---@param rotation number
---@param velocity Vec2?
---@param health number
function NoitaComponentUtils.setEntityData(entityId, x, y, rotation, velocity, health)
    local cpc = CustomProfiler.start("NoitaComponentUtils.setEntityData")
    if not EntityUtils.isEntityAlive(entityId) then
        CustomProfiler.stop("NoitaComponentUtils.setEntityData", cpc)
        return
    end

    local hpCompId = EntityGetFirstComponentIncludingDisabled(entityId, "DamageModelComponent")
    if hpCompId then
        ComponentSetValue2(hpCompId, "hp", math.round(tonumber(health.current / 25), 0.01))
        ComponentSetValue2(hpCompId, "max_hp", math.round(tonumber(health.max / 25), 0.01))
    else
        Logger.debug(Logger.channels.entity, ("Unable to get DamageModelComponent, because entity (%s) might not" ..
            "have any DamageModelComponent."):format(entityId))
    end

    EntityApplyTransform(entityId, x, y, rotation, 1, 1)

    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    if velocity and velocityCompId then
        ComponentSetValue2(velocityCompId, "mVelocity", velocity.x or velocity[1], velocity.y or velocity[2])
    else
        Logger.debug(Logger.channels.entity, ("Unable to get VelocityComponent, because entity (%s) might not" ..
            "have any VelocityComponent."):format(entityId))
        --EntityAddComponent2(entityId, "VelocityComponent", {})
    end
    CustomProfiler.stop("NoitaComponentUtils.setEntityData", cpc)
end

--- Fetches data like position, rotation, velocity, health and filename
--- @param entityId number
--- @return string ownername, string ownerguid, number nuid, string filename, Health health, number rotation, Vec2 velocity, number x, number y
function NoitaComponentUtils.getEntityData(entityId)
    local cpc                                    = CustomProfiler.start("NoitaComponentUtils.getEntityData")
    local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(entityId)
    local hpCompId                               = EntityGetFirstComponentIncludingDisabled(entityId,
        "DamageModelComponent")
    ---@class Health
    ---@field current number
    ---@field max number
    local health                                 = { current = 0, max = 0 }
    if hpCompId then
        local hpCurrent = math.round(ComponentGetValue2(hpCompId, "hp") * 25, 0.01)
        local hpMax     = math.round(ComponentGetValue2(hpCompId, "max_hp") * 25, 0.01)
        health          = { current = hpCurrent, max = hpMax }
    end
    local x, y, rotation = EntityGetTransform(entityId)
    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    local velocity       = { x = 0, y = 0 }
    if velocityCompId then
        local velocityX, velocityY = ComponentGetValue2(velocityCompId, "mVelocity")
        velocity                   = { x = math.round(velocityX, 0.1), y = math.round(velocityY, 0.1) }
    end
    local filename = EntityGetFilename(entityId)
    CustomProfiler.stop("NoitaComponentUtils.getEntityData", cpc)
    ---@diagnostic disable-next-line: return-type-mismatch
    return compOwnerName, compOwnerGuid, compNuid, filename, health, math.round(
        rotation, 0.1), velocity, math.round(x, 0.1), math.round(y, 0.1)
end

function NoitaComponentUtils.getEntityDataByNuid(nuid)
    local cpc             = CustomProfiler.start("NoitaComponentUtils.getEntityDataByNuid")
    local nNuid, entityId = GlobalsUtils.getNuidEntityPair(nuid)
    CustomProfiler.stop("NoitaComponentUtils.getEntityDataByNuid", cpc)
    return NoitaComponentUtils.getEntityData(entityId)
end

---Adds a SpriteComponent to indicate network status visually.
---@param entityId number
---@return number|nil compId
function NoitaComponentUtils.addOrGetNetworkSpriteStatusIndicator(entityId)
    local cpc = CustomProfiler.start("NoitaComponentUtils.addNetworkSpriteStatusIndicator")
    if not EntityUtils.isEntityAlive(entityId) then
        CustomProfiler.stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
        return nil
    end
    local compId, compOwnerName = NetworkVscUtils.checkIfSpecificVscExists(
        entityId, "SpriteComponent", "image_file",
        "network_indicator.png", "image_file")
    if compId then
        Logger.debug(Logger.channels.vsc, ("Entity(%s) already has a network indicator."):format(entityId))
        CustomProfiler.stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
        return compId
    else
        compId = EntityAddComponent2(entityId, "SpriteComponent", {
            image_file = "mods/noita-mp/files/data/debug/network_indicator_off.png",
            ui_is_parent = false,
            offset_x = 0,
            offset_y = -3,
            alpha = 1,
            visible = true,
            z_index = 255,
            update_transform = true,
            special_scale_x = 1,
            special_scale_y = 1
        })
        --ComponentAddTag(compId, "enabled_in_hand")
        --ComponentAddTag(compId, "enabled_in_world")
        Logger.debug(Logger.channels.vsc,
            ("%s(%s) added with noita componentId = %s to entityId = %s!")
            :format("SpriteComponent", "network_indicator.png", compId, entityId))
        CustomProfiler.stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
        return compId
    end

    error("Unable to add network indicator!", 2)
    CustomProfiler.stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
    return nil
end

---Sets the SpriteComponent to a specific status by setting image_file.
---@param entityId number
---@param status string off, processed, serialised, sent, acked
function NoitaComponentUtils.setNetworkSpriteIndicatorStatus(entityId, status)
    local componentId = NoitaComponentUtils.addOrGetNetworkSpriteStatusIndicator(entityId)
    if not Utils.IsEmpty(componentId) then
        ComponentSetValue2(componentId, "image_file",
            ("mods/noita-mp/files/data/debug/network_indicator_%s.png"):format(status))
    end
end

---Set initial serialized entity string to determine if the entity already exists on the server.
---@param entityId number
---@param initialSerializedEntityString string
---@return boolean if success
function NoitaComponentUtils.setInitialSerializedEntityString(entityId, initialSerializedEntityString)
    local cpc = CustomProfiler.start("NoitaComponentUtils.setInitialSerializedEntityString")

    entityId = EntityGetRootEntity(entityId)
    if not EntityUtils.isEntityAlive(entityId) then
        CustomProfiler.stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)
        error("Unable to set initial serialized entity string, because entity is not alive!", 2)
    end
    if Utils.IsEmpty(initialSerializedEntityString) then
        CustomProfiler.stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)
        error("Unable to set initial serialized entity string, because it is empty!", 2)
    end
    local compId = EntityAddComponent2(entityId, NetworkVscUtils.variableStorageComponentName,
        {
            name         = "noita-mp.nc_initialSerializedEntityString",
            value_string = initialSerializedEntityString
        })
    CustomProfiler.stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)

    return not Utils.IsEmpty(compId)
end

function NoitaComponentUtils.hasInitialSerializedEntityString(entityId)
    local status, result = pcall(NoitaComponentUtils.getInitialSerializedEntityString, entityId)
    return status
end

---Get initial serialized entity string to determine if the entity already exists on the server.
---@param entityId number
---@return string|nil initialSerializedEntityString
function NoitaComponentUtils.getInitialSerializedEntityString(entityId)
    local cpc = CustomProfiler.start("NoitaComponentUtils.getInitialSerializedEntityString")

    local rootEntityId = EntityGetRootEntity(entityId)
    if not EntityUtils.isEntityAlive(rootEntityId) then
        CustomProfiler.stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
        error(("Unable to get initial serialized entity (%s) string, because entity is not alive!"):format(rootEntityId), 2)
    end

    local componentIds = EntityGetComponentIncludingDisabled(rootEntityId, NetworkVscUtils.variableStorageComponentName) or {}
    local serializedString = nil
    for i = 1, #componentIds do
        local componentId = componentIds[i]
        -- get the components name
        local compName    = tostring(ComponentGetValue2(componentId, "name"))
        if string.find(compName, "noita-mp.nc_initialSerializedEntityString", 1, true) then
            -- if the name of the component match to the one we are searching for, then get the value
            serializedString = ComponentGetValue2(componentId, "value_string")
        end
    end

    if Utils.IsEmpty(serializedString) then
        CustomProfiler.stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
        error(("Unable to get initial serialized entity string, because it is empty! Root %s Child %s"):format(rootEntityId, entityId), 2)
        return nil
    end

    CustomProfiler.stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
    return serializedString
end

return NoitaComponentUtils
