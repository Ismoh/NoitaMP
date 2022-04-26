-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local util = require("util")
local networkVscUtil = require("NetworkVscUtil")

-----------------
-- EntityUtils:
-----------------
--- class for manipulating entities in Noita
EntityUtils = {}

--#region Global private variables

local initEntitiesCache = {}

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
            if EntityGetFirstComponentIncludingDisabled(entityId, componentName) then
                return true
            end
        end
    end

    for i, entityId in ipairs(entities) do
        if entityMatches(entityId, EntityUtils.include.byFilename, EntityUtils.include.byComponentsName) and
            not entityMatches(entityId, EntityUtils.exclude.byFilename, EntityUtils.exclude.byComponentsName) and
            not table.contains(initEntitiesCache, entityId)
        then
            table.insert(filteredEntities, entityId)
            table.insert(initEntitiesCache, entityId)
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
        local entityIds = EntityGetInRadius(x, y, 150)

        table.insertAll(entities, entityIds)
    end

    return filterEntities(entities)
end

--#endregion

--#region Global public variables

EntityUtils.include = {
    byComponentsName = { "VelocityComponent", "PhysicsBody2Component" },
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
        local nuid = NuidUtils.getNextNuid()
        networkVscUtil.addOrUpdateAllVscs(entityId, owner.username, owner.guid, nuid)
        GlobalsUtils.setNuid(nuid, entityId)

        EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file = "mods/noita-mp/files/scripts/noita-components/nuid_updater.lua",
            execute_on_added = true,
            execute_on_removed = true,
            execute_every_n_frame = -1, -- = -1 -> execute only on add/remove/event
        })

        EntityAddComponent2(entityId, "LuaComponent", {
            script_source_file = "mods/noita-mp/files/scripts/noita-components/nuid_debug.lua",
            execute_every_n_frame = 1,
        })
    end
end

--#endregion

return EntityUtils
