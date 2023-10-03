local args                                     = { ... }

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

---@class EntityUtils
local entityUtils                              = args[1]

entityUtils.maxExecutionTime                   = 35 --ms = 1000 / 35 = 28,57 fps
entityUtils.maxPoolSize                        = 10000
entityUtils.include                            = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent",
        "PotionComponent" },
    byFilename       = {}
}
entityUtils.exclude                            = {
    byComponentsName = { "WorldStateComponent" },
    byFilename       = { "particle", "tree_entity.xml", "vegetation", "custom_cards" }
}

entityUtils.remove                             = {
    byComponentsName = { "AIComponent", "AdvancedFishAIComponent", "AnimalAIComponent", "ControllerGoombaAIComponent",
        "FishAIComponent", "PhysicsAIComponent", "WormAIComponent" },
    byFilename       = {}
}

------------------------------------------------------------------------------------------------------------------------
--- Furthermore it holds ModSettings, which shouldn't be set by Noita, because one computer shares ModSettings in
---  multiple Noita.exe instances.
------------------------------------------------------------------------------------------------------------------------
local NoitaApiModSettingSet                    = ModSettingSet
local NoitaApiModSettingGet                    = ModSettingGet
local NoitaApiModSettingSetNextValue           = ModSettingSetNextValue
local NoitaApiModSettingGetNextValue           = ModSettingGetNextValue

ModSettingSet                                  = function(id, value)
    if id:contains("noita-mp") then
        --error("Get rid off ModSettings!", 2)
    end
    if id == "noita-mp.nickname" then
        entityUtils.minaUtils:setLocalMinaName(value)
    end
    if id == "noita-mp.guid" then
        entityUtils.minaUtils:setLocalMinaGuid(value)
    end
    NoitaApiModSettingSet(id, value)
end

ModSettingGet                                  = function(id)
    if id:contains("noita-mp") then
        --error("Get rid off ModSettings!", 2)
    end
    if id == "noita-mp.nickname" then
        local name = entityUtils.minaUtils:getLocalMinaName()
        if not entityUtils.utils:isEmpty(name) then
            return name
        else
            name = tostring(NoitaApiModSettingGet(id))
            entityUtils.minaUtils:setLocalMinaName(name)
            return name
        end
    end
    if id == "noita-mp.guid" then
        local guid = entityUtils.minaUtils:getLocalMinaGuid()
        if not entityUtils.utils:isEmpty(guid) then
            return guid
        else
            guid = tostring(NoitaApiModSettingGet(id))
            entityUtils.minaUtils:setLocalMinaGuid(guid)
            return guid
        end
    end
    return NoitaApiModSettingGet(id)
end

ModSettingSetNextValue                         = function(id, value, is_default)
    if id:contains("noita-mp") then
        --error("Get rid off ModSettings!", 2)
    end
    if id == "noita-mp.nickname" then
        name = value
    end
    if id == "noita-mp.guid" then
        guid = value
    end
    NoitaApiModSettingSetNextValue(id, value, is_default)
end

ModSettingGetNextValue                         = function(id)
    if id:contains("noita-mp") then
        --error("Get rid off ModSettings!", 2)
    end
    if id == "noita-mp.nickname" and name then
        local name = entityUtils.minaUtils:getLocalMinaName()
        if not entityUtils.utils:isEmpty(name) then
            return name
        end
    end
    if id == "noita-mp.guid" and guid then
        local guid = entityUtils.minaUtils:getLocalMinaGuid()
        if not entityUtils.utils:isEmpty(guid) then
            return guid
        end
    end
    return NoitaApiModSettingGetNextValue(id)
end

------------------------------------------------------------------------------------------------------------------------
--- It also overwrites Noita API functions.
------------------------------------------------------------------------------------------------------------------------
local entityLoadToEntity                       = _G.EntityLoadToEntity
EntityLoadToEntity                             = function(filename, entity)
    if EntityGetIsAlive(entity) then
        entityLoadToEntity(filename, entity)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityLoadToEntity(filename '%s', entity '%s'), because entity isn't alive anymore!")
            :format(filename, entity))
    end
end

