-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------
dofile("mods/noita-mp/config.lua")

------------------------------------------------------------------------------------------------------------------------
--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
------------------------------------------------------------------------------------------------------------------------
if require then
    Utils = require("Utils")
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    if not Utils then
        Utils                   = dofile("mods/noita-mp/files/scripts/util/Utils.lua")
    end

    if not EntityCache then
        EntityCache            = {}
        EntityCache.delete     = function(entityId)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use EntityCache.delete(entityId %s)")
            --                    :format(entityId))
        end
        EntityCache.get        = function(entityId)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use EntityCache.get(entityId %s)")
            --                    :format(entityId))
        end
        EntityCache.set        = function(entityId, compNuid, compOwnerGuid, compOwnerName, filename, x, y, rotation, velocityX,
                                          velocityY, healthCurrent, healthMax)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use EntityCache.set(entityId %s, compNuid %s, compOwnerGuid %s, compOwnerName %s, filename %s, x %s, y %s, rotation %s, velocityX %s, velocityY %s, healthCurrent %s, healthMax %s)")
            --                    :format(entityId, compNuid, compOwnerGuid, compOwnerName, filename, x, y, rotation,
            --                            velocityX, velocityY, healthCurrent, healthMax))
        end
        EntityCache.deleteNuid = function(nuid)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use EntityCache.deleteNuid(nuid %s)")
            --                    :format(nuid))
        end
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

------------------------------------------------------------------------------------------------------------------------
--- @see config.lua
------------------------------------------------------------------------------------------------------------------------
if not EntityUtils then
    EntityUtils = {}
end

----------------------------------------
--- private local variables:
----------------------------------------


----------------------------------------
--- public global variables:
----------------------------------------


----------------------------------------
--- private local methods:
----------------------------------------

--- Special thanks to @Horscht:
---@param inventory_type string
---@return number[]
local function get_player_inventory_contents(inventory_type)
    local cpc    = CustomProfiler.start("EntityUtils.get_player_inventory_contents")
    local player = MinaUtils.getLocalMinaEntityId() --EntityGetWithTag("player_unit")[1]
    local out    = {}
    if player then
        for i, child in ipairs(EntityGetAllChildren(player) or {}) do
            if EntityGetName(child) == inventory_type then
                for _, item_entity in ipairs(EntityGetAllChildren(child) or {}) do
                    table.insert(out, item_entity)
                end
                break
            end
        end
    end
    CustomProfiler.stop("EntityUtils.get_player_inventory_contents", cpc)
    return out
end

--- Checks if the entity filename is in the include or exclude list of filenames.
--- @param filename string current entity filename
--- @param filenames table list of filenames
--- @return boolean true if filename is in filenames list otherwise false
local function findByFilename(filename, filenames)
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

local function getParentsUntilRootEntity(who, entityId)
    local cpc            = CustomProfiler.start("EntityUtils.getParentsUntilRootEntity")
    local parentNuids    = {}
    local parentEntityId = EntityGetParent(entityId) -- returns 0, if entity has no parent

    while parentEntityId and parentEntityId > 0 do
        local parentNuid = NetworkVscUtils.hasNuidSet(parentEntityId)
        if not parentNuid then
            local localPlayer = MinaUtils.getLocalMinaInformation()
            local ownerName   = localPlayer.name
            local ownerGuid   = localPlayer.guid
            if who == Server.iAm and not parentNuid then
                parentNuid = NuidUtils.getNextNuid()
                NetworkVscUtils.addOrUpdateAllVscs(parentEntityId, ownerName, ownerGuid, parentNuid)
                local _, _, _, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(parentEntityId)
                Server.sendNewNuid({ ownerName, ownerGuid }, parentEntityId, parentNuid, x, y, rotation, velocity,
                                   filename, health, EntityUtils.isEntityPolymorphed(entityId))
            elseif who == Client.iAm and not parentNuid then
                Client.sendNeedNuid(ownerName, ownerGuid, entityId)
                -- TODO: return and wait for nuid? Otherwise child will never know who is the parent.
            else
                error("Unable to get whoAmI()!", 2)
            end
        end
        if type(parentNuid) == "number" then
            table.insert(parentNuids, 1, parentNuid)
        end
        parentEntityId = EntityGetParent(parentEntityId)
    end
    CustomProfiler.stop("EntityUtils.getParentsUntilRootEntity", cpc)
    return parentNuids
end

----------------------------------------
--- public global methods:
----------------------------------------

