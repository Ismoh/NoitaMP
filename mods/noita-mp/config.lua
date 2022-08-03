if not EntityUtils then
    _G.EntityUtils = {}
end

EntityUtils.include = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename = {}
}
EntityUtils.exclude = {
    byComponentsName = {},
    byFilename = { "particle", "tree_entity.xml", "vegetation" }
}

EntityUtils.remove = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent", "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename = {}
}