if not EntityUtils then
    --------------------------------------------------------------------------------------------------------------------
    --- EntityUtils
    --- 'Class' for manipulating entities in Noita.
    --- @see config.lua
    --- @see EntityUtils.lua
    --------------------------------------------------------------------------------------------------------------------
    _G.EntityUtils = {}
end

EntityUtils.maxExecutionTime = 20 --ms = 50 fps
EntityUtils.maxPoolSize      = 10000
EntityUtils.include          = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename       = {}
}
EntityUtils.exclude          = {
    byComponentsName = {},
    byFilename       = {
        --"particle",
        "tree_entity.xml",
        "vegetation",
        -- TODO: REMOVE ME: child spawning issues, should be fixed "data/entities/misc/custom_cards/", -- This somehow occurs when changing wands in inventory
    }
}

EntityUtils.remove           = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent", "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename       = {}
}