------------------------------------------------------------------------------------------------
--- isEntityPolymorphed
------------------------------------------------------------------------------------------------
--- Checks if a specific entity is polymorphed.
--- @param entityId number
function EntityUtils.isEntityPolymorphed(entityId)
    local cpc                  = CustomProfiler.start("EntityUtils.isEntityPolymorphed")
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        if polymorphedEntityIds[e] == entityId then
            CustomProfiler.stop("EntityUtils.isEntityPolymorphed")
            return true
        end
    end
    CustomProfiler.stop("EntityUtils.isEntityPolymorphed", cpc)
    return false
end

------------------------------------------------------------------------------------------------
-- TODO: Rework this by adding and updating entityId to Server.entityId and Client.entityId! Dont forget polymorphism!
--- isRemoteMinae
------------------------------------------------------------------------------------------------
function EntityUtils.isRemoteMinae(entityId)
    local cpc = CustomProfiler.start("EntityUtils.isRemoteMinae")
    if not EntityUtils.isEntityAlive(entityId) then
        CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
        return false
    end
    local who = whoAmI()
    if who == Server.iAm then
        local clients = Server:getClients()
        for i = 1, #clients do
            local client                     = clients[i]
            local clientsNuid                = client.nuid
            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(clientsNuid)
            if not Utils.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    elseif who == Client.iAm then
        local serverNuid, serverEntityId = GlobalsUtils.getNuidEntityPair(Client.serverInfo.nuid)
        if entityId == serverEntityId then
            CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
            return true
        end
        for i = 1, #Client.otherClients do
            local client                     = Client.otherClients[i]
            local clientsNuid                = client.nuid
            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(clientsNuid)
            if not Utils.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    end
    CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
    return false
end

------------------------------------------------------------------------------------------------
--- isEntityAlive
------------------------------------------------------------------------------------------------
--- Looks like there were access to removed entities, which might cause game crashing.
--- Use this function whenever you work with entity_id/entityId to stop client game crashing.
--- @param entityId number Id of any entity.
--- @return number|false entityId returns the entityId if is alive, otherwise false
function EntityUtils.isEntityAlive(entityId)
    local cpc = CustomProfiler.start("EntityUtils.isEntityAlive")
    if EntityGetIsAlive(entityId) then
        CustomProfiler.stop("EntityUtils.isEntityAlive", cpc)
        return entityId
    end
    Logger.trace(Logger.channels.entity, ("Entity (%s) isn't alive anymore! Returning false."):format(entityId))
    CustomProfiler.stop("EntityUtils.isEntityAlive", cpc)
    return false
end

------------------------------------------------------------------------------------------------
--- processAndSyncEntityNetworking
------------------------------------------------------------------------------------------------
local prevEntityIndex = 1
function EntityUtils.processAndSyncEntityNetworking()
    local start            = GameGetRealWorldTimeSinceStarted() * 1000
    local cpc              = CustomProfiler.start("EntityUtils.processAndSyncEntityNetworking")
    local who              = whoAmI()
    local localPlayerId    = MinaUtils.getLocalMinaEntityId()
    local playerX, playerY = EntityGetTransform(localPlayerId)
    local radius           = ModSettingGetNextValue("noita-mp.radius_include_entities")
    ---@cast radius number
    local entityIds        = EntityGetInRadius(playerX, playerY, radius)
    local playerEntityIds  = {}

    ----[[ Make sure child entities are already added to the entityIds list
    -- otherwise nuid isn't set when extracting parents. ]]--
    --for i = 1, #entityIds do
    --    local childEntityIds = EntityGetAllChildren(entityIds[i])
    --    if not util.IsEmpty(childEntityIds) then
    --        table.insertAllButNotDuplicates(entityIds, childEntityIds)
    --    end
    --end

    --[[ Sort entityIds to process entities in the same order.
    In addition parent entities will be processed before children. ]]--
    table.sort(entityIds)

    if who == Client.iAm then
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
        if not NetworkVscUtils.hasNuidSet(localPlayerId) then
            Client.sendNeedNuid(MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(),
                                EntityGetRootEntity(localPlayerId))
        end
    end

    for entityIndex = prevEntityIndex, #entityIds do
        -- entityId in CoroutineUtils.iterator(entityIds) do
        repeat -- repeat until true with break works like continue
            local entityId = EntityGetRootEntity(entityIds[entityIndex])
            --[[ Just be double sure and check if entity is alive. If not next entityId ]]--
            if not EntityUtils.isEntityAlive(entityId) then
                if type(entityId) == "number" then
                    EntityCache.delete(entityId)
                else
                    error(("processAndSyncEntityNetworking: entityId with entityIndex %s was not a number"):format(entityIndex),
                          2)
                end
                break -- work around for continue: repeat until true with break
            end

            --[[ Check if this entityId belongs to client ]]--
            if who == Client.iAm then
                if not table.contains(playerEntityIds, entityId) then
                    if EntityUtils.isEntityAlive(entityId) and
                            entityId ~= MinaUtils.getLocalMinaEntityId() and
                            not EntityUtils.isRemoteMinae(entityId) and
                            not NetworkVscUtils.hasNetworkLuaComponents(entityId)
                    then
                        local distance                    = -1
                        local localMinaEntityId           = MinaUtils.getLocalMinaEntityId()
                        local isPolymorphed, polyEntityId = MinaUtils.isLocalMinaPolymorphed()
                        if isPolymorphed then
                            localMinaEntityId = polyEntityId
                        end
                        if EntityUtils.isEntityAlive(localMinaEntityId) then
                            local localX, localY             = EntityGetTransform(localMinaEntityId)
                            --for i = 1, #Client.otherClients do -- TODO NOT YET IMPLEMENTED
                            --    local remoteX, remoteY = EntityGetTransform(Client.otherClients[i].)
                            --end
                            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(Client.serverInfo.nuid) -- TODO rework with getRemoteMina
                            if EntityUtils.isEntityAlive(entityIdRemote) then
                                local remoteX, remoteY = EntityGetTransform(entityIdRemote)
                                distance               = get_distance2(localX, localY, remoteX, remoteY)

                                if distance <= (tonumber(ModSettingGet("noita-mp.radius_include_entities")) * 1.5) then
                                    EntityKill(entityId)
                                else
                                    Client.sendNeedNuid(MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(),
                                                        entityId)
                                end
                                break -- work around for continue: repeat until true with break
                            end
                        end
                    end
                end
            end

            --[[ Check if entity can be ignored, because it is not necessary to sync it,
                 depending on config.lua: EntityUtils.include and EntityUtils.exclude ]]--
            local exclude     = true
            local filename    = EntityGetFilename(entityId)
            local cachedValue = EntityCache.get(entityId)
            ---- if already in cache, ignore it, because it was already processed
            --if cachedValue and cachedValue.entityId == entityId then
            --    exclude = false
            --else
            if EntityUtils.exclude.byFilename[filename] or
                    --table.contains(EntityUtils.exclude.byFilename, filename) or
                    findByFilename(filename, EntityUtils.exclude.byFilename)
            then
                exclude = true
                break -- work around for continue: repeat until true with break
            else
                for i = 1, #EntityUtils.exclude.byComponentsName do
                    local componentTypeName = EntityUtils.exclude.byComponentsName[i]
                    local components        = EntityGetComponentIncludingDisabled(entityId,
                                                                                  componentTypeName) or {}
                    if #components > 0 then
                        exclude = true
                        break -- work around for continue: repeat until true with break
                    end
                end
            end

            if EntityUtils.include.byFilename[filename] or
                    --table.contains(EntityUtils.include.byFilename, filename) or
                    findByFilename(filename, EntityUtils.include.byFilename)
            then
                exclude = false
            else
                for i = 1, #EntityUtils.include.byComponentsName do
                    local componentTypeName = EntityUtils.include.byComponentsName[i]
                    local components        = EntityGetComponentIncludingDisabled(entityId,
                                                                                  componentTypeName) or {}
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

            --[[ Check if entity has already all network components ]]--
            local nuid = NetworkVscUtils.hasNuidSet(entityId)
            if not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) or
                    not NetworkVscUtils.hasNetworkLuaComponents(entityId)
            then
                local localPlayerInfo = MinaUtils.getLocalMinaInformation()
                local ownerName       = localPlayerInfo.name
                local ownerGuid       = localPlayerInfo.guid

                if who == Server.iAm and not nuid then
                    nuid = NuidUtils.getNextNuid()
                    -- Server.sendNewNuid this will be executed below
                elseif who == Client.iAm and not nuid then
                    Client.sendNeedNuid(ownerName, ownerGuid, entityId)
                else
                    error("Unable to get whoAmI()!", 2)
                end

                NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
            end

            --[[ Entity is new and not in cache, that's why cachedValue is nil ]]--
            local compOwnerName, compOwnerGuid, compNuid, filenameUnused, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
            if cachedValue == nil then
                if who == Server.iAm then
                    if not nuid then
                        nuid = compNuid
                        if not nuid then
                            nuid = NuidUtils.getNextNuid()
                            NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, nuid)
                        end
                    end
                    --Server.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, nuid, x, y, rotation, velocity,
                    --                   filename, health, EntityUtils.isEntityPolymorphed(entityId))
                    local finished, serializedEntity = EntitySerialisationUtils.serializeEntireRootEntity(entityId)
                    --local ONLYFORTESTING = EntitySerialisationUtils.deserializeEntireRootEntity(serializedEntity)
                    if finished == true then
                        Server.sendNewNuidSerialized(compOwnerName, compOwnerGuid, entityId, serializedEntity)
                    end
                end
            end

            --[[ Check if moved or anything else changed, but only on each tick ]]--
            if NetworkUtils.isTick() and not EntityUtils.isRemoteMinae(entityId) then
                local changed = false
                --local compOwnerName, compOwnerGuid, compNuid, filenameUnused, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)

                ----[[ Entity is new and not in cache, that's why cachedValue is nil ]]--
                --if cachedValue == nil then
                --    if who == Server.iAm then
                --        if not nuid then
                --            nuid = compNuid
                --            if not nuid then
                --                nuid = NuidUtils.getNextNuid()
                --                NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, nuid)
                --            end
                --        end
                --        ---- TODO: check if entityId has parents and if so, send them too. How many parents?
                --        ---- TODO: EntityGetParent(entityId) returns 0, if there is no parent
                --        --local parents = getParentsUntilRootEntity(who, entityId)
                --        --Server.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, nuid, x, y, rotation, velocity,
                --        --                   filename,
                --        --                   health, EntityUtils.isEntityPolymorphed(entityId))
                --        local serializedEntity = EntitySerialisationUtils.serializeEntireRootEntity(entityId)
                --    end
                --else
                if cachedValue then
                    --[[ Entity is already in cache, so check if something changed ]]--
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
                EntityCacheUtils.set(entityId, nuid, compOwnerGuid, compOwnerName, filename, x, y, rotation,
                                     velocity.x, velocity.y, health.current, health.max)
                if changed then
                    NetworkUtils.getClientOrServer().sendEntityData(entityId)
                end
            end

            --[[ Check execution time to reduce lag ]]--
            local executionTime = GameGetRealWorldTimeSinceStarted() * 1000 - start
            if executionTime >= EntityUtils.maxExecutionTime then
                Logger.warn(Logger.channels.entity,
                            "EntityUtils.processAndSyncEntityNetworking took too long. Breaking loop by returning entityId.")
                -- when executionTime is too long, return the next entityCacheIndex to continue with it
                prevEntityIndex = entityIndex + 1

                CustomProfiler.stop("EntityUtils.processAndSyncEntityNetworking", cpc)
                return -- completely end function, because it took too long
            end

            break
        until true
    end
    -- when all entities are processed, reset the entityCacheIndex to 1 to start with the first entity again
    prevEntityIndex = 1
    CustomProfiler.stop("EntityUtils.processAndSyncEntityNetworking", cpc)
