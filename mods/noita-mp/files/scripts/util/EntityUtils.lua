-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------
dofile("mods/noita-mp/config.lua")
local util = require("util")

------------------------------------------------------------------------------------------------------------------------
--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
------------------------------------------------------------------------------------------------------------------------
if not CustomProfiler then
    CustomProfiler = {}
    function CustomProfiler.start(functionName)
        return 0
    end
    function CustomProfiler.stop(functionName, customProfilerCounter)
        return 0
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

local localOwner                           = {
    name = tostring(ModSettingGet("noita-mp.name")),
    guid = tostring(ModSettingGet("noita-mp.guid"))
}
-- local localPlayerEntityId = nil do not cache, because players entityId will change when respawning

----------------------------------------
--- public global variables:
----------------------------------------

EntityUtils.localPlayerEntityId            = -1
EntityUtils.localPlayerEntityIdPolymorphed = -1
EntityUtils.transformCache                 = {}
table.setNoitaMpDefaultMetaMethods(EntityUtils.transformCache)

----------------------------------------
--- private local methods:
----------------------------------------

--- Special thanks to @Horscht:
---@param inventory_type any
---@return table
local function get_player_inventory_contents(inventory_type)
    local cpc    = CustomProfiler.start("EntityUtils.get_player_inventory_contents")
    local player = EntityUtils.getLocalPlayerEntityId() --EntityGetWithTag("player_unit")[1]
    local out    = {}
    if player then
        for i, child in ipairs(EntityGetAllChildren(player) or {}) do
            if EntityGetName(child) == inventory_type then
                for i, item_entity in ipairs(EntityGetAllChildren(child) or {}) do
                    table.insert(out, item_entity)
                end
                break
            end
        end
    end
    CustomProfiler.stop("EntityUtils.get_player_inventory_contents", cpc)
    return out
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
--- isEntityPolymorphed
------------------------------------------------------------------------------------------------
--- Checks if the local player is polymorphed.
function EntityUtils.isPlayerPolymorphed()
    local cpc                  = CustomProfiler.start("EntityUtils.isPlayerPolymorphed")
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        local componentIds = EntityGetComponentIncludingDisabled(polymorphedEntityIds[e],
                                                                 "GameStatsComponent") or {}
        for c = 1, #componentIds do
            local isPlayer = ComponentGetValue2(componentIds[c], "is_player")
            if isPlayer then
                EntityUtils.localPlayerEntityIdPolymorphed = polymorphedEntityIds[e]
                CustomProfiler.stop("EntityUtils.isPlayerPolymorphed", cpc)
                return true, polymorphedEntityIds[e]
            end
        end
    end
    CustomProfiler.stop("EntityUtils.isPlayerPolymorphed", cpc)
    return false, nil
end

------------------------------------------------------------------------------------------------
--- getLocalPlayerEntityId
------------------------------------------------------------------------------------------------
--- Returns the local player entity id.
--- @return number localPlayerEntityId
function EntityUtils.getLocalPlayerEntityId()
    local cpc = CustomProfiler.start("EntityUtils.getLocalPlayerEntityId")
    if EntityUtils.isEntityAlive(EntityUtils.localPlayerEntityId) then
        -- TODO: I think this can lead to problems. Think of polymorphed minä. EntityId will change!
        CustomProfiler.stop("EntityUtils.getLocalPlayerEntityId", cpc)
        return EntityUtils.localPlayerEntityId
    end

    local polymorphed, entityId = EntityUtils.isPlayerPolymorphed()

    if polymorphed then
        CustomProfiler.stop("EntityUtils.getLocalPlayerEntityId", cpc)
        return entityId
    end

    local playerEntityIds = EntityGetWithTag("player_unit")
    for i = 1, #playerEntityIds do
        if NetworkVscUtils.hasNetworkLuaComponents(playerEntityIds[i]) then
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVcsValuesByEntityId(playerEntityIds[i])
            if compOwnerGuid == localOwner.guid then
                EntityUtils.localPlayerEntityId = playerEntityIds[i]
                CustomProfiler.stop("EntityUtils.getLocalPlayerEntityId", cpc)
                return playerEntityIds[i]
            end
        end
    end
    logger:warn(logger.channels.entity,
                "Unable to get local player entity id. Returning first entity id(%s), which was found.",
                playerEntityIds[1])
    EntityUtils.localPlayerEntityId = playerEntityIds[1]
    CustomProfiler.stop("EntityUtils.getLocalPlayerEntityId", cpc)
    return playerEntityIds[1]
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
            if not util.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
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
            if not util.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
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
--- @return number|nil entityId returns the entityId if is alive, otherwise nil
function EntityUtils.isEntityAlive(entityId)
    local cpc = CustomProfiler.start("EntityUtils.isEntityAlive")
    if EntityGetIsAlive(entityId) then
        CustomProfiler.stop("EntityUtils.isEntityAlive", cpc)
        return entityId
    end
    logger:warn(logger.channels.entity, ("Entity (%s) isn't alive anymore! Returning nil."):format(entityId))
    CustomProfiler.stop("EntityUtils.isEntityAlive", cpc)
    return nil
