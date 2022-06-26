-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

dofile("mods/noita-mp/config.lua")

-----------------
-- EntityUtils:
-----------------
--- class for manipulating entities in Noita
if not EntityUtils then
    EntityUtils = {}
end

--#region Global private variables

local localOwner = {
    name = tostring(ModSettingGet("noita-mp.name")),
    guid = tostring(ModSettingGet("noita-mp.guid"))
}
-- local localPlayerEntityId = nil do not cache, because players entityId will change when respawning

--#endregion

--#region Global private functions

--- Filters a table of entities by component name or filename. This include and exclude map is defined in EntityUtils.include/.exclude.
--- Credits to @Horscht#6086!
--- @param entities table Usually all entities in a specific radius to the player.
--- @param include
--- @param exclude
--- @param additionalCheck1 function which has to return true of false, but can also be nil: additionalChecks1
--- @param additionalCheck2 function which has to return true of false, but can also be nil: additionalChecks2
--- @param additionalCheck3 function which has to return true of false, but can also be nil: additionalChecks3
--- @return table filteredEntities
local function filterEntities(entities, include, exclude, additionalCheck1, additionalCheck2)
    local filteredEntities = {}

    local function entityMatches(entityId, filenames, componentNames)
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end
        for i, filename in ipairs(filenames) do
            if EntityGetFilename(entityId):find(filename) then
                return true
            end
        end
        for i, componentName in ipairs(componentNames) do
            if EntityGetComponentIncludingDisabled(entityId, componentName) then
                return true
            end
        end
    end

    for i, entityId in ipairs(entities) do
        if EntityGetRootEntity(entityId) == entityId then
            local included = entityMatches(entityId, include.byFilename, include.byComponentsName)
            local excluded = entityMatches(entityId, exclude.byFilename, exclude.byComponentsName)

            if included and not excluded then
                -- local isNetworkEntity         = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
                -- local hasNetworkLuaComponents = NetworkVscUtils.hasNetworkLuaComponents(entityId)
                -- if not isNetworkEntity and not hasNetworkLuaComponents then

                local addCheck1 = true
                if additionalCheck1 then
                    addCheck1 = additionalCheck1(entityId)
                end

                local addCheck2 = true
                if additionalCheck2 then
                    addCheck2 = additionalCheck2(entityId)
                end

                if addCheck1 and addCheck2 then
                    table.insert(filteredEntities, entityId)
                end
                -- end
            end
        end
    end

    return filteredEntities
end

--- Gets all entities in a specific radius to the player entities. This can only be executed by server. Entities are filtered by EntityUtils.include/.exclude.
--- @param radius number radius to detect entities.
--- @param include
--- @param exclude
--- @param additionalCheck1 function which has to return true of false, but can also be nil
--- @param additionalCheck2 function which has to return true of false, but can also be nil
--- @return table filteredEntities
local function getFilteredEntities(radius, include, exclude, additionalCheck1, additionalCheck2)
    local entities      = {}

    local playerUnitIds = EntityGetWithTag("player_unit")
    if EntityUtils.isPlayerPolymorphed() then
        table.insertIfNotExist(playerUnitIds, util.getLocalPlayerInfo().entityId)
    end
    for i = 1, #playerUnitIds do
        -- get all player units
        local x, y, rot, scaleX, scaleY = EntityGetTransform(playerUnitIds[i])

        -- find all entities in a specific radius based on the player units position
        local entityIds                 = EntityGetInRadius(x, y, radius) or {}

        table.insertAllButNotDuplicates(entities, entityIds)
    end

    return filterEntities(entities, include, exclude, additionalCheck1, additionalCheck2)
end

--#endregion

--#region Global public variables

EntityUtils.localPlayerEntityId = -1

--#endregion

--#region Global public functions

