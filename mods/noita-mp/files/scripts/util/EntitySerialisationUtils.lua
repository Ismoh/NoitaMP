---
--- Created by Ismoh-PC.
--- DateTime: 25.02.2023 15:47
---
-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------


------------------------------------------------------------------------------------------------------------------------
--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
------------------------------------------------------------------------------------------------------------------------
if require then
    util = require("util")
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    if not util then
        util = dofile("mods/noita-mp/files/scripts/util/util.lua")
    end

    if not CustomProfiler then
        CustomProfiler = {}
        ---@diagnostic disable-next-line: duplicate-set-field
        function CustomProfiler.start(functionName)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.start(functionName %s)")
            --                    :format(functionName))
            return -1
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        function CustomProfiler.stop(functionName, customProfilerCounter)
            --Logger.trace(Logger.channels.entity,
            --            ("NoitaComponents with their restricted Lua context are trying to use CustomProfiler.stop(functionName %s, customProfilerCounter %s)")
            --                    :format(functionName, customProfilerCounter))
            return -1
        end
    end
end

----------------------------------------
--- EntitySerialisationUtils
----------------------------------------
--- Utils class only for serialisation of entities.
EntitySerialisationUtils                             = {}
EntitySerialisationUtils.componentTags               = {
    "activate",
    "aiming_reticle",
    "air",
    "angry_ghost_cooldown",
    "angry_ghost_projectile_memory",
    "area_damage",
    "autoaim_fx",
    "belt_root",
    "blit_target",
    "boss_robot_spell_eater",
    "boss_wizard_laser_multiply",
    "boss_wizard_mode",
    "boss_wizard_state",
    "building",
    "buildup_particles",
    "cape_root",
    "cell_eater",
    "character",
    "charge_indicator",
    "chest_disable",
    "chest_enable",
    "counter",
    "crouch_sensor",
    "crouched",
    "curse",
    "curse_cloud_script",
    "death_reward",
    "disabled",
    "disabled_at_start",
    "disabled_by_liquid",
    "driver",
    "driverless",
    "duck_timer",
    "earth",
    "earth_disable",
    "effect_curse_damage",
    "effect_curse_lifetime",
    "effect_curse_wither_type",
    "effect_protection",
    "effect_protection_all",
    "effect_resistance",
    "effect_worm",
    "effect_worm_attractor",
    "effect_worm_detractor",
    "electricity_effect",
    "enable_when_player_seen",
    "enabled_at_start",
    "enabled_by_liquid",
    "enabled_by_meditation",
    "enabled_by_meditation_early",
    "enabled_by_script",
    "enabled_in_hand",
    "enabled_in_inventory",
    "enabled_in_world",
    "enabled_on_throw",
    "enabled_while_shielding",
    "end",
    "evil_eye_in_hand",
    "eyespot_object",
    "fart",
    "fire",
    "fire_disable",
    "first",
    "flying_energy_bar",
    "fungal_disease",
    "fx",
    "ghost_id",
    "grow",
    "gun",
    "hand",
    "hand_hotspot",
    "hand_l",
    "head",
    "health_bar",
    "health_bar_back",
    "helmet",
    "hitbox_default",
    "hitbox_weak_spot",
    "homing_projectile",
    "homunculus_type",
    "hpcrystal_effect",
    "hungry_ghost_cooldown",
    "igniter",
    "ingestion",
    "invincible",
    "item",
    "item_bg",
    "item_identified",
    "item_identified__LEGACY",
    "item_locked",
    "item_unidentified",
    "item_unlocked",
    "jetpack",
    "kick_count",
    "kick_pos",
    "laser_fx",
    "laser_sight",
    "laser_status",
    "laser_toggle",
    "lukki_disable",
    "lukki_enable",
    "lurker_data",
    "lurkershot_id",
    "magic_eye",
    "magic_eye_check",
    "mana_bar",
    "melee_buildup_particles",
    "modulate_radius",
    "necrobot_entity_file",
    "no_gold_drop",
    "no_hitbox",
    "not_enabled_in_wand",
    "orb_discovered",
    "orb_picked",
    "orb_undiscovered",
    "orbit_projectile_speed",
    "orbit_projectile_type",
    "particles_a",
    "particles_b",
    "particles_c",
    "pata_active",
    "pata_inactive",
    "pata_times_shot",
    "perk_component",
    "perk_reroll_disable",
    "pingpong_path",
    "player_amulet",
    "player_amulet_gem",
    "player_hat",
    "player_hat2",
    "player_hat2_shadow",
    "polyp_homing",
    "protection_all_short",
    "reload_bar",
    "right_arm_root",
    "risky_critical",
    "sacred_barrel",
    "second",
    "shield",
    "shield_hit",
    "shield_ring",
    "shoot_pos",
    "shop_cost",
    "smoke",
    "sound_air_whoosh",
    "sound_damage_curse",
    "sound_digger",
    "sound_jetpack",
    "sound_pick_gold_sand",
    "sound_prebattle_tinkering",
    "sound_spray",
    "sound_suffocating",
    "sound_telekinesis_hold",
    "sound_telekinesis_move",
    "sound_underwater",
    "spray_pos",
    "sunbaby_essences_list",
    "sunbaby_sprite",
    "sunbaby_stage_1",
    "sunbaby_stage_2",
    "sunegg_kills",
    "teleport_closer",
    "teleportitis_dodge_vfx",
    "testcheck",
    "theta",
    "turret_rotate_sound",
    "ui",
    "vacuum_powder_helper",
    "water",
    "with_item",
    "wizard_orb_id",
    "worm_shot_homing"
}
EntitySerialisationUtils.materialTags                = {
    "acid",
    "alchemy",
    "blood",
    "box2d",
    "burnable",
    "burnable_fast",
    "cold",
    "corrodible",
    "earth",
    "evaporable",
    "evaporable_by_fire",
    "evaporable_custom",
    "evaporable_fast",
    "fire",
    "fire_lava",
    "fire_strong",
    "food",
    "freezable",
    "frozen",
    "fungus",
    "gas",
    "gold",
    "grows_fungus",
    "grows_grass",
    "hax",
    "hot",
    "ice",
    "impure",
    "indestructible",
    "lava",
    "liquid",
    "liquid_common",
    "magic_faster",
    "magic_liquid",
    "magic_polymorph",
    "matter_eater_ignore_list",
    "meat",
    "meltable",
    "meltable_by_fire",
    "meltable_metal",
    "meltable_metal_generic",
    "meltable_to_acid",
    "meltable_to_blood",
    "meltable_to_cold",
    "meltable_to_lava",
    "meltable_to_lava_fast",
    "meltable_to_poison",
    "meltable_to_radioactive",
    "meltable_to_slime",
    "meltable_to_water",
    "molten",
    "molten_metal",
    "plant",
    "radioactive",
    "regenerative",
    "regenerative_gas",
    "requires_air",
    "rust",
    "rust_box2d",
    "rust_oxide",
    "sand_ground",
    "sand_metal",
    "sand_other",
    "slime",
    "snow",
    "solid",
    "soluble",
    "static",
    "sunbaby_ignore_list",
    "vapour",
    "water"
}
EntitySerialisationUtils.componentObjectMemberNames  = {
    "attack_melee_finish_config_explosion",
    "config",
    "config_explosion",
    "damage_by_type",
    "damage_critical",
    "damage_multipliers",
    "drug_fx_target",
    "fx_add",
    "fx_multiply",
    "gun_config",
    "gunaction_config",
    "laser",
    "m_drug_fx_current"
}