end

------------------------------------------------------------------------------------------------
--- processAndSyncEntityNetworking
------------------------------------------------------------------------------------------------
function EntityUtils.processAndSyncEntityNetworking()
    local cpc              = CustomProfiler.start("EntityUtils.processAndSyncEntityNetworking")
    local who              = whoAmI()
    local localPlayerId    = EntityUtils.getLocalPlayerEntityId()
    local playerX, playerY = EntityGetTransform(localPlayerId)
    local radius           = ModSettingGetNextValue("noita-mp.radius_include_entities")
    local entityIds        = EntityGetInRadius(playerX, playerY, radius) or {}
    local playerEntityIds  = {}

    if who == Client.iAm then
        table.insertIfNotExist(playerEntityIds, localPlayerId)
        table.insertAllButNotDuplicates(playerEntityIds,
                                        get_player_inventory_contents("inventory_quick")) -- wands and items
        table.insertAllButNotDuplicates(playerEntityIds,
                                        get_player_inventory_contents("inventory_full")) -- spells
        table.insertAllButNotDuplicates(playerEntityIds, EntityGetAllChildren(localPlayerId) or {})

        for i = 1, #playerEntityIds do
            local clientEntityId = playerEntityIds[i]
            local rootEntityId   = EntityGetRootEntity(clientEntityId)
            if not NetworkVscUtils.hasNetworkLuaComponents(rootEntityId) then
                NetworkVscUtils.addOrUpdateAllVscs(rootEntityId, localOwner.name, localOwner.guid, nil)
            end
            -- if not NetworkVscUtils.hasNuidSet(entityId) then
            --     Client.sendNeedNuid(localOwner, entityId)
            -- end
        end
    end

    for entityId in CoroutineUtils.iterator(entityIds) do
        --[[ Check if this entityId belongs to client ]]--
        if who == Client.iAm then
            if not table.contains(playerEntityIds, entityId) then
                if EntityUtils.isEntityAlive(entityId) and
                        entityId ~= EntityUtils.localPlayerEntityId and
                        entityId ~= EntityUtils.localPlayerEntityIdPolymorphed and
                        not EntityUtils.isRemoteMinae(entityId)
                then
                    EntityKill(entityId)
                end
            end
        end

        --[[ Just be double sure and check if entity is alive. If not next entityId ]]--
        repeat
            if not EntityUtils.isEntityAlive(entityId) then
                EntityUtils.transformCache[entityId] = nil
                break -- work around for continue: repeat until true with break
            end
        until true

        --[[ Check if entity can be ignored, because it is not necessary to sync it,
             depending on config.lua: EntityUtils.include. ]]--
        local exclude  = true
        local filename = EntityGetFilename(entityId) or ""

        if EntityUtils.include.byFilename[filename] or
                table.contains(EntityUtils.include.byFilename, filename)
        then
            exclude = false
        else
            for i = 1, #EntityUtils.include.byComponentsName do
                local componentTypeName = EntityUtils.include.byComponentsName[i]
                local components        = EntityGetComponentIncludingDisabled(entityId, componentTypeName) or {}
                if #components > 0 then
                    -- Entity has a component, which is included in the config.lua.
                    exclude = false
                    break
                end
            end
        end
        repeat
            if exclude then
                break -- work around for continue: repeat until true with break
            end
        until true

        --[[ Check if entity has already all network components ]]--
        local nuid = nil
        if not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) or
                not NetworkVscUtils.hasNetworkLuaComponents(entityId)
        then
            local localPlayerInfo = util.getLocalPlayerInfo()
            local ownerName       = localPlayerInfo.name
            local ownerGuid       = localPlayerInfo.guid

            if who == Server.iAm then
                nuid = NuidUtils.getNextNuid()
                -- Server.sendNewNuid this will be executed below
            elseif who == Client.iAm then
                Client.sendNeedNuid(ownerName, ownerGuid, entityId)
            else
                logger:error(logger.channels.entity, "Unable to get whoAmI()!")
            end

            NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
        end

        --[[ Check if moved or anything else changed ]]--
        if not EntityUtils.isEntityAlive(entityId) then
            EntityUtils.transformCache[entityId] = nil
        elseif not EntityUtils.isRemoteMinae(entityId) then
            local changed                                                                                  = false
            local compOwnerName, compOwnerGuid, compNuid, filenameUnused, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
            if EntityUtils.transformCache[entityId] == nil then
                if who == Server.iAm then
                    Server.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, nuid, x, y, rotation, velocity,
                                       filename,
                                       health, EntityUtils.isEntityPolymorphed(entityId))
                end
            else
                local threshold = math.round(tonumber(ModSettingGetNextValue("noita-mp.change_detection")) / 100, 0.1)
                if math.abs(EntityUtils.transformCache[entityId].health.current - health.current) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].health.max - health.max) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].rotation - rotation) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].velocity.x - velocity.x) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].velocity.y - velocity.y) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].x - x) > threshold or
                        math.abs(EntityUtils.transformCache[entityId].y - y) > threshold
                then
                    changed = true
                end
            end
            EntityUtils.transformCache[entityId] = {
                ownerName = compOwnerName,
                ownerGuid = compOwnerGuid,
                nuid      = compNuid,
                filename  = filename,
                health    = health,
                rotation  = rotation,
                velocity  = velocity,
                x         = x,
                y         = y
            }
            --repeat
            --    if not changed then
            --        break -- work around for continue: repeat until true with break
            --    end
            --until true
            if changed then
                NetworkUtils.getClientOrServer().sendEntityData(entityId)
            end
        end

        --[[ Check execution time to reduce lag ]]--
        if CustomProfiler.getDuration("EntityUtils.processAndSyncEntityNetworking", cpc) > 25 then
            logger:warn(logger.channels.entity,
                        "EntityUtils.processAndSyncEntityNetworking took too long. Breaking loop by returning entityId.")
            break --return coroutine.yield(entityId) --co.yield(entityId)
        end
    end

    CustomProfiler.stop("EntityUtils.processAndSyncEntityNetworking", cpc)
