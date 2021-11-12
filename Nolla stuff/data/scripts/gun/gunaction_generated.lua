function ConfigGunActionInfo_Init( value )
    value.action_id = ""
    value.action_name = ""
    value.action_description = ""
    value.action_sprite_filename = ""
    value.action_unidentified_sprite_filename = "data/ui_gfx/gun_actions/unidentified.png"
    value.action_type = ACTION_TYPE_PROJECTILE
    value.action_spawn_level = ""
    value.action_spawn_probability = ""
    value.action_spawn_requires_flag = ""
    value.action_spawn_manual_unlock = false
    value.action_max_uses = -1
    value.custom_xml_file = ""
    value.action_mana_drain = 10
    value.action_is_dangerous_blast = false
    value.action_draw_many_count = 0
    value.action_ai_never_uses = false
    value.action_never_unlimited = false
    value.state_shuffled = false
    value.state_cards_drawn = 0
    value.state_discarded_action = false
    value.state_destroyed_action = false
    value.fire_rate_wait = 0
    value.speed_multiplier = 1.0
    value.child_speed_multiplier = 1.0
    value.dampening = 1
    value.explosion_radius = 0
    value.spread_degrees = 0
    value.pattern_degrees = 0
    value.screenshake = 0
    value.recoil = 0
    value.damage_melee_add = 0.0
    value.damage_projectile_add = 0.0
    value.damage_electricity_add = 0.0
    value.damage_fire_add = 0.0
    value.damage_explosion_add = 0.0
    value.damage_ice_add = 0.0
    value.damage_slice_add = 0.0
    value.damage_healing_add = 0.0
    value.damage_curse_add = 0.0
    value.damage_drill_add = 0.0
    value.damage_critical_chance = 0
    value.damage_critical_multiplier = 0.0
    value.explosion_damage_to_materials = 0
    value.knockback_force = 0
    value.reload_time = 0
    value.lightning_count = 0
    value.material = ""
    value.material_amount = 0
    value.trail_material = ""
    value.trail_material_amount = 0
    value.bounces = 0
    value.gravity = 0
    value.light = 0
    value.blood_count_multiplier = 1.0
    value.gore_particles = 0
    value.ragdoll_fx = 0
    value.friendly_fire = false
    value.physics_impulse_coeff = 0
    value.lifetime_add = 0
    value.sprite = ""
    value.extra_entities = ""
    value.game_effect_entities = ""
    value.sound_loop_tag = ""
    value.projectile_file = ""
end

function ConfigGunActionInfo_PassToGame( value )
    RegisterGunAction(
        value.action_id, 
        value.action_name, 
        value.action_description, 
        value.action_sprite_filename, 
        value.action_unidentified_sprite_filename, 
        value.action_type, 
        value.action_spawn_level, 
        value.action_spawn_probability, 
        value.action_spawn_requires_flag, 
        value.action_spawn_manual_unlock, 
        value.action_max_uses, 
        value.custom_xml_file, 
        value.action_mana_drain, 
        value.action_is_dangerous_blast, 
        value.action_draw_many_count, 
        value.action_ai_never_uses, 
        value.action_never_unlimited, 
        value.state_shuffled, 
        value.state_cards_drawn, 
        value.state_discarded_action, 
        value.state_destroyed_action, 
        value.fire_rate_wait, 
        value.speed_multiplier, 
        value.child_speed_multiplier, 
        value.dampening, 
        value.explosion_radius, 
        value.spread_degrees, 
        value.pattern_degrees, 
        value.screenshake, 
        value.recoil, 
        value.damage_melee_add, 
        value.damage_projectile_add, 
        value.damage_electricity_add, 
        value.damage_fire_add, 
        value.damage_explosion_add, 
        value.damage_ice_add, 
        value.damage_slice_add, 
        value.damage_healing_add, 
        value.damage_curse_add, 
        value.damage_drill_add, 
        value.damage_critical_chance, 
        value.damage_critical_multiplier, 
        value.explosion_damage_to_materials, 
        value.knockback_force, 
        value.reload_time, 
        value.lightning_count, 
        value.material, 
        value.material_amount, 
        value.trail_material, 
        value.trail_material_amount, 
        value.bounces, 
        value.gravity, 
        value.light, 
        value.blood_count_multiplier, 
        value.gore_particles, 
        value.ragdoll_fx, 
        value.friendly_fire, 
        value.physics_impulse_coeff, 
        value.lifetime_add, 
        value.sprite, 
        value.extra_entities, 
        value.game_effect_entities, 
        value.sound_loop_tag, 
        value.projectile_file
  )
