--- EntitySerialisationUtils: Utils class only for serialisation of entities.
EntitySerialisationUtils = {}

--- Created by Ismoh-PC.
--- DateTime: 25.02.2023 15:47
---


--- 'Imports'




--- When NoitaComponents are accessing this file, they are not able to access the global variables defined in this file.
--- Therefore, we need to redefine the global variables which we don't have access to, because of NoitaAPI restrictions.
--- This is done by the following code:
if require then
    Utils = require("Utils")
else
    -- Fix stupid Noita sandbox issue. Noita Components does not have access to require.
    if not Utils then
        Utils = dofile("mods/noita-mp/files/scripts/util/Utils.lua")
    end

    if not CustomProfiler then
        ---@type CustomProfiler
        CustomProfiler = {}
        
        ---@diagnostic disable-next-line: duplicate-doc-alias
        ---@alias CustomProfiler.start function(functionName: string): number
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


--- It can happen, that there are more than on component per type.
--- Then we need to know how to determine those.
--- The keys/members listed below can help!
EntitySerialisationUtils.componentIdentifier        = {
    AudioComponent = "event_root",
    AudioLoopComponent = "event_name",
    HotspotComponent = "sprite_hotspot_name",
    ItemComponent = "mItemUid",
    LuaComponent = "script_source_file",
    MagicConvertMaterialComponent = "from_material",
    ParticleEmitterComponent = "emitted_material_name",
    SpriteComponent = "image_file",
    SpriteOffsetAnimatorComponent = "sprite_id",
    VariableStorageComponent = "name",
}
EntitySerialisationUtils.componentTags              = {
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
    "curse_cloud_script",
    "curse",
    "death_reward",
    "disabled_at_start",
    "disabled_by_liquid",
    "disabled",
    "driver",
    "driverless",
    "duck_timer",
    "earth_disable",
    "earth",
    "effect_curse_damage",
    "effect_curse_lifetime",
    "effect_curse_wither_type",
    "effect_protection_all",
    "effect_protection",
    "effect_resistance",
    "effect_worm_attractor",
    "effect_worm_detractor",
    "effect_worm",
    "electricity_effect",
    "enable_when_player_seen",
    "enabled_at_start",
    "enabled_by_liquid",
    "enabled_by_meditation_early",
    "enabled_by_meditation",
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
    "fire_disable",
    "fire",
    "first",
    "flying_energy_bar",
    "fungal_disease",
    "fx",
    "ghost_id",
    "grow",
    "gun",
    "hand_hotspot",
    "hand_l",
    "hand",
    "head",
    "health_bar_back",
    "health_bar",
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
    "item_bg",
    "item_identified__LEGACY",
    "item_identified",
    "item_locked",
    "item_unidentified",
    "item_unlocked",
    "item",
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
    "magic_eye_check",
    "magic_eye",
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
    "player_amulet_gem",
    "player_amulet",
    "player_hat",
    "player_hat2_shadow",
    "player_hat2",
    "polyp_homing",
    "protection_all_short",
    "reload_bar",
    "right_arm_root",
    "risky_critical",
    "sacred_barrel",
    "second",
    "shield_hit",
    "shield_ring",
    "shield",
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
EntitySerialisationUtils.materialTags               = {
    "acid",
    "alchemy",
    "blood",
    "box2d",
    "burnable_fast",
    "burnable",
    "cold",
    "corrodible",
    "earth",
    "evaporable_by_fire",
    "evaporable_custom",
    "evaporable_fast",
    "evaporable",
    "fire_lava",
    "fire_strong",
    "fire",
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
    "liquid_common",
    "liquid",
    "magic_faster",
    "magic_liquid",
    "magic_polymorph",
    "matter_eater_ignore_list",
    "meat",
    "meltable_by_fire",
    "meltable_metal_generic",
    "meltable_metal",
    "meltable_to_acid",
    "meltable_to_blood",
    "meltable_to_cold",
    "meltable_to_lava_fast",
    "meltable_to_lava",
    "meltable_to_poison",
    "meltable_to_radioactive",
    "meltable_to_slime",
    "meltable_to_water",
    "meltable",
    "molten_metal",
    "molten",
    "plant",
    "radioactive",
    "regenerative_gas",
    "regenerative",
    "requires_air",
    "rust_box2d",
    "rust_oxide",
    "rust",
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
EntitySerialisationUtils.unsupportedDataTypes       = {
    "colors",
    "count_per_material_type",
    "debug_path",
    "effects_previous",
    "imgui",
    "ingestion_effect_causes_many",
    "ingestion_effect_causes",
    "ingestion_effects",
    "input",
    "job_result_receiver",
    "jump_trajectories",
    "leftJoint",
    "links",
    "m_cached_image_animation",
    "m_collision_angles",
    "m_ingestion_satiation_material_cache",
    "mAiStateStack",
    "materials",
    "mBody",
    "mCachedTargetSpriteTag",
    "mCollisionMessageMaterialCountsThisFrame",
    "mCollisionMessageMaterials",
    "mCurrentJob",
    "mDamageMaterials",
    "mDamageMaterialsHowMuch",
    "mData",
    "mFallbackLogic",
    "mLastPurchasedAction",
    "mLocalPosition",
    "mLogic",
    "mLuaManager",
    "mMaterialDamageThisFrame",
    "mNode",
    "mPersistentValues",
    "mPhysicsCollisionHax",
    "mRenderList",
    "mSelectedLogic",
    "mSprite",
    "mStainEffectsSmoothedForUI",
    "mState",
    "mStates",
    "mTextureHandle",
    "mTriggers",
    "path_next_node",
    "path_previous_node",
    "path",
    "randomized_position",
    "rightJoint",
    "sprite",
    "stain_effects",
}
--- Looks like some internal types aren't correct.
--- i.e.: ComponentGetValue2 returns number instead of boolean for 'friend_firemage'.
EntitySerialisationUtils.typeFixes                  = {
    friend_firemage = toBoolean,
    friend_thundermage = toBoolean
}
EntitySerialisationUtils.componentObjectMemberNames = {
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


--- @param entityId number
--- @param nuid number|nil nuid can only be nil, when being Client
EntitySerialisationUtils.serializeEntireRootEntity   = function(entityId, nuid)
    local cpc = CustomProfiler.start("EntitySerialisationUtils.serializeEntireRootEntity")
    if Utils.IsEmpty(entityId) then
        error(("Unable to serialize entity, because entityId is %s"):format(entityId), 2)
    end
    if whoAmI() == "SERVER" and Utils.IsEmpty(nuid) then
        error(("Unable to serialize entity, because nuid is '%s' and you're Server!"):format(nuid), 2)
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
        nuid       = nuid,
        attributes = EntitySerialisationUtils.serializeEntityAttributes(rootEntityId),
        _tags      = EntitySerialisationUtils.serializeEntityTags(rootEntityId),
        components = EntitySerialisationUtils.serializeEntityComponents(rootEntityId),
        children   = {}
    }

    local childrenEntityIds = EntityGetAllChildren(rootEntityId) or {}
    for i = 1, #childrenEntityIds do
        local childEntityId = childrenEntityIds[i]
        if not table.contains(EntitySerialisationUtils.ignore.byFilenameOrPath, EntityGetFilename(childEntityId))
            and not table.contains(EntitySerialisationUtils.ignore.byEntityName, EntityGetName(childEntityId)) then
            root.children[i]            = {}
            root.children[i].attributes = EntitySerialisationUtils.serializeEntityAttributes(childEntityId)
            root.children[i]._tags      = EntitySerialisationUtils.serializeEntityTags(childEntityId)
            root.children[i].components = EntitySerialisationUtils.serializeEntityComponents(childEntityId)
        end
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
    attributes.name                                                                                                                         = EntityGetName(
        entityId)
    attributes.filename                                                                                                                     = EntityGetFilename(
        entityId)
    attributes.transform                                                                                                                    = {}
    attributes.transform.x, attributes.transform.y, attributes.transform.rotation, attributes.transform.scaleX, attributes.transform.scaleY =
        EntityGetTransform(entityId)

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
        local componentId = componentIds[i]
        local componentType = ComponentGetTypeName(componentId)
        if not table.contains(EntitySerialisationUtils.ignore.byComponentsType, componentType) then
            components[i]          = {}
            components[i]._enabled = ComponentGetIsEnabled(componentId)
            components[i]._tags    = EntitySerialisationUtils.serializeComponentTags(componentId)
            components[i].type     = componentType

            local members          = ComponentGetMembers(componentId) or {}
            for k, v in pairs(members) do
                -- skip unsupported data types
                if not table.contains(EntitySerialisationUtils.unsupportedDataTypes, k)
                    and not table.contains(EntitySerialisationUtils.ignore.byMemberKey, k) then
                    if table.contains(EntitySerialisationUtils.componentObjectMemberNames, k) then
                        components[i][k]   = {}
                        -- Check for object values like tables
                        local memberObject = ComponentObjectGetMembers(componentId, k) or {}
                        for kObj, vObj in pairs(memberObject) do
                            -- if member objects contains other member objects we cannot access them and need to skip those
                            if not table.contains(EntitySerialisationUtils.componentObjectMemberNames, kObj) then
                                vObj = ComponentObjectGetValue2(componentId, k, kObj)
                                if not Utils.IsEmpty(vObj) then
                                    components[i][k][kObj] = vObj
                                end
                            end
                        end
                    else
                        -- Check for vector values, where ComponentGetValue2 returns more than one value
                        local returnedValues = { ComponentGetValue2(componentId, k) }
                        if #returnedValues > 1 then
                            if k == "friend_firemage" then
                                print("bla!")
                            end
                            v = returnedValues
                        else
                            -- else get value with correct value type: string, number, boolean
                            v = returnedValues[1]
                        end
                        --if not v then -- if not Utils.IsEmpty(v) then -- only check nil not empty string!
                        if EntitySerialisationUtils.typeFixes[k] then
                            v = EntitySerialisationUtils.typeFixes[k](v)
                        end
                        components[i][k] = v
                        --end
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
    local cpc = CustomProfiler.start("EntitySerialisationUtils.deserializeEntireRootEntity")
    if Utils.IsEmpty(serializedRootEntity) then
        error(("Unable to deserialize entity, because serializedRootEntity is '%s'"):format(serializedRootEntity), 2)
    end
    if whoAmI() == "CLIENT" and Utils.IsEmpty(serializedRootEntity.nuid) then
        error(("Unable to deserialize entity, because serializedRootEntity.nuid is '%s' and on Clients nuid has already be set from Server!")
            :format(serializedRootEntity.nuid), 2)
    end

    local serialisedNuid = serializedRootEntity.nuid
    local _, entityId = GlobalsUtils.getNuidEntityPair(serialisedNuid)

    if Utils.IsEmpty(serialisedNuid) or Utils.IsEmpty(entityId) then
        entityId = EntityLoad(serializedRootEntity.attributes.filename, serializedRootEntity.attributes.transform.x,
            serializedRootEntity.attributes.transform.y)
    end

    if Utils.IsEmpty(entityId) then
        error(("Unable to find entityId '%s' for serializedRootEntity '%s'!"):format(entityId, Utils.pformat(serializedRootEntity)), 2)
    end

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

    local processedComponentIds = {}

    for i = 1, #serializedRootEntity.components do
        -- there will be gaps/holes, when there are components, which were completely ignored by serialisation!
        if not Utils.IsEmpty(serializedRootEntity.components[i]) then
            local componentType      = serializedRootEntity.components[i].type
            local componentIsEnabled = serializedRootEntity.components[i]._enabled

            if componentType == "LuaComponent" then
                print("ASFLDJNOSUIFDGHJOSDFJIUG")
            end

            local allComponentsPerType = EntityGetComponentIncludingDisabled(entityId, componentType) or {}
            table.removeByTable(allComponentsPerType, processedComponentIds)                            -- remove already processed components, otherwise next possible match will be used
            if not table.contains(EntitySerialisationUtils.ignore.byComponentsType, componentType) then --- some components shouldn't be enabled or even added in multiplayer?
                -- TODO: add 'isOtherMinaInRange' to if
                local componentId = nil
                if Utils.IsEmpty(allComponentsPerType) then
                    componentId = EntityAddComponent2(entityId, componentType)
                elseif #allComponentsPerType == 1 then
                    componentId = allComponentsPerType[1]
                else
                    for c = 1, #allComponentsPerType do
                        if EntitySerialisationUtils.componentIdentifier[componentType] then
                            local compareValue = ComponentGetValue2(allComponentsPerType[c],
                                EntitySerialisationUtils.componentIdentifier[componentType])
                            if serializedRootEntity.components[i][EntitySerialisationUtils.componentIdentifier[componentType]] == compareValue then
                                componentId = allComponentsPerType[c]
                                break
                            end
                        else
                            if #allComponentsPerType > 1 then
                                print("for debugging only")
                                error("No fycking idea how to match components from server to client!", 2)
                            end
                            componentId = allComponentsPerType[c]
                            break
                        end
                    end
                end

                processedComponentIds[i] = componentId

                if Utils.IsEmpty(componentId) then
                    Logger.warn(Logger.channels.entitySerialisation,
                        ("componentId must not be nil or empty! '%s' No fycking idea how to match components from server to client!")
                        :format(componentId))
                    -- error(
                    --     ("componentId must not be nil or empty! '%s' No fycking idea how to match components from server to client!")
                    --     :format(componentId), 2)
                else
                    EntitySerialisationUtils.deserializeComponentTags(entityId, componentId,
                        serializedRootEntity.components[i])

                    for k, v in pairs(serializedRootEntity.components[i]) do
                        if k ~= "type" and k ~= "_enabled" and k ~= "_tags" then
                            if Utils.IsEmpty(componentId) then
                                Logger.warn(Logger.channels.entitySerialisation,
                                    ("componentId is empty: %s"):format(componentId))
                            elseif Utils.IsEmpty(k) then
                                Logger.warn(Logger.channels.entitySerialisation, ("k is empty: %s"):format(k))
                            elseif Utils.IsEmpty(v) then
                                --Logger.warn(Logger.channels.entitySerialisation, ("v is empty: %s"):format(v))
                            else
                                if table.contains(EntitySerialisationUtils.componentObjectMemberNames, k) then
                                    if k == "impl_position" or k == "delay" or k == "physics_explosion_power" then
                                        print("ASDASDGFFGDSG")
                                    end
                                    for kObj, vObj in pairs(v) do
                                        ComponentObjectSetValue2(componentId, k, kObj, vObj)
                                    end
                                elseif type(v) == "table" then -- if v is a table, we need to use the additional and optional parameters
                                    ComponentSetValue2(componentId,
                                        k, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8],
                                        v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18], v[19],
                                        v[20])
                                else
                                    ComponentSetValue2(componentId, k, v)
                                end
                            end
                        end
                    end
                    EntitySetComponentIsEnabled(entityId, componentId, componentIsEnabled)
                end
            end
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

    local tags = string.split(serialisedComponent._tags or "", ",")
    for i = 1, #tags do
        if not ComponentHasTag(componentId, tags[i]) then
            ComponentAddTag(componentId, tags[i])
        end
    end
    CustomProfiler.stop("EntitySerialisationUtils.serializeComponentTags", cpc)
    return true
end
