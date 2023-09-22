--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
local requireG = require
local require = function(modname, path)
    if requireG then
        return requireG(modname)
    else
        if not path then
            error("customRequire: path must not be nil or empty!", 2)
        end
        return dofile(("%s/%s.lua"):format(path, modname))
    end
end

---@class EntityUtils
---'Class' for manipulating entities in Noita.
---In addition have a look at the following file: ./config.lua
---@see EntityUtils.new
local EntityUtils = {
    --[[ 'Imports' ]]

    ---@type Client
    client = nil,
    ---@type CustomProfiler
    customProfiler = nil,
    ---@type EntityCacheUtils
    enitityCacheUtils = nil,
    ---@type EntityCache
    entityCache = nil,
    ---@type Logger
    logger = nil,
    ---@type MinaUtils
    minaUtils = nil,
    ---@type NetworkVscUtils
    networkVscUtils = nil,
    ---@type NoitaComponentUtils
    noitaComponentUtils = nil,
    ---@type NuidUtils
    nuidUtils = nil,
    ---@type Server
    server = nil,
    ---@type Utils
    utils = nil,
    ---@type NetworkUtils
    networkUtils = nil,
    ---@type GlobalsUtils
    globalsUtils = nil,

    --[[ 'Attributes' ]]

    --- Contains all entities, which are alive
    aliveEntityIds = {},
    --- Contains the highest alive entity id
    previousHighestAliveEntityId = 0,
    --- Time(Frames) between coroutines.
    --- @see coroutines.lua#wake_up_waiting_threads
    --- coroutines.lua: "this function should be called once per game logic update with the amount of time
    --- that has passed since it was last called"
    timeFramesDelta = 1,
}

--- Checks if the entity filename is in the include or exclude list of filenames.
---@private
--- @param filename string current entity filename
--- @param filenames table list of filenames
--- @return boolean true if filename is in filenames list otherwise false
local findByFilename = function(filename, filenames) --[[ private ]]
    local cpc = CustomProfiler.start("EntityUtils.findByFilename")
    for i = 1, #filenames do
        if filename:find(filenames[i]) then
            CustomProfiler.stop("EntityUtils.findByFilename", cpc)
            return true
        end
    end
    CustomProfiler.stop("EntityUtils.findByFilename", cpc)
    return false
end

--- Make sure this is only be executed once!
function EntityUtils:onEntityRemoved(entityId, nuid)
    local cpc = self.customProfiler:start("OnEntityRemoved")
    -- local _nuid, _entityId = self.globalsUtils.getNuidEntityPair(nuid)

    -- -- _entityId can be nil if the entity was removed before it was fully loaded
    -- if not Utils.IsEmpty(_entityId) and entityId ~= _entityId then
    --     error(("EntityUtils.OnEntityRemoved: entityId %s ~= _entityId %s"):format(entityId, _entityId), 2)
    -- end

    -- -- _nuid can be nil if the entity was removed before it was fully loaded
    -- if not Utils.IsEmpty(_nuid) and nuid ~= _nuid then
    --     error(("EntityUtils.OnEntityRemoved: nuid %s ~= _nuid %s"):format(nuid, _nuid), 2)
    -- end
    self.entityCache:delete(entityId)
    -- NetworkCacheUtils.delete ?
    GlobalsUtils.setDeadNuid(nuid)
    self.customProfiler:stop("OnEntityRemoved", cpc)
end

--- Checks if a specific entity is polymorphed.
--- @param entityId number
function EntityUtils:isEntityPolymorphed(entityId)
    local cpc                  = self.customProfiler:start("EntityUtils.isEntityPolymorphed")
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        if polymorphedEntityIds[e] == entityId then
            self.customProfiler:stop("EntityUtils.isEntityPolymorphed", cpc)
            return true
        end
    end
    self.customProfiler:stop("EntityUtils.isEntityPolymorphed", cpc)
    return false
end