end

------------------------------------------------------------------------------------------------
--- spawnEntity
------------------------------------------------------------------------------------------------
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
function EntityUtils.spawnEntity(owner, nuid, x, y, rotation, velocity, filename, localEntityId, health, isPolymorphed)
    local cpc        = CustomProfiler.start("EntityUtils.spawnEntity")
    local localGuid  = MinaUtils.getLocalMinaInformation().guid or MinaUtils.getLocalMinaInformation()[2]
    local remoteName = owner.name or owner[1]
    local remoteGuid = owner.guid or owner[2]

    if localGuid == remoteGuid and EntityUtils.isEntityAlive(localEntityId) and not NetworkVscUtils.hasNuidSet(localEntityId) then
        -- if the owner sent by network is the local owner, don't spawn an additional entity, but update the nuid, when nuid is not set already
        NetworkVscUtils.addOrUpdateAllVscs(localEntityId, remoteName, remoteGuid, nuid)
        return
    end

    -- double check, if there is already an entity with this NUID and return the entity_id
    if EntityUtils.isEntityAlive(localEntityId) and NetworkVscUtils.hasNetworkLuaComponents(localEntityId) then
        local ownerNameByVsc, ownerGuidByVsc, nuidByVsc = NetworkVscUtils.getAllVscValuesByEntityId(localEntityId)
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
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    local compIds = EntityGetAllComponents(entityId) or {}
    for i = 1, #compIds do
        local compId   = compIds[i]
        local compType = ComponentGetTypeName(compId)
        if table.contains(EntityUtils.remove.byComponentsName, compType) then
            EntityRemoveComponent(entityId, compId)
        end
    end

    NetworkVscUtils.addOrUpdateAllVscs(entityId, remoteName, remoteGuid, nuid)
    NoitaComponentUtils.setEntityData(entityId, x, y, rotation, velocity, health)

    CustomProfiler.stop("EntityUtils.spawnEntity", cpc)
    return entityId