EntitySerialisationUtils.serializeEntireRootEntity   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntireRootEntity")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entity, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local rootEntityId = EntityGetRootEntity(entityId)
    if not rootEntityId or util.IsEmpty(rootEntityId) then
        error(("Broken Noita API: EntityGetRootEntity(entityId %s) returned nil!"):format(entityId), 2)
    end
    if rootEntityId ~= entityId then
        Logger.trace(Logger.channels.entity,
                     ("Skipping serialisation of entity, because it isn't root. Root is %s!"):format(rootEntityId))
        return nil
    end

    local finished          = false
    local root              = {
        attributes = EntitySerialisationUtils.serializeEntityAttributes(rootEntityId),
        tags       = EntitySerialisationUtils.serializeEntityTags(rootEntityId),
        components = EntitySerialisationUtils.serializeEntityComponents(rootEntityId),
        children   = {}
    }

    local childrenEntityIds = EntityGetAllChildren(rootEntityId) or {}
    for i = 1, #childrenEntityIds do
        local childEntityId         = childrenEntityIds[i]
        root.children[i]            = {}
        root.children[i].attributes = EntitySerialisationUtils.serializeEntityAttributes(childEntityId)
        root.children[i].tags       = EntitySerialisationUtils.serializeEntityTags(childEntityId)
        root.children[i].components = EntitySerialisationUtils.serializeEntityComponents(childEntityId)
        finished                    = true
    end

    CustomProfiler.stop("EntitySerialisationUtils.serializeEntireRootEntity", cpc)
    return finished, root
end

EntitySerialisationUtils.serializeEntityAttributes   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntityAttributes")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entity attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local attributes                                                                                                                        = {}
    attributes.name                                                                                                                         = EntityGetName(entityId)
    attributes.filename                                                                                                                     = EntityGetFilename(entityId)
    attributes.transform                                                                                                                    = {}
    attributes.transform.x, attributes.transform.y, attributes.transform.rotation, attributes.transform.scaleX, attributes.transform.scaleY = EntityGetTransform(entityId)

    CustomProfiler.stop("EntitySerialisationUtils.serializeEntityAttributes", cpc)
    return attributes
end