local prevEntityIndex = 1
---Adds or updates all network components to the entity.
---Sends the entity data to all other peers.
---@param startFrameTime number Time at the very beginning of the frame.
function EntityUtils:syncEntities(startFrameTime)
    local cpc              = self.customProfiler:start("EntityUtils.syncEntities")
    local start            = GameGetRealWorldTimeSinceStarted() * 1000
    local who              = whoAmI()
    local localPlayerId    = self.minaUtils:getLocalMinaEntityId()
    local playerX, playerY = EntityGetTransform(localPlayerId)
    local radius           = ModSettingGetNextValue("noita-mp.radius_include_entities")
    ---@cast radius number
    local entityIds        = EntityGetInRadius(playerX, playerY, radius)
    local playerEntityIds  = {}


    --[[ Sort entityIds to process entities in the same order.
    In addition parent entities will be processed before children. ]]
    --
    table.sort(entityIds)

    if who == self.client.iAm then
        --table.insertIfNotExist(playerEntityIds, localPlayerId)
        --table.insertAllButNotDuplicates(playerEntityIds,
        --                                get_player_inventory_contents("inventory_quick")) -- wands and items
        --table.insertAllButNotDuplicates(playerEntityIds,
        --                                get_player_inventory_contents("inventory_full")) -- spells
        --table.insertAllButNotDuplicates(playerEntityIds, EntityGetAllChildren(localPlayerId) or {})
        --
        --for i = 1, #playerEntityIds do
        --    local clientEntityId = playerEntityIds[i]
        --    if not NetworkVscUtils.hasNetworkLuaComponents(clientEntityId) then
        --        NetworkVscUtils.addOrUpdateAllVscs(clientEntityId, MinaUtils.getLocalMinaName(),
        --                                           MinaUtils.getLocalMinaGuid())
        --    end
        --    if not NetworkVscUtils.hasNuidSet(clientEntityId) then
        --        Client.sendNeedNuid(MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(), clientEntityId)
        --    end
        --end
        if not self.networkVscUtils:hasNuidSet(localPlayerId) then
            self.client:sendNeedNuid(self.minaUtils:getLocalMinaName(), self.minaUtils:getLocalMinaGuid(),
                EntityGetRootEntity(localPlayerId))
        end
    end

    for entityIndex = prevEntityIndex, #entityIds do
        -- entityId in CoroutineUtils.iterator(entityIds) do
        repeat -- repeat until true with break works like continue
            local entityId = EntityGetRootEntity(entityIds[entityIndex])
            --[[ Just be double sure and check if entity is alive. If not next entityId ]]
            --
            if not EntityGetIsAlive(entityId) then
                if type(entityId) == "number" then
                    self.entityCache:delete(entityId)
                else
                    error(("processAndSyncEntityNetworking: entityId with entityIndex %s was not a number"):format(entityIndex),
                        2)
                end
                break -- work around for continue: repeat until true with break
            end

            --[[ Check if this entityId belongs to client ]]
            --
            if who == self.client.iAm then
                if not table.contains(playerEntityIds, entityId) then
                    if EntityGetIsAlive(entityId) and
                        entityId ~= self.minaUtils:getLocalMinaEntityId() and
                        not self.minaUtils:isRemoteMinae(entityId) and
                        not self.networkVscUtils:hasNetworkLuaComponents(entityId)
                    then
                        local distance                    = -1
                        local localMinaEntityId           = self.minaUtils:getLocalMinaEntityId()
                        local isPolymorphed, polyEntityId = self.minaUtils:isLocalMinaPolymorphed()
                        if isPolymorphed then
                            localMinaEntityId = polyEntityId
                        end
                        if EntityGetIsAlive(localMinaEntityId) then
                            local localX, localY             = EntityGetTransform(localMinaEntityId)
                            --for i = 1, #Client.otherClients do -- TODO NOT YET IMPLEMENTED
                            --    local remoteX, remoteY = EntityGetTransform(Client.otherClients[i].)
                            --end
                            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(self.client.serverInfo.nuid) -- TODO rework with getRemoteMina
                            if EntityGetIsAlive(entityIdRemote) then
                                local remoteX, remoteY = EntityGetTransform(entityIdRemote)
                                distance               = get_distance2(localX, localY, remoteX, remoteY)

                                if distance <= (tonumber(ModSettingGet("noita-mp.radius_include_entities")) * 1.5) then
                                    EntityKill(entityId)
                                else
                                    self.client:sendNeedNuid(self.minaUtils:getLocalMinaName(), self.minaUtils:getLocalMinaGuid(), entityId)
                                end
                                break -- work around for continue: repeat until true with break
                            end
                        end
                    end
                end
            end

            --[[ Check if entity can be ignored, because it is not necessary to sync it,
                 depending on config.lua: EntityUtils.include and EntityUtils.exclude ]]
            --
            local exclude     = true
            local filename    = EntityGetFilename(entityId)
            local cachedValue = self.entityCache:get(entityId)
            -- if already in cache, ignore it, because it was already processed
            --if cachedValue and cachedValue.entityId == entityId then
            --    exclude = false
            --else
            if self.exclude.byFilename[filename] or
                --table.contains(EntityUtils.exclude.byFilename, filename) or
                findByFilename(filename, self.exclude.byFilename)
            then
                exclude = true
                break -- work around for continue: repeat until true with break
            else
                for i = 1, #self.exclude.byComponentsName do
                    local componentTypeName = self.exclude.byComponentsName[i]
                    local components        = EntityGetComponentIncludingDisabled(entityId,
                        componentTypeName) or {}
                    if #components > 0 then
                        exclude = true
                        break -- work around for continue: repeat until true with break
                    end
                end
            end

            if self.include.byFilename[filename] or
                --table.contains(EntityUtils.include.byFilename, filename) or
                findByFilename(filename, self.include.byFilename)
            then
                exclude = false
            else
                for i = 1, #self.include.byComponentsName do
                    local componentTypeName = self.include.byComponentsName[i]
                    local components        = EntityGetComponentIncludingDisabled(entityId, componentTypeName) or {}
                    if #components > 0 then
                        -- Entity has a component, which is included in the config.lua.
                        exclude = false
                        break
                    end
                end
            end
            --end
            if exclude then
                break -- work around for continue: repeat until true with break
            end

            --[[ Check if entity has already all network components ]]
            --
            local hasNuid, nuid = self.networkVscUtils:hasNuidSet(entityId)
            if not self.networkVscUtils:isNetworkEntityByNuidVsc(entityId) or
                not self.networkVscUtils:hasNetworkLuaComponents(entityId)
            then
                local localPlayerInfo = self.minaUtils:getLocalMinaInformation()
                local ownerName       = localPlayerInfo.name
                local ownerGuid       = localPlayerInfo.guid

                if who == self.server.iAm and not hasNuid then
                    nuid = self.nuidUtils:getNextNuid()
                    -- Server.sendNewNuid this will be executed below
                elseif who == self.client.iAm and not hasNuid then
                    self.client:sendNeedNuid(ownerName, ownerGuid, entityId)
                else
                    error("Unable to get whoAmI()!", 2)
                    return
                end

                self.networkVscUtils:addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
            end

            --[[ Entity is new and not in cache, that's why cachedValue is nil ]]
            --
            local compOwnerName, compOwnerGuid, compNuid, filenameUnused, health, rotation, velocity, x, y =
                self.noitaComponentUtils:getEntityData(entityId)
            if cachedValue == nil or cachedValue.fullySerialised == false then
                if who == self.iAm then
                    if not hasNuid then
                        nuid = compNuid
                        if not nuid then
                            nuid = self.nuidUtils:getNextNuid()
                            self.networkVscUtils:addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, nuid)
                        end
                    end
                    --Server.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, nuid, x, y, rotation, velocity,
                    --    filename, health, EntityUtils.isEntityPolymorphed(entityId))
                    --local finished, serializedEntity = EntitySerialisationUtils.serializeEntireRootEntity(entityId, nuid, startFrameTime)
                    --local ONLYFORTESTING = EntitySerialisationUtils.deserializeEntireRootEntity(serializedEntity)
                    local serializedEntityString = self.noitaPatcherUtils:serializeEntity(entityId)
                    local finished               = false
                    if not self.utils:IsEmpty(serializedEntityString) then
                        finished = true
                    end
                    if finished == true then
                        self.server:sendNewNuid(compOwnerName, compOwnerGuid, entityId, serializedEntityString, nuid, x, y,
                            self.noitaComponentUtils:getInitialSerializedEntityString(entityId))
                    else
                        self.logger:warn(self.logger.channels.entity,
                            "EntitySerialisationUtils.serializeEntireRootEntity took too long. Breaking loop by returning entityId.")
                        -- when executionTime is too long, return the next entityCacheIndex to continue with it
                        --prevEntityIndex = entityIndex + 1
                        self.entityCacheUtils:set(entityId, nuid, compOwnerGuid, compOwnerName, filename, x, y, rotation, velocity.x, velocity.y,
                            health.current, health.max, finished, serializedEntityString)
                        self.customProfiler:stop("EntityUtils.syncEntities", cpc)
                        return -- completely end function, because it took too long
                    end
                end
            end

            --[[ Check if moved or anything else changed, but only on each tick ]]
            --
            if self.networkUtils:isTick() and not self.minaUtils:isRemoteMinae(entityId) then
                local changed = false
                --local compOwnerName, compOwnerGuid, compNuid, filenameUnused, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)

                --[[ Entity is new and not in cache, that's why cachedValue is nil ]]
                --
                --if cachedValue == nil then
                --    if who == Server.iAm then
                --        if not nuid then
                --            nuid = compNuid
                --            if not nuid then
                --                nuid = NuidUtils.getNextNuid()
                --                NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, nuid)
                --            end
                --        end
                --         TODO: check if entityId has parents and if so, send them too. How many parents?
                --         TODO: EntityGetParent(entityId) returns 0, if there is no parent
                --        --local parents = getParentsUntilRootEntity(who, entityId)
                --        --Server.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, nuid, x, y, rotation, velocity,
                --        --                   filename,
                --        --                   health, EntityUtils.isEntityPolymorphed(entityId))
                --        local serializedEntity = EntitySerialisationUtils.serializeEntireRootEntity(entityId)
                --    end
                --else
                if cachedValue then
                    --[[ Entity is already in cache, so check if something changed ]]
                    --
                    local threshold = math.round(tonumber(ModSettingGetNextValue("noita-mp.change_detection")) / 100,
                        0.1)
                    if math.abs(cachedValue.currentHealth - health.current) >= threshold or
                        math.abs(cachedValue.maxHealth - health.max) >= threshold or
                        math.abs(cachedValue.rotation - rotation) >= threshold or
                        math.abs(cachedValue.velX - velocity.x) >= threshold or
                        math.abs(cachedValue.velY - velocity.y) >= threshold or
                        math.abs(cachedValue.x - x) >= threshold or
                        math.abs(cachedValue.y - y) >= threshold
                    then
                        changed = true
                    end
                end
                --end
                self.entityCacheUtils:set(entityId, nuid, compOwnerGuid, compOwnerName, filename, x, y, rotation,
                    velocity.x, velocity.y, health.current, health.max, true, nil)
                if changed then
                    --NetworkUtils.getClientOrServer().sendEntityData(entityId) TODO: Reenable this again
                end
            end

            --[[ Check execution time to reduce lag ]]
            --
            local executionTime = GameGetRealWorldTimeSinceStarted() * 1000 - start
            if executionTime >= self.maxExecutionTime then
                self.logger:warn(self.logger.channels.entity, "EntityUtils.syncEntities took too long. Breaking loop by returning entityId.")
                -- when executionTime is too long, return the next entityCacheIndex to continue with it
                prevEntityIndex = entityIndex + 1

                self.customProfiler:stop("EntityUtils.syncEntities", cpc)
                return -- completely end function, because it took too long
            end

            break
        until true
    end
    -- when all entities are processed, reset the entityCacheIndex to 1 to start with the first entity again
    prevEntityIndex = 1
    self.customProfiler:stop("EntityUtils.syncEntities", cpc)
end

--- Spawns an entity and applies the transform and velocity to it. Also adds the network_component.
--- @param owner EntityOwner
--- @param nuid number
--- @param x number
--- @param y number
--- @param rotation number
--- @param velocity Vec2? - can be nil
--- @param filename string
--- @param localEntityId number this is the initial entity_id created by server OR client. It's owner specific! Every
--- owner has its own entity ids.
--- @return number? entityId Returns the entity_id of a already existing entity, found by nuid or the newly created entity.
function EntityUtils:spawnEntity(owner, nuid, x, y, rotation, velocity, filename, localEntityId, health, isPolymorphed)
    local cpc        = self.customProfiler:start("EntityUtils.spawnEntity")
    local localGuid  = self.minaUtils:getLocalMinaInformation().guid or self.minaUtils:getLocalMinaInformation()[2]
    local remoteName = owner.name or owner[1]
    local remoteGuid = owner.guid or owner[2]

    if localGuid == remoteGuid and EntityGetIsAlive(localEntityId) and not self.networkVscUtils:hasNuidSet(localEntityId) then
        -- if the owner sent by network is the local owner, don't spawn an additional entity, but update the nuid, when nuid is not set already
        self.networkVscUtils:addOrUpdateAllVscs(localEntityId, remoteName, remoteGuid, nuid)
        return
    end

    -- double check, if there is already an entity with this NUID and return the entity_id
    if EntityGetIsAlive(localEntityId) and self.networkVscUtils:hasNetworkLuaComponents(localEntityId) then
        local ownerNameByVsc, ownerGuidByVsc, nuidByVsc = self.networkVscUtils:getAllVscValuesByEntityId(localEntityId)
        -- if guid is not equal, but nuid is the same, then something is broken for sure!
        if ownerGuidByVsc ~= remoteGuid and nuidByVsc == nuid then
            error(("Trying to spawn entity(%s) locally, but owner does not match: remoteOwner(%s) ~= localOwner(%s). remoteNuid(%s) ~= localNuid(%s)")
                :format(localEntityId, remoteName, ownerNameByVsc, nuid, nuidByVsc), 2)
        end
    end

    -- include exclude list of entityIds which shouldn't be spawned
    if filename:contains("player.xml") then
        filename = "mods/noita-mp/data/enemies_gfx/client_player_base.xml"
    end

    local entityId = EntityLoad(filename, x, y)
    if not EntityGetIsAlive(entityId) then
        return
    end

    local compIds = EntityGetAllComponents(entityId) or {}
    for i = 1, #compIds do
        local compId   = compIds[i]
        local compType = ComponentGetTypeName(compId)
        if table.contains(self.remove.byComponentsName, compType) then
            EntityRemoveComponent(entityId, compId)
        end
    end

    self.networkVscUtils:addOrUpdateAllVscs(entityId, remoteName, remoteGuid, nuid)
    self.noitaComponentUtils:setEntityData(entityId, x, y, rotation, velocity, health)

    self.customProfiler:stop("EntityUtils.spawnEntity", cpc)
    return entityId
