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
    name = tostring(ModSettingGet("noita-mp.username")),
    guid = tostring(ModSettingGet("noita-mp.guid"))
}
local localPlayerEntityId = nil

--#endregion

--#region Global private functions

--- Assuming this will be called before the other player units will be spawned.
--- @return number localPlayerEntityId
local function getLocalPlayerEntityId()
    if not localPlayerEntityId then
        local playerUnits = EntityGetWithTag("player_unit")
        if #playerUnits > 2 then
            error("Unable to detect the local player unit! This is a serious problem, which needs to be fixed!", 2) -- TODO
        end
        localPlayerEntityId = playerUnits[1]
    end

    return localPlayerEntityId
end

--- Filters a table of entities by component name or filename. This include and exclude map is defined in EntityUtils.include/.exclude.
--- Credits to @Horscht#6086!
--- @param entities table Usually all entities in a specific radius to the player.
--- @return table filteredEntities
local function filterEntities(entities, include, exclude)
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
            ---@diagnostic disable-next-line: missing-parameter
            if EntityGetComponentIncludingDisabled(entityId, componentName) then
                return true
            end
        end
    end

    for i, entityId in ipairs(entities) do
        local included = entityMatches(entityId, include.byFilename, include.byComponentsName)
        local excluded = entityMatches(entityId, exclude.byFilename, exclude.byComponentsName)

        if included and not excluded then
            local isNetworkEntity = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
            local hasNetworkLuaComponents = NetworkVscUtils.hasNetworkLuaComponents(entityId)
            if not isNetworkEntity and not hasNetworkLuaComponents then
                table.insert(filteredEntities, entityId)
            end
        end
    end

    return filteredEntities
end

--- Gets all entities in a specific radius to the player entities. This can only be executed by server. Entities are filtered by EntityUtils.include/.exclude.
--- @param radius number radius to detect entities.
--- @return table filteredEntities
local function getFilteredEntities(radius, include, exclude)
    local entities = {}

    local playerUnitIds = EntityGetWithTag("player_unit")
    for i = 1, #playerUnitIds do
        -- get all player units
        local x, y, rot, scaleX, scaleY = EntityGetTransform(playerUnitIds[i])

        -- find all entities in a specific radius based on the player units position
        local entityIds = EntityGetInRadius(x, y, radius)

        table.insertAll(entities, entityIds)
    end

    return filterEntities(entities, include, exclude)
end

--#endregion

--#region Global public variables

-- include and exclude list is inside mods\noita-mp\config.lua

--#endregion

--#region Global public functions

--- Looks like there were access to despawned entities, which might cause game crashing.
--- Use this function whenever you work with entity_id/entityId to stop client game crashing.
--- @param entityId number Id of any entity.
--- @return number|nil entityId returns the entityId if is alive, otherwise nil
function EntityUtils.isEntityAlive(entityId)
    if EntityGetIsAlive(entityId) then
        return entityId
    end
    logger:warn("Entity (%s) isn't alive anymore! Returning nil.", entityId)
    return nil
end

function EntityUtils.initNetworkVscs()
    if _G.whoAmI() ~= Server.SERVER then
        error("You are not allowed to init network variable storage components, if not server!", 2)
    end

    local radius = tonumber(ModSettingGetNextValue("noita-mp.radius_include_entities"))
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude)
    local owner = localOwner

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]

        if EntityUtils.isEntityAlive(entityId) then
            local nuid = nil
            local compId, value = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
            if not compId then -- if a nuid on an entity already exists, don't get a new nuid
                nuid = NuidUtils.getNextNuid()
            else
                nuid = tonumber(value)
            end
            NetworkVscUtils.addOrUpdateAllVscs(entityId, owner.username, owner.guid, nuid)
            GlobalsUtils.setNuid(nuid, entityId)

            local x, y, rotation, scaleX, scaleY = EntityGetTransform(entityId)
            ---@diagnostic disable-next-line: missing-parameter
            local veloCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
            local velo_x, velo_y = ComponentGetValue2(veloCompId, "mVelocity")
            local fileName = EntityGetFilename(entityId)
            _G.Server:sendNewNuid(owner, entityId, nuid, x, y, rotation, { velo_x, velo_y }, fileName)
        end
    end
end

function EntityUtils.despawnClientEntities()
    if _G.whoAmI() ~= Client.CLIENT then
        error("You are not allowed to remove entities, if not client!", 2)
    end

    local radius = tonumber(ModSettingGetNextValue("noita-mp.radius_exclude_entities"))
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude)

    if #filteredEntities > 0 then
        -- local playerUnitIds = EntityGetWithTag("player_unit")
        -- for i = 1, #playerUnitIds do
        local playerEntityId = getLocalPlayerEntityId()
        local playerEntities = {}
        table.insertIfNotExist(playerEntities, playerEntityId)
        table.insertIfNotExist(playerEntities, EntityUtils.getPlayerInventoryEntityId(playerEntityId, "inventory_quick"))
        table.insertIfNotExist(playerEntities, EntityUtils.getPlayerInventoryEntityId(playerEntityId, "inventory_full"))
        table.insertAll(playerEntities, EntityGetAllChildren(playerEntityId) or {})

        table.removeByTable(filteredEntities, playerEntities)
        --end
    end

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]
        if EntityUtils.isEntityAlive(entityId) then
            EntityKill(entityId)
        end
    end
end

--- Special thanks to @Coxas/Thighs:
--- @param playerUnitEntityId number Player units entity id. (local or remote)
--- @param inventoryType string inventoryType can be either "inventory_quick" or "inventory_full".
--- @return number|nil inventoryEntityId
function EntityUtils.getPlayerInventoryEntityId(playerUnitEntityId, inventoryType)
    local playerChildrenEntityIds = EntityGetAllChildren(playerUnitEntityId) or {}
    for i = 1, #playerChildrenEntityIds do
        local childEntityId = playerChildrenEntityIds[i]
        if EntityGetName(childEntityId) == inventoryType then
            return childEntityId -- inventoryEntityId
        end
    end
    return nil
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
]]               ))
                ModTextFileSetContent(filePath, tostring(xml))
            end
        end
    else
        logger:error("Unable to modify physics entities, because util(%s), fu(%s) and nxml(%s) seems to be nil", util, fu, nxml)
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
