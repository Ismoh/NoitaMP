------------------------------------------------------------------------------------------------------------------------
--- This config.lua is for configurable settings, like 'which entities and how should be synced?!'.
--- Furthermore it holds ModSettings, which shouldn't be set by Noita, because one computer shares ModSettings in
---  multiple Noita.exe instances.
--- It also overwrites Noita API functions.
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
        "particle",
        "tree_entity.xml",
        "vegetation",
        "custom_cards",
    }
}

EntityUtils.remove                   = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent", "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename       = { }
}

------------------------------------------------------------------------------------------------------------------------
--- Furthermore it holds ModSettings, which shouldn't be set by Noita, because one computer shares ModSettings in
---  multiple Noita.exe instances.
------------------------------------------------------------------------------------------------------------------------
local NoitaApiModSettingSet          = ModSettingSet
local NoitaApiModSettingGet          = ModSettingGet
local NoitaApiModSettingSetNextValue = ModSettingSetNextValue
local NoitaApiModSettingGetNextValue = ModSettingGetNextValue

if not util then
    if require then
        util = require("util")
    else
        -- when NoitaComponents with their own restricted LuaContext load this file,
        -- util isn't available!
        util = dofile_once("mods/noita-mp/files/scripts/util/util.lua")
        if not MinaUtils and not require then
            MinaUtils = dofile_once("mods/noita-mp/files/scripts/util/MinaUtils.lua")
        end
    end
end

ModSettingSet                                  = function(id, value)
    if id == "noita-mp.name" then
        MinaUtils.setLocalMinaName(value)
    end
    if id == "noita-mp.guid" then
        MinaUtils.setLocalMinaGuid(value)
    end
    NoitaApiModSettingSet(id, value)
end

ModSettingGet                                  = function(id)
    if id == "noita-mp.name" then
        local name = MinaUtils.getLocalMinaName()
        if not util.IsEmpty(name) then
            return name
        else
            name = NoitaApiModSettingGet(id)
            MinaUtils.setLocalMinaName(name)
            return name
        end
    end
    if id == "noita-mp.guid" then
        local guid = MinaUtils.getLocalMinaGuid()
        if not util.IsEmpty(guid) then
            return guid
        else
            guid = NoitaApiModSettingGet(id)
            MinaUtils.setLocalMinaGuid(guid)
            return guid
        end
    end
    return NoitaApiModSettingGet(id)
end

ModSettingSetNextValue                         = function(id, value, is_default)
    if id == "noita-mp.name" then
        name = value
    end
    if id == "noita-mp.guid" then
        guid = value
    end
    NoitaApiModSettingSetNextValue(id, value, is_default)
end

ModSettingGetNextValue                         = function(id)
    if id == "noita-mp.name" and name then
        local name = MinaUtils.getLocalMinaName()
        if not util.IsEmpty(name) then
            return name
        end
    end
    if id == "noita-mp.guid" and guid then
        local guid = MinaUtils.getLocalMinaGuid()
        if not util.IsEmpty(guid) then
            return guid
        end
    end
    return NoitaApiModSettingGetNextValue(id)
end

------------------------------------------------------------------------------------------------------------------------
--- It also overwrites Noita API functions.
------------------------------------------------------------------------------------------------------------------------
local entityLoadToEntity                       = EntityLoadToEntity
EntityLoadToEntity                             = function(filename, entity)
    if EntityGetIsAlive(entity) then
        entityLoadToEntity(filename, entity)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityLoadToEntity(filename '%s', entity '%s'), because entity isn't alive anymore!")
                            :format(filename, entity))
    end
end

local entityKill                               = EntityKill
EntityKill                                     = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        entityKill(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityKill(entity '%s'), because entity isn't alive anymore!"):format(entity_id))
    end
end

local entityAddComponent                       = EntityAddComponent
EntityAddComponent                             = function(entity_id, component_type_name, table_of_component_values)
    if EntityGetIsAlive(entity_id) then
        return entityAddComponent(entity_id, component_type_name, table_of_component_values)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityAddComponent(entity_id %s, component_type_name %s, table_of_component_values %s), because entity isn't alive anymore!")
                            :format(entity_id, component_type_name, table_of_component_values))
    end
end

