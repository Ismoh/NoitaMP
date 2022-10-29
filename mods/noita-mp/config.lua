if not EntityUtils then
    --------------------------------------------------------------------------------------------------------------------
    --- EntityUtils
    --- 'Class' for manipulating entities in Noita.
    --- @see config.lua
    --- @see EntityUtils.lua
    --------------------------------------------------------------------------------------------------------------------
    _G.EntityUtils = {}
end

EntityUtils.include = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename       = {}
}
EntityUtils.exclude = {
    byComponentsName = {},
    byFilename       = { "particle", "tree_entity.xml", "vegetation" }
}

EntityUtils.remove  = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent", "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename       = {}
}