function EntityUtils.isPlayerPolymorphed()
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        local componentIds = EntityGetComponentIncludingDisabled(polymorphedEntityIds[e],
                                                                 "GameStatsComponent") or {}
        for c = 1, #componentIds do
            local isPlayer = ComponentGetValue2(componentIds[c], "is_player")
            if isPlayer then
                return true, polymorphedEntityIds[e]
            end
        end
    end
    return false, nil
end

function EntityUtils.getLocalPlayerEntityId()
    if EntityUtils.isEntityAlive(EntityUtils.localPlayerEntityId) then
        -- TODO: I think this can lead to problems. Think of polymorphed minä. EntityId will change!
        return EntityUtils.localPlayerEntityId
    end

    local polymorphed, entityId = EntityUtils.isPlayerPolymorphed()

    if polymorphed then
        return entityId
    end

    local playerEntityIds = EntityGetWithTag("player_unit")
    for i = 1, #playerEntityIds do
        if NetworkVscUtils.hasNetworkLuaComponents(playerEntityIds[i]) then
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVcsValuesByEntityId(playerEntityIds[i])
            if compOwnerGuid == localOwner.guid then
                EntityUtils.localPlayerEntityId = playerEntityIds[i]
                return playerEntityIds[i]
            end
        end
    end
    logger:warn(logger.channels.entity,
                "Unable to get local player entity id. Returning first entity id(%s), which was found.",
                playerEntityIds[1])
    EntityUtils.localPlayerEntityId = playerEntityIds[1]
    return playerEntityIds[1]
end

-- --- Assuming this will be called before the other player units will be spawned.
-- --- @return number localPlayerEntityIds
-- function EntityUtils.getLocalPlayerEntityIds()
--     --if not localPlayerEntityId then
--     local playerEntityIds = EntityGetWithTag("player_unit")
--     --if #playerEntityIds > 2 then
--     --        error("Unable to detect the local player unit! This is a serious problem, which needs to be fixed!", 2) -- TODO
--     --    end
--     --    localPlayerEntityId = playerUnits[1]
--     --end
--     return playerEntityIds --return localPlayerEntityId
-- end

--- Looks like there were access to despawned entities, which might cause game crashing.
--- Use this function whenever you work with entity_id/entityId to stop client game crashing.
--- @param entityId number Id of any entity.
--- @return number|nil entityId returns the entityId if is alive, otherwise nil
function EntityUtils.isEntityAlive(entityId)
    if EntityGetIsAlive(entityId) then
        return entityId
    end
    logger:warn(logger.channels.entity, ("Entity (%s) isn't alive anymore! Returning nil."):format(entityId))
    return nil
end

--- Initialise Network VSC.
--- If server then nuid is added.
--- If client then nuid is needed.
function EntityUtils.initNetworkVscs()
    -- if _G.whoAmI() ~= _G.Server.iAm then
    --     error("You are not allowed to init network variable storage components, if not server!", 2)
    -- end

    local radius           = tonumber(ModSettingGetNextValue("noita-mp.radius_include_entities"))
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude,
                                                 function(entityId)
                                                     return not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
                                                 end,
                                                 function(entityId)
                                                     return not
                                                     NetworkVscUtils.hasNetworkLuaComponents(entityId)
                                                 end)
    local owner            = localOwner

    for i = 1, #filteredEntities do
        local entityId                = filteredEntities[i]

        local isNetworkEntity         = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
        local hasNetworkLuaComponents = NetworkVscUtils.hasNetworkLuaComponents(entityId)
        if not isNetworkEntity and not hasNetworkLuaComponents then

            if EntityUtils.isEntityAlive(entityId) then
                local nuid          = nil
                local compId, value = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)

                if not compId or value == "" or value == nil then
                    -- if a nuid on an entity already exists, don't get a new nuid
                    if _G.whoAmI() == _G.Server.iAm then
                        nuid = NuidUtils.getNextNuid()
                    else
                        _G.Client.sendNeedNuid(owner.name, owner.guid, entityId)
                    end
                else
                    nuid = tonumber(value)
                end

                NetworkVscUtils.addOrUpdateAllVscs(entityId, owner.name, owner.guid, nuid)

                if _G.whoAmI() == _G.Server.iAm then
                    GlobalsUtils.setNuid(nuid, entityId)
                    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
                    _G.Server.sendNewNuid(owner, entityId, nuid, x, y, rotation, velocity, filename)
                end
            end

        end
    end