end
function ConfigGunActionInfo_ReadToLua( action_id, action_name, action_description, action_sprite_filename, action_unidentified_sprite_filename, action_type, action_spawn_level, action_spawn_probability, action_spawn_requires_flag, action_spawn_manual_unlock, action_max_uses, custom_xml_file, action_mana_drain, action_is_dangerous_blast, action_draw_many_count, action_ai_never_uses, action_never_unlimited, state_shuffled, state_cards_drawn, state_discarded_action, state_destroyed_action, fire_rate_wait, speed_multiplier, child_speed_multiplier, dampening, explosion_radius, spread_degrees, pattern_degrees, screenshake, recoil, damage_melee_add, damage_projectile_add, damage_electricity_add, damage_fire_add, damage_explosion_add, damage_ice_add, damage_slice_add, damage_healing_add, damage_curse_add, damage_drill_add, damage_critical_chance, damage_critical_multiplier, explosion_damage_to_materials, knockback_force, reload_time, lightning_count, material, material_amount, trail_material, trail_material_amount, bounces, gravity, light, blood_count_multiplier, gore_particles, ragdoll_fx, friendly_fire, physics_impulse_coeff, lifetime_add, sprite, extra_entities, game_effect_entities, sound_loop_tag, projectile_file )
    __globaldata = {}
    __globaldata.action_id = action_id
    __globaldata.action_name = action_name
    __globaldata.action_description = action_description
    __globaldata.action_sprite_filename = action_sprite_filename
    __globaldata.action_unidentified_sprite_filename = action_unidentified_sprite_filename
    __globaldata.action_type = action_type
    __globaldata.action_spawn_level = action_spawn_level
    __globaldata.action_spawn_probability = action_spawn_probability
    __globaldata.action_spawn_requires_flag = action_spawn_requires_flag
    __globaldata.action_spawn_manual_unlock = action_spawn_manual_unlock
    __globaldata.action_max_uses = action_max_uses
    __globaldata.custom_xml_file = custom_xml_file
    __globaldata.action_mana_drain = action_mana_drain
    __globaldata.action_is_dangerous_blast = action_is_dangerous_blast
    __globaldata.action_draw_many_count = action_draw_many_count
    __globaldata.action_ai_never_uses = action_ai_never_uses
    __globaldata.action_never_unlimited = action_never_unlimited
    __globaldata.state_shuffled = state_shuffled
    __globaldata.state_cards_drawn = state_cards_drawn
    __globaldata.state_discarded_action = state_discarded_action
    __globaldata.state_destroyed_action = state_destroyed_action
    __globaldata.fire_rate_wait = fire_rate_wait
    __globaldata.speed_multiplier = speed_multiplier
    __globaldata.child_speed_multiplier = child_speed_multiplier
    __globaldata.dampening = dampening
    __globaldata.explosion_radius = explosion_radius
    __globaldata.spread_degrees = spread_degrees
    __globaldata.pattern_degrees = pattern_degrees
    __globaldata.screenshake = screenshake
    __globaldata.recoil = recoil
    __globaldata.damage_melee_add = damage_melee_add
    __globaldata.damage_projectile_add = damage_projectile_add
    __globaldata.damage_electricity_add = damage_electricity_add
    __globaldata.damage_fire_add = damage_fire_add
    __globaldata.damage_explosion_add = damage_explosion_add
    __globaldata.damage_ice_add = damage_ice_add
    __globaldata.damage_slice_add = damage_slice_add
    __globaldata.damage_healing_add = damage_healing_add
    __globaldata.damage_curse_add = damage_curse_add
    __globaldata.damage_drill_add = damage_drill_add
    __globaldata.damage_critical_chance = damage_critical_chance
    __globaldata.damage_critical_multiplier = damage_critical_multiplier
    __globaldata.explosion_damage_to_materials = explosion_damage_to_materials
    __globaldata.knockback_force = knockback_force
    __globaldata.reload_time = reload_time
    __globaldata.lightning_count = lightning_count
    __globaldata.material = material
    __globaldata.material_amount = material_amount
    __globaldata.trail_material = trail_material
    __globaldata.trail_material_amount = trail_material_amount
    __globaldata.bounces = bounces
    __globaldata.gravity = gravity
    __globaldata.light = light
    __globaldata.blood_count_multiplier = blood_count_multiplier
    __globaldata.gore_particles = gore_particles
    __globaldata.ragdoll_fx = ragdoll_fx
    __globaldata.friendly_fire = friendly_fire
    __globaldata.physics_impulse_coeff = physics_impulse_coeff
    __globaldata.lifetime_add = lifetime_add
    __globaldata.sprite = sprite
    __globaldata.extra_entities = extra_entities
    __globaldata.game_effect_entities = game_effect_entities
    __globaldata.sound_loop_tag = sound_loop_tag
    __globaldata.projectile_file = projectile_file
