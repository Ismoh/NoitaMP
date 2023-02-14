------------------------------------------------------------------------------------------------------------------------
--- This config.lua is for configurable settings, like 'which entities and how should be synced?!'.
--- Furthermore it holds ModSettings, which shouldn't be set by Noita,
--- because one computer shares ModSettings in multiple Noita.exe instances.
--- And in addition for Mod compatibility!
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--- This config.lua is for configurable settings, like 'which entities and how should be synced?!'.
------------------------------------------------------------------------------------------------------------------------
if not EntityUtils then
    --------------------------------------------------------------------------------------------------------------------
    --- EntityUtils
    --- 'Class' for manipulating entities in Noita.
    --- @see config.lua
    --- @see EntityUtils.lua
    --------------------------------------------------------------------------------------------------------------------
    _G.EntityUtils = {}
end

EntityUtils.maxExecutionTime         = 35 --ms = 1000 / 35 = 28,57 fps
EntityUtils.maxPoolSize              = 10000
EntityUtils.include                  = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename       = {}
}
EntityUtils.exclude                  = {
    byComponentsName = {},
    byFilename       = {
        --"particle",
        "tree_entity.xml",
        "vegetation",
        "custom_cards",
    }
}

EntityUtils.remove                   = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent", "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename       = {}
}

------------------------------------------------------------------------------------------------------------------------
--- Furthermore it holds ModSettings, which shouldn't be set by Noita,
--- because one computer shares ModSettings in multiple Noita.exe instances.
------------------------------------------------------------------------------------------------------------------------
local NoitaApiModSettingSet          = ModSettingSet
local NoitaApiModSettingGet          = ModSettingGet
local NoitaApiModSettingSetNextValue = ModSettingSetNextValue
local NoitaApiModSettingGetNextValue = ModSettingGetNextValue

ModSettingSet                        = function(id, value)
    if id == "noita-mp.name" then
        MinaUtils.setLocalMinaName(value)
    end
    if id == "noita-mp.guid" then
        MinaUtils.setLocalMinaGuid(value)
    end
    NoitaApiModSettingSet(id, value)
end

ModSettingGet                        = function(id)
    if id == "noita-mp.name" then
        return MinaUtils.getLocalMinaName()
    end
    if id == "noita-mp.guid" then
        return MinaUtils.getLocalMinaGuid()
    end
    return NoitaApiModSettingGet(id)
end

ModSettingSetNextValue               = function(id, value, is_default)
    if id == "noita-mp.name" then
        name = value
    end
    if id == "noita-mp.guid" then
        guid = value
    end
    NoitaApiModSettingSetNextValue(id, value, is_default)
end

ModSettingGetNextValue               = function(id)
    if id == "noita-mp.name" and name then
        return name
    end
    if id == "noita-mp.guid" and guid then
        return guid
    end
    return NoitaApiModSettingGetNextValue(id)
end



------------------------------------------------------------------------------------------------------------------------
--- And in addition for Mod compatibility
------------------------------------------------------------------------------------------------------------------------