local entityKill                               = _G.EntityKill
EntityKill                                     = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        entityKill(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityKill(entity '%s'), because entity isn't alive anymore!"):format(entity_id))
    end
end

local entityRemoveComponent                    = _G.EntityRemoveComponent
EntityRemoveComponent                          = function(entity_id, component_id)
    if EntityGetIsAlive(entity_id) then
        entityRemoveComponent(entity_id, component_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityRemoveComponent(entity_id %s, component_id %s), because entity isn't alive anymore!")
            :format(entity_id, component_id))
    end
end

local entityGetAllComponents                   = _G.EntityGetAllComponents
EntityGetAllComponents                         = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetAllComponents(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetAllComponents(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return {}
end

local entityGetComponent                       = _G.EntityGetComponent
EntityGetComponent                             = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        if not tag then
            return entityGetComponent(entity_id, component_type_name)
        end
        return entityGetComponent(entity_id, component_type_name, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetComponent(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, tag))
    end
    return nil
end

local entityGetFirstComponent                  = _G.EntityGetFirstComponent
EntityGetFirstComponent                        = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        if not tag then
            return entityGetFirstComponent(entity_id, component_type_name)
        end
        return entityGetFirstComponent(entity_id, component_type_name, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetFirstComponent(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, tag))
    end
    return nil
end

local entityGetComponentIncludingDisabled      = _G.EntityGetComponentIncludingDisabled
EntityGetComponentIncludingDisabled            = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        if not tag then
            return entityGetComponentIncludingDisabled(entity_id, component_type_name)
        end
        return entityGetComponentIncludingDisabled(entity_id, component_type_name, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetComponentIncludingDisabled(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, tag))
    end
    return nil
end

local entityGetFirstComponentIncludingDisabled = _G.EntityGetFirstComponentIncludingDisabled
EntityGetFirstComponentIncludingDisabled       = function(entity_id, component_type_name, tag)
    if EntityGetIsAlive(entity_id) then
        if not tag then
            return entityGetFirstComponentIncludingDisabled(entity_id, component_type_name)
        end
        return entityGetFirstComponentIncludingDisabled(entity_id, component_type_name, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetFirstComponentIncludingDisabled(entity_id %s, component_type_name %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, tag))
    end
    return nil
end

local entitySetTransform                       = _G.EntitySetTransform
EntitySetTransform                             = function(entity_id, x, y, rotation, scale_x, scale_y)
    if EntityGetIsAlive(entity_id) then
        entitySetTransform(entity_id, x, y, rotation, scale_x, scale_y)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntitySetTransform(entity_id %s, x %s, y %s, rotation %s, scale_x %s, scale_y %s), because entity isn't alive anymore!")
            :format(entity_id, x, y, rotation, scale_x, scale_y))
    end
end

local entityApplyTransform                     = _G.EntityApplyTransform
EntityApplyTransform                           = function(entity_id, x, y, rotation, scale_x, scale_y)
    if EntityGetIsAlive(entity_id) then
        entityApplyTransform(entity_id, x, y, rotation, scale_x, scale_y)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityApplyTransform(entity_id %s, x %s, y %s, rotation %s, scale_x %s, scale_y %s), because entity isn't alive anymore!")
            :format(entity_id, x, y, rotation, scale_x, scale_y))
    end
end

local entityGetTransform                       = _G.EntityGetTransform
EntityGetTransform                             = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetTransform(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetTransform(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entityAddChild                           = _G.EntityAddChild
EntityAddChild                                 = function(parent_id, child_id)
    if EntityGetIsAlive(parent_id) and EntityGetIsAlive(child_id) then
        entityAddChild(parent_id, child_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityAddChild(parent_id %s %s, child_id %s %s), because entity isn't alive anymore!")
            :format(parent_id, EntityGetIsAlive(parent_id), child_id, EntityGetIsAlive(child_id)))
    end
end

local entityGetAllChildren                     = _G.EntityGetAllChildren
EntityGetAllChildren                           = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetAllChildren(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetAllChildren(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entityGetParent                          = _G.EntityGetParent
EntityGetParent                                = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetParent(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetParent(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entityGetRootEntity                      = _G.EntityGetRootEntity
EntityGetRootEntity                            = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetRootEntity(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetRootEntity(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entityRemoveFromParent                   = _G.EntityRemoveFromParent
EntityRemoveFromParent                         = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityRemoveFromParent(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityRemoveFromParent(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
end

local entitySetComponentsWithTagEnabled        = _G.EntitySetComponentsWithTagEnabled
EntitySetComponentsWithTagEnabled              = function(entity_id, tag, enabled)
    if EntityGetIsAlive(entity_id) then
        return entitySetComponentsWithTagEnabled(entity_id, tag, enabled)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntitySetComponentsWithTagEnabled(entity_id %s, tag %s, enabled %s), because entity isn't alive anymore!")
            :format(entity_id, tag, enabled))
    end
end

local entitySetComponentIsEnabled              = _G.EntitySetComponentIsEnabled
EntitySetComponentIsEnabled                    = function(entity_id, component_id, is_enabled)
    if EntityGetIsAlive(entity_id) then
        return entitySetComponentIsEnabled(entity_id, component_id, is_enabled)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntitySetComponentIsEnabled(entity_id %s, component_id %s, is_enabled %s), because entity isn't alive anymore!")
            :format(entity_id, component_id, is_enabled))
    end
end

local entityGetName                            = _G.EntityGetName
EntityGetName                                  = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetName(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetName(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entitySetName                            = _G.EntitySetName
EntitySetName                                  = function(entity_id, name)
    if EntityGetIsAlive(entity_id) then
        entitySetName(entity_id, name)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntitySetName(entity_id %s, name %s), because entity isn't alive anymore!")
            :format(entity_id, name))
    end
end

local entityGetTags                            = _G.EntityGetTags
EntityGetTags                                  = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetTags(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetTags(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local entityAddTag                             = _G.EntityAddTag
EntityAddTag                                   = function(entity_id, tag)
    if EntityGetIsAlive(entity_id) then
        entityAddTag(entity_id, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityAddTag(entity_id %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, tag))
    end
end

local entityRemoveTag                          = _G.EntityRemoveTag
EntityRemoveTag                                = function(entity_id, tag)
    if EntityGetIsAlive(entity_id) then
        entityRemoveTag(entity_id, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityRemoveTag(entity_id %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, tag))
    end
end

local entityHasTag                             = _G.EntityHasTag
EntityHasTag                                   = function(entity_id, tag)
    if EntityGetIsAlive(entity_id) then
        return entityHasTag(entity_id, tag)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityHasTag(entity_id %s, tag %s), because entity isn't alive anymore!")
            :format(entity_id, tag))
    end
    return nil
end

local entityGetFilename                        = _G.EntityGetFilename
EntityGetFilename                              = function(entity_id)
    if EntityGetIsAlive(entity_id) then
        return entityGetFilename(entity_id)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityGetFilename(entity_id %s), because entity isn't alive anymore!")
            :format(entity_id))
    end
    return nil
end

local componentAddTag                          = _G.ComponentAddTag
ComponentAddTag                                = function(component_id, tag)
    --if ComponentGetIsEnabled(component_id) then
    componentAddTag(component_id, tag)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentAddTag(component_id %s, tag %s), because component doesn't exist!")
    --                        :format(component_id, tag))
    --end
end

local componentRemoveTag                       = _G.ComponentRemoveTag
ComponentRemoveTag                             = function(component_id, tag)
    --if ComponentGetIsEnabled(component_id) then
    componentRemoveTag(component_id, tag)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentRemoveTag(component_id %s, tag %s), because component doesn't exist!")
    --                        :format(component_id, tag))
    --end
end

local componentHasTag                          = _G.ComponentHasTag
ComponentHasTag                                = function(component_id, tag)
    --if ComponentGetIsEnabled(component_id) then
    return componentHasTag(component_id, tag)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentHasTag(component_id %s, tag %s), because component doesn't exist!")
    --                        :format(component_id, tag))
    --end
    --return nil
end

local componentGetValue2                       = _G.ComponentGetValue2
ComponentGetValue2                             = function(component_id, field_name)
    --if ComponentGetIsEnabled(component_id) then
    return componentGetValue2(component_id, field_name)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentGetValue2(component_id %s, field_name %s), because component doesn't exist!")
    --                        :format(component_id, field_name))
    --end
    --return nil
end

local componentSetValue                        = _G.ComponentSetValue
ComponentSetValue                              = function(component_id, variable_name, value_string)
    --if ComponentGetIsEnabled(component_id) then
    if not value_string then
        error(
            ("value_string must not be nil! ComponentSetValue(component_id '%s', variable_name '%s', value_string '%s')")
            :format(component_id, variable_name, value_string), 2)
    end
    componentSetValue(component_id, variable_name, ("%s"):format(value_string))
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentSetValue(component_id %s, variable_name %s, value_string %s), because component doesn't exist!")
    --                        :format(component_id, variable_name, value_string))
    --end
end

local componentSetValue2                       = _G.ComponentSetValue2
ComponentSetValue2                             = function(component_id, field_name, ...)
    --if ComponentGetIsEnabled(component_id) then
    --if not ... then
    --    error(
    --        ("value_string must not be nil! ComponentSetValue2(component_id '%s', field_name '%s', ... '%s')")
    --        :format(component_id, field_name, ...), 2)
    --end
    componentSetValue2(component_id, field_name, ...)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentSetValue2(component_id %s, field_name %s, value_string %s), because component doesn't exist!")
    --                        :format(component_id, field_name, value_string))
    --end
end

local entityAddComponent                       = _G.EntityAddComponent
EntityAddComponent                             = function(entity_id, component_type_name, table_of_component_values)
    if EntityGetIsAlive(entity_id) then
        return entityAddComponent(entity_id, component_type_name, table_of_component_values)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityAddComponent(entity_id %s, component_type_name %s, table_of_component_values %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, table_of_component_values))
    end
    return nil
end

local entityAddComponent2                      = _G.EntityAddComponent2
EntityAddComponent2                            = function(entity_id, component_type_name, table_of_component_values)
    if EntityGetIsAlive(entity_id) then
        if entityUtils.utils:isEmpty(table_of_component_values) then
            return entityAddComponent2(entity_id, component_type_name)
        else
            if type(table_of_component_values) ~= "table" then
                error(("table_of_component_values is not a table: %s -> %s")
                    :format(type(table_of_component_values), utils:pformat(table_of_component_values)), 2)
            end
            for k, v in pairs(table_of_component_values) do
                if entityUtils.utils:isEmpty(k) then
                    error(("k is empty: %s"):format(k), 2)
                end
                if entityUtils.utils:isEmpty(v) then
                    error(("v is empty: %s"):format(v), 2)
                end
                --if type(v) == "boolean" then
                --    error(("v is type of boolean: type(%s) = %s"):format(v, type(v)), 2)
                --end
            end
        end
        return entityAddComponent2(entity_id, component_type_name, table_of_component_values)
    else
        entityUtils.logger:warn(entityUtils.logger.channels.entity,
            ("Unable to EntityAddComponent2(entity_id %s, component_type_name %s, table_of_component_values %s), because entity isn't alive anymore!")
            :format(entity_id, component_type_name, table_of_component_values))
    end
    return nil
end

local componentGetMembers                      = _G.ComponentGetMembers
ComponentGetMembers                            = function(component_id)
    --if ComponentGetIsEnabled(component_id) then
    return componentGetMembers(component_id)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentGetMembers(component_id %s), because component doesn't exist!")
    --                        :format(component_id))
    --end
    --return nil
end

local componentObjectGetMembers                = _G.ComponentObjectGetMembers
ComponentObjectGetMembers                      = function(component_id, object_name)
    --if ComponentGetIsEnabled(component_id) then
    return componentObjectGetMembers(component_id, object_name)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentGetMembers(component_id %s, object_name %s), because component doesn't exist!")
    --                        :format(component_id, object_name))
    --end
    --return nil
end

local componentGetTypeName                     = _G.ComponentGetTypeName
ComponentGetTypeName                           = function(component_id)
    --if ComponentGetIsEnabled(component_id) then
    return componentGetTypeName(component_id)
    --else
    --    entityUtils.logger:warn(entityUtils.logger.channels.entity,
    --                ("Unable to ComponentGetMembers(component_id %s), because component doesn't exist!")
    --                        :format(component_id))
    --end
    --return nil
end
------------------------------------------------------------------------------------------------------------------------
--- And in addition for Mod compatibility
------------------------------------------------------------------------------------------------------------------------
