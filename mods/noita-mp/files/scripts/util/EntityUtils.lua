-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local util = require("util")
local NetworkVscUtils = require("NetworkVscUtils")

-----------------
-- EntityUtils:
-----------------
--- class for manipulating entities in Noita
EntityUtils = {}

--#region Global private variables

--local initEntitiesCache = {}

--#endregion

--#region Global private functions

--- Filters a table of entities by component name or filename. This include and exclude map is defined in EntityUtils.include/.exclude.
--- Credits to @Horscht#6086!
--- @param entities table Usually all entities in a specific radius to the player.
--- @return table filteredEntities
local function filterEntities(entities)
    local filteredEntities = {}

    local function entityMatches(entityId, filenames, componentNames)
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
        local include = entityMatches(entityId, EntityUtils.include.byFilename, EntityUtils.include.byComponentsName)
        local exclude = entityMatches(entityId, EntityUtils.exclude.byFilename, EntityUtils.exclude.byComponentsName)

        if include and not exclude then
            local isNetworkEntity = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
            local hasNetworkLuaComponents = NetworkVscUtils.hasNetworkLuaComponents(entityId)
            if not isNetworkEntity and not hasNetworkLuaComponents then
                table.insert(filteredEntities, entityId)
                --table.insert(initEntitiesCache, entityId)
            end
        end
    end

    return filteredEntities
end

--- Gets all entities in a specific radius to the player entities. This can only be executed by server. Entities are filtered by EntityUtils.include/.exclude.
---@return table filteredEntities
local function getFilteredEntities()
    if _G.whoAmI() ~= Server.SERVER then
        error("You are not allowed to get all entities, if not server!", 2)
    end

    local entities = {}

    local playerUnitIds = EntityGetWithTag("player_unit")
    for i = 1, #playerUnitIds do
        -- get all player units
        local x, y, rot, scaleX, scaleY = EntityGetTransform(playerUnitIds[i])

        -- find all entities in a specific radius based on the player units position
        local entityIds = EntityGetInRadius(x, y, 100)

        table.insertAll(entities, entityIds)
    end

    return filterEntities(entities)
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

function EntityUtils.initNetworkVscs()
    if _G.whoAmI() ~= Server.SERVER then
        error("You are not allowed to init network variable storage components, if not server!", 2)
    end

    local filteredEntities = getFilteredEntities()
    local owner = util.getLocalOwner()

    for i = 1, #filteredEntities do
        local entityId = filteredEntities[i]
        local nuid = nil
        local compId, value = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
        if not compId then -- if a nuid on an entity already exists, don't get a new nuid
            nuid = NuidUtils.getNextNuid()
        else
            nuid = tonumber(value)
        end
        NetworkVscUtils.addOrUpdateAllVscs(entityId, owner.username, owner.guid, nuid)
        GlobalsUtils.setNuid(nuid, entityId)
    end
end

--#endregion

return EntityUtils
