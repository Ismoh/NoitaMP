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
    local cpc = self.customProfiler:start("NoitaComponentUtils.setEntityData")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NoitaComponentUtils.setEntityData", cpc)
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
    self.customProfiler:stop("NoitaComponentUtils.setEntityData", cpc)
end

--- Fetches data like position, rotation, velocity, health and filename
--- @param entityId number
--- @return string ownername, string ownerguid, number nuid, string filename, Health health, number rotation, Vec2 velocity, number x, number y
function NoitaComponentUtils:getEntityData(entityId)
    local cpc                                    = self.customProfiler:start("NoitaComponentUtils.getEntityData")
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
    self.customProfiler:stop("NoitaComponentUtils.getEntityData", cpc)
    return compOwnerName, compOwnerGuid, compNuid, filename, health, math.round(
        rotation, 0.1), velocity, math.round(x, 0.1), math.round(y, 0.1)
end

function NoitaComponentUtils:getEntityDataByNuid(nuid)
    local cpc             = self.customProfiler:start("NoitaComponentUtils.getEntityDataByNuid")
    local nNuid, entityId = self.globalsUtils:getNuidEntityPair(nuid)
    self.customProfiler:stop("NoitaComponentUtils.getEntityDataByNuid", cpc)
    return self:getEntityData(entityId)
end

---Adds a SpriteComponent to indicate network status visually.
---@param entityId number
---@return number|nil compId
function NoitaComponentUtils:addOrGetNetworkSpriteStatusIndicator(entityId)
    local cpc = self.customProfiler:start("NoitaComponentUtils.addNetworkSpriteStatusIndicator")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
        return nil
    end
    local compId, compOwnerName = self.networkVscUtils:checkIfSpecificVscExists(
        entityId, "SpriteComponent", "image_file",
        "network_indicator.png", "image_file")
    if compId then
        self.logger:debug(self.logger.channels.vsc, ("Entity(%s) already has a network indicator."):format(entityId))
        self.customProfiler:stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
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
            ("%s(%s) added with noita componentId = %s to entityId = %s!")
            :format("SpriteComponent", "network_indicator.png", compId, entityId))
        self.customProfiler:stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
        return compId
    end

    error("Unable to add network indicator!", 2)
    self.customProfiler:stop("NoitaComponentUtils.addNetworkSpriteStatusIndicator", cpc)
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

--- Set initial serialized entity string to determine if the entity already exists on the server.
---@param entityId number
---@param initSerializedB64Str string
---@return boolean if success
function NoitaComponentUtils:setInitialSerializedEntityString(entityId, initSerializedB64Str)
    local cpc = self.customProfiler:start("NoitaComponentUtils.setInitialSerializedEntityString")

    entityId = EntityGetRootEntity(entityId)
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)
        error("Unable to set initial serialized entity string, because entity is not alive!", 2)
    end
    if self.utils:isEmpty(initSerializedB64Str) then
        self.customProfiler:stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)
        error("Unable to set initial serialized entity string, because it is empty!", 2)
    end
    local compId = EntityAddComponent2(entityId, self.networkVscUtils.variableStorageComponentName,
        {
            name         = "noita-mp.nc_initialSerializedEntityString",
            value_string = initSerializedB64Str
        })
    self.customProfiler:stop("NoitaComponentUtils.setInitialSerializedEntityString", cpc)

    return not self.utils:isEmpty(compId)
end

function NoitaComponentUtils:hasInitialSerializedEntityString(entityId)
    local status, result = pcall(self.getInitialSerializedEntityString, self, entityId)
    return status
end

--- Get initial serialized entity string to determine if the entity already exists on the server.
---@param entityId number
---@return string|nil initSerializedB64Str
function NoitaComponentUtils:getInitialSerializedEntityString(entityId)
    local cpc = self.customProfiler:start("NoitaComponentUtils.getInitialSerializedEntityString")

    local rootEntityId = EntityGetRootEntity(entityId)
    if not EntityGetIsAlive(rootEntityId) then
        self.customProfiler:stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
        error(("Unable to get initial serialized entity (%s) string, because entity is not alive!"):format(rootEntityId), 2)
    end

    local componentIds = EntityGetComponentIncludingDisabled(rootEntityId, self.networkVscUtils.variableStorageComponentName) or {}
    local serializedString = nil
    for i = 1, #componentIds do
        local componentId = componentIds[i]
        -- get the components name
        local compName    = tostring(ComponentGetValue2(componentId, "name"))
        if string.find(compName, "noita-mp.nc_initialSerializedEntityString", 1, true) then
            -- if the name of the component match to the one we are searching for, then get the value
            serializedString = ComponentGetValue2(componentId, "value_string")
            break
        end
    end

    if self.utils:isEmpty(serializedString) then
        self.customProfiler:stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
        error(("Unable to get initial serialized entity string, because it is empty! Root %s Child %s"):format(rootEntityId, entityId), 2)
        return nil
    end

    self.customProfiler:stop("NoitaComponentUtils.getInitialSerializedEntityString", cpc)
    return serializedString
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

    local cpc                 = customProfiler:start("NoitaComponentUtils:new")

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
