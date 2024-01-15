---Class for using Noita components.
---@class NoitaComponentUtils
local NoitaComponentUtils = {

    --[[ Attributes ]]
}

---@param entityId number
---@param x number
---@param y number
---@param rotation number
---@param velocity Vec2?
---@param health number
function NoitaComponentUtils:setEntityData(entityId, x, y, rotation, velocity, health)
    if not EntityGetIsAlive(entityId) then
        return
    end

    local hpCompId = EntityGetFirstComponentIncludingDisabled(entityId, "DamageModelComponent")
    if hpCompId then
        ComponentSetValue2(hpCompId, "hp", math.round(tonumber(health.current / 25), 0.01))
        ComponentSetValue2(hpCompId, "max_hp", math.round(tonumber(health.max / 25), 0.01))
    else
        self.logger:debug(self.logger.channels.entity, ("Unable to get DamageModelComponent, because entity (%s) might not" ..
            "have any DamageModelComponent."):format(entityId))
    end

    EntityApplyTransform(entityId, x, y, rotation, 1, 1)

    local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
    if velocity and velocityCompId then
        ComponentSetValue2(velocityCompId, "mVelocity", velocity.x or velocity[1], velocity.y or velocity[2])
    else
        self.logger:debug(self.logger.channels.entity, ("Unable to get VelocityComponent, because entity (%s) might not" ..
            "have any VelocityComponent."):format(entityId))
        --EntityAddComponent2(entityId, "VelocityComponent", {})
    end
end

--- Fetches data like position, rotation, velocity, health and filename
--- @param entityId number
--- @return string ownername, string ownerguid, number nuid, string filename, Health health, number rotation, Vec2 velocity, number x, number y
function NoitaComponentUtils:getEntityData(entityId)
    local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils:getAllVscValuesByEntityId(entityId)
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
    return compOwnerName, compOwnerGuid, compNuid, filename, health, math.round(
        rotation, 0.1), velocity, math.round(x, 0.1), math.round(y, 0.1)
end

function NoitaComponentUtils:getEntityDataByNuid(nuid)
    local nNuid, entityId = self.globalsUtils:getNuidEntityPair(nuid)
    return self:getEntityData(entityId)
end

---Adds a SpriteComponent to indicate network status visually.
---@param entityId number
---@return number|nil compId
function NoitaComponentUtils:addOrGetNetworkSpriteStatusIndicator(entityId)
    if not EntityGetIsAlive(entityId) then
        return nil
    end
    local compId, compOwnerName = self.networkVscUtils:checkIfSpecificVscExists(
        entityId, "SpriteComponent", "image_file",
        "network_indicator.png", "image_file")
    if compId then
        self.logger:debug(self.logger.channels.vsc, ("Entity(%s) already has a network indicator."):format(entityId))
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
        self.logger:debug(self.logger.channels.vsc,
            ("%s(%s) added with noita componentId = %s to entityId = %s!"):format("SpriteComponent", "network_indicator.png", compId, entityId))
        return compId
    end

    error("Unable to add network indicator!", 2)
    return nil
end

---Sets the SpriteComponent to a specific status by setting image_file.
---@param entityId number
---@param status string off, processed, serialised, sent, acked
function NoitaComponentUtils:setNetworkSpriteIndicatorStatus(entityId, status)
    local componentId = self:addOrGetNetworkSpriteStatusIndicator(entityId)
    if not self.utils:isEmpty(componentId) then
        ComponentSetValue2(componentId, "image_file",
            ("mods/noita-mp/files/data/debug/network_indicator_%s.png"):format(status))
    end
end

---NoitaComponentUtils constructor.
---@param noitaComponentUtilsObject NoitaComponentUtils|nil optional
---@param customProfiler CustomProfiler required
---@param globalsUtils GlobalsUtils required
---@param logger Logger|nil optional
---@param networkVscUtils NetworkVscUtils|nil optional
---@param utils Utils|nil optional
---@param noitaPatcherUtils NoitaPatcherUtils required
---@return NoitaComponentUtils
function NoitaComponentUtils:new(noitaComponentUtilsObject, customProfiler, globalsUtils, logger, networkVscUtils, utils, noitaPatcherUtils)
    ---@class NoitaComponentUtils
    noitaComponentUtilsObject = setmetatable(noitaComponentUtilsObject or self, NoitaComponentUtils)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not noitaComponentUtilsObject.customProfiler then
        ---@type CustomProfiler
        noitaComponentUtilsObject.customProfiler = customProfiler or error("NoitaComponentUtils:new requires a CustomProfiler object", 2)
    end

    if not noitaComponentUtilsObject.globalsUtils then
        ---@type GlobalsUtils
        noitaComponentUtilsObject.globalsUtils = globalsUtils or error("NoitaComponentUtils:new requires a GlobalsUtils object", 2)
    end

    if not noitaComponentUtilsObject.logger then
        ---@type Logger
        noitaComponentUtilsObject.logger = logger or
            require("Logger"):new(nil, customProfiler)
    end

    if not noitaComponentUtilsObject.networkVscUtils then
        ---@type NetworkVscUtils
        noitaComponentUtilsObject.networkVscUtils = networkVscUtils or
            require("NetworkVscUtils") --:new()
    end

    if not noitaComponentUtilsObject.utils then
        ---@type Utils
        noitaComponentUtilsObject.utils = utils or
            require("Utils") --:new()
    end

    if not noitaComponentUtilsObject.noitaPatcherUtils then
        ---@type NoitaPatcherUtils
        noitaComponentUtilsObject.noitaPatcherUtils = noitaPatcherUtils or
            error("NoitaComponentUtils:new requires a NoitaPatcherUtils object", 2)
    end

    return noitaComponentUtilsObject
end

return NoitaComponentUtils