local entityRemoveComponent                    = EntityRemoveComponent
EntityRemoveComponent                          = function(entity_id, component_id)
    if EntityGetIsAlive(entity_id) then
        entityRemoveComponent(entity_id, component_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityRemoveComponent(entity_id %s, component_id %s), because entity isn't alive anymore!")
                            :format(entity_id, component_id))
    end
end

local entityGetAllComponents                   = EntityGetAllComponents
EntityGetAllComponents                         = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetAllComponents(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetAllComponents(entity_id %s), because entity isn't alive anymore!")
                            :format(entity_id))
    end
end

local entityGetComponent                       = EntityGetComponent
EntityGetComponent                             = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        return entityGetComponent(entity_id, component_type_name, tag)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetComponent(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
                            :format(entity_id, component_type_name, tag))
    end
end

local entityGetFirstComponent                  = EntityGetFirstComponent
EntityGetFirstComponent                        = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        return entityGetFirstComponent(entity_id, component_type_name, tag)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetFirstComponent(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
                            :format(entity_id, component_type_name, tag))
    end
end

local entityGetComponentIncludingDisabled      = EntityGetComponentIncludingDisabled
EntityGetComponentIncludingDisabled            = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        return entityGetComponentIncludingDisabled(entity_id, component_type_name, tag)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetComponentIncludingDisabled(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
                            :format(entity_id, component_type_name, tag))
    end
end

local entityGetFirstComponentIncludingDisabled = EntityGetFirstComponentIncludingDisabled
EntityGetFirstComponentIncludingDisabled       = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        return entityGetFirstComponentIncludingDisabled(entity_id, component_type_name, tag)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetFirstComponentIncludingDisabled(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
                            :format(entity_id, component_type_name, tag))
    end
end

local entitySetTransform                       = EntitySetTransform
EntitySetTransform                             = function(entity_id, x, y, rotation, scale_x, scale_y)
    if EntityGetIsAlive(entity_id) then
        entitySetTransform(entity_id, x, y, rotation, scale_x, scale_y)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntitySetTransform(entity_id %s, x %s, y %s, rotation %s, scale_x %s, scale_y %s), because entity isn't alive anymore!")
                            :format(entity_id, x, y, rotation, scale_x, scale_y))
    end
end

local entityApplyTransform                     = EntityApplyTransform
EntityApplyTransform                           = function(entity_id, x, y, rotation, scale_x, scale_y)
    if EntityGetIsAlive(entity_id) then
        entityApplyTransform(entity_id, x, y, rotation, scale_x, scale_y)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityApplyTransform(entity_id %s, x %s, y %s, rotation %s, scale_x %s, scale_y %s), because entity isn't alive anymore!")
                            :format(entity_id, x, y, rotation, scale_x, scale_y))
    end
end

local entityGetTransform                       = EntityGetTransform
EntityGetTransform                             = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetTransform(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetTransform(entity_id %s), because entity isn't alive anymore!")
                            :format(entity_id))
    end
end

local entityAddChild                           = EntityAddChild
EntityAddChild                                 = function(parent_id, child_id)
    if EntityGetIsAlive(parent_id) and EntityGetIsAlive(child_id) then
        entityAddChild(parent_id, child_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityAddChild(parent_id %s %s, child_id %s %s), because entity isn't alive anymore!")
                            :format(parent_id, EntityGetIsAlive(parent_id), child_id, EntityGetIsAlive(child_id)))
    end
end

local entityGetAllChildren                     = EntityGetAllChildren
EntityGetAllChildren                           = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetAllChildren(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetAllChildren(entity_id %s), because entity isn't alive anymore!")
                            :format(entity_id))
    end
end

local entityGetParent                          = EntityGetParent
EntityGetParent                                = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetParent(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetParent(entity_id %s), because entity isn't alive anymore!")
                            :format(entity_id))
    end
end

local entityGetRootEntity                      = EntityGetRootEntity
EntityGetRootEntity                            = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetRootEntity(entity_id)
    else
        Logger.warn(Logger.channels.entity,
                    ("Unable to EntityGetRootEntity(entity_id %s), because entity isn't alive anymore!")
                            :format(entity_id))
    end
end
------------------------------------------------------------------------------------------------------------------------
--- And in addition for Mod compatibility
------------------------------------------------------------------------------------------------------------------------