end

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
function EntityUtils.SpawnEntity(owner, nuid, x, y, rotation, velocity, filename, localEntityId, isPolymorphed)
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

    if isPolymorphed then
        local compIds = EntityGetAllComponents(entityId) or {}
        for i = 1, #compIds do
            local compId   = compIds[i]
            local compType = ComponentGetTypeName(compId)
            if string.contains(compType, "AI") then
                EntityRemoveComponent(entityId, compIdAi)
            end
        end
    end

    NetworkVscUtils.addOrUpdateAllVscs(entityId, remoteName, remoteGuid, nuid)
    NoitaComponentUtils.setEntityData(entityId, x, y, rotation, velocity)

    return entityId
end

function EntityUtils.syncEntityData()
    local clientOrServer = nil

    if _G.whoAmI() == Client.iAm then
        clientOrServer = Client
    elseif _G.whoAmI() == Server.iAm then
        clientOrServer = Server
    else
        error("Unable to identify whether I am Client or Server..", 3)
    end

    local anythingChanged  = function(entityId)
        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)

        if clientOrServer.entityCache[entityId] == nil then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].health.current ~= health.current then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].health.max ~= health.max then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].rotation ~= rotation then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].velocity[1] ~= velocity[1] then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].velocity[2] ~= velocity[2] then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].x ~= x then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end

        if clientOrServer.entityCache[entityId].y ~= y then
            clientOrServer.entityCache[entityId] = { health = health, rotation = rotation, velocity = velocity, x = x, y = y }
            return true
        end
    end

    local radius           = tonumber(ModSettingGetNextValue("noita-mp.radius_include_entities"))
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude,
                                                 NetworkVscUtils.isNetworkEntityByNuidVsc,
                                                 anythingChanged)

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]
        clientOrServer.sendEntityData(entityId)
    end
end

function EntityUtils.destroyClientEntities()
    if _G.whoAmI() ~= _G.Client.iAm then
        error("You are not allowed to remove entities, if not client!", 2)
    end

    local radius           = tonumber(ModSettingGetNextValue("noita-mp.radius_exclude_entities"))
    local x, y             = EntityGetTransform(EntityUtils.getLocalPlayerEntityId())
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude,
                                                 function(entityId)
                                                     return not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
                                                 end,
                                                 function(entityId)
                                                     return not
                                                     NetworkVscUtils.hasNetworkLuaComponents(entityId)
                                                 end)

    if #filteredEntities > 0 then
        -- local playerUnitIds = EntityGetWithTag("player_unit")
        -- for i = 1, #playerUnitIds do
        local playerEntityId  = EntityUtils.getLocalPlayerEntityId()
        local playerEntityIds = {}
        table.insertIfNotExist(playerEntityIds, playerEntityId)
        table.insertAllButNotDuplicates(playerEntityIds,
                                        EntityUtils.get_player_inventory_contents("inventory_quick")) -- wands and items
        table.insertAllButNotDuplicates(playerEntityIds,
                                        EntityUtils.get_player_inventory_contents("inventory_full")) -- spells
        table.insertAllButNotDuplicates(playerEntityIds, EntityGetAllChildren(playerEntityId) or {})

        for i = 1, #playerEntityIds do
            local entityId     = playerEntityIds[i]
            local rootEntityId = EntityGetRootEntity(entityId)
            if not NetworkVscUtils.hasNetworkLuaComponents(rootEntityId) then
                NetworkVscUtils.addOrUpdateAllVscs(rootEntityId, localOwner.name, localOwner.guid, nil)
            end
            -- if not NetworkVscUtils.hasNuidSet(entityId) then
            --     Client.sendNeedNuid(localOwner, entityId)
            -- end
        end

        table.removeByTable(filteredEntities, playerEntityIds)
        --end
    end

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]
        if EntityUtils.isEntityAlive(entityId) then

            local kill         = true
            -- Does this entityId belongs to the player minä?
            local componentIds = EntityGetAllComponents(entityId)
            for i = 1, #componentIds do
                local compId   = componentIds[i]
                local compType = ComponentGetTypeName(compId)
                if compType == "ProjectileComponent" then
                    local whoShotEntityId = ComponentGetValue2(compId, "mWhoShot")
                    if not util.IsEmpty(whoShotEntityId) and whoShotEntityId == EntityUtils.getLocalPlayerEntityId() then
                        kill = false
                        break
                    end
                end
            end

            if kill then
                EntityKill(entityId)
            else
                if not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
                    local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
                    if util.IsEmpty(ownerName) or util.IsEmpty(ownerGuid) then
                        local localPlayerInfo = util.getLocalPlayerInfo()
                        ownerName             = localPlayerInfo.name
                        ownerGuid             = localPlayerInfo.guid
                    end
                    NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
                    _G.Client.sendNeedNuid(ownerName, ownerGuid, entityId)
                end
            end
        end
    end
