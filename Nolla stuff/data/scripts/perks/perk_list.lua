dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/perks/perk_utilities.lua")

STACKABLE_YES = true
STACKABLE_NO = false

STACKABLE_MAX_AMOUNT = true --this is left for mod backwards compatibility

perk_list =
{
	-- TODO: stackable perks (separate stackable perks)
	-- TODO: stackable perks (separate stackable perks)
	-- VARIOUS
	{
		id = "CRITICAL_HIT",
		ui_name = "$perk_critical_hit",
		ui_description = "$perkdesc_critical_hit",
		ui_icon = "data/ui_gfx/perk_icons/critical_hit.png",
		perk_icon = "data/items_gfx/perks/critical_hit.png",
		game_effect = "CRITICAL_HIT_BOOST",
		particle_effect = "critical_hit_boost",
		stackable = STACKABLE_YES,
		usable_by_enemies = true,
	},
	{
		id = "BREATH_UNDERWATER",
		ui_name = "$perk_breath_underwater",
		ui_description = "$perkdesc_breath_underwater",
		ui_icon = "data/ui_gfx/perk_icons/breath_underwater.png",
		perk_icon = "data/items_gfx/perks/breath_underwater.png",
		game_effect = "BREATH_UNDERWATER",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local swim_idle = math.min( math.max( tonumber( ComponentGetValue( model, "swim_idle_buoyancy_coeff" ) ) * 0.6, 0.0 ), 2.0 )
					local swim_up = math.min( math.max( tonumber( ComponentGetValue( model, "swim_up_buoyancy_coeff" ) ) * 0.2, 0.0 ), 2.0 )
					local swim_down = math.min( math.max( tonumber( ComponentGetValue( model, "swim_down_buoyancy_coeff" ) ) * 0.2, 0.0 ), 2.0 )
					
					local swim_drag = math.min( math.max( tonumber( ComponentGetValue( model, "swim_drag" ) ) * 1.2, 0.0 ), 1.01 )
					local swim_drag_extra = math.min( math.max( tonumber( ComponentGetValue( model, "swim_extra_horizontal_drag" ) ) * 1.2, 0.0 ), 1.01 )
					
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", swim_idle )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", swim_up )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", swim_down )
					
					ComponentSetValue( model, "swim_drag", swim_drag )
					ComponentSetValue( model, "swim_extra_horizontal_drag", swim_drag_extra )
				end
			end

		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", 1.2 )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", 0.9 )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", 0.7 )
					
					ComponentSetValue( model, "swim_drag", 0.95 )
					ComponentSetValue( model, "swim_extra_horizontal_drag", 0.9 )
				end
			end
		end,
	},
	-- gold / money related
	{
		id = "EXTRA_MONEY",
		ui_name = "$perk_extra_money",
		ui_description = "$perkdesc_extra_money",
		ui_icon = "data/ui_gfx/perk_icons/extra_money.png",
		perk_icon = "data/items_gfx/perks/extra_money.png",
		game_effect = "EXTRA_MONEY",
		stackable = STACKABLE_YES,
	},
	{
		id = "EXTRA_MONEY_TRICK_KILL",
		ui_name = "$perk_extra_money_trick_kill",
		ui_description = "$perkdesc_extra_money_trick_kill",
		ui_icon = "data/ui_gfx/perk_icons/extra_money_trick_kill.png",
		perk_icon = "data/items_gfx/perks/extra_money_trick_kill.png",
		game_effect = "EXTRA_MONEY_TRICK_KILL",
		stackable = STACKABLE_YES,
	},
	{
		-- Gold nuggets never go away
		id = "GOLD_IS_FOREVER",
		ui_name = "$perk_gold_is_forever",
		ui_description = "$perkdesc_gold_is_forever",
		ui_icon = "data/ui_gfx/perk_icons/gold_is_forever.png",
		perk_icon = "data/items_gfx/perks/gold_is_forever.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO trick gold, drops blood gold which gives back hp+3
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_gold_is_forever", "1" )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_gold_is_forever", "0" )
				end
			end
		end,
	},
	{
		id = "TRICK_BLOOD_MONEY",
		ui_name = "$perk_trick_blood_money",
		ui_description = "$perkdesc_trick_blood_money",
		ui_icon = "data/ui_gfx/perk_icons/trick_blood_money.png",
		perk_icon = "data/items_gfx/perks/trick_blood_money.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO trick gold, drops blood gold which gives back hp+3
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_trick_kills_blood_money", "1" )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_trick_kills_blood_money", "0" )
				end
			end
		end,
	},
	{
		id = "EXPLODING_GOLD",
		ui_name = "$perk_exploding_gold",
		ui_description = "$perkdesc_exploding_gold",
		ui_icon = "data/ui_gfx/perk_icons/exploding_gold.png",
		perk_icon = "data/items_gfx/perks/exploding_gold.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 6,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GameAddFlagRun( "exploding_gold" )
		end,
		func_remove = function( entity_who_picked )
			GameRemoveFlagRun( "exploding_gold" )
		end,
		
	},
	-- movement related
	{
		id = "HOVER_BOOST",
		ui_name = "$perk_hover_boost",
		ui_description = "$perkdesc_hover_boost",
		ui_icon = "data/ui_gfx/perk_icons/hover_boost.png",
		perk_icon = "data/items_gfx/perks/hover_boost.png",
		game_effect = "HOVER_BOOST",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
	},
	{
		id = "FASTER_LEVITATION",
		ui_name = "$perk_faster_levitation",
		ui_description = "$perkdesc_faster_levitation",
		ui_icon = "data/ui_gfx/perk_icons/faster_levitation.png",
		perk_icon = "data/items_gfx/perks/faster_levitation.png",
		game_effect = "FASTER_LEVITATION",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = math.min( tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * 1.4, 588 )
					ComponentSetValue( model, "pixel_gravity", gravity )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "MOVEMENT_FASTER",
		ui_name = "$perk_movement_faster",
		ui_description = "$perkdesc_movement_faster",
		ui_icon = "data/ui_gfx/perk_icons/movement_faster.png",
		perk_icon = "data/items_gfx/perks/movement_faster.png",
		game_effect = "MOVEMENT_FASTER",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
	},
	--[[
	{
		id = "LOW_GRAVITY",
		ui_name = "$perk_low_gravity",
		ui_description = "$perkdesc_low_gravity",
		ui_icon = "data/ui_gfx/perk_icons/low_gravity.png",
		perk_icon = "data/items_gfx/perks/low_gravity.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * 0.6
					ComponentSetValue( model, "pixel_gravity", gravity )
				end
			end
			
			if ( EntityHasTag( entity_who_picked, "low_gravity" ) == false ) then
				EntityAddTag( entity_who_picked, "low_gravity" )
				
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					script_source_file="data/scripts/perks/low_gravity.lua",
					execute_every_n_frame="80"
				} )
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = ComponentGetValue2( model, "pixel_gravity" ) * 0.6
					ComponentSetValue2( model, "pixel_gravity", gravity )
				end
			end
		end,
	},
	{
		id = "HIGH_GRAVITY",
		ui_name = "$perk_high_gravity",
		ui_description = "$perkdesc_high_gravity",
		ui_icon = "data/ui_gfx/perk_icons/high_gravity.png",
		perk_icon = "data/items_gfx/perks/high_gravity.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name )

			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * 1.4
					ComponentSetValue( model, "pixel_gravity", gravity )
				end
			end
			
			if ( EntityHasTag( entity_who_picked, "high_gravity" ) == false ) then
				EntityAddTag( entity_who_picked, "high_gravity" )
				
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					script_source_file="data/scripts/perks/high_gravity.lua",
					execute_every_n_frame="80"
				} )
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = ComponentGetValue2( model, "pixel_gravity" ) * 1.4
					ComponentSetValue2( model, "pixel_gravity", gravity )
				end
			end
		end,
	},
	{
		id = "SPEED_DIVER",
		ui_name = "$perk_speed_diver",
		ui_description = "$perkdesc_speed_diver",
		ui_icon = "data/ui_gfx/perk_icons/speed_diver.png",
		perk_icon = "data/items_gfx/perks/speed_diver.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local swim_idle = math.min( math.max( tonumber( ComponentGetValue( model, "swim_idle_buoyancy_coeff" ) ) * 0.6, 0.0 ), 2.0 )
					local swim_up = math.min( math.max( tonumber( ComponentGetValue( model, "swim_up_buoyancy_coeff" ) ) * 0.2, 0.0 ), 2.0 )
					local swim_down = math.min( math.max( tonumber( ComponentGetValue( model, "swim_down_buoyancy_coeff" ) ) * 0.2, 0.0 ), 2.0 )
					
					local swim_drag = math.min( math.max( tonumber( ComponentGetValue( model, "swim_drag" ) ) * 1.2, 0.0 ), 1.01 )
					local swim_drag_extra = math.min( math.max( tonumber( ComponentGetValue( model, "swim_extra_horizontal_drag" ) ) * 1.2, 0.0 ), 1.01 )
					
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", swim_idle )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", swim_up )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", swim_down )
					
					ComponentSetValue( model, "swim_drag", swim_drag )
					ComponentSetValue( model, "swim_extra_horizontal_drag", swim_drag_extra )
				end
			end

		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", 1.2 )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", 0.9 )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", 0.7 )
					
					ComponentSetValue( model, "swim_drag", 0.95 )
					ComponentSetValue( model, "swim_extra_horizontal_drag", 0.9 )
				end
			end
		end,
	},
	]]--
	{
		id = "STRONG_KICK",
		ui_name = "$perk_strong_kick",
		ui_description = "$perkdesc_strong_kick",
		ui_icon = "data/ui_gfx/perk_icons/strong_kick.png",
		perk_icon = "data/items_gfx/perks/strong_kick.png",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local kick_force = tonumber( ComponentGetMetaCustom( model, "max_force" ) ) * 1.7
					local player_kick_force = tonumber( ComponentGetMetaCustom( model, "player_kickforce" ) ) * 1.7
					local kick_damage = tonumber( ComponentGetMetaCustom( model, "kick_damage" ) ) + 2.4
					local kick_knockback = tonumber( ComponentGetMetaCustom( model, "kick_knockback" ) ) + 250
					local telekinesis_throw_speed = tonumber( ComponentGetValue2( model, "telekinesis_throw_speed") ) + 25
					local kick_entities = tostring( ComponentGetValue2( model, "kick_entities" ) ) .. ",data/entities/misc/crack_ice.xml"

					ComponentSetMetaCustom( model, "max_force", kick_force )
					ComponentSetMetaCustom( model, "player_kickforce", player_kick_force )
					ComponentSetMetaCustom( model, "kick_damage", kick_damage )
					ComponentSetMetaCustom( model, "kick_knockback", kick_knockback )
					ComponentSetValue2( model, "telekinesis_throw_speed", telekinesis_throw_speed )
					ComponentSetValue2( model, "kick_entities", kick_entities )
				end
			end

			models = EntityGetComponent( entity_who_picked, "TelekinesisComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local throw_speed = tonumber( ComponentGetValue2( model, "throw_speed") ) + 25
					ComponentSetValue2( model, "throw_speed", throw_speed )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetMetaCustom( model, "max_force", 12.0 )
					ComponentSetMetaCustom( model, "player_kickforce", 28.0 )
					ComponentSetMetaCustom( model, "kick_damage", 0.04 )
					ComponentSetMetaCustom( model, "kick_knockback", 3.0 )
					ComponentSetValue2( model, "telekinesis_throw_speed", 25.0 )
					ComponentSetValue2( model, "kick_entities", "" )
				end
			end

			models = EntityGetComponent( entity_who_picked, "TelekinesisComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "throw_speed", 25.0 )
				end
			end
		end,
	},
	{
		id = "TELEKINESIS",
		ui_name = "$perk_telekinesis",
		ui_description = "$perkdesc_telekinesis",
		ui_icon = "data/ui_gfx/perk_icons/telekinesis.png",
		perk_icon = "data/items_gfx/perks/telekinesis.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityLoadToEntity( "data/entities/misc/perk_telekinesis.xml", entity_who_picked )
			-- component_write( EntityGetFirstComponent( entity_who_picked, "KickComponent" ), { can_kick = false } )
			
			local throw_speed = 25
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "can_kick", false )
					local ts = tonumber( ComponentGetValue2( model, "telekinesis_throw_speed" ) )
					if( ts > throw_speed ) then throw_speed = ts end
				end
			end
			-- component_write( EntityGetFirstComponent( entity_who_picked, "TelekinesisComponent" ), { throw_speed = throw_speed } )
			local tks = EntityGetFirstComponent( entity_who_picked, "TelekinesisComponent" )
			if( tks ~= nil ) then ComponentSetValue2( tks, "throw_speed", throw_speed ) end
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "can_kick", true )
				end
			end
		end,
	},
	{
		id = "REPELLING_CAPE",
		ui_name = "$perk_repelling_cape",
		ui_description = "$perkdesc_repelling_cape",
		ui_icon = "data/ui_gfx/perk_icons/repelling_cape.png",
		perk_icon = "data/items_gfx/perks/repelling_cape.png",
		game_effect = "STAINS_DROP_FASTER",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 8,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
	},
	{
		id = "EXPLODING_CORPSES",
		ui_name = "$perk_exploding_corpses",
		ui_description = "$perkdesc_exploding_corpses",
		ui_icon = "data/ui_gfx/perk_icons/exploding_corpses.png",
		perk_icon = "data/items_gfx/perks/exploding_corpses.png",
		remove_other_perks = {"PROTECTION_EXPLOSION"},
		stackable = STACKABLE_NO,
		game_effect = "EXPLODING_CORPSE_SHOTS",
		game_effect2 = "PROTECTION_EXPLOSION",
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, -1)
		end,
	},
	{
		id = "SAVING_GRACE",
		ui_name = "$perk_saving_grace",
		ui_description = "$perkdesc_saving_grace",
		ui_icon = "data/ui_gfx/perk_icons/saving_grace.png",
		perk_icon = "data/items_gfx/perks/saving_grace.png",
		game_effect = "SAVING_GRACE",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, 1)
		end,
	},
	{
		id = "INVISIBILITY",
		ui_name = "$perk_invisibility",
		ui_description = "$perkdesc_invisibility",
		ui_icon = "data/ui_gfx/perk_icons/invisibility.png",
		perk_icon = "data/items_gfx/perks/invisibility.png",
		game_effect = "INVISIBILITY",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func_remove = function( entity_who_picked )
			local s = EntityGetComponent( entity_who_picked, "SpriteComponent" )
			if ( s ~= nil ) then
				for a,b in ipairs( s ) do
					ComponentSetValue2( b, "alpha", 1.0 )
				end
			end
		end,
	},
	{
		id = "GLOBAL_GORE",
		ui_name = "$perk_global_gore",
		ui_description = "$perkdesc_global_gore",
		ui_icon = "data/ui_gfx/perk_icons/global_gore.png",
		perk_icon = "data/items_gfx/perks/global_gore.png",
		game_effect = "GLOBAL_GORE",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, -1)
		end,
	},
	{
		id = "REMOVE_FOG_OF_WAR",
		ui_name = "$perk_remove_fog_of_war",
		ui_description = "$perkdesc_remove_fog_of_war",
		ui_icon = "data/ui_gfx/perk_icons/remove_fog_of_war.png",
		perk_icon = "data/items_gfx/perks/remove_fog_of_war.png",
		game_effect = "REMOVE_FOG_OF_WAR",
		stackable = STACKABLE_NO,
	},
	{
		id = "LEVITATION_TRAIL",
		ui_name = "$perk_levitation_trail",
		ui_description = "$perkdesc_levitation_trail",
		ui_icon = "data/ui_gfx/perk_icons/levitation_trail.png",
		perk_icon = "data/items_gfx/perks/levitation_trail.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags="perk_component",
				script_source_file="data/scripts/perks/levitation_trail.lua",
				execute_every_n_frame="3"
			} )
		end,
	},
	--[[
	-- NOTE( Petri ): Removed NO_DAMAGE_FLASH, because its not really a useful perk
	{
		id = "NO_DAMAGE_FLASH",
		ui_name = "$perk_no_damage_flash",
		ui_description = "$perkdesc_no_damage_flash",
		ui_icon = "data/ui_gfx/perk_icons/no_damage_flash.png",
		perk_icon = "data/items_gfx/perks/no_damage_flash.png",
		game_effect = "NO_DAMAGE_FLASH",
	},
	]]--
	--[[{
		id = "REVERSE_SLOWDOWN",
		ui_name = "$perk_reverse_slowdown",
		ui_description = "$perkdesc_reverse_slowdown",
		ui_icon = "data/ui_gfx/material_indicators/hp_regeneration.png",
		game_effect = "MOVEMENT_REVERSE_SLOWDOWN",
	},]]--

	
	-- HP AFFECTORS
	{
		id = "VAMPIRISM",
		ui_name = "$perk_vampirism",
		ui_description = "$perkdesc_vampirism",
		ui_icon = "data/ui_gfx/perk_icons/vampirism.png",
		perk_icon = "data/items_gfx/perks/vampirism.png",
		game_effect = "HEALING_BLOOD",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) ) * 0.75

					max_hp = math.ceil( max_hp * 25 ) / 25
					
					ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
				end
			end

			add_halo_level(entity_who_picked, -1)
		end,
	},
	{
		id = "EXTRA_HP",
		ui_name = "$perk_extra_hp",
		ui_description = "$perkdesc_extra_hp",
		ui_icon = "data/ui_gfx/perk_icons/extra_hp.png",
		perk_icon = "data/items_gfx/perks/extra_hp.png",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 3,
		one_off_effect = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local old_max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )
					local max_hp = old_max_hp * 1.5
					
					local max_hp_cap = tonumber( ComponentGetValue( damagemodel, "max_hp_cap" ) )
					if max_hp_cap > 0 then
						max_hp = math.min( max_hp, max_hp_cap )
					end
					
					local current_hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					current_hp = math.min( current_hp + math.abs(max_hp - old_max_hp), max_hp )
					
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "hp", current_hp )
				end
			end
		end,
	},
	--[[
	{
		id = "MULTIPLY_HP",
		ui_name = "$perk_multiply_hp",
		ui_description = "$perkdesc_multiply_hp",
		ui_icon = "data/ui_gfx/perk_icons/multiply_hp.png",
		perk_icon = "data/items_gfx/perks/multiply_hp.png",
		--game_effect = "CANNOT_HEAL",
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO Game effect -> (CANNOT_HEAL) Player cannot regain HP
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local old_max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )
					local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) ) * 3
					
					local max_hp_cap = tonumber( ComponentGetValue( damagemodel, "max_hp_cap" ) )
					if max_hp_cap > 0 then
						max_hp = math.min( max_hp, max_hp_cap )
					end
					
					local current_hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					current_hp = math.min( current_hp + math.abs(max_hp - old_max_hp), max_hp )
					
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "hp", current_hp )
				end
			end
			
		end,
	},
	]]--
	{
		id = "HEARTS_MORE_EXTRA_HP",
		ui_name = "$perk_hearts_more_extra_hp",
		ui_description = "$perkdesc_hearts_more_extra_hp",
		ui_icon = "data/ui_gfx/perk_icons/hearts_more_extra_hp.png",
		perk_icon = "data/items_gfx/perks/hearts_more_extra_hp.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 9,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO heart containers give 2x more health
			local heart_multiplier = tonumber( GlobalsGetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" ) )
			
			if ( heart_multiplier < 2.0 ) then
				heart_multiplier = heart_multiplier + 1.0
			elseif ( heart_multiplier < 4 ) then
				heart_multiplier = heart_multiplier + 0.25
			end
			
			GlobalsSetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", tostring( heart_multiplier ) )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" )
		end,
	},
	{
		id = "GLASS_CANNON",
		ui_name = "$perk_glass_cannon",
		ui_description = "$perkdesc_glass_cannon",
		ui_icon = "data/ui_gfx/perk_icons/glass_cannon.png",
		perk_icon = "data/items_gfx/perks/glass_cannon.png",
		game_effect = "DAMAGE_MULTIPLIER",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 2,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					local max_hp = 50 / 25
					
					--ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "max_hp_cap", max_hp )
					ComponentSetValue( damagemodel, "hp", max_hp )
				end
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					local max_hp = 50 / 25
					
					--ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "max_hp_cap", max_hp )
					ComponentSetValue( damagemodel, "hp", max_hp )
				end
			end
			
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/glass_cannon_enemy.lua",
				execute_every_n_frame = "-1",
			} )
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) ) * 25
					ComponentSetValue( damagemodel, "max_hp_cap", 0.0 )
					
					if ( max_hp < 100 ) then
						ComponentSetValue( damagemodel, "max_hp", 4 )
						ComponentSetValue( damagemodel, "hp", 4 )
					end
				end
			end
		end,
	},
	{
		id = "LOW_HP_DAMAGE_BOOST",
		ui_name = "$perk_low_hp_damage_boost",
		ui_description = "$perkdesc_low_hp_damage_boost",
		ui_icon = "data/ui_gfx/perk_icons/low_hp_damage_boost.png",
		perk_icon = "data/items_gfx/perks/low_hp_damage_boost.png",
		game_effect = "LOW_HP_DAMAGE_BOOST",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_shot = "data/scripts/perks/low_hp_damage_boost_enemy.lua",
				execute_every_n_frame = "-1",
			} )
		end,
	},
	{
		id = "RESPAWN",
		ui_name = "$perk_respawn",
		ui_description = "$perkdesc_respawn",
		ui_icon = "data/ui_gfx/perk_icons/respawn.png",
		perk_icon = "data/items_gfx/perks/respawn.png",
		game_effect = "RESPAWN",
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, 1)
		end,
	},

	{
		id = "WORM_ATTRACTOR",
		ui_name = "$perk_worm_attractor",
		ui_description = "$perkdesc_worm_attractor",
		ui_icon = "data/ui_gfx/perk_icons/worm_attractor.png",
		perk_icon = "data/items_gfx/perks/worm_attractor.png",
		game_effect = "WORM_ATTRACTOR",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
	},
	{
		id = "RADAR_ENEMY",
		ui_name = "$perk_radar_enemy",
		ui_description = "$perkdesc_radar_enemy",
		ui_icon = "data/ui_gfx/perk_icons/radar_enemy.png",
		perk_icon = "data/items_gfx/perks/radar_enemy.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "FOOD_CLOCK",
		ui_name = "$perk_food_clock",
		ui_description = "$perkdesc_food_clock",
		ui_icon = "data/ui_gfx/perk_icons/mystery_eggplant.png",
		perk_icon = "data/items_gfx/perks/mystery_eggplant.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/food_clock.lua",
				execute_every_n_frame = "60",
			} )
			
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "food_clock",
			} )
			
			local x,y = EntityGetTransform( entity_perk_item )
			EntityLoad( "data/entities/items/pickup/potion_porridge.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
			
			local comp = EntityGetFirstComponent( entity_who_picked, "IngestionComponent" )

			if ( comp ~= nil ) then
				local size = ComponentGetValue2( comp, "ingestion_size" )
				local capacity = ComponentGetValue2( comp, "ingestion_capacity" )
				component_write( comp,
				{
					ingestion_cooldown_delay_frames = 400,
					ingestion_reduce_every_n_frame = 3,
					ingestion_size = math.max( size, capacity / 4 * 3 ),
					ingestion_satiation_material_tag = "[food]",
				})
				
			end
		end,
		func_remove = function( entity_who_picked )
			local comp = EntityGetFirstComponent( entity_who_picked, "IngestionComponent" )

			if ( comp ~= nil ) then
				component_write( comp,
				{
					ingestion_cooldown_delay_frames = 600,
					ingestion_reduce_every_n_frame = 5,
					ingestion_size = 7500,
					ingestion_satiation_material_tag = "",
				})
				
			end
		end,
	},
	{
		id = "IRON_STOMACH",
		ui_name = "$perk_iron_stomach",
		ui_description = "$perkdesc_iron_stomach",
		ui_icon = "data/ui_gfx/perk_icons/iron_stomach.png",
		perk_icon = "data/items_gfx/perks/iron_stomach.png",
		game_effect = "IRON_STOMACH",
		stackable = STACKABLE_NO,
	},
	{
		id = "WAND_RADAR",
		ui_name = "$perk_radar_wand",
		ui_description = "$perkdesc_radar_wand",
		ui_icon = "data/ui_gfx/perk_icons/radar_wand.png",
		perk_icon = "data/items_gfx/perks/radar_wand.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_wand.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "ITEM_RADAR",
		ui_name = "$perk_radar_item",
		ui_description = "$perkdesc_radar_item",
		ui_icon = "data/ui_gfx/perk_icons/radar_item.png",
		perk_icon = "data/items_gfx/perks/radar_item.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_item.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "MOON_RADAR",
		ui_name = "$perk_radar_moon",
		ui_description = "$perkdesc_radar_moon",
		ui_icon = "data/ui_gfx/perk_icons/radar_moon.png",
		perk_icon = "data/items_gfx/perks/radar_moon.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_moon.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "MAP",
		ui_name = "$perk_map",
		ui_description = "$perkdesc_map",
		ui_icon = "data/ui_gfx/perk_icons/map.png",
		perk_icon = "data/items_gfx/perks/map.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/map.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	-- RESISTANCE AFFECTORS
	{
		id = "PROTECTION_FIRE",
		ui_name = "$perk_protection_fire",
		ui_description = "$perkdesc_protection_fire",
		ui_icon = "data/ui_gfx/perk_icons/protection_fire.png",
		perk_icon = "data/items_gfx/perks/protection_fire.png",
		game_effect = "PROTECTION_FIRE",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "PROTECTION_RADIOACTIVITY",
		ui_name = "$perk_protection_radioactivity",
		ui_description = "$perkdesc_protection_radioactivity",
		ui_icon = "data/ui_gfx/perk_icons/protection_radioactivity.png",
		perk_icon = "data/items_gfx/perks/protection_radioactivity.png",
		game_effect = "PROTECTION_RADIOACTIVITY",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "PROTECTION_EXPLOSION",
		ui_name = "$perk_protection_explosion",
		ui_description = "$perkdesc_protection_explosion",
		ui_icon = "data/ui_gfx/perk_icons/protection_explosion.png",
		perk_icon = "data/items_gfx/perks/protection_explosion.png",
		game_effect = "PROTECTION_EXPLOSION",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "PROTECTION_MELEE",
		ui_name = "$perk_protection_melee",
		ui_description = "$perkdesc_protection_melee",
		ui_icon = "data/ui_gfx/perk_icons/protection_melee.png",
		perk_icon = "data/items_gfx/perks/protection_melee.png",
		game_effect = "PROTECTION_MELEE",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "PROTECTION_ELECTRICITY",
		ui_name = "$perk_protection_electricity",
		ui_description = "$perkdesc_protection_electricity",
		ui_icon = "data/ui_gfx/perk_icons/protection_electricity.png",
		perk_icon = "data/items_gfx/perks/protection_electricity.png",
		game_effect = "PROTECTION_ELECTRICITY",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	--[[
	{
		id = "PROTECTION_FREEZE",
		ui_name = "$perk_protection_freeze",
		ui_description = "$perkdesc_protection_freeze",
		ui_icon = "data/ui_gfx/perk_icons/protection_freeze.png",
		perk_icon = "data/items_gfx/perks/protection_freeze.png",
		game_effect = "PROTECTION_FREEZE",
		usable_by_enemies = true,
	},
	]]--
	-- PROTECTION ACID
	-- PROTECTION FREEZE
	{
		id = "TELEPORTITIS",
		ui_name = "$perk_teleportitis",
		ui_description = "$perkdesc_teleportitis", -- TODO "and gain a shield for a short duration."
		ui_icon = "data/ui_gfx/perk_icons/teleportitis.png",
		perk_icon = "data/items_gfx/perks/teleportitis.png",
		game_effect = "TELEPORTITIS",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "TELEPORTITIS_DODGE",
		ui_name = "$perk_teleportitis_dodge",
		ui_description = "$perkdesc_teleportitis_dodge",
		ui_icon = "data/ui_gfx/perk_icons/teleportitis_dodge.png",
		perk_icon = "data/items_gfx/perks/teleportitis_dodge.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/teleportitis_dodge.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "STAINLESS_ARMOUR",
		ui_name = "$perk_stainless_armour",
		ui_description = "$perkdesc_stainless_armour",
		ui_icon = "data/ui_gfx/perk_icons/stainless_armour.png",
		perk_icon = "data/items_gfx/perks/stainless_armour.png",
		game_effect = "STAINLESS_ARMOUR",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
	},

	-- WAND & ACTION AFFECTORS
	{
		id = "EDIT_WANDS_EVERYWHERE",
		ui_name = "$perk_edit_wands_everywhere",
		ui_description = "$perkdesc_edit_wands_everywhere",
		ui_icon = "data/ui_gfx/perk_icons/edit_wands_everywhere.png",
		perk_icon = "data/items_gfx/perks/edit_wands_everywhere.png",
		game_effect = "EDIT_WANDS_EVERYWHERE",
		stackable = STACKABLE_NO,
	},
	{
		id = "NO_WAND_EDITING",
		ui_name = "$perk_no_wand_editing",
		ui_description = "$perkdesc_no_wand_editing",
		ui_icon = "data/ui_gfx/perk_icons/no_wand_editing.png",
		perk_icon = "data/items_gfx/perks/no_wand_editing.png",
		game_effect = "NO_WAND_EDITING",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					-- 6% chance of dropping blood money
					local perk_hp_drop_chance = tonumber( ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) )
					perk_hp_drop_chance = perk_hp_drop_chance + 6
					ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", perk_hp_drop_chance )
				end
			end
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", 0 )
				end
			end
		end,
	},
	{
		-- shooting unedited wands gives back HP
		id = "WAND_EXPERIMENTER",
		ui_name = "$perk_wand_experimenter",
		ui_description = "$perkdesc_wand_experimenter",
		ui_icon = "data/ui_gfx/perk_icons/wand_experimenter.png",
		perk_icon = "data/items_gfx/perks/wand_experimenter.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_wand_fired = "data/scripts/perks/wand_experimenter.lua",
				execute_every_n_frame = "-1",
			} )
			
		end,
	},
	{
		-- shooting unedited wands gives back HP
		id = "ADVENTURER",
		ui_name = "$perk_adventurer",
		ui_description = "$perkdesc_adventurer",
		ui_icon = "data/ui_gfx/perk_icons/adventurer.png",
		perk_icon = "data/items_gfx/perks/adventurer.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/adventurer.lua",
				execute_every_n_frame = "60",
			} )
			
		end,
	},
	{
		id = "ABILITY_ACTIONS_MATERIALIZED",
		ui_name = "$perk_ability_actions_materialized",
		ui_description = "$perkdesc_ability_actions_materialized",
		ui_icon = "data/ui_gfx/perk_icons/ability_actions_materialized.png",
		perk_icon = "data/items_gfx/perks/ability_actions_materialized.png",
		game_effect = "ABILITY_ACTIONS_MATERIALIZED",
		stackable = STACKABLE_NO,
	},
	{
		id = "PROJECTILE_HOMING",
		ui_name = "$perk_projectile_homing",
		ui_description = "$perkdesc_projectile_homing",
		ui_icon = "data/ui_gfx/perk_icons/projectile_homing.png",
		perk_icon = "data/items_gfx/perks/projectile_homing.png",
		game_effect = "PROJECTILE_HOMING",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				script_shot = "data/scripts/perks/projectile_homing_enemy.lua",
				execute_every_n_frame = "-1",
			} )
		end,
	},
	{
		id = "PROJECTILE_HOMING_SHOOTER",
		ui_name = "$perk_projectile_homing_shooter",
		ui_description = "$perkdesc_projectile_homing_shooter",
		ui_icon = "data/ui_gfx/perk_icons/projectile_homing_shooter.png",
		perk_icon = "data/items_gfx/perks/projectile_homing_shooter.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "projectile_homing_shooter",
			} )
			
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "powerful_shot",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/projectile_homing_shooter_enemy.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					
					explosion_resistance = explosion_resistance * 0.7
					projectile_resistance = projectile_resistance * 0.7
					
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
	},
	{
		id = "UNLIMITED_SPELLS",
		ui_name = "$perk_unlimited_spells",
		ui_description = "$perkdesc_unlimited_spells",
		ui_icon = "data/ui_gfx/perk_icons/unlimited_spells.png",
		perk_icon = "data/items_gfx/perks/unlimited_spells.png",
		stackable = STACKABLE_NO,
		-- almost all spells of limited use become unlimited
		func = function( entity_perk_item, entity_who_picked, item_name )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_infinite_spells", "1" )
				end
			end

			-- this goes through the items player is holding and sets their uses_remaining to -1
			GameRegenItemActionsInPlayer( entity_who_picked )

			-- UI refreshing, for some reason the uses_remaining remains somewhere
			-- This selects the current wand again, which seems to fix the uses_remaining remaining in various uses
			local inventory2_comp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
			if( inventory2_comp ) then
				ComponentSetValue( inventory2_comp, "mActualActiveItem", "0" )
			end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_infinite_spells", "0" )
				end
			end

			-- this goes through the items player is holding and sets their uses_remaining to -1
			GameRegenItemActionsInPlayer( entity_who_picked )

			-- UI refreshing, for some reason the uses_remaining remains somewhere
			-- This selects the current wand again, which seems to fix the uses_remaining remaining in various uses
			local inventory2_comp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
			if( inventory2_comp ) then
				ComponentSetValue( inventory2_comp, "mActualActiveItem", "0" )
			end
		end,
	},
	
	-- PLAYER EFFECTS
	
	{
		id = "FREEZE_FIELD",
		ui_name = "$perk_freeze_field",
		ui_description = "$perkdesc_freeze_field",
		ui_icon = "data/ui_gfx/perk_icons/freeze_field.png",
		perk_icon = "data/items_gfx/perks/freeze_field.png",
		game_effect = "PROTECTION_FIRE",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/freeze_field.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
		end,
	},
	{
		id = "FIRE_GAS",
		ui_name = "$perk_gas_fire",
		ui_description = "$perkdesc_gas_fire",
		ui_icon = "data/ui_gfx/perk_icons/fire_gas.png",
		perk_icon = "data/items_gfx/perks/fire_gas.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/fire_gas.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
		end,
	},
	{
		id = "DISSOLVE_POWDERS",
		ui_name = "$perk_dissolve_powders",
		ui_description = "$perkdesc_dissolve_powders",
		ui_icon = "data/ui_gfx/perk_icons/dissolve_powders.png",
		perk_icon = "data/items_gfx/perks/dissolve_powders.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/dissolve_powders.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
		end,
	},
	{
		id = "BLEED_SLIME",
		ui_name = "$perk_bleed_slime",
		ui_description = "$perkdesc_bleed_slime",
		ui_icon = "data/ui_gfx/perk_icons/slime_blood.png",
		perk_icon = "data/items_gfx/perks/slime_blood.png",
		game_effect = "NO_SLIME_SLOWDOWN",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "slime" )
					ComponentSetValue( damagemodel, "blood_spray_material", "slime" )
					ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
					
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
			
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "BLEED_OIL",
		ui_name = "$perk_bleed_oil",
		ui_description = "$perkdesc_bleed_oil",
		ui_icon = "data/ui_gfx/perk_icons/oil_blood.png",
		perk_icon = "data/items_gfx/perks/oil_blood.png",
		game_effect = "PROTECTION_FIRE",
		stackable = STACKABLE_NO,
		remove_other_perks = {"PROTECTION_FIRE"},
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "oil" )
					ComponentSetValue( damagemodel, "blood_spray_material", "oil" )
					ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_oil_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_oil_$[1-3].xml" )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
				end
			end
		end,
	},
	{
		id = "BLEED_GAS",
		ui_name = "$perk_gas_blood",
		ui_description = "$perkdesc_gas_blood",
		ui_icon = "data/ui_gfx/perk_icons/gas_blood.png",
		perk_icon = "data/items_gfx/perks/gas_blood.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		game_effect = "PROTECTION_RADIOACTIVITY",
		remove_other_perks = {"PROTECTION_RADIOACTIVITY"},
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "acid_gas" )
					ComponentSetValue( damagemodel, "blood_spray_material", "acid_gas" )
					ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_green_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_green_$[1-3].xml" )
				end
			end
			
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = ComponentGetValue2( model, "pixel_gravity" ) * 0.75
					ComponentSetValue2( model, "pixel_gravity", gravity )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
				end
			end
			
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "SHIELD",
		ui_name = "$perk_shield",
		ui_description = "$perkdesc_shield",
		ui_icon = "data/ui_gfx/perk_icons/shield.png",
		perk_icon = "data/items_gfx/perks/shield.png",
		stackable = STACKABLE_YES,
		stackable_how_often_reappears = 10,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
			
			local shield_num = tonumber( GlobalsGetValue( "PERK_SHIELD_COUNT", "0" ) )
			local shield_radius = 10 + shield_num * 2.5
			local charge_speed = math.max( 0.22 - shield_num * 0.05, 0.02 )
			shield_num = shield_num + 1
			GlobalsSetValue( "PERK_SHIELD_COUNT", tostring( shield_num ) )
			
			local comps = EntityGetComponent( child_id, "EnergyShieldComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					ComponentSetValue2( comp, "radius", shield_radius )
					ComponentSetValue2( comp, "recharge_speed", charge_speed )
				end
			end
			
			comps = EntityGetComponent( child_id, "ParticleEmitterComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					local minradius,maxradius = ComponentGetValue2( comp, "area_circle_radius" )
					
					if ( minradius ~= nil ) and ( maxradius ~= nil ) then
						if ( minradius == 0 ) then
							ComponentSetValue2( comp, "area_circle_radius", 0, shield_radius )
						elseif ( minradius == 10 ) then
							ComponentSetValue2( comp, "area_circle_radius", shield_radius, shield_radius )
						end
					end
				end
			end
			
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_who_picked )
			local shield_num = 0
			GlobalsSetValue( "PERK_SHIELD_COUNT", tostring( shield_num ) )
		end,
	},
	{
		id = "REVENGE_EXPLOSION",
		ui_name = "$perk_revenge_explosion",
		ui_description = "$perkdesc_revenge_explosion",
		ui_icon = "data/ui_gfx/perk_icons/revenge_explosion.png",
		perk_icon = "data/items_gfx/perks/revenge_explosion.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_explosion.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					explosion_resistance = explosion_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
				end
			end
		end,
	},
	{
		id = "REVENGE_TENTACLE",
		ui_name = "$perk_revenge_tentacle",
		ui_description = "$perkdesc_revenge_tentacle",
		ui_icon = "data/ui_gfx/perk_icons/revenge_tentacle.png",
		perk_icon = "data/items_gfx/perks/revenge_tentacle.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_tentacle.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "REVENGE_RATS",
		ui_name = "$perk_revenge_rats",
		ui_description = "$perkdesc_revenge_rats",
		ui_icon = "data/ui_gfx/perk_icons/revenge_rats.png",
		perk_icon = "data/items_gfx/perks/revenge_rats.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_rats.lua",
				execute_every_n_frame = "-1",
			} )
			
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
			end
			
			perk_pickup_event("RAT")
			
			add_rattiness_level(entity_who_picked)
			--GenomeSetHerdId( entity_who_picked, "rat" )
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "REVENGE_BULLET",
		ui_name = "$perk_revenge_bullet",
		ui_description = "$perkdesc_revenge_bullet",
		ui_icon = "data/ui_gfx/perk_icons/revenge_bullet.png",
		perk_icon = "data/items_gfx/perks/revenge_bullet.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_bullet.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					explosion_resistance = explosion_resistance * 0.8
					 projectile_resistance = projectile_resistance * 0.8
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring( explosion_resistance ) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring( projectile_resistance ) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	-- Pending overhaul.
	{
		id = "ATTACK_FOOT",
		ui_name = "$perk_attack_foot",
		ui_description = "$perkdesc_attack_foot",
		ui_icon = "data/ui_gfx/perk_icons/attack_foot.png",
		perk_icon = "data/items_gfx/perks/attack_foot.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = 0
			local is_stacking = GameHasFlagRun( "ATTACK_FOOT_CLIMBER" )

			local limb_count = 4
			if is_stacking then limb_count = 2 end
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_walker.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			
			child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_attacker.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			if not is_stacking then
				-- enable climbing
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_climb.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
				GameAddFlagRun( "ATTACK_FOOT_CLIMBER" )
			else
				-- add length to limbs
				for _,v in ipairs(EntityGetAllChildren(entity_who_picked)) do
					if EntityHasTag(v, "attack_foot_walker") then
						component_readwrite(EntityGetFirstComponent(v, "IKLimbComponent"), { length = 50 }, function(comp)
							comp.length = comp.length * 1.5
						end)
					end
				end
			end
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
			
			perk_pickup_event("LUKKI")
			
			if ( pickup_count <= 2 ) then
				add_lukkiness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "ATTACK_FOOT_CLIMBER" )
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					ComponentSetMetaCustom( component, "run_velocity", 154 )
					ComponentSetMetaCustom( component, "velocity_min_x", -57 )
					ComponentSetMetaCustom( component, "velocity_max_x", 57 )
					ComponentSetValue2( component, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "LEGGY_FEET",
		ui_name = "$perk_leggy_feet",
		ui_description = "$perkdesc_leggy_feet",
		ui_icon = "data/ui_gfx/perk_icons/leggy_feet.png",
		perk_icon = "data/items_gfx/perks/leggy_feet.png",
		stackable = STACKABLE_YES, -- Arvi: these variables don't really make sense for this perk but putting them in anyway
		stackable_is_rare = true,
		usable_by_enemies = true,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = 0
			local is_stacking = GameHasFlagRun( "ATTACK_FOOT_CLIMBER" )
			local limb_count = 2
			if is_stacking then limb_count = 1 end
			
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_left.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_right.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			
			child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_attacker.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )

			if not is_stacking then
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_climb.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
				GameAddFlagRun( "ATTACK_FOOT_CLIMBER" )
			else
				-- add length to limbs
				for _,v in ipairs(EntityGetAllChildren(entity_who_picked)) do
					if EntityHasTag(v, "leggy_foot_walker") then
						component_readwrite(EntityGetFirstComponent(v, "IKLimbComponent"), { length = 50 }, function(comp)
							comp.length = comp.length * 1.5
						end)
					end
				end
			end
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
			
			perk_pickup_event("LUKKI")
			
			if ( pickup_count <= 2 ) then
				add_lukkiness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "ATTACK_FOOT_CLIMBER" )
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					ComponentSetMetaCustom( component, "run_velocity", 154 )
					ComponentSetMetaCustom( component, "velocity_min_x", -57 )
					ComponentSetMetaCustom( component, "velocity_max_x", 57 )
					-- NOTE apparently this isn't needed, since the LEGGY works differently from the LUKKI
					-- ComponentSetValue2( component, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "PLAGUE_RATS",
		ui_name = "$perk_plague_rats",
		ui_description = "$perkdesc_plague_rats",
		ui_icon = "data/ui_gfx/perk_icons/plague_rats.png",
		perk_icon = "data/items_gfx/perks/plague_rats.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/plague_rats.lua",
					execute_every_n_frame = "20",
				} )
				
				local world_entity_id = GameGetWorldStateEntity()
				if ( world_entity_id ~= nil ) then
					component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
				end
				--GenomeSetHerdId( entity_who_picked, "rat" )
			end
			
			perk_pickup_event("RAT")
			add_rattiness_level(entity_who_picked)
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			reset_perk_pickup_event("RAT")
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "VOMIT_RATS",
		ui_name = "$perk_vomit_rats",
		ui_description = "$perkdesc_vomit_rats",
		ui_icon = "data/ui_gfx/perk_icons/vomit_rats.png",
		perk_icon = "data/items_gfx/perks/vomit_rats.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
			local child_id = EntityLoad( "data/entities/misc/perks/vomit_rats.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityLoad( "data/entities/items/pickup/potion_vomit.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
			
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
			end
			
			perk_pickup_event("RAT")
			add_rattiness_level(entity_who_picked)
			--GenomeSetHerdId( entity_who_picked, "rat" )
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			reset_perk_pickup_event("RAT")
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "CORDYCEPS",
		ui_name = "$perk_cordyceps",
		ui_description = "$perkdesc_cordyceps",
		ui_icon = "data/ui_gfx/perk_icons/cordyceps.png",
		perk_icon = "data/items_gfx/perks/cordyceps.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/cordyceps.lua",
					execute_every_n_frame = "20",
				} )
			end
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_cordyceps" ) == false ) then
				GameAddFlagRun( "player_status_cordyceps" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_cordyceps" )
		end,
	},
	{
		id = "MOLD",
		ui_name = "$perk_mold",
		ui_description = "$perkdesc_mold",
		ui_icon = "data/ui_gfx/perk_icons/mold.png",
		perk_icon = "data/items_gfx/perks/mold.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
			local child_id = EntityLoad( "data/entities/misc/perks/slime_fungus.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityLoad( "data/entities/items/pickup/potion_slime.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_mold" ) == false ) then
				GameAddFlagRun( "player_status_mold" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_mold" )
		end,
	},
	{
		id = "WORM_SMALLER_HOLES",
		ui_name = "$perk_worm_smaller_holes",
		ui_description = "$perkdesc_worm_smaller_holes",
		ui_icon = "data/ui_gfx/perk_icons/worm_smaller_holes.png",
		perk_icon = "data/items_gfx/perks/worm_smaller_holes.png",
		stackable = STACKABLE_NO,
		game_effect = "WORM_DETRACTOR",
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/worm_smaller_holes.lua",
				execute_every_n_frame = "20",
			} )
			
		end,
	},
	--[[
	{
		id = "WORM_BIGGER_HOLES",
		ui_name = "$perk_worm_bigger_holes",
		ui_description = "$perkdesc_worm_bigger_holes",
		ui_icon = "data/ui_gfx/perk_icons/worm_bigger_holes.png",
		perk_icon = "data/items_gfx/perks/worm_bigger_holes.png",
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/worm_bigger_holes.lua",
				execute_every_n_frame = "20",
			} )
			
		end,
	},
	]]--
	{
		id = "PROJECTILE_REPULSION",
		ui_name = "$perk_projectile_repulsion",
		ui_description = "$perkdesc_projectile_repulsion",
		ui_icon = "data/ui_gfx/perk_icons/projectile_repulsion.png",
		perk_icon = "data/items_gfx/perks/projectile_repulsion.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		particle_effect = "projectile_repulsion_field",
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if pickup_count <= 1 then
				-- no existing perk found, spawn perk
				local x,y = EntityGetTransform( entity_who_picked )
				local child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_field.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			else
				-- skip spawning, store pickup count
				set_perk_entity_pickup_count(entity_who_picked, "projectile_repulsion", pickup_count)
			end

			-- increase resistance
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.26
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "RISKY_CRITICAL",
		ui_name = "$perk_risky_critical",
		ui_description = "$perkdesc_risky_critical",
		ui_icon = "data/ui_gfx/perk_icons/risky_critical.png",
		perk_icon = "data/items_gfx/perks/risky_critical.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/risky_critical.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "FUNGAL_DISEASE",
		ui_name = "$perk_fungal_disease",
		ui_description = "$perkdesc_fungal_disease",
		ui_icon = "data/ui_gfx/perk_icons/fungal_disease.png",
		perk_icon = "data/items_gfx/perks/fungal_disease.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/fungal_disease.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_fungal_disease" ) == false ) then
				GameAddFlagRun( "player_status_fungal_disease" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_fungal_disease" )
		end,
	},
	{
		id = "PROJECTILE_SLOW_FIELD",
		ui_name = "$perk_projectile_slow_field",
		ui_description = "$perkdesc_projectile_slow_field",
		ui_icon = "data/ui_gfx/perk_icons/projectile_slow_field.png",
		perk_icon = "data/items_gfx/perks/projectile_slow_field.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		particle_effect = "projectile_slow_field",
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/projectile_slow_field.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "PROJECTILE_REPULSION_SECTOR",
		ui_name = "$perk_projectile_repulsion_sector",
		ui_description = "$perkdesc_projectile_repulsion_sector",
		ui_icon = "data/ui_gfx/perk_icons/projectile_repulsion_sector.png",
		perk_icon = "data/items_gfx/perks/projectile_repulsion_sector.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id
			
			if ( pickup_count <= 1 ) then
				child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_sector.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
			else
				set_perk_entity_pickup_count(entity_who_picked, "projectile_repulsion_sector", pickup_count)
				--child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_sector_noparticles.xml", x, y )
			end
			
			if ( child_id ~= nil ) then
				EntityAddChild( entity_who_picked, child_id )
			end
		end,
	},
	{
		id = "PROJECTILE_EATER_SECTOR",
		ui_name = "$perk_projectile_eater_sector",
		ui_description = "$perkdesc_projectile_eater_sector",
		ui_icon = "data/ui_gfx/perk_icons/projectile_eater_sector.png",
		perk_icon = "data/items_gfx/perks/projectile_eater_sector.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id
			
			if ( pickup_count <= 1 ) then
				child_id = EntityLoad( "data/entities/misc/perks/projectile_eater_sector.xml", x, y )
			else
				child_id = EntityLoad( "data/entities/misc/perks/projectile_eater_sector_noparticles.xml", x, y )
			end
			
			if ( child_id ~= nil ) then
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
		end,
	},
	{
		id = "ORBIT",
		ui_name = "$perk_orbit",
		ui_description = "$perkdesc_orbit",
		ui_icon = "data/ui_gfx/perk_icons/orbit.png",
		perk_icon = "data/items_gfx/perks/orbit.png",
		usable_by_enemies = true,
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		stackable_how_often_reappears = 10,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/orbit.lua",
				execute_every_n_frame = "1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					projectile_resistance = projectile_resistance * 1.33
					explosion_resistance = explosion_resistance * 1.33
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
				end
			end
		end,
	},
	{
		id = "ANGRY_GHOST",
		ui_name = "$perk_angry_ghost",
		ui_description = "$perkdesc_angry_ghost",
		ui_icon = "data/ui_gfx/perk_icons/angry_ghost.png",
		perk_icon = "data/items_gfx/perks/angry_ghost.png",
		usable_by_enemies = true,
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/angry_ghost.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_wand_fired = "data/scripts/perks/angry_ghost_shoot.lua",
				execute_every_n_frame = "1",
			} )
			
			perk_pickup_event("GHOST")
			
			if ( GameHasFlagRun( "player_status_angry_ghost" ) == false ) then
				GameAddFlagRun( "player_status_angry_ghost" )
				add_ghostness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_angry_ghost" )
		end,
	},
	{
		id = "HUNGRY_GHOST",
		ui_name = "$perk_hungry_ghost",
		ui_description = "$perkdesc_hungry_ghost",
		ui_icon = "data/ui_gfx/perk_icons/hungry_ghost.png",
		perk_icon = "data/items_gfx/perks/hungry_ghost.png",
		usable_by_enemies = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/hungry_ghost.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			perk_pickup_event("GHOST")
			
			if ( GameHasFlagRun( "player_status_hungry_ghost" ) == false ) then
				GameAddFlagRun( "player_status_hungry_ghost" )
				add_ghostness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_hungry_ghost" )
		end,
	},
	{
		id = "DEATH_GHOST",
		ui_name = "$perk_death_ghost",
		ui_description = "$perkdesc_death_ghost",
		ui_icon = "data/ui_gfx/perk_icons/death_ghost.png",
		perk_icon = "data/items_gfx/perks/death_ghost.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/death_ghost.lua",
					execute_every_n_frame = "20",
				} )
			end
			
			perk_pickup_event("GHOST")
			
			if ( GameHasFlagRun( "player_status_death_ghost" ) == false ) then
				GameAddFlagRun( "player_status_death_ghost" )
				add_ghostness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_death_ghost" )
		end,
	},
	{
		id = "HOMUNCULUS",
		ui_name = "$perk_homunculus",
		ui_description = "$perkdesc_homunculus",
		ui_icon = "data/ui_gfx/perk_icons/homunculus.png",
		perk_icon = "data/items_gfx/perks/homunculus.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 10,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/homunculus_spawner.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "LUKKI_MINION",
		ui_name = "$perk_lukki_minion",
		ui_description = "$perkdesc_lukki_minion",
		ui_icon = "data/ui_gfx/perk_icons/lukki_minion.png",
		perk_icon = "data/items_gfx/perks/lukki_minion.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/lukki_minion.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			
			EntityAddComponent( child_id, "VariableStorageComponent", 
			{
				name = "owner_id",
				value_int = tostring( entity_who_picked ),
			} )
			
			perk_pickup_event("LUKKI")
			
			if ( GameHasFlagRun( "player_status_lukki_minion" ) == false ) then
				GameAddFlagRun( "player_status_lukki_minion" )
				add_lukkiness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "player_status_lukki_minion" )
		end,
	},
	{
		id = "ELECTRICITY",
		ui_name = "$perk_electricity",
		ui_description = "$perkdesc_electricity",
		ui_icon = "data/ui_gfx/perk_icons/electricity.png",
		perk_icon = "data/items_gfx/perks/electricity.png",
		game_effect = "PROTECTION_ELECTRICITY",
		stackable = STACKABLE_NO,
		remove_other_perks = {"PROTECTION_ELECTRICITY"},
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/electricity.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
		end,
	},
	{
		id = "ATTRACT_ITEMS",
		ui_name = "$perk_attract_items",
		ui_description = "$perkdesc_attract_items",
		ui_icon = "data/ui_gfx/perk_icons/attract_items.png",
		perk_icon = "data/items_gfx/perks/attract_items.png",
		usable_by_enemies = true,
		stackable = STACKABLE_YES,
		stackable_maximum = 6,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local distance_full = tonumber( GlobalsGetValue( "PERK_ATTRACT_ITEMS_RANGE", "0" ) )
			
			if ( distance_full == 0 ) then
				GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", "72" )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/attract_items.lua",
					execute_every_n_frame = "2",
				} )
			else
				distance_full = distance_full + 24
				GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", tostring(distance_full) )
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/attract_items_enemy.lua",
				execute_every_n_frame = "2",
			} )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", "0" )
		end,
	},
	{
		id = "EXTRA_KNOCKBACK",
		ui_name = "$perk_extra_knockback",
		ui_description = "$perkdesc_extra_knockback",
		ui_icon = "data/ui_gfx/perk_icons/extra_knockback.png",
		perk_icon = "data/items_gfx/perks/extra_knockback.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "extra_knockback",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/extra_knockback_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "LOWER_SPREAD",
		ui_name = "$perk_lower_spread",
		ui_description = "$perkdesc_lower_spread",
		ui_icon = "data/ui_gfx/perk_icons/lower_spread.png",
		perk_icon = "data/items_gfx/perks/lower_spread.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "lower_spread",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/lower_spread_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "LOW_RECOIL",
		ui_name = "$perk_low_recoil",
		ui_description = "$perkdesc_low_recoil",
		ui_icon = "data/ui_gfx/perk_icons/low_recoil.png",
		perk_icon = "data/items_gfx/perks/low_recoil.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "low_recoil",
			} )
		end,
	},
	{
		id = "BOUNCE",
		ui_name = "$perk_bounce",
		ui_description = "$perkdesc_bounce",
		ui_icon = "data/ui_gfx/perk_icons/bounce.png",
		perk_icon = "data/items_gfx/perks/bounce.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "bounce",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/bounce_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "FAST_PROJECTILES",
		ui_name = "$perk_fast_projectiles",
		ui_description = "$perkdesc_fast_projectiles",
		ui_icon = "data/ui_gfx/perk_icons/fast_projectiles.png",
		perk_icon = "data/items_gfx/perks/fast_projectiles.png",
		usable_by_enemies = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "fast_projectiles",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/fast_projectiles_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "ALWAYS_CAST",
		ui_name = "$perk_always_cast",
		ui_description = "$perkdesc_always_cast",
		ui_icon = "data/ui_gfx/perk_icons/always_cast.png",
		perk_icon = "data/items_gfx/perks/always_cast.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )

			local good_cards = { "DAMAGE", "CRITICAL_HIT", "HOMING", "SPEED", "ACID_TRAIL", "SINEWAVE" }

			-- "FREEZE", "MATTER_EATER", "ELECTRIC_CHARGE"
			local x, y = EntityGetTransform( entity_perk_item )
			SetRandomSeed( x, y )

			local card = good_cards[ Random( 1, #good_cards ) ]

			local r = Random( 1, 100 )
			local level = 6

			if( r <= 50 ) then
				local p = Random(1,100)
				
				--[[
				Arvi (9.12.2020): DRAW_MANY cards were causing odd behaviour as always casts, so testing a different set of always_cast cards
				if( p <= 80 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, 666 )
				elseif( p <= 95 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, 666 )
				else 
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 666 )
				end
				]]--
				
				if( p <= 86 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, 666 )
				elseif( p <= 93 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_STATIC_PROJECTILE, 666 )
				elseif ( p < 100 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 666 )
				else
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_UTILITY, 666 )
				end
			end

			local wand = find_the_wand_held( entity_who_picked )
			
			if ( wand ~= NULL_ENTITY ) then
				local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				
				if ( comp ~= nil ) then
					local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
					local deck_capacity2 = EntityGetWandCapacity( wand )
					
					local always_casts = deck_capacity - deck_capacity2
					
					if ( always_casts < 4 ) then
						AddGunActionPermanent( wand, card )
					else
						GamePrintImportant( "$log_always_cast_failed", "$logdesc_always_cast_failed" )
					end
				end
			end
		end,
	},
	{
		id = "EXTRA_MANA",
		ui_name = "$perk_extra_mana",
		ui_description = "$perkdesc_extra_mana",
		ui_icon = "data/ui_gfx/perk_icons/extra_mana.png",
		perk_icon = "data/items_gfx/perks/extra_mana.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local wand = find_the_wand_held( entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			
			SetRandomSeed( entity_who_picked, wand )
			
			if ( wand ~= NULL_ENTITY ) then
				local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				
				if ( comp ~= nil ) then
					local mana_max = ComponentGetValue2( comp, "mana_max" )
					local mana_charge_speed = ComponentGetValue2( comp, "mana_charge_speed" )
					local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
					local deck_capacity2 = EntityGetWandCapacity( wand )
					
					local always_casts = math.max( 0, deck_capacity - deck_capacity2 )
					
					mana_max = math.min( mana_max + Random( 10, 20 ) * Random( 10, 30 ), 20000 )
					mana_charge_speed = math.min( math.min( mana_charge_speed * Random( 200, 350 ) * 0.01, mana_charge_speed + Random( 100, 300 ) ), 20000 )
					
					deck_capacity2 = math.max( 1, math.floor( deck_capacity2 * 0.5 ) )
					
					ComponentSetValue2( comp, "mana_max", mana_max )
					ComponentSetValue2( comp, "mana_charge_speed", mana_charge_speed )
					ComponentObjectSetValue( comp, "gun_config", "deck_capacity", deck_capacity2 + always_casts )
					
					local c = EntityGetAllChildren( wand )
					
					if ( c ~= nil ) and ( #c > deck_capacity2 + always_casts ) then
						for i=always_casts+1,#c do
							local v = c[i]
							local comp2 = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" )
							
							if ( comp2 ~= nil ) and ( i > deck_capacity2 + always_casts ) then
								EntityRemoveFromParent( v )
								EntitySetTransform( v, x, y )
								
								local all = EntityGetAllComponents( v )
								
								for a,b in ipairs( all ) do
									EntitySetComponentIsEnabled( v, b, true )
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "NO_MORE_SHUFFLE",
		ui_name = "$perk_no_more_shuffle",
		ui_description = "$perkdesc_no_more_shuffle",
		ui_icon = "data/ui_gfx/perk_icons/no_more_shuffle.png",
		perk_icon = "data/items_gfx/perks/no_more_shuffle.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "1" )
			
			-- local wands = find_all_wands_held( entity_who_picked )
			local wands = EntityGetWithTag("wand")

			for i,wand in ipairs(wands) do
				-- we need to add a slot to the ability_comp
				local ability_comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				if( ability_comp ~= nil ) then
					-- local shuffler = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty" ) )
					-- if( shuffler == 0 ) then shuffler = 1 else shuffler = 0 end
					local shuffler = "0"
					ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", shuffler )
				end
			end 
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "0" )
		end,
	},
	{
		id = "NO_MORE_KNOCKBACK",
		ui_name = "$perk_no_more_knockback",
		ui_description = "$perkdesc_no_more_knockback",
		ui_icon = "data/ui_gfx/perk_icons/no_player_knockback.png",
		perk_icon = "data/items_gfx/perks/no_player_knockback.png",
		game_effect = "KNOCKBACK_IMMUNITY",
		stackable = STACKABLE_NO,
	},
	{
		id = "DUPLICATE_PROJECTILE",
		ui_name = "$perk_spell_duplication",
		ui_description = "$perkdesc_spell_duplication",
		ui_icon = "data/ui_gfx/perk_icons/duplicate_projectile.png",
		perk_icon = "data/items_gfx/perks/duplicate_projectile.png",
		stackable = STACKABLE_YES,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "duplicate_projectile",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.25
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local comps = EntityGetComponent( entity_who_picked, "AnimalAIComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs(comps) do
					local c_max = ComponentGetValue2( comp, "attack_ranged_entity_count_max" )
					c_max = c_max * 2
					ComponentSetValue2( comp, "attack_ranged_entity_count_max", c_max )
				end
			end
			
			comps = EntityGetComponent( entity_who_picked, "AIAttackComponent" )
			if( comps ~= nil ) then
				for i,comp in ipairs(comps) do
					local c_max = ComponentGetValue2( comp, "attack_ranged_entity_count_max" )
					c_max = c_max * 2
					ComponentSetValue2( comp, "attack_ranged_entity_count_max", c_max )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "FASTER_WANDS",
		ui_name = "$perk_faster_wands",
		ui_description = "$perkdesc_faster_wands",
		ui_icon = "data/ui_gfx/perk_icons/faster_wands.png",
		perk_icon = "data/items_gfx/perks/faster_wands.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			local wands = EntityGetInRadiusWithTag( x, y, 24, "wand" )
			
			for i,entity_id in ipairs( wands ) do
				local root_entity = EntityGetRootEntity( entity_id )
				
				if ( root_entity == entity_who_picked ) then
					local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
					if( models ~= nil ) then
						for j,model in ipairs(models) do
							local reload_time = tonumber( ComponentObjectGetValue( model, "gun_config", "reload_time" ) )
							local cast_delay = tonumber( ComponentObjectGetValue( model, "gunaction_config", "fire_rate_wait" ) )
							local mana_charge_speed = ComponentGetValue2( model, "mana_charge_speed" )
							
							--print( tostring(reload_time) .. ", " .. tostring(cast_delay) .. ", " .. tostring(mana_charge_speed) )
							
							reload_time = reload_time * 0.8 - 5
							cast_delay = cast_delay * 0.8 - 5
							mana_charge_speed = mana_charge_speed + 30
							
							ComponentSetValue2( model, "mana_charge_speed", mana_charge_speed )
							ComponentObjectSetValue( model, "gun_config", "reload_time", tostring(reload_time) )
							ComponentObjectSetValue( model, "gunaction_config", "fire_rate_wait", tostring(cast_delay) )
						end
					end
				end
			end
		end,
	},
	{
		id = "EXTRA_SLOTS",
		ui_name = "$perk_extra_slots",
		ui_description = "$perkdesc_extra_slots",
		ui_icon = "data/ui_gfx/perk_icons/extra_slots.png",
		perk_icon = "data/items_gfx/perks/extra_slots.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			local wands = EntityGetInRadiusWithTag( x, y, 24, "wand" )
			
			SetRandomSeed( x, y )
			
			for i,entity_id in ipairs( wands ) do
				local root_entity = EntityGetRootEntity( entity_id )
				
				if ( root_entity == entity_who_picked ) then
					local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
					if( models ~= nil ) then
						for j,model in ipairs(models) do
							local deck_capacity = tonumber( ComponentObjectGetValue( model, "gun_config", "deck_capacity" ) )
							local deck_capacity2 = EntityGetWandCapacity( entity_id )
							
							local always_casts = deck_capacity - deck_capacity2
							
							deck_capacity = math.min( deck_capacity + Random( 1, 3 ), math.max( 25 + always_casts, deck_capacity ) )
							
							ComponentObjectSetValue( model, "gun_config", "deck_capacity", tostring(deck_capacity) )
						end
					end
				end
			end
		end,
	},
	--[[
	{
		id = "EXTRA_POTION_CAPACITY",
		ui_name = "$perk_extra_potion_capacity",
		ui_description = "$perkdesc_extra_potion_capacity",
		ui_icon = "data/ui_gfx/perk_icons/extra_potion_capacity.png",
		perk_icon = "data/items_gfx/perks/extra_potion_capacity.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
			capacity = math.floor( capacity * 1.8 )
			GlobalsSetValue( "EXTRA_POTION_CAPACITY_LEVEL", tostring( capacity ) )
		end,
	},
	]]--
	{
		id = "CONTACT_DAMAGE",
		ui_name = "$perk_contact_damage",
		ui_description = "$perkdesc_contact_damage",
		ui_icon = "data/ui_gfx/perk_icons/contact_damage.png",
		perk_icon = "data/items_gfx/perks/contact_damage.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/contact_damage.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/contact_damage_enemy.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},


	-- SECRET
	--[[
	{
		id = "MYSTERY_EGGPLANT",
		ui_name = "$perk_mystery_eggplant",
		ui_description = "$perkdesc_mystery_eggplant", -- does nothing
		ui_icon = "data/ui_gfx/material_indicators/hp_regeneration.png",
		perk_icon = "data/items_gfx/perks/mystery_eggplant.png",
		not_in_default_perk_pool = true, -- if set, this perk only materializes when manually spawned, e.g. when calling spawn_perk("MYSTERY_EGGPLANT") somewhere
	},
	

	-- CRITICALS
	{
		id = "CRITS_2X_DAMAGE",
		ui_name = "$perk_crits_2x_damage",
		ui_description = "$perkdesc_crits_2x_damage",
		ui_icon = "data/ui_gfx/perk_icons/crits_2x_damage.png",
		perk_icon = "data/items_gfx/perks/crits_2x_damage.png",
		game_effect = "CRITS_2X_DAMAGE",
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO crits do 2x more damage, so normally its now 5x and then it would be 10x. Probably should tweak to 4x and 8x
		end,
	},

	-- HP AFFECTORS

	-- WAND & ACTION AFFECTORS
	{
		id = "BERSERK",
		ui_name = "$perk_berserk",
		ui_description = "$perkdesc_berserk",
	},

	-- WAND & ACTION SHUFFLERS and SPAWNERS
	{
		id = "SHUFFLE_WANDS",
		ui_name = "$perk_shuffle_wands",
		ui_description = "$perkdesc_shuffle_wands",
	},
	{
		id = "HEAVY_AMMO",
		ui_name = "$perk_heavy_ammo",
		ui_description = "$perkdesc_heavy_ammo", -- Nuke, Holy_grenade
	},
	-- PERKS
	{
		id = "ROLL_AGAIN",
		ui_name = "$perk_roll_again",
		ui_description = "$perkdesc_roll_again",
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO: code that replaces the perks with a new set 
		end,
	},
	--]]
	{
		id = "EXTRA_PERK",
		ui_name = "$perk_extra_perk",
		ui_description = "$perkdesc_extra_perk",
		ui_icon = "data/ui_gfx/perk_icons/extra_perk.png",
		perk_icon = "data/items_gfx/perks/extra_perk.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO - this should work - seems to work
			local perk_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ) )
			perk_count = perk_count + 1
			GlobalsSetValue( "TEMPLE_PERK_COUNT", tostring(perk_count) )
		end,
		func_remove = function( entity_who_picked )
			-- TODO - this should work - seems to work
			GlobalsSetValue( "TEMPLE_PERK_COUNT", "3" )
		end,
	},
	{
		id = "PERKS_LOTTERY",
		ui_name = "$perk_perks_lottery",
		ui_description = "$perkdesc_perks_lottery",
		ui_icon = "data/ui_gfx/perk_icons/perks_lottery.png",
		perk_icon = "data/items_gfx/perks/perks_lottery.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 6,
		max_in_perk_pool = 3,
		-- when picking up a perk, there's 50% chance less (instead of 100%) of other perks disappearing
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO - this should work - seems to work
			local perk_destroy_chance = tonumber( GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", "100" ) )
			perk_destroy_chance = perk_destroy_chance / 2
			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", tostring(perk_destroy_chance) )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", "100" )
		end,
	},
	{
		id = "GAMBLE",
		ui_name = "$perk_gamble",
		ui_description = "$perkdesc_gamble",
		ui_icon = "data/ui_gfx/perk_icons/gamble.png", -- TODO
		perk_icon = "data/items_gfx/perks/gamble.png", -- TODO
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local pos_x, pos_y = EntityGetTransform(entity_who_picked)
			EntityLoad("data/entities/misc/perk_gamble_spawner.xml", pos_x, pos_y)
		end,
	},
	{
		id = "EXTRA_SHOP_ITEM",
		ui_name = "$perk_extra_shop_item",
		ui_description = "$perkdesc_extra_shop_item",
		ui_icon = "data/ui_gfx/perk_icons/extra_shop_item.png",
		perk_icon = "data/items_gfx/perks/extra_shop_item.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local shop_item_count = tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) )
			shop_item_count = math.min( shop_item_count + 1, 10 )
			GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", tostring(shop_item_count) )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" )
		end,
	},
	-- GENOME RELATIONS
	{
		id = "GENOME_MORE_HATRED",
		ui_name = "$perk_genome_more_hatred",
		ui_description = "$perkdesc_genome_more_hatred",
		ui_icon = "data/ui_gfx/perk_icons/genome_more_hatred.png",
		perk_icon = "data/items_gfx/perks/genome_more_hatred.png",
		stackable = STACKABLE_YES,
		-- enemies hate each other more by 25%
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO - impl
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					local global_genome_relations_modifier = tonumber( ComponentGetValue( comp_worldstate, "global_genome_relations_modifier" ) )
					global_genome_relations_modifier = global_genome_relations_modifier - 25
					ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", tostring( global_genome_relations_modifier ) )
				end
			end

			add_halo_level(entity_who_picked, -1)
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", "0" )
				end
			end
		end,
	},
	{
		id = "GENOME_MORE_LOVE",
		ui_name = "$perk_genome_more_love",
		ui_description = "$perkdesc_genome_more_love",
		ui_icon = "data/ui_gfx/perk_icons/genome_more_love.png",
		perk_icon = "data/items_gfx/perks/genome_more_love.png",
		stackable = STACKABLE_YES,
		-- enemies love each other more by 25%
		func = function( entity_perk_item, entity_who_picked, item_name )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					local global_genome_relations_modifier = tonumber( ComponentGetValue( comp_worldstate, "global_genome_relations_modifier" ) )
					global_genome_relations_modifier = global_genome_relations_modifier + 25
					ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", tostring( global_genome_relations_modifier ) )
				end
			end

			add_halo_level(entity_who_picked, 1)
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", "0" )
				end
			end
		end,
	},
	{
		id = "PEACE_WITH_GODS",
		ui_name = "$perk_peace_with_steve",
		ui_description = "$perkdesc_peace_with_steve",
		ui_icon = "data/ui_gfx/perk_icons/peace_with_gods.png",
		perk_icon = "data/items_gfx/perks/peace_with_gods.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "TEMPLE_PEACE_WITH_GODS", "1" )
			if( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) == "1" ) then
				GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" )
			end
			-- necromancer_shop
			local steves = EntityGetWithTag( "necromancer_shop" )
			if( steves ~= nil ) then
				for index,entity_steve in ipairs(steves) do
					GetGameEffectLoadTo( entity_steve, "CHARM", true )
				end
			end
			-- give steve charm!

			add_halo_level(entity_who_picked, 1)
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_PEACE_WITH_GODS", "0" )
			GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" )
			if( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) == "1" ) then
				GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" )
			end
		end,
	},
	{
		id = "MANA_FROM_KILLS",
		ui_name = "$perk_mana_from_kills",
		ui_description = "$perkdesc_mana_from_kills",
		ui_icon = "data/ui_gfx/perk_icons/mana_from_kills.png",
		perk_icon = "data/items_gfx/perks/mana_from_kills.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/mana_from_kills.lua",
					execute_every_n_frame = "20",
				} )
			end
		end,
	},
	{
		id = "ANGRY_LEVITATION",
		ui_name = "$perk_angry_levitation",
		ui_description = "$perkdesc_angry_levitation",
		ui_icon = "data/ui_gfx/perk_icons/angry_levitation.png",
		perk_icon = "data/items_gfx/perks/angry_levitation.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/angry_levitation.lua",
				execute_every_n_frame = "20",
			} )
		end,
	},
	{
		id = "LASER_AIM",
		ui_name = "$perk_laser_aim",
		ui_description = "$perkdesc_laser_aim",
		ui_icon = "data/ui_gfx/perk_icons/laser_aim.png",
		perk_icon = "data/items_gfx/perks/laser_aim.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/laser_aim.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "laser_aim",
			} )
		end,
	},
	{
		id = "PERSONAL_LASER",
		ui_name = "$perk_personal_laser",
		ui_description = "$perkdesc_personal_laser",
		ui_icon = "data/ui_gfx/perk_icons/personal_laser.png",
		perk_icon = "data/items_gfx/perks/personal_laser.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			
			if ( pickup_count <= 1 ) then
				local child_id = EntityLoad( "data/entities/misc/perks/personal_laser.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
				
				EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
				{
					_tags = "perk_component",
					extra_modifier = "slow_firing",
				} )
			elseif ( pickup_count > 1 ) then
				local entities = EntityGetWithTag( "personal_laser" )
				
				for i,entity_id in ipairs( entities ) do
					local comp = EntityGetFirstComponent( entity_id, "LaserEmitterComponent" )
					if ( comp ~= nil ) then
						local damage_entities = 0.15 + ( pickup_count - 1 ) * 0.025
						local damage_cells = 3000 + ( pickup_count - 1 ) * 350
						local range = 54 + ( pickup_count - 1 ) * 12
						
						ComponentObjectSetValue2( comp, "laser", "damage_to_entities", damage_entities )
						ComponentObjectSetValue2( comp, "laser", "damage_to_cells", damage_cells )
						ComponentObjectSetValue2( comp, "laser", "max_length", range )
					end
				end
			end
		end,
	},
	{
		id = "MEGA_BEAM_STONE",
		ui_name = "$perk_mega_beam_stone",
		ui_description = "$perkdesc_mega_beam_stone",
		ui_icon = "data/ui_gfx/perk_icons/mega_beam_stone.png",
		perk_icon = "data/items_gfx/perks/mega_beam_stone.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			EntityLoad( "data/entities/items/pickup/beamstone.xml", x, y-10 )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y-10 )
		end,
	},

	-- INGESTION
	--[[
	{
		id = "INGEST_PROJECTILES",
		ui_name = "$perk_ingest_projectiles", -- TODO
		ui_description = "$perkdesc_ingest_projectiles", -- TODO
		ui_icon = "data/ui_gfx/perk_icons/ingest_projectiles.png",
		perk_icon = "data/items_gfx/perks/ingest_projectiles.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "data/scripts/perks/ingest_projectiles.lua", -- TODO
				execute_every_n_frame = "-1",
			} )
		end,
	},
	--]]
	--[[
	{
		id = "GENOME_RANDOM_ALLIES",
		ui_name = "$perk_random_allies",
		ui_description = "$perkdesc_random_allies",
		ui_icon = "data/ui_gfx/perk_icons/random_allies.png",
		perk_icon = "data/items_gfx/perks/random_allies.png",
		-- player changed herd_id to a random herd_id
		func = function( entity_perk_item, entity_who_picked, item_name )
			if( entity_who_picked ~= nil and entity_perk_item ~= nil ) then
				local pos_x, pos_y = EntityGetTransform( entity_item )
				local random_herds = { "slimes", "robot", "fire", "orcs", "rat", "electricity", "worm,", "zombie", "mage" }

				SetRandomSeed( pos_x, pos_y )
				local new_herd = random_herds[ Random( #random_herds ) ]

				GenomeSetHerdId( entity_who_picked, new_herd )
			end
		end,
	}
	]]--
	-- HEALTHIUM POTION
	-- KNOCKBACK

	--
	--[[

	------------------
	{
		id = "LIQUID_MOVEMENT",
		ui_name = "$perk_liquid_movement",
		ui_description = "$perkdesc_liquid_movement",
	},
	{
		id = "FASTER_SWIMMING",
		ui_name = "$perk_faster_swimming",
		ui_description = "$perkdesc_faster_swimming",
	},
	{
		id = "SHOP_IS_FREE",
		ui_name = "$perk_shop_is_free",
		ui_description = "$perkdesc_shop_is_free",
	},
	{
		id = "POISON_BURN",
		ui_name = "$perk_poison_burn",
		ui_description = "$perkdesc_poison_burn",
	},
	{
		-- durability is less by 1
		id = "DESTRUCTION_ENHANCEMENT",
		ui_name = "$perk_destruction_enhancement",
		ui_description = "$perkdesc_destruction_enhancement",
	},
	{
		id = "DAMAGING_AURA",
		ui_name = "$perk_damaging_aura",
		ui_description = "$perkdesc_damaging_aura",
	},
	{
		id = "THUNDER_KICK",
		ui_name = "$perk_thunder_kick",
		ui_description = "$perkdesc_thunder_kick",
	},
	{
		-- more kick damage
	},
	{
		id = "VISION",
		ui_name = "$perk_vision",
		ui_description = "$perkdesc_vision",
	},
	{
		id = "TELEPATHIC_VISION",
		ui_name = "$perk_telepathic_vision",
		ui_description = "$perkdesc_telepathic_vision",
	},
	{
		id = "NO_MORE_KNOCKBACK",
		ui_name = "$perk_no_more_knockback",
		ui_description = "$perkdesc_no_more_knockback",
	},
	{
		id = "KNOCKBACK_CONTROL",
		ui_name = "$perk_knockback_control",
		ui_description = "$perkdesc_knockback_control",
	},
	{
		id = "REVEAL_SECRETS",
		ui_name = "$perk_reveal_secrets",
		ui_description = "$perkdesc_reveal_secrets",
	},
	{
		id = "POTION_DROP",
		ui_name = "$perk_potion_drop",
		ui_description = "$perkdesc_potion_drop",
	},
	{
		id = "MYSTERY_EGG",
		ui_name = "$perk_mystery_egg",
		ui_description = "$perkdesc_mystery_egg", -- spawnaa ison madon
	},
	{
		id = "GOLD_NO_DISAPPEAR_WHILE_SEEN",
		ui_name = "$perk_gold_no_disappear_while_seen",
		ui_description = "$perkdesc_gold_no_disappear_while_seen"
		ui_icon = "data/ui_gfx/material_indicators/hp_regeneration.png",
		game_effect = "GOLD_NO_DISAPPEAR_WHILE_SEEN",
	},
	{
		id = "GOLD_STAY_FOREVER",
		ui_name = "$perk_gold_stay_forever",
		ui_description = "$perkdesc_gold_stay_forever"
		-- Gold nuggets never go away
	},
	{
		id = "MANA_DISCOUNT",
		ui_name = "$perk_mana_discount",
		ui_description = "$perkdesc_mana_discount"
	},
	{
		id = "JUGGERNAUT",
		ui_name = "$perk_juggernaut",
		ui_description = "$perkdesc_juggernaut"
	},
	{
		id = "BIG_POTIONS",
		ui_name = "$perk_big_potions",
		ui_description = "$perkdesc_big_potions"
	},
	{
		id = "EXTRA_CHARGES",
		ui_name = "$perk_extra_charges",
		ui_description = "$perkdesc_extra_charges"
	},
	{
		id = "FAST_PROJECTILES",
		ui_name = "$perk_fast_projectiles",
		ui_description = "$perkdesc_fast_projectiles"
	},
	{
		id = "DEADLY_ENVIRONMENT",
		ui_name = "$perk_deadly_environment",
		ui_description = "$perkdesc_deadly_environment"
	},
	{
		id = "CURSED_POWER",
		ui_name = "$perk_cursed_power",
		ui_description = "$perkdesc_cursed_power"
	},
	{
		id = "GOLD_ATTRACTION",
		ui_name = "$perk_gold_attraction",
		ui_description = "$perkdesc_gold_attraction"
		-- Gold nuggets float towards player when nearby
	},
	]]--
	--[[
	FEATURE CREEP
	{
		id = "RANDOMIZE_SPELLS",
		ui_name = "$perk_randomize_spells",
		ui_description = "$perkdesc_randomize_spells"
	},
	{
		id = "PERSONAL_RAINCLOUD",
		ui_name = "$perk_personal_raincloud",
		ui_description = "$perkdesc_personal_raincloud"
	},
	{
		id = "HELPER_ORB",
		ui_name = "$perk_helper_orb",
		ui_description = "$perkdesc_helper_orb",
	},
	{
		id = "EXTRA_WAND_SLOT",
		ui_name = "$perk_extra_wand_slot",
		ui_description = "$perkdesc_extra_wand_slot",
	},
	{
		id = "EXTRA_POTION_SLOT",
		ui_name = "$perk_extra_potion_slot",
		ui_description = "$perkdesc_extra_potion_slot",
	},
	{
		id = "EXTRA_ACTION_STORAGE",
		ui_name = "$perk_extra_action_storage",
		ui_description = "$perkdesc_extra_action_storage",
	},
	{
		id = "PERSUASION",
		ui_name = "$perk_persuasion",
		ui_description = "$perkdesc_persuasion",
	},
	{
		id = "PERMANENT_FLYING",
		ui_name = "$perk_permanent_flying",
		ui_description = "$perkdesc_permanent_flying",
	},
	{
		id = "MELT",
		ui_name = "$perk_melt",
		ui_description = "$perkdesc_melt",
	},
	{
		id = "DOUBLE_CAST",
		ui_name = "$perk_double_cast",
		ui_description = "$perkdesc_double_cast",
	},
	]]--
}


function get_perk_with_id( perk_list, perk_id )
	local perk_data = nil
	for i,perk in ipairs(perk_list) do
		if perk.id == perk_id then
			perk_data = perk
			break
		end
	end

	return perk_data
end

function get_perk_picked_flag_name( perk_id )
	return "PERK_PICKED_" .. perk_id
end