end

--- Synchronises dead nuids between server and client.
function EntityUtils:syncDeadNuids()
    local cpc       = self.customProfiler:start("EntityUtils.syncDeadNuids")
    local deadNuids = self.nuidUtils:getEntityIdsByKillIndicator()
    if #deadNuids > 0 then
        local clientOrServer = self.networkUtils:getClientOrServer()
        clientOrServer.sendDeadNuids(deadNuids)
    end
    self.customProfiler:stop("EntityUtils.syncDeadNuids", cpc)
end

---Destroys the entity by the given nuid.
---@param nuid number The nuid of the entity.
function EntityUtils:destroyByNuid(peer, nuid)
    local cpc = self.customProfiler:start("EntityUtils.destroyByNuid")

    if not peer or type(peer) ~= "table" then
        error(("EntityUtils.destroyByNuid: peer is not a table: %s"):format(self.utils:pformat(peer)), 2)
    end

    if not nuid then
        error(("EntityUtils.destroyByNuid: nuid must not be nil: %s"):format(self.utils:pformat(nuid)), 2)
    end

    if type(nuid) ~= "number" then
        nuid = tonumber(nuid)
    end

    local _, entityId = self.globalsUtils:getNuidEntityPair(nuid)

    if not entityId then
        self.customProfiler:stop("EntityUtils.destroyByNuid", cpc)
        return
    end

    if entityId < 0 then
        -- Dead entities are recognized by the kill indicator '-', which is the entityId multiplied by -1.
        entityId = math.abs(entityId) -- might be kill indicator is set: -entityId -> entityId
    end

    if not EntityGetIsAlive(entityId) then
        self.entityCache:delete(entityId)
        self.customProfiler:stop("EntityUtils.destroyByNuid", cpc)
        return
    end

    if entityId ~= self.minaUtils:getLocalMinaEntityId() and
        entityId ~= self.minaUtils:getLocalPolymorphedMinaEntityId()
    then
        EntityKill(entityId)
    end

    if type(nuid) ~= "number" then
        error(("EntityUtils.destroyByNuid nuid was not a number"), 2)
    else
        self.entityCache:deleteNuid(nuid)
    end
    self.customProfiler:stop("EntityUtils.destroyByNuid", cpc)