end

function EntityUtils.destroyByNuid(nuid)
    local nNuid, entityId = GlobalsUtils.getNuidEntityPair(nuid)
    if EntityUtils.isEntityAlive(entityId) then
        EntityKill(entityId)
    end
end

-- --- Special thanks to @Coxas/Thighs:
-- --- @param playerUnitEntityId number Player units entity id. (local or remote)
-- --- @param inventoryType string inventoryType can be either "inventory_quick" or "inventory_full".
-- --- @return number|nil inventoryEntityId
-- function EntityUtils.getPlayerInventoryEntityId(playerUnitEntityId, inventoryType)
--     local playerChildrenEntityIds = EntityGetAllChildren(playerUnitEntityId) or {}
--     for i = 1, #playerChildrenEntityIds do
--         local childEntityId = playerChildrenEntityIds[i]
--         if EntityGetName(childEntityId) == inventoryType then
--             return childEntityId -- inventoryEntityId
--         end
--     end
--     return nil
-- end

--- Special thanks to @Horscht:
---@param inventory_type any
---@return table
function EntityUtils.get_player_inventory_contents(inventory_type)
    local player = EntityUtils.getLocalPlayerEntityId() --EntityGetWithTag("player_unit")[1]
    local out = {}
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
    return out
end

function EntityUtils.modifyPhysicsEntities()
    if not util then
        util = require("util")
    end
    if not fu then
        fu = require("file_util")
    end
    if not nxml then
        nxml = require("nxml")
    end

    if util and fu and nxml then
        local files = fu.scanDir("data")
        for index, filePath in ipairs(files) do
            local content = ModTextFileGetContent(filePath)
            if not util.IsEmpty(content) then
                content = content:gsub("kill_entity_after_initialized=\"1\"", "kill_entity_after_initialized=\"0\"")
                local xml = nxml.parse(content)
                for element in xml:each_of("PhysicsImageShapeComponent") do
                    --if element.attr.image_file == root_physics_image_file then
                    element.attr.is_root = "1"
                    --end
                end
                xml:add_child(nxml.parse([[
<PhysicsImageComponent
  is_root = "1"
></PhysicsImageComponent>
]]))
                ModTextFileSetContent(filePath, tostring(xml))
            end
        end
    else
        logger:error("Unable to modify physics entities, because util(%s), fu(%s) and nxml(%s) seems to be nil",
                     util, fu, nxml)
    end
end

--#endregion


-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.EntityUtils = EntityUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return EntityUtils