end

------------------------------------------------------------------------------------------------
--- syncDeadNuids
------------------------------------------------------------------------------------------------
--- Synchronises the dead nuids between server and client.
function EntityUtils.syncDeadNuids()
    local cpc       = CustomProfiler.start("EntityUtils.syncDeadNuids")
    local deadNuids = NuidUtils.getEntityIdsByKillIndicator()
    if #deadNuids > 0 then
        local clientOrServer = NetworkUtils.getClientOrServer()
        clientOrServer.sendDeadNuids(deadNuids)
    end
    CustomProfiler.stop("EntityUtils.syncDeadNuids", cpc)
end

------------------------------------------------------------------------------------------------
--- destroyByNuid
------------------------------------------------------------------------------------------------
--- Destroys the entity by the given nuid.
--- @param nuid number The nuid of the entity.
function EntityUtils.destroyByNuid(peer, nuid)
    local cpc = CustomProfiler.start("EntityUtils.destroyByNuid")

    if not peer or type(peer) ~= "table" then
        error(("EntityUtils.destroyByNuid: peer is not a table: %s"):format(Utils.pformat(peer)), 2)
    end

    if not nuid then
        error(("EntityUtils.destroyByNuid: nuid must not be nil: %s"):format(Utils.pformat(nuid)), 2)
    end

    if type(nuid) ~= "number" then
        nuid = tonumber(nuid)
    end

    local _, entityId = GlobalsUtils.getNuidEntityPair(nuid)

    if not entityId then
        CustomProfiler.stop("EntityUtils.destroyByNuid", cpc)
        return
    end

    if entityId < 0 then
        -- Dead entities are recognized by the kill indicator '-', which is the entityId multiplied by -1.
        entityId = math.abs(entityId) -- might be kill indicator is set: -entityId -> entityId
    end

    if not EntityUtils.isEntityAlive(entityId) then
        EntityCache.delete(entityId)
        CustomProfiler.stop("EntityUtils.destroyByNuid", cpc)
        return
    end

    if entityId ~= MinaUtils.getLocalMinaEntityId() and
            entityId ~= MinaUtils.getLocalPolymorphedMinaEntityId
    then
        EntityKill(entityId)
    end

    if type(nuid) ~= "number" then
        error(("EntityUtils.destroyByNuid nuid was not a number"), 2)
    else
        EntityCache.deleteNuid(nuid)
    end
    CustomProfiler.stop("EntityUtils.destroyByNuid", cpc)
end

------------------------------------------------------------------------------------------------
--- addOrChangeDetectionRadiusDebug
------------------------------------------------------------------------------------------------
--- Simply adds a ugly debug circle around the player to visualize the detection radius.
function EntityUtils.addOrChangeDetectionRadiusDebug(player_entity)
    local cpc              = CustomProfiler.start("EntityUtils.addOrChangeDetectionRadiusDebug")
    local compIdInclude    = nil
    local compIdExclude    = nil
    local imageFileInclude = "mods/noita-mp/files/data/debug/radiusInclude24.png"
    local imageFileExclude = "mods/noita-mp/files/data/debug/radiusExclude24.png"

    local compIds          = EntityGetComponentIncludingDisabled(player_entity, "SpriteComponent") or {}
    for i = 1, #compIds do
        local compId = compIds[i]
        if ComponentGetValue2(compId, "image_file") == imageFileInclude then
            compIdInclude = compId
        end
        if ComponentGetValue2(compId, "image_file") == imageFileExclude then
            compIdExclude = compId
        end
    end

    if ModSettingGet("noita-mp.toggle_radius") then

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
        EntityRemoveComponent(player_entity, compIdInclude)
        EntityRemoveComponent(player_entity, compIdExclude)
    end
    CustomProfiler.stop("EntityUtils.addOrChangeDetectionRadiusDebug", cpc)
end

------------------------------------------------------------------------------------------------
--- 'Class' in Lua Globals
------------------------------------------------------------------------------------------------
--- Because of stack overflow errors when loading lua files,
--- I decided to put Utils 'classes' into globals
_G.EntityUtils = EntityUtils

------------------------------------------------------------------------------------------------
--- 'Class' as module return value
------------------------------------------------------------------------------------------------
--- But still return for Noita Components,
--- which does not have access to _G,
--- because of own context/vm
return EntityUtils