EntitySerialisationUtils.serializeEntityTags         = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntityTags")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entitys attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end
    local tags = EntityGetTags(entityId)
    CustomProfiler.stop("EntitySerialisationUtils.serializeEntityTags", cpc)
    return tags
end

EntitySerialisationUtils.serializeEntityComponents   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntityComponents")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entity's attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local components   = {}
    local componentIds = EntityGetAllComponents(entityId)

    for i = 1, #componentIds do
        local componentId       = componentIds[i]
        components[i]           = {}
        components[i].isEnabled = ComponentGetIsEnabled(componentId)
        components[i].tags      = EntitySerialisationUtils.serializeComponentTags(componentId)
        components[i].type      = ComponentGetTypeName(componentId)
        -- Credits to NathanSkimScam#4544
        local members           = ComponentGetMembers(componentId) or {}
        for k, v in pairs(members) do
            if v ~= "" then
                components[i][k] = v
            else
                if EntitySerialisationUtils.componentObjectMemberNames[k] then
                    local memberObject = ComponentObjectGetMembers(componentId, k)
                    if not util.IsEmpty(memberObject) then
                        components[i][k] = memberObject
                    end
                end
            end
        end
    end

    CustomProfiler.stop("EntitySerialisationUtils.serializeEntityComponents", cpc)
    return components
end

EntitySerialisationUtils.serializeComponentTags      = function(componentId)
    local cpc  = CustomProfiler.start("EntitySerialisationUtils.serializeComponentTags")
    local tags = {}
    for i = 1, #EntitySerialisationUtils.componentTags do
        local tag = EntitySerialisationUtils.componentTags[i]
        if ComponentHasTag(componentId, tag) then
            tags[tag] = true
        end
    end
    CustomProfiler.stop("EntitySerialisationUtils.serializeComponentTags", cpc)
    return tags
end

EntitySerialisationUtils.deserializeEntireRootEntity = function(serializedRootEntity)
    local cpc      = CustomProfiler.start("EntitySerialisationUtils.deserializeEntireRootEntity")
    local entityId = EntityLoad(serializedRootEntity.attributes.filename, serializedRootEntity.transform.x,
                                serializedRootEntity.transform.y)
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end
    local finished = false
    finished       = EntitySerialisationUtils.deserializeEntityAttributes(entityId, serializedRootEntity)
    finished       = EntitySerialisationUtils.deserializeEntityTags(entityId, serializedRootEntity)

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntireRootEntity", cpc)
end

EntitySerialisationUtils.deserializeEntityAttributes = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityAttributes")
    if util.IsEmpty(entityId) then
        error(("Unable to deserialize entity attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    EntitySetName(entityId, serializedRootEntity.attributes.name)

    EntityApplyTransform(entityId, serializedRootEntity.transform.x, serializedRootEntity.transform.y,
                         serializedRootEntity.transform.rotation, serializedRootEntity.transform.scaleX,
                         serializedRootEntity.transform.scaleY)

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityAttributes", cpc)
    return true
end

EntitySerialisationUtils.deserializeEntityTags       = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityTags")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entitys attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local tags = string.split(serializedRootEntity.tags or {}, ",")
    for i = 1, #tags do
        if not EntityHasTag(serializedRootEntity.tags[i]) then
            EntityAddTag(serializedRootEntity.tags[i])
        end
    end

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityTags", cpc)
    return true
end

EntitySerialisationUtils.deserializeEntityComponents = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityComponents")
    if util.IsEmpty(entityId) then
        error(("Unable to serialize entity's attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local components   = {}
    local componentIds = EntityGetAllComponents(entityId)

    for i = 1, #componentIds do
        local componentId = componentIds[i]
        EntityRemoveComponent(entityId, componentId)
    end

    for i = 1, #serializedRootEntity.components do
        local componentType                          = serializedRootEntity.components[i].type
        local isEnabled                              = serializedRootEntity.components[i].isEnabled
        -- remove non noita values
        serializedRootEntity.components[i].type      = nil
        serializedRootEntity.components[i].isEnabled = nil

        local componentId                            = EntityAddComponent2(entityId, componentType,
                                                                           serializedRootEntity.components[i])
        if EntityUtils.remove.byComponentsName[componentType] then
            -- some components shouldn't be enabled at all in multiplayer?
            -- TODO: remove or do not add at all? instead of disabling?
            isEnabled = false
        end

        EntitySetComponentIsEnabled(entityId, componentId, isEnabled)

        --local members           = ComponentGetMembers(componentId) or {}
        --for k, v in pairs(members) do
        --    if v ~= "" then
        --        components[i][k] = v
        --    else
        --        if EntitySerialisationUtils.componentObjectMemberNames[k] then
        --            local memberObject = ComponentObjectGetMembers(componentId, k)
        --            if not util.IsEmpty(memberObject) then
        --                components[i][k] = memberObject
        --            end
        --        end
        --    end
        --end
    end

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityComponents", cpc)
    return components
end