end

--- addOrChangeDetectionRadiusDebug

--- Simply adds a ugly debug circle around the player to visualize the detection radius.
function EntityUtils:addOrChangeDetectionRadiusDebug(player_entity)
    local cpc              = self.customProfiler:start("EntityUtils.addOrChangeDetectionRadiusDebug")

    local compIdInclude    = nil
    local compIdExclude    = nil
    local imageFileInclude = "mods/noita-mp/files/data/debug/radiusInclude24.png"
    local imageFileExclude = "mods/noita-mp/files/data/debug/radiusExclude24.png"

    if ModSettingGet("noita-mp.toggle_radius") then
        local compIds = EntityGetComponentIncludingDisabled(player_entity, "SpriteComponent") or {}
        for i = 1, #compIds do
            local compId = compIds[i]
            if ComponentGetValue2(compId, "image_file") == imageFileInclude then
                compIdInclude = compId
            end
            if ComponentGetValue2(compId, "image_file") == imageFileExclude then
                compIdExclude = compId
            end
        end

        if not compIdInclude then
            compId = EntityAddComponent2(player_entity, "SpriteComponent", {
                image_file        = imageFileInclude,
                has_special_scale = true,
                special_scale_x   = tonumber(ModSettingGet("noita-mp.radius_include_entities")) / 12,
                special_scale_y   = tonumber(ModSettingGet("noita-mp.radius_include_entities")) / 12,
                offset_x          = 12,
                offset_y          = 12,
                alpha             = 1
            })
        else
            ComponentSetValue2(compIdInclude, "special_scale_x",
                tonumber(ModSettingGet("noita-mp.radius_include_entities")) / 12)
            ComponentSetValue2(compIdInclude, "special_scale_y",
                tonumber(ModSettingGet("noita-mp.radius_include_entities")) / 12)
        end

        if not compIdExclude then
            compId = EntityAddComponent2(player_entity, "SpriteComponent", {
                image_file        = imageFileExclude,
                has_special_scale = true,
                special_scale_x   = tonumber(ModSettingGet("noita-mp.radius_exclude_entities")) / 12,
                special_scale_y   = tonumber(ModSettingGet("noita-mp.radius_exclude_entities")) / 12,
                offset_x          = 12,
                offset_y          = 12,
                alpha             = 1
            })
        else
            ComponentSetValue2(compIdExclude, "special_scale_x",
                tonumber(ModSettingGet("noita-mp.radius_exclude_entities")) / 12)
            ComponentSetValue2(compIdExclude, "special_scale_y",
                tonumber(ModSettingGet("noita-mp.radius_exclude_entities")) / 12)
        end
    else
        if compIdInclude then
            EntityRemoveComponent(player_entity, compIdInclude)
        end
        if compIdExclude then
            EntityRemoveComponent(player_entity, compIdExclude)
        end
    end
    self.customProfiler:stop("EntityUtils.addOrChangeDetectionRadiusDebug", cpc)