end
function ConfigGunActionInfo_Copy( source, dest )
    dest.action_id = source.action_id
    dest.action_name = source.action_name
    dest.action_description = source.action_description
    dest.action_sprite_filename = source.action_sprite_filename
    dest.action_unidentified_sprite_filename = source.action_unidentified_sprite_filename
    dest.action_type = source.action_type
    dest.action_spawn_level = source.action_spawn_level
    dest.action_spawn_probability = source.action_spawn_probability
    dest.action_spawn_requires_flag = source.action_spawn_requires_flag
    dest.action_spawn_manual_unlock = source.action_spawn_manual_unlock
    dest.action_max_uses = source.action_max_uses
    dest.custom_xml_file = source.custom_xml_file
    dest.action_mana_drain = source.action_mana_drain
    dest.action_is_dangerous_blast = source.action_is_dangerous_blast
    dest.action_draw_many_count = source.action_draw_many_count
    dest.action_ai_never_uses = source.action_ai_never_uses
    dest.action_never_unlimited = source.action_never_unlimited
    dest.state_shuffled = source.state_shuffled
    dest.state_cards_drawn = source.state_cards_drawn
    dest.state_discarded_action = source.state_discarded_action
    dest.state_destroyed_action = source.state_destroyed_action
    dest.fire_rate_wait = source.fire_rate_wait
    dest.speed_multiplier = source.speed_multiplier
    dest.child_speed_multiplier = source.child_speed_multiplier
    dest.dampening = source.dampening
    dest.explosion_radius = source.explosion_radius
    dest.spread_degrees = source.spread_degrees
    dest.pattern_degrees = source.pattern_degrees
    dest.screenshake = source.screenshake
    dest.recoil = source.recoil
    dest.damage_melee_add = source.damage_melee_add
    dest.damage_projectile_add = source.damage_projectile_add
    dest.damage_electricity_add = source.damage_electricity_add
    dest.damage_fire_add = source.damage_fire_add
    dest.damage_explosion_add = source.damage_explosion_add
    dest.damage_ice_add = source.damage_ice_add
    dest.damage_slice_add = source.damage_slice_add
    dest.damage_healing_add = source.damage_healing_add
    dest.damage_curse_add = source.damage_curse_add
    dest.damage_drill_add = source.damage_drill_add
    dest.damage_critical_chance = source.damage_critical_chance
    dest.damage_critical_multiplier = source.damage_critical_multiplier
    dest.explosion_damage_to_materials = source.explosion_damage_to_materials
    dest.knockback_force = source.knockback_force
    dest.reload_time = source.reload_time
    dest.lightning_count = source.lightning_count
    dest.material = source.material
    dest.material_amount = source.material_amount
    dest.trail_material = source.trail_material
    dest.trail_material_amount = source.trail_material_amount
    dest.bounces = source.bounces
    dest.gravity = source.gravity
    dest.light = source.light
    dest.blood_count_multiplier = source.blood_count_multiplier
    dest.gore_particles = source.gore_particles
    dest.ragdoll_fx = source.ragdoll_fx
    dest.friendly_fire = source.friendly_fire
    dest.physics_impulse_coeff = source.physics_impulse_coeff
    dest.lifetime_add = source.lifetime_add
    dest.sprite = source.sprite
    dest.extra_entities = source.extra_entities
    dest.game_effect_entities = source.game_effect_entities
    dest.sound_loop_tag = source.sound_loop_tag
    dest.projectile_file = source.projectile_file
end