end

------------------------------------------------------------------------------------------------
--- spawnEntity
------------------------------------------------------------------------------------------------
--- Spawns an entity and applies the transform and velocity to it. Also adds the network_component.
--- @param owner table owner { name, guid }
--- @param nuid any
--- @param x any
--- @param y any
--- @param rot any
--- @param velocity table velocity { x, y } - can be nil
--- @param filename any
--- @param localEntityId number this is the initial entity_id created by server OR client. It's owner specific! Every
--- owner has its own entity ids.
--- @return number entityId Returns the entity_id of a already existing entity, found by nuid or the newly created
--- entity.
function EntityUtils.spawnEntity(owner, nuid, x, y, rotation, velocity, filename, localEntityId, health, isPolymorphed)
    local cpc        = CustomProfiler.start("EntityUtils.spawnEntity")
    local localGuid  = util.getLocalPlayerInfo().guid or util.getLocalPlayerInfo()[2]
    local remoteName = owner.name or owner[1]
    local remoteGuid = owner.guid or owner[2]

    if localGuid == remoteGuid then
        if not EntityUtils.isEntityAlive(localEntityId) then
            return
        end
        -- if the owner sent by network is the local owner, don't spawn an additional entity, but update the nuid
        NetworkVscUtils.addOrUpdateAllVscs(localEntityId, remoteName, remoteGuid, nuid)
        return
    end

    -- double check, if there is already an entity with this NUID and return the entity_id
    if EntityUtils.isEntityAlive(localEntityId) and NetworkVscUtils.hasNetworkLuaComponents(localEntityId) then
        local ownerNameByVsc, ownerGuidByVsc, nuidByVsc = NetworkVscUtils.getAllVcsValuesByEntityId(localEntityId)
        if ownerGuidByVsc ~= remoteGuid then
            logger:error("Trying to spawn entity(%s) locally, but owner does not match: remoteOwner(%s) ~= localOwner(%s). remoteNuid(%s) ~= localNuid(%s)",
                         localEntityId, remoteName, ownerNameByVsc, nuid, nuidByVsc)
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

    --if isPolymorphed then
    local compIds = EntityGetAllComponents(entityId) or {}
    for i = 1, #compIds do
        local compId   = compIds[i]
        local compType = ComponentGetTypeName(compId)
        if table.contains(EntityUtils.remove.byComponentsName, compType) then
            EntityRemoveComponent(entityId, compId)
        end
    end
    --end

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
function EntityUtils.destroyByNuid(nuid)
    local cpc             = CustomProfiler.start("EntityUtils.destroyByNuid")
    local nNuid, entityId = GlobalsUtils.getNuidEntityPair(nuid)

    if not EntityUtils.isEntityAlive(entityId) then
        CustomProfiler.stop("EntityUtils.destroyByNuid", cpc)
        return
    end

    -- Dead entities are recognized by the kill indicator, which is the entityId multiplied by -1.
    if math.sign(entityId) == -1 then
        entityId = entityId * -1
    end

    if EntityUtils.isEntityAlive(entityId) and
            entityId ~= EntityUtils.localPlayerEntityId and
            entityId ~= EntityUtils.localPlayerEntityIdPolymorphed then
        EntityKill(entityId)
    end
    -- Make sure cache is cleared correctly
    EntityUtils.transformCache[entityId] = nil
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