end

---Constructor for EntityUtils. With this constructor you can override the default imports.
---@param entityUtils EntityUtils|nil
---@param client Client Must not be nil!
---@param customProfiler CustomProfiler Must not be nil!
---@param enitityCacheUtils EntityCacheUtils Must not be nil!
---@param entityCache EntityCache Must not be nil!
---@param globalsUtils GlobalsUtils|nil
---@param logger Logger|nil (Must not be nil!)?
---@param minaUtils MinaUtils Must not be nil!
---@param networkUtils NetworkUtils Must not be nil!
---@param networkVscUtils NetworkVscUtils Must not be nil!
---@param noitaComponentUtils NoitaComponentUtils (Must not be nil!)?
---@param nuidUtils NuidUtils Must not be nil!
---@param server Server Must not be nil!
---@param utils Utils|nil
---@return EntityUtils
function EntityUtils:new(entityUtils, client, customProfiler, enitityCacheUtils, entityCache, globalsUtils, logger, minaUtils, networkUtils,
                         networkVscUtils, noitaComponentUtils, nuidUtils, server, utils)
    local entityUtils = entityUtils or {}
    setmetatable(entityUtils, self)
    self.__index = self

    assert(loadfile("mods/noita-mp/config.lua"))(self)

    local cpc = customProfiler:start("EntityUtils:new")

    -- Initialize all imports to avoid recursive imports
    self.client = client or error("EntityUtils:new: Parameter 'client' must not be nil!", 2)
    self.customProfiler = customProfiler or require("CustomProfiler", "mods/noita-mp/files/scripts/util"):new()
    self.enitityCacheUtils = enitityCacheUtils or require("EntityCacheUtils", "mods/noita-mp/files/scripts/util"):new()
    self.entityCache = entityCache or require("EntityCache", "mods/noita-mp/files/scripts/util"):new()
    self.globalsUtils = globalsUtils or require("GlobalsUtils", "mods/noita-mp/files/scripts/util"):new()
    self.logger = logger or require("Logger", "mods/noita-mp/files/scripts/util"):new()
    self.minaUtils = minaUtils or require("MinaUtils", "mods/noita-mp/files/scripts/util"):new()
    self.networkUtils = networkUtils or require("NetworkUtils", "mods/noita-mp/files/scripts/util"):new()
    self.networkVscUtils = networkVscUtils or require("NetworkVscUtils", "mods/noita-mp/files/scripts/util"):new()
    self.noitaComponentUtils = noitaComponentUtils or require("NoitaComponentUtils", "mods/noita-mp/files/scripts/util"):new()
    self.nuidUtils = nuidUtils or require("NuidUtils", "mods/noita-mp/files/scripts/util"):new()
    self.server = server or error("EntityUtils:new: Parameter 'server' must not be nil!", 2)
    self.utils = utils or require("Utils", "mods/noita-mp/files/scripts/util")

    customProfiler:stop("EntityUtils:new", cpc)
    return entityUtils
end

return EntityUtils
