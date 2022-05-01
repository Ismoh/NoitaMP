-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

--if not NetworkVscUtils then
--    NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua") --require("NetworkVscUtils")
--end

-----------------
-- EntityUtils:
-----------------
--- class for manipulating entities in Noita
EntityUtils = {}

--#region Global private variables

--local initEntitiesCache = {}

--#endregion

--#region Global private functions

local function getLocalOwner()
    return {
        username = tostring(ModSettingGet("noita-mp.username")),
        guid = tostring(ModSettingGet("noita-mp.guid"))
    }
end

--- Filters a table of entities by component name or filename. This include and exclude map is defined in EntityUtils.include/.exclude.
--- Credits to @Horscht#6086!
--- @param entities table Usually all entities in a specific radius to the player.
--- @return table filteredEntities
local function filterEntities(entities, include, exclude, ignoreNetwork)
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
            if ignoreNetwork or not isNetworkEntity and not hasNetworkLuaComponents then
                table.insert(filteredEntities, entityId)
                --table.insert(initEntitiesCache, entityId)
            end
        end
    end

    return filteredEntities
end

--- Gets all entities in a specific radius to the player entities. This can only be executed by server. Entities are filtered by EntityUtils.include/.exclude.
--- @param radius number radius to detect entities.
--- @return table filteredEntities
local function getFilteredEntities(radius, include, exclude, ignoreNetwork)
    local entities = {}

    local playerUnitIds = EntityGetWithTag("player_unit")
    for i = 1, #playerUnitIds do
        -- get all player units
        local x, y, rot, scaleX, scaleY = EntityGetTransform(playerUnitIds[i])

        -- find all entities in a specific radius based on the player units position
        local entityIds = EntityGetInRadius(x, y, radius)

        table.insertAll(entities, entityIds)
    end

    return filterEntities(entities, include, exclude, ignoreNetwork)
end

--#endregion

--#region Global public variables

EntityUtils.include = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename = {}
}
EntityUtils.exclude = {
    byComponentsName = {},
    byFilename = { "particle", "tree_entity.xml", "vegetation" }
}

--#endregion

--#region Global public functions

--- Looks like there were access to despawned entities, which might cause game crashing.
--- Use this function whenever you work with entity_id/entityId to stop client game crashing.
---@param entityId number Id of any entity.
---@return number|nil entityId returns the entityId if is alive, otherwise nil
function EntityUtils.isEntityAlive(entityId)
    if EntityGetIsAlive(entityId) then
        return entityId
    end
    logger:error("Entity (%s) isn't alive anymore! Returning nil.", entityId)
    return nil
end

function EntityUtils.initNetworkVscs()
    if _G.whoAmI() ~= Server.SERVER then
        error("You are not allowed to init network variable storage components, if not server!", 2)
    end

    local radius = tonumber(ModSettingGetNextValue("noita-mp.radius_include_entities"))
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, EntityUtils.exclude, false)
    local owner = getLocalOwner()

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
    local exclude = { byComponentsName = {}, byFilename = { "player" } }
    local filteredEntities = getFilteredEntities(radius, EntityUtils.include, exclude, false)

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]
        if EntityUtils.isEntityAlive(entityId) then
            EntityKill(entityId)
        end
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
