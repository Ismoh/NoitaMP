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
    Utils = require("Utils")
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    if not Utils then
        Utils = dofile("mods/noita-mp/files/scripts/util/Utils.lua")
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
EntitySerialisationUtils.componentMemberTypes        = {
    additive                                     = "boolean",
    affect_physics_bodies                        = "boolean",
    air_needed                                   = "boolean",
    apply_terminal_velocity                      = "boolean",
    auto_play                                    = "boolean",
    auto_play_if_enabled                         = "boolean",
    berserk_dont_attack_friends                  = "boolean",
    blood_spray_create_some_cosmetic             = "boolean",
    calculate_material_lowpass                   = "boolean",
    call_init_function                           = "boolean",
    camera_bound                                 = "boolean",
    can_kick                                     = "boolean",
    center_camera_on_this_entity                 = "boolean",
    collide_with_gas_and_fire                    = "boolean",
    collide_with_grid                            = "boolean",
    color_is_based_on_pos                        = "boolean",
    cosmetic_force_create                        = "boolean",
    create_ragdoll                               = "boolean",
    create_real_particles                        = "boolean",
    dead                                         = "boolean",
    displace_liquid                              = "boolean",
    draw_as_long                                 = "boolean",
    drop_as_item                                 = "boolean",
    drop_items_on_death                          = "boolean",
    eff_hg_update_box2d                          = "boolean",
    effect_hit_ground                            = "boolean",
    emissive                                     = "boolean",
    emit_cosmetic_particles                      = "boolean",
    emit_real_particles                          = "boolean",
    enable_coroutines                            = "boolean",
    enabled                                      = "boolean",
    execute_on_added                             = "boolean",
    execute_on_removed                           = "boolean",
    fade_based_on_lifetime                       = "boolean",
    fade_stains_towards_srite_top                = "boolean",
    falling_damages                              = "boolean",
    fire_cells_dont_ignite_damagemodel           = "boolean",
    fly_model_player                             = "boolean",
    fly_smooth_y                                 = "boolean",
    flying_needs_recharge                        = "boolean",
    fog_of_war_hole                              = "boolean",
    freeze_on_distance_kill                      = "boolean",
    freeze_on_max_count_kill                     = "boolean",
    gamepad_fire_on_thumbstick_extend            = "boolean",
    gamepad_indirect_aiming_enabled              = "boolean",
    halftime_materials                           = "boolean",
    has_opened_inventory_edit                    = "boolean",
    has_special_scale                            = "boolean",
    image_animation_loop                         = "boolean",
    image_animation_raytrace_from_center         = "boolean",
    image_animation_use_entity_rotation          = "boolean",
    isBroken                                     = "boolean",
    is_death_handled                             = "boolean",
    is_emitting                                  = "boolean",
    is_enemy                                     = "boolean",
    is_immune_to_kicks                           = "boolean",
    is_in_npc                                    = "boolean",
    is_item                                      = "boolean",
    is_on_fire                                   = "boolean",
    is_on_ground                                 = "boolean",
    is_on_slippery_ground                        = "boolean",
    is_player                                    = "boolean",
    is_predator                                  = "boolean",
    is_text_sprite                               = "boolean",
    is_trail                                     = "boolean",
    keyboard_look                                = "boolean",
    kill_entity_after_finished                   = "boolean",
    kill_now                                     = "boolean",
    kill_when_empty                              = "boolean",
    limit_to_max_velocity                        = "boolean",
    mActive                                      = "boolean",
    mAirAreWeInWater                             = "boolean",
    mAirDoWeHave                                 = "boolean",
    mButtonDownAction                            = "boolean",
    mButtonDownChangeItemL                       = "boolean",
    mButtonDownChangeItemR                       = "boolean",
    mButtonDownDig                               = "boolean",
    mButtonDownDown                              = "boolean",
    mButtonDownDropItem                          = "boolean",
    mButtonDownEat                               = "boolean",
    mButtonDownFire                              = "boolean",
    mButtonDownFire2                             = "boolean",
    mButtonDownFly                               = "boolean",
    mButtonDownHolsterItem                       = "boolean",
    mButtonDownInteract                          = "boolean",
    mButtonDownInventory                         = "boolean",
    mButtonDownJump                              = "boolean",
    mButtonDownKick                              = "boolean",
    mButtonDownLeft                              = "boolean",
    mButtonDownLeftClick                         = "boolean",
    mButtonDownRight                             = "boolean",
    mButtonDownRightClick                        = "boolean",
    mButtonDownRun                               = "boolean",
    mButtonDownThrow                             = "boolean",
    mButtonDownTransformDown                     = "boolean",
    mButtonDownTransformLeft                     = "boolean",
    mButtonDownTransformRight                    = "boolean",
    mButtonDownTransformUp                       = "boolean",
    mButtonDownUp                                = "boolean",
    mCollidedHorizontally                        = "boolean",
    mCrouching                                   = "boolean",
    mDisplay_FireRateWaitBar                     = "boolean",
    mFallIsOnGround                              = "boolean",
    mFireTriedIgniting                           = "boolean",
    mForceFireOnNextUpdate                       = "boolean",
    mForceRefresh                                = "boolean",
    mHasChildIconsCached                         = "boolean",
    mHasGamepadControlsPrev                      = "boolean",
    mHasReachedInf                               = "boolean",
    mInitialized                                 = "boolean",
    mIsOnFire                                    = "boolean",
    mIsPrecisionJumping                          = "boolean",
    mItemHolstered                               = "boolean",
    mModAppendsDone                              = "boolean",
    mRequireTriggerPull                          = "boolean",
    mShouldCrouch                                = "boolean",
    mShouldCrouchPrev                            = "boolean",
    m_has_emitted                                = "boolean",
    materials_create_messages                    = "boolean",
    materials_damage                             = "boolean",
    materials_damage_proportional_to_maxhp       = "boolean",
    mouse_look                                   = "boolean",
    move_camera_with_aim                         = "boolean",
    never_ragdollify_on_death                    = "boolean",
    on_death_spill                               = "boolean",
    particle_single_width                        = "boolean",
    physics_objects_damage                       = "boolean",
    play_on_component_enable                     = "boolean",
    play_only_if_visible                         = "boolean",
    polymorph_hax                                = "boolean",
    ragdollify_child_entity_sprites              = "boolean",
    ragdollify_disintegrate_nonroot              = "boolean",
    randomize_position_inside_hitbox             = "boolean",
    remove_after_executed                        = "boolean",
    remove_latest_event_on_destroyed             = "boolean",
    render_back                                  = "boolean",
    render_on_grid                               = "boolean",
    render_ultrabright                           = "boolean",
    report_damage                                = "boolean",
    report_death                                 = "boolean",
    report_new_biomes                            = "boolean",
    rotate_to_surface_normal                     = "boolean",
    run_animation_velocity_switching_enabled     = "boolean",
    send_message_on_event_dead                   = "boolean",
    send_transform_update_message                = "boolean",
    set_latest_event_position                    = "boolean",
    set_magic_creation                           = "boolean",
    set_projectile_to_liquid                     = "boolean",
    set_speed_parameter                          = "boolean",
    set_speed_parameter_only_based_on_x_movement = "boolean",
    set_speed_parameter_only_based_on_y_movement = "boolean",
    smooth_filtering                             = "boolean",
    sprite_centered                              = "boolean",
    sprite_random_rotation                       = "boolean",
    suck_gold                                    = "boolean",
    suck_health                                  = "boolean",
    suck_static_materials                        = "boolean",
    transform_with_scale                         = "boolean",
    ui_force_report_damage                       = "boolean",
    ui_is_parent                                 = "boolean",
    ui_report_damage                             = "boolean",
    update_properties                            = "boolean",
    update_transform                             = "boolean",
    update_transform_rotation                    = "boolean",
    updates_velocity                             = "boolean",
    use_material_inventory                       = "boolean",
    use_rotation_from_entity                     = "boolean",
    use_rotation_from_velocity_component         = "boolean",
    use_velocity_as_rotation                     = "boolean",
    value_bool                                   = "boolean",
    --velocity_always_away_from_center             = "boolean", can be number AND boolean!
    visible                                      = "boolean",
    wait_for_kill_flag_on_death                  = "boolean",
}

EntitySerialisationUtils.serializeEntireRootEntity   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntireRootEntity")
    if Utils.IsEmpty(entityId) then
        error(("Unable to serialize entity, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local rootEntityId = EntityGetRootEntity(entityId)
    if not rootEntityId or Utils.IsEmpty(rootEntityId) then
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
    end

    finished = true
    CustomProfiler.stop("EntitySerialisationUtils.serializeEntireRootEntity", cpc)
    return finished, root
end

EntitySerialisationUtils.serializeEntityAttributes   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntityAttributes")
    if Utils.IsEmpty(entityId) then
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
    if Utils.IsEmpty(entityId) then
        error(("Unable to serialize entitys attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end
    local tags = EntityGetTags(entityId)
    if Utils.IsEmpty(tags) then
        -- let's remove tags, when there aren't any
        tags = nil
    end
    CustomProfiler.stop("EntitySerialisationUtils.serializeEntityTags", cpc)
    return tags
end

EntitySerialisationUtils.serializeEntityComponents   = function(entityId)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntityComponents")
    if Utils.IsEmpty(entityId) then
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
                    if not Utils.IsEmpty(memberObject) then
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
    local tags = ""
    for i = 1, #EntitySerialisationUtils.componentTags do
        local tag = EntitySerialisationUtils.componentTags[i]
        if ComponentHasTag(componentId, tag) then
            tags = ("%s,%s"):format(tags, tag)
        end
    end
    tags = tags:sub(2) -- ",shoot_pos,foo,bar" -> "shoot_pos,foo,bar"
    if Utils.IsEmpty(tags) then
        -- let's remove tags, when there aren't any
        tags = nil
    end
    CustomProfiler.stop("EntitySerialisationUtils.serializeComponentTags", cpc)
    return tags
end

EntitySerialisationUtils.deserializeEntireRootEntity = function(serializedRootEntity)
    local cpc      = CustomProfiler.start("EntitySerialisationUtils.deserializeEntireRootEntity")
    local entityId = EntityLoad(serializedRootEntity.attributes.filename, serializedRootEntity.attributes.transform.x,
                                serializedRootEntity.attributes.transform.y)
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end
    local finished = false
    finished       = EntitySerialisationUtils.deserializeEntityAttributes(entityId, serializedRootEntity)
    finished       = EntitySerialisationUtils.deserializeEntityTags(entityId, serializedRootEntity)
    finished       = EntitySerialisationUtils.deserializeEntityComponents(entityId, serializedRootEntity)

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntireRootEntity", cpc)
end

EntitySerialisationUtils.deserializeEntityAttributes = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityAttributes")
    if Utils.IsEmpty(entityId) then
        error(("Unable to deserialize entity attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    EntitySetName(entityId, serializedRootEntity.attributes.name)

    EntityApplyTransform(entityId,
                         serializedRootEntity.attributes.transform.x,
                         serializedRootEntity.attributes.transform.y,
                         serializedRootEntity.attributes.transform.rotation,
                         serializedRootEntity.attributes.transform.scaleX,
                         serializedRootEntity.attributes.transform.scaleY)

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityAttributes", cpc)
    return true
end

EntitySerialisationUtils.deserializeEntityTags       = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityTags")
    if Utils.IsEmpty(entityId) then
        error(("Unable to serialize entitys attributes, because entityId is %s"):format(entityId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local tags = string.split(serializedRootEntity.tags or "", ",")
    for i = 1, #tags do
        if not EntityHasTag(entityId, tags[i]) then
            EntityAddTag(entityId, tags[i])
        end
    end
    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityTags", cpc)
    return true
end

EntitySerialisationUtils.deserializeEntityComponents = function(entityId, serializedRootEntity)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntityComponents")
    if Utils.IsEmpty(entityId) then
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
        local componentIsEnabled                     = serializedRootEntity.components[i].isEnabled
        -- remove non noita component values
        serializedRootEntity.components[i].type      = nil
        serializedRootEntity.components[i].isEnabled = nil

        --- some components shouldn't be enabled or even added in multiplayer?
        if not table.contains(EntityUtils.remove.byComponentsName, componentType) then
            -- TODO: add 'isOtherMinaInRange' to if
            local componentId = EntityAddComponent2(entityId, componentType)
            EntitySerialisationUtils.deserializeComponentTags(entityId, componentId, serializedRootEntity.components[i])
            -- remove non noita component values
            serializedRootEntity.components[i].tags = nil

            for k, v in pairs(serializedRootEntity.components[i]) do
                -- convert strings, which are booleans to boolean
                if EntitySerialisationUtils.componentMemberTypes[k] then
                    if EntitySerialisationUtils.componentMemberTypes[k] == "number" then
                        -- convert strings, which are numbers to number
                        local num = tonumber(v)
                        if num ~= nil and type(num) == "number" then
                            v = num
                        end
                    end
                    if EntitySerialisationUtils.componentMemberTypes[k] == "boolean" then
                        v = toBoolean(v)
                    end
                    if Utils.IsEmpty(componentId) then
                        Logger.warn(Logger.channels.entitySerialisation,
                                    ("componentId is empty: %s"):format(componentId))
                    elseif Utils.IsEmpty(k) then
                        Logger.warn(Logger.channels.entitySerialisation, ("k is empty: %s"):format(k))
                    elseif Utils.IsEmpty(v) then
                        Logger.warn(Logger.channels.entitySerialisation, ("v is empty: %s"):format(v))
                    else
                        ComponentSetValue2(componentId, k, v)
                    end
                else
                    -- If there is anything, we don't track the type of, use the old api function as a fallback
                    if Utils.IsEmpty(componentId) then
                        Logger.warn(Logger.channels.entitySerialisation,
                                    ("componentId is empty: %s"):format(componentId))
                    elseif Utils.IsEmpty(k) then
                        Logger.warn(Logger.channels.entitySerialisation, ("k is empty: %s"):format(k))
                    elseif Utils.IsEmpty(v) then
                        Logger.warn(Logger.channels.entitySerialisation, ("v is empty: %s"):format(v))
                    else
                        ComponentSetValue(componentId, k, v)
                    end
                end
            end
            EntitySetComponentIsEnabled(entityId, componentId, componentIsEnabled)
        end
    end

    CustomProfiler.stop("EntitySerialisationUtils.deserializeEntityComponents", cpc)
    return true
end

EntitySerialisationUtils.deserializeComponentTags    = function(entityId, componentId, serialisedComponent)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeComponentTags")
    if Utils.IsEmpty(entityId) then
        error(("Unable to deserialize components tags, because entityId is %s, componentId")
                      :format(entityId, componentId), 2)
    end
    if Utils.IsEmpty(componentId) then
        error(("Unable to deserialize components tags, because componentId is %s"):format(componentId), 2)
    end
    if not EntityUtils.isEntityAlive(entityId) then
        error("NOITA SUCKS!", 2)
    end

    local tags = string.split(serialisedComponent.tags or "", ",")
    for i = 1, #tags do
        if not ComponentHasTag(componentId, tags[i]) then
            ComponentAddTag(componentId, tags[i])
        end
    end
    CustomProfiler.stop("EntitySerialisationUtils.serializeComponentTags", cpc)
    return true
end