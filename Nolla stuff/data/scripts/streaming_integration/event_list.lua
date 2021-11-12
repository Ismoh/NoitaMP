dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/streaming_integration/event_utilities.lua")
dofile( "data/scripts/perks/perk.lua" )
dofile( "data/scripts/game_helpers.lua" )

STREAMING_EVENT_AWFUL = 0
STREAMING_EVENT_BAD = 1
STREAMING_EVENT_NEUTRAL = 2
STREAMING_EVENT_GOOD = 3
STREAMING_EVENT_AUTHOR_NOLLAGAMES = "Nolla Games"

streaming_events =
{
	{
		id = "HEALTH_PLUS",
		ui_name = "$streamingevent_health_plus",
		ui_description = "$streamingeventdesc_health_plus",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in ipairs( get_players() ) do
				local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
				
				local max_hp = 0
				local hp = 0
				
				if( damagemodels ~= nil ) then
					for a,damagemodel in ipairs(damagemodels) do
						max_hp = ComponentGetValue2( damagemodel, "max_hp" )
						hp = ComponentGetValue2( damagemodel, "hp" )
						hp = math.min( hp + 3.2, max_hp )
						
						ComponentSetValue2( damagemodel, "hp", hp )
					end
				end
			end
		end,
	},
	{
		id = "SPEEDY_ENEMIES",
		ui_name = "$streamingevent_speedy_enemies",
		ui_description = "$streamingeventdesc_speedy_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "MOVEMENT_FASTER_2X", false )
				if (game_effect_comp ~= nil) and (game_effect_entity ~= nil) then
					ComponentSetValue( game_effect_comp, "frames", "-1" )
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/movement_faster.png", event )
				end
			end
		end,
	},
	{
		id = "PROTECT_ENEMIES",
		ui_name = "$streamingevent_protect_enemies",
		ui_description = "$streamingeventdesc_protect_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "PROTECTION_ALL", false )
				if (game_effect_comp ~= nil) and (game_effect_entity ~= nil) then
					ComponentSetValue2( game_effect_comp, "frames", get_lifetime() )
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/protection_all.png", event )
				end
			end
		end,
	},
	{
		id = "TELEPORTING_ENEMIES",
		ui_name = "$streamingevent_teleporting_enemies",
		ui_description = "$streamingeventdesc_teleporting_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/teleporting_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(600)) do
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "TELEPORTATION", false )
				if (game_effect_comp ~= nil) and (game_effect_entity ~= nil) then
					ComponentSetValue2( game_effect_comp, "frames", get_lifetime() )
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/teleportation.png", event )
				end
			end
		end,
	},
	{
		id = "POLYMORPH_ENEMIES",
		ui_name = "$streamingevent_polymorph_enemies",
		ui_description = "$streamingeventdesc_polymorph_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/polymorph_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			local t = GameGetFrameNum()
			for id,enemy in pairs(get_enemies_in_radius(400)) do
				local game_effect_comp
				local game_effect_entity
				local icon
				if ProceduralRandom(id, t) > 0.4 then
					game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "POLYMORPH_RANDOM", false )
					icon = "polymorph"
				else
					game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "POLYMORPH", false )
					icon = "polymorph_random"
				end
				
				if (game_effect_comp ~= nil) and (game_effect_entity ~= nil) and (icon ~= nil) then
					ComponentSetValue2( game_effect_comp, "frames", get_lifetime() )
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/" .. icon .. ".png", event )
				end
			end
		end,
	},
	{
		id = "TINY_GHOST_PLAYER",
		ui_name = "$streamingevent_tiny_ghost_player",
		ui_description = "$streamingeventdesc_tiny_ghost_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/tiny_ghost_player.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 2.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local count = ProceduralRandom(GameGetFrameNum(),0,2,5)
					local random_viewer_names = nil
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/tiny_ghost.xml" )

						set_lifetime( entity_id, 4.0 )
						EntityAddChild( player, entity_id )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )

						if random_viewer_name ~= "" then
							if random_viewer_names == nil then
								random_viewer_names = random_viewer_name
							else
								random_viewer_names = random_viewer_names .. ", " .. random_viewer_name
							end
						end
					end

					if random_viewer_names ~= nil then
						random_viewer_names = random_viewer_names .. " "
						add_icon_in_hud( entity_id, "data/ui_gfx/status_indicators/tiny_ghost.png", event, random_viewer_names )
					end
				end
			end
		end,
	},
	{
		id = "TINY_GHOST_ENEMY",
		ui_name = "$streamingevent_tiny_ghost_enemy",
		ui_description = "$streamingeventdesc_tiny_ghost_enemy",
		ui_icon = "data/ui_gfx/streaming_event_icons/tiny_ghost_enemy.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 2.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				if EntityGetComponent(enemy, "GenomeDataComponent") ~= nil then
					local entity_id = EntityLoad( "data/scripts/streaming_integration/entities/tiny_ghost.xml" )
					EntityAddChild( enemy, entity_id )
					add_text_above_head( entity_id, StreamingGetRandomViewerName() )
				end
			end
		end,
	},
	{
		id = "HOMING_ENEMY_PROJECTILES",
		ui_name = "$streamingevent_homing_enemy_projectiles",
		ui_description = "$streamingeventdesc_homing_enemy_projectiles",
		ui_icon = "data/ui_gfx/streaming_event_icons/homing_enemy_projectiles.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				local entity_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_homing_enemy_projectiles.xml" )
				EntityAddChild( enemy, entity_id )
				add_icon_above_head( entity_id, "data/ui_gfx/status_indicators/homing.png", event )
			end
		end,
	},
	--[[
	{
		id = "HEALTH_MINUS",
		ui_name = "$streamingevent_health_minus",
		ui_description = "$streamingeventdesc_health_minus",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in ipairs( get_players() ) do
				local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
				
				local max_hp = 0
				local hp = 0
				
				if( damagemodels ~= nil ) then
					for a,damagemodel in ipairs(damagemodels) do
						max_hp = ComponentGetValue2( damagemodel, "max_hp" )
						hp = ComponentGetValue2( damagemodel, "hp" )
						hp = math.max( hp - 1.6, 0.04 )
						
						ComponentSetValue2( damagemodel, "hp", hp )
					end
				end
			end
		end,
	},
	]]--
	{
		id = "MAX_HEALTH_PLUS",
		ui_name = "$streamingevent_max_health_plus",
		ui_description = "$streamingeventdesc_max_health_plus",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in ipairs( get_players() ) do
				local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
				
				local max_hp_old = 0
				local max_hp = 0
				local hp = 0
				
				if( damagemodels ~= nil ) then
					for a,damagemodel in ipairs(damagemodels) do
						max_hp = ComponentGetValue2( damagemodel, "max_hp" )
						hp = ComponentGetValue2( damagemodel, "hp" )
						max_hp_old = max_hp
						max_hp = max_hp + 2
						hp = math.min( max_hp, hp + 2 )

						local max_hp_cap = tonumber( ComponentGetValue2( damagemodel, "max_hp_cap" ) )
						if max_hp_cap > 0 then
							max_hp = math.min( max_hp, max_hp_cap )
						end
						
						ComponentSetValue2( damagemodel, "max_hp", max_hp )
						ComponentSetValue2( damagemodel, "hp", hp )
					end
				end
			end
		end,
	},
	--[[
	{
		id = "MAX_HEALTH_MINUS",
		ui_name = "$streamingevent_max_health_minus",
		ui_description = "$streamingeventdesc_max_health_minus",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in ipairs( get_players() ) do
				local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
				
				local max_hp_old = 0
				local max_hp = 0
				local hp = 0
				
				if( damagemodels ~= nil ) then
					for a,damagemodel in ipairs(damagemodels) do
						max_hp = ComponentGetValue2( damagemodel, "max_hp" )
						hp = ComponentGetValue2( damagemodel, "hp" )
						max_hp_old = max_hp
						max_hp = math.max( max_hp - 1, 0.4 )
						hp = math.min( max_hp, hp )

						local max_hp_cap = tonumber( ComponentGetValue2( damagemodel, "max_hp_cap" ) )
						if max_hp_cap > 0 then
							max_hp = math.min( max_hp, max_hp_cap )
						end
						
						ComponentSetValue2( damagemodel, "max_hp", max_hp )
						ComponentSetValue2( damagemodel, "hp", hp )
					end
				end
			end
		end,
	},
	]]--
	{
		id = "REGENERATION_FIELD",
		ui_name = "$streamingevent_regeneration_field",
		ui_description = "$streamingeventdesc_regeneration_field",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/regeneration_field_long.xml", x, y )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/hp_regeneration.png", event )
			end
		end,
	},
	{
		id = "PROTECT_PLAYER",
		ui_name = "$streamingevent_protect_player",
		ui_description = "$streamingeventdesc_protect_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_protection_all.xml", x, y )
				set_lifetime( effect_id, 0.75 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/protection_all.png", event )
			end
		end,
	},
	{
		id = "SHIELD_ENEMIES",
		ui_name = "$streamingevent_shield_enemies",
		ui_description = "$streamingeventdesc_shield_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(400) ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/shield.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				add_icon_above_head( effect_id, "data/ui_gfx/status_indicators/shield.png", event )
			end
		end,
	},
	{
		id = "SHIELD_PLAYER",
		ui_name = "$streamingevent_shield_player",
		ui_description = "$streamingeventdesc_shield_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/shield.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/shield.png", event )
			end
		end,
	},
	{
		id = "FASTER_PLAYER",
		ui_name = "$streamingevent_faster_player",
		ui_description = "$streamingeventdesc_faster_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_movement_faster.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/movement_faster.png", event )
			end
		end,
	},
	{
		id = "SLIMY_PLAYER",
		ui_name = "$streamingevent_slimy_player",
		ui_description = "$streamingeventdesc_slimy_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityAddRandomStains( entity_id, CellFactory_GetType("slime"), 400 )
			end
			
			for i,entity_id in pairs( get_enemies_in_radius(400) ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityAddRandomStains( entity_id, CellFactory_GetType("slime"), 400 )
			end
		end,
	},
	{
		id = "WET_PLAYER",
		ui_name = "$streamingevent_wet_player",
		ui_description = "$streamingeventdesc_wet_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/cloud_water.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/cloud_water.png", event )
			end
		end,
	},
	{
		id = "OILED_PLAYER",
		ui_name = "$streamingevent_oiled_player",
		ui_description = "$streamingeventdesc_oiled_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/cloud_oil.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/cloud_oil.png", event )
			end
		end,
	},
	{
		id = "DRUNK_PLAYER",
		ui_name = "$streamingevent_drunk_player",
		ui_description = "$streamingeventdesc_drunk_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityIngestMaterial( entity_id, CellFactory_GetType("alcohol"), 100 )
			end
		end,
	},
	{
		id = "DRUNK_ENEMIES",
		ui_name = "$streamingevent_drunk_enemies",
		ui_description = "$streamingeventdesc_drunk_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(800) ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityAddRandomStains( entity_id, CellFactory_GetType("alcohol"), 800 )
			end
		end,
	},
	{
		id = "SPELL_REFRESH",
		ui_name = "$streamingevent_spell_refresh",
		ui_description = "$streamingeventdesc_spell_refresh",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				EntityLoad( "data/scripts/streaming_integration/entities/spell_refresh.xml", x, y )
			end
		end,
	},
	{
		id = "SEA_OF_X",
		ui_name = "$streamingevent_sea_of_x",
		ui_description = "$streamingeventdesc_sea_of_x",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_NEUTRAL,
		delay_timer = 300,
		action_delayed = function(event)
			local players = get_players()
			local t = GameGetFrameNum()
			local opts = { "lava", "water", "oil", "alcohol", "acid_gas" }
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )
				
				SetRandomSeed( entity_id, t )
				local rnd = Random( 1, #opts )
				local opt = opts[rnd]

				EntityLoad( "data/scripts/streaming_integration/entities/sea_" .. opt .. ".xml", x, y )
			end
		end,
	},
	{
		id = "SEA_OF_WATER",
		ui_name = "$streamingevent_sea_of_water",
		ui_description = "$streamingeventdesc_sea_of_water",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				EntityLoad( "data/scripts/streaming_integration/entities/sea_water.xml", x, y )
			end
		end,
	},
	{
		id = "SEA_OF_OIL",
		ui_name = "$streamingevent_sea_of_oil",
		ui_description = "$streamingeventdesc_sea_of_oil",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				EntityLoad( "data/scripts/streaming_integration/entities/sea_oil.xml", x, y )
			end
		end,
	},
	{
		id = "SEA_OF_LAVA",
		ui_name = "$streamingevent_sea_of_lava",
		ui_description = "$streamingeventdesc_sea_of_lava",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 420,
		action_delayed = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				EntityLoad( "data/scripts/streaming_integration/entities/sea_lava.xml", x, y )
			end
		end,
	},
	{
		id = "NUKE",
		ui_name = "$streamingevent_nuke",
		ui_description = "$streamingeventdesc_nuke",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_NEUTRAL,
		delay_timer = 300,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				shoot_projectile( entity_id, "data/scripts/streaming_integration/entities/nuke.xml", x, y, 0, 0 )
			end
		end,
	},
	{
		id = "SPAWN_WORM",
		ui_name = "$streamingevent_spawn_worm",
		ui_description = "$streamingeventdesc_spawn_worm",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			local players = get_players()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() - 253 )
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )
				
				local angle = Random( 0, 31415 ) * 0.0001
				local length = 250
				
				local ex = x + math.cos( angle ) * length
				local ey = y - math.sin( angle ) * length

				EntityLoad( "data/scripts/streaming_integration/entities/worm_big.xml", ex, ey )
			end
		end,
	},
	{
		id = "SPAWN_SHOPKEEPER",
		ui_name = "$streamingevent_spawn_shopkeeper",
		ui_description = "$streamingeventdesc_spawn_shopkeeper",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = "Steve",
		weight = 0.75,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			local players = get_players()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 353 )
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )
				
				local angle = Random( 0, 31415 ) * 0.0001
				local length = 250
				
				local ex = x + math.cos( angle ) * length
				local ey = y - math.sin( angle ) * length

				EntityLoad( "data/scripts/streaming_integration/entities/necromancer_shop.xml", ex, ey )
				EntityLoad( "data/scripts/streaming_integration/entities/empty_circle.xml", ex, ey )
			end
		end,
	},
	{
		id = "BOUNCY_SHOTS",
		ui_name = "$streamingevent_bouncy_shots",
		ui_description = "$streamingeventdesc_bouncy_shots",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_bouncy_shots.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/bouncy_shots.png", event )
			end
		end,
	},
	{
		id = "BOOMERANG_SHOTS",
		ui_name = "$streamingevent_boomerang_shots",
		ui_description = "$streamingeventdesc_boomerang_shots",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_boomerang_shots.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/homing_shooter.png", event )
			end
		end,
	},
	{
		id = "FIZZLE",
		ui_name = "$streamingevent_fizzle",
		ui_description = "$streamingeventdesc_fizzle",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_fizzle.xml", x, y )
				EntityAddChild( entity_id, effect_id )
			end
		end,
	},
	{
		id = "GRAVITY",
		ui_name = "$streamingevent_gravity",
		ui_description = "$streamingeventdesc_gravity",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_gravity.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/gravity.png", event )
			end
		end,
	},
	{
		id = "ANTIGRAVITY",
		ui_name = "$streamingevent_antigravity",
		ui_description = "$streamingeventdesc_antigravity",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_antigravity.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/antigravity.png", event )
			end
		end,
	},
	{
		id = "EXPLOSIVE_PROJECTILE",
		ui_name = "$streamingevent_explosive_projectile",
		ui_description = "$streamingeventdesc_explosive_projectile",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_explosive_projectile.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/explosive_shots.png", event )
			end
		end,
	},
	{
		id = "GIVE_WAND_TO_ENEMY",
		ui_name = "$streamingevent_give_wand_to_enemy",
		ui_description = "$streamingeventdesc_give_wand_to_enemy",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			local enemies = get_enemies_in_radius(600)
			if #enemies == 0 then return end
			
			-- select a random enemy that can pick up items
			local entity_id, itempickup
			local t = GameGetFrameNum()
			for i=1,20 do
				SetRandomSeed( t, i )
				entity_id = random_from_array( enemies )
				itempickup = EntityGetComponent( entity_id, "ItemPickUpperComponent" )
				if itempickup then break end
			end
			
			local rnd = Random( 1, 3 )
			local x, y = EntityGetTransform( entity_id )
			EntityLoad( "data/scripts/streaming_integration/entities/wand_level_0" .. tostring(rnd) .. ".xml", x, y )
		end,
	},
	{
		id = "GIVE_WAND_TO_PLAYER",
		ui_name = "$streamingevent_give_wand_to_player",
		ui_description = "$streamingeventdesc_give_wand_to_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				SetRandomSeed( x, y )
				local rnd = Random( 1, 3 )
				
				EntityLoad( "data/scripts/streaming_integration/entities/wand_level_0" .. tostring(rnd) .. ".xml", x, y )
			end
		end,
	},
	{
		id = "REMOVE_LIQUID",
		ui_name = "$streamingevent_remove_liquid",
		ui_description = "$streamingeventdesc_remove_liquid",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/remove_liquid.xml", x, y )
			end
		end,
	},
	{
		id = "REMOVE_GROUND",
		ui_name = "$streamingevent_remove_ground",
		ui_description = "$streamingeventdesc_remove_ground",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 300,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/remove_ground.xml", x, y )
			end
		end,
	},
	{
		id = "BERSERK",
		ui_name = "$streamingevent_berserk",
		ui_description = "$streamingeventdesc_berserk",
		ui_icon = "data/ui_gfx/streaming_event_icons/teleporting_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for _,enemy in pairs( get_enemies_in_radius(400) ) do
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "BERSERK", false )
				
				if (game_effect_comp ~= nil) and (game_effect_entity ~= nil) then
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/berserk.png", event )
				end
			end
			
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_berserk.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/berserk.png", event )
			end
		end,
	},
	{
		id = "FIREBALL_THROWER_PLAYER",
		ui_name = "$streamingevent_fireball_thrower_player",
		ui_description = "$streamingeventdesc_fireball_thrower_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_AWFUL,
		delay_timer = 300,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/fireball_ray.xml", x, y )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/fireball_ray.png", event )
			end
		end,
	},
	{
		id = "FIREBALL_THROWER_ENEMIES",
		ui_name = "$streamingevent_fireball_thrower_enemies",
		ui_description = "$streamingeventdesc_fireball_thrower_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(400) ) do
				local x, y = EntityGetTransform( entity_id )
				
				SetRandomSeed( x, y )
				
				if ( Random( 1, 2 ) == 2 ) then
					local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/fireball_ray.xml", x, y )
					EntityAddChild( entity_id, effect_id )
					add_icon_above_head( effect_id, "data/ui_gfx/status_indicators/fireball_ray.png", event )
				end
			end
		end,
	},
	{
		id = "SPAWN_CHEST",
		ui_name = "$streamingevent_spawn_chest",
		ui_description = "$streamingeventdesc_spawn_chest",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/chest_random.xml", x, y - 32 )
			end
		end,
	},
	{
		id = "TRANSFORM_GIGA_DISCS",
		ui_name = "$streamingevent_transform_giga_discs",
		ui_description = "$streamingeventdesc_transform_giga_discs",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_giga_discs.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/disc_bullet.png", event )
			end
		end,
	},
	{
		id = "TRANSFORM_NUKES",
		ui_name = "$streamingevent_transform_nukes",
		ui_description = "$streamingeventdesc_transform_nukes",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_AWFUL,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_nukes.xml", x, y )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/nuke.png", event )
			end
		end,
	},
	{
		id = "RAIN_GOLD",
		ui_name = "$streamingevent_rain_gold",
		ui_description = "$streamingeventdesc_rain_gold",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_gold.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_WORM",
		ui_name = "$streamingevent_rain_worm",
		ui_description = "$streamingeventdesc_rain_worm",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 600,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_worm.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_BOMB",
		ui_name = "$streamingevent_rain_bomb",
		ui_description = "$streamingeventdesc_rain_bomb",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_bomb.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_BLACKHOLE",
		ui_name = "$streamingevent_rain_blackhole",
		ui_description = "$streamingeventdesc_rain_blackhole",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.2,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_blackhole.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_HIISI",
		ui_name = "$streamingevent_rain_hiisi",
		ui_description = "$streamingeventdesc_rain_hiisi",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_hiisi.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_BARREL",
		ui_name = "$streamingevent_rain_barrel",
		ui_description = "$streamingeventdesc_rain_barrel",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_barrel.xml", x, y )
			end
		end,
	},
	{
		id = "RAIN_POTION",
		ui_name = "$streamingevent_rain_potion",
		ui_description = "$streamingeventdesc_rain_potion",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/rain_potion.xml", x, y )
			end
		end,
	},
	{
		id = "GRAVITY_PLAYER",
		ui_name = "$streamingevent_gravity_player",
		ui_description = "$streamingeventdesc_gravity_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/gravity_field.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/gravity_field.png", event )
			end
		end,
	},
	{
		id = "GRAVITY_ENEMIES",
		ui_name = "$streamingevent_gravity_enemies",
		ui_description = "$streamingeventdesc_gravity_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.75,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(300) ) do
				local x, y = EntityGetTransform( entity_id )
				
				SetRandomSeed( x, y * entity_id )
				
				if ( Random( 1, 3 ) > 1 ) then
					local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/gravity_field.xml", x, y )
					set_lifetime( effect_id )
					EntityAddChild( entity_id, effect_id )
					add_icon_above_head( effect_id, "data/ui_gfx/status_indicators/gravity_field.png", event )
				end
			end
		end,
	},
	{
		id = "PORTAL_EAST",
		ui_name = "$streamingevent_portal_east",
		ui_description = "$streamingeventdesc_portal_east",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.05,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,player_id in ipairs( get_players() ) do
				local pos_x,pos_y = EntityGetTransform( player_id )
				-- don't place inside ceiling
				local _,_,ray_y = RaytraceSurfaces(pos_x, pos_y, pos_x, pos_y - 50)
				pos_y = math.min(pos_y, ray_y + 10)
				local effect_id = EntityLoad("data/scripts/streaming_integration/entities/portal_east.xml", pos_x, pos_y)
				set_lifetime( effect_id )
			end
		end,
	},
	{
		id = "PORTAL_BEGINNING",
		ui_name = "$streamingevent_portal_beginning",
		ui_description = "$streamingeventdesc_portal_beginning",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,player_id in ipairs( get_players() ) do
				local pos_x,pos_y = EntityGetTransform(player_id)
				-- don't place inside ceiling
				local _,_,ray_y = RaytraceSurfaces(pos_x, pos_y, pos_x, pos_y - 50)
				pos_y = math.min(pos_y, ray_y + 10)
				local effect_id = EntityLoad("data/scripts/streaming_integration/entities/portal_beginning.xml", pos_x, pos_y)
				set_lifetime( effect_id )
			end
		end,
	},
	{
		id = "PORTAL_RANDOM",
		ui_name = "$streamingevent_portal_random",
		ui_description = "$streamingeventdesc_portal_random",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,player_id in ipairs( get_players() ) do
				local pos_x,pos_y = EntityGetTransform(player_id)
				-- don't place inside ceiling
				local _,_,ray_y = RaytraceSurfaces(pos_x, pos_y, pos_x, pos_y - 50)
				pos_y = math.min(pos_y, ray_y + 10)
				local effect_id = EntityLoad("data/scripts/streaming_integration/entities/portal_random.xml", pos_x, pos_y)
				set_lifetime( effect_id )
			end
		end,
	},
	{
		id = "TRAIL_WATER",
		ui_name = "$streamingevent_trail_water",
		ui_description = "$streamingeventdesc_trail_water",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_water.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_water.png", event )
			end
		end,
	},
	{
		id = "TRAIL_OIL",
		ui_name = "$streamingevent_trail_oil",
		ui_description = "$streamingeventdesc_trail_oil",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_oil.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
			
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_oil.png", event )
			end
		end,
	},
	{
		id = "TRAIL_ALCOHOL",
		ui_name = "$streamingevent_trail_alcohol",
		ui_description = "$streamingeventdesc_trail_alcohol",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_alcohol.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_alcohol.png", event )
			end
		end,
	},
	{
		id = "TRAIL_GUNPOWDER",
		ui_name = "$streamingevent_trail_gunpowder",
		ui_description = "$streamingeventdesc_trail_gunpowder",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_gunpowder.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_gunpowder.png", event )
			end
		end,
	},
	{
		id = "TRAIL_ACID",
		ui_name = "$streamingevent_trail_acid",
		ui_description = "$streamingeventdesc_trail_acid",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_acid.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_acid.png", event )
			end
		end,
	},
	{
		id = "TRAIL_LAVA",
		ui_name = "$streamingevent_trail_lava",
		ui_description = "$streamingeventdesc_trail_lava",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_lava.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_lava.png", event )
			end
		end,
	},
	{
		id = "TRAIL_FIRE",
		ui_name = "$streamingevent_trail_fire",
		ui_description = "$streamingeventdesc_trail_fire",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_fire.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_fire.png", event )
			end
		end,
	},
	{
		id = "TRAIL_POISON",
		ui_name = "$streamingevent_trail_poison",
		ui_description = "$streamingeventdesc_trail_poison",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.85,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_trail_poison.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/trail_poison.png", event )
			end
		end,
	},
	{
		id = "PLAYER_TRIP",
		ui_name = "$streamingevent_player_trip",
		ui_description = "$streamingeventdesc_player_trip",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				EntityIngestMaterial( entity_id, CellFactory_GetType("fungi"), 200 )
			end
		end,
	},
	{
		id = "TRANSMUTATION",
		ui_name = "$streamingevent_transmutation",
		ui_description = "$streamingeventdesc_transmutation",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		delay_timer = 180,
		action_delayed = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/transmutation.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/radioactive.png", event )
			end
		end,
	},
	{
		id = "SLOW_BULLETS",
		ui_name = "$streamingevent_slow_bullets",
		ui_description = "$streamingeventdesc_slow_bullets",
		ui_icon = "data/ui_gfx/streaming_event_icons/protect_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_slow_bullets.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/slow_bullets.png", event )
			end
		end,
	},
	{
		id = "SLOW_ENEMIES",
		ui_name = "$streamingevent_slow_enemies",
		ui_description = "$streamingeventdesc_slow_enemies",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				-- stack multiple speed slowdowns that last perpetually
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "MOVEMENT_SLOWER_2X", false )
				if game_effect_comp ~= nil then
					ComponentSetValue( game_effect_comp, "frames", "-1" )
					add_icon_above_head( game_effect_entity, "data/ui_gfx/status_indicators/movement_slower.png", event )
				end
			end
		end,
	},
	{
		id = "SLOW_PLAYER",
		ui_name = "$streamingevent_slow_player",
		ui_description = "$streamingeventdesc_slow_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_players()) do
				-- stack multiple speed ups that last perpetually
				local game_effect_comp,game_effect_entity = GetGameEffectLoadTo( enemy, "MOVEMENT_SLOWER", false )
				if game_effect_comp ~= nil then
					ComponentSetValue2( game_effect_comp, "frames", 1800 )
					add_icon_in_hud( game_effect_entity, "data/ui_gfx/status_indicators/movement_slower.png", event )
				end
			end
		end,
	},
	--[[
	{
		id = "NOTHING",
		ui_name = "$streamingevent_nothing",
		ui_description = "$streamingeventdesc_nothing",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.01,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			GamePrint( "$streamingeventdesc_nothing" )
		end,
	},
	]]--
	{
		id = "IMPROVE_WANDS",
		ui_name = "$streamingevent_improve_wands",
		ui_description = "$streamingeventdesc_improve_wands",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local wands = EntityGetWithTag( "wand" )
			
			for i,entity_id in ipairs( wands ) do
				local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
				if( models ~= nil ) then
					for j,model in ipairs(models) do
						local reload_time = tonumber( ComponentObjectGetValue( model, "gun_config", "reload_time" ) )
						local actions_per_round = tonumber( ComponentObjectGetValue( model, "gun_config", "actions_per_round" ) )
						local fire_rate_wait = tonumber( ComponentObjectGetValue( model, "gunaction_config", "fire_rate_wait" ) )
						local spread_degrees = tonumber( ComponentObjectGetValue( model, "gunaction_config", "spread_degrees" ) )
						local speed_multiplier = tonumber( ComponentObjectGetValue( model, "gunaction_config", "speed_multiplier" ) )
						local mana_charge_speed = ComponentGetValue2( model, "mana_charge_speed" )
						local mana_max = ComponentGetValue2( model, "mana_max" )
						
						SetRandomSeed( entity_id + GameGetFrameNum(), GameGetFrameNum() - 453 )
						
						--print( tostring(reload_time) .. ", " .. tostring(cast_delay) .. ", " .. tostring(mana_charge_speed) )
						
						reload_time = reload_time - Random(0, 200) * 0.1
						fire_rate_wait = fire_rate_wait - Random(0, 200) * 0.1
						mana_charge_speed = mana_charge_speed + Random(0, 40)
						spread_degrees = math.max( 0, spread_degrees - Random(0, 5) )
						speed_multiplier = speed_multiplier + Random( 0, 5 ) * 0.1
						mana_max = mana_max + Random( 0, 200 )
						actions_per_round = actions_per_round + Random( 0, 1 ) * Random( 0, 1 )
						
						ComponentSetValue2( model, "mana_charge_speed", mana_charge_speed )
						ComponentSetValue2( model, "mana_max", mana_max )
						ComponentObjectSetValue( model, "gun_config", "reload_time", tostring(reload_time) )
						ComponentObjectSetValue( model, "gun_config", "actions_per_round", tostring(actions_per_round) )
						ComponentObjectSetValue( model, "gunaction_config", "fire_rate_wait", tostring(fire_rate_wait) )
						ComponentObjectSetValue( model, "gunaction_config", "spread_degrees", tostring(spread_degrees) )
						ComponentObjectSetValue( model, "gunaction_config", "speed_multiplier", tostring(speed_multiplier) )
					end
				end
			end
		end,
	},
	{
		id = "WEAKEN_WANDS",
		ui_name = "$streamingevent_weaken_wands",
		ui_description = "$streamingeventdesc_weaken_wands",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			local wands = EntityGetWithTag( "wand" )
			
			for i,entity_id in ipairs( wands ) do
				local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
				if( models ~= nil ) then
					for j,model in ipairs(models) do
						local reload_time = tonumber( ComponentObjectGetValue( model, "gun_config", "reload_time" ) )
						local actions_per_round = tonumber( ComponentObjectGetValue( model, "gun_config", "actions_per_round" ) )
						local fire_rate_wait = tonumber( ComponentObjectGetValue( model, "gunaction_config", "fire_rate_wait" ) )
						local spread_degrees = tonumber( ComponentObjectGetValue( model, "gunaction_config", "spread_degrees" ) )
						local speed_multiplier = tonumber( ComponentObjectGetValue( model, "gunaction_config", "speed_multiplier" ) )
						local mana_charge_speed = ComponentGetValue2( model, "mana_charge_speed" )
						local mana_max = ComponentGetValue2( model, "mana_max" )
						
						SetRandomSeed( entity_id + GameGetFrameNum(), GameGetFrameNum() - 453 )
						
						--print( tostring(reload_time) .. ", " .. tostring(cast_delay) .. ", " .. tostring(mana_charge_speed) )
						
						reload_time = reload_time + Random(0, 200) * 0.1
						fire_rate_wait = fire_rate_wait + Random(0, 200) * 0.1
						mana_charge_speed = math.max( 1, mana_charge_speed - Random(0, 40) )
						spread_degrees = spread_degrees + Random(0, 5)
						speed_multiplier = math.max( -0.9, speed_multiplier - Random( 0, 5 ) * 0.1 )
						mana_max = math.max( mana_max - Random( 0, 200 ), 5 )
						actions_per_round = math.max( actions_per_round - Random( 0, 1 ) * Random( 0, 1 ), 2 )
						
						ComponentSetValue2( model, "mana_charge_speed", mana_charge_speed )
						ComponentSetValue2( model, "mana_max", mana_max )
						ComponentObjectSetValue( model, "gun_config", "reload_time", tostring(reload_time) )
						ComponentObjectSetValue( model, "gun_config", "actions_per_round", tostring(actions_per_round) )
						ComponentObjectSetValue( model, "gunaction_config", "fire_rate_wait", tostring(fire_rate_wait) )
						ComponentObjectSetValue( model, "gunaction_config", "spread_degrees", tostring(spread_degrees) )
						ComponentObjectSetValue( model, "gunaction_config", "speed_multiplier", tostring(speed_multiplier) )
					end
				end
			end
		end,
	},
	{
		id = "HEAL_GHOST",
		ui_name = "$streamingevent_heal_ghost",
		ui_description = "$streamingeventdesc_heal_ghost",
		ui_icon = "data/ui_gfx/streaming_event_icons/tiny_ghost_player.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.2,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local count = ProceduralRandom(GameGetFrameNum(),0,2,4)
					local random_viewer_names = nil
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/heal_ghost.xml" )

						set_lifetime( entity_id, 2.0 )
						EntityAddChild( player, entity_id )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )

						if random_viewer_name ~= "" then
							if random_viewer_names == nil then
								random_viewer_names = random_viewer_name
							else
								random_viewer_names = random_viewer_names .. ", " .. random_viewer_name
							end
						end
					end

					if random_viewer_names ~= nil then
						random_viewer_names = random_viewer_names .. " "
						add_icon_in_hud( entity_id, "data/ui_gfx/status_indicators/heal_ghost.png", event, random_viewer_names )
					end
				end
			end
		end,
	},
	{
		id = "SHIELD_GHOST",
		ui_name = "$streamingevent_shield_ghost",
		ui_description = "$streamingeventdesc_shield_ghost",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.8,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local count = 1
					local random_viewer_names = nil
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/shield_ghost.xml" )

						set_lifetime( entity_id, 2.0 )
						EntityAddChild( player, entity_id )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )

						if random_viewer_name ~= "" then
							if random_viewer_names == nil then
								random_viewer_names = random_viewer_name
							else
								random_viewer_names = random_viewer_names .. ", " .. random_viewer_name
							end
						end
					end

					if random_viewer_names ~= nil then
						random_viewer_names = random_viewer_names .. " "
						add_icon_in_hud( entity_id, "data/ui_gfx/status_indicators/shield_ghost.png", event, random_viewer_names )
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS",
		ui_name = "$streamingevent_homunculus",
		ui_description = "$streamingeventdesc_homunculus",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.3,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,3,5)
					local entity_id = nil
					for i=1,count do
						SetRandomSeed( x, y * GameGetFrameNum() )
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS_DARK",
		ui_name = "$streamingevent_homunculus_dark",
		ui_description = "$streamingeventdesc_homunculus_dark",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,1,2)
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x, y )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
						
						local storages = EntityGetComponent( entity_id, "VariableStorageComponent", "homunculus_type" )
						if ( storages ~= nil ) then
							for j,comp in ipairs( storages ) do
								local name = ComponentGetValue2( comp, "name" )
								if ( name == "homunculus_type" ) then
									ComponentSetValue2( comp, "value_string", "slow" )
									break
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS_HEAL",
		ui_name = "$streamingevent_homunculus_heal",
		ui_description = "$streamingeventdesc_homunculus_heal",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,1,2)
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x, y )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
						
						local storages = EntityGetComponent( entity_id, "VariableStorageComponent", "homunculus_type" )
						if ( storages ~= nil ) then
							for j,comp in ipairs( storages ) do
								local name = ComponentGetValue2( comp, "name" )
								if ( name == "homunculus_type" ) then
									ComponentSetValue2( comp, "value_string", "healer" )
									break
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS_FIRE",
		ui_name = "$streamingevent_homunculus_fire",
		ui_description = "$streamingeventdesc_homunculus_fire",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,1,2)
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x, y )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
						
						local storages = EntityGetComponent( entity_id, "VariableStorageComponent", "homunculus_type" )
						if ( storages ~= nil ) then
							for j,comp in ipairs( storages ) do
								local name = ComponentGetValue2( comp, "name" )
								if ( name == "homunculus_type" ) then
									ComponentSetValue2( comp, "value_string", "fireball" )
									break
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS_LASER",
		ui_name = "$streamingevent_homunculus_laser",
		ui_description = "$streamingeventdesc_homunculus_laser",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,1,2)
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x, y )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
						
						local storages = EntityGetComponent( entity_id, "VariableStorageComponent", "homunculus_type" )
						if ( storages ~= nil ) then
							for j,comp in ipairs( storages ) do
								local name = ComponentGetValue2( comp, "name" )
								if ( name == "homunculus_type" ) then
									ComponentSetValue2( comp, "value_string", "laser" )
									break
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "HOMUNCULUS_PUNCH",
		ui_name = "$streamingevent_homunculus_punch",
		ui_description = "$streamingeventdesc_homunculus_punch",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for a,player in ipairs( players ) do
				if EntityGetComponent(player, "GenomeDataComponent") ~= nil then
					local x,y = EntityGetTransform( player )
					local count = ProceduralRandom(GameGetFrameNum(),0,1,2)
					local entity_id = nil
					for i=1,count do
						entity_id = EntityLoad( "data/scripts/streaming_integration/entities/homunculus.xml", x, y )
						
						local random_viewer_name = StreamingGetRandomViewerName()
						add_text_above_head( entity_id, random_viewer_name )
						
						local herd_id
						
						edit_component( player, "GenomeDataComponent", function(comp,vars)
							herd_id = ComponentGetValue2( comp, "herd_id" )
						end)
						
						if ( herd_id ~= nil ) then
							edit_component( entity_id, "GenomeDataComponent", function(comp,vars)
								ComponentSetValue2( comp, "herd_id", herd_id )
							end)
						end
						
						local storages = EntityGetComponent( entity_id, "VariableStorageComponent", "homunculus_type" )
						if ( storages ~= nil ) then
							for j,comp in ipairs( storages ) do
								name = ComponentGetValue2( comp, "name" )
								if ( name == "homunculus_type" ) then
									ComponentSetValue2( comp, "value_string", "punch" )
									break
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "PLAYER_GAS",
		ui_name = "$streamingevent_player_gas",
		ui_description = "$streamingeventdesc_player_gas",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_player_gas.xml", x, y )
				set_lifetime( effect_id, 1.25 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/farts.png", event )
			end
		end,
	},
	{
		id = "AREADAMAGE_PLAYER",
		ui_name = "$streamingevent_areadamage_player",
		ui_description = "$streamingeventdesc_areadamage_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/tiny_ghost_enemy.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.8,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for _,enemy in pairs( get_players() ) do
				local entity_id = EntityLoad( "data/scripts/streaming_integration/entities/contact_damage.xml" )
				set_lifetime( entity_id, 1.25 )
				EntityAddChild( enemy, entity_id )
				
				add_icon_in_hud( entity_id, "data/ui_gfx/status_indicators/contact_damage.png", event )
			end
		end,
	},
	{
		id = "AREADAMAGE_ENEMY",
		ui_name = "$streamingevent_areadamage_enemy",
		ui_description = "$streamingeventdesc_areadamage_enemy",
		ui_icon = "data/ui_gfx/streaming_event_icons/tiny_ghost_enemy.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.6,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for _,enemy in pairs(get_enemies_in_radius(400)) do
				local entity_id = EntityLoad( "data/scripts/streaming_integration/entities/contact_damage_enemy.xml" )
				set_lifetime( entity_id, 0.8 )
				EntityAddChild( enemy, entity_id )
			end
		end,
	},
	{
		id = "TWITCHY",
		ui_name = "$streamingevent_twitchy",
		ui_description = "$streamingeventdesc_twitchy",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x, y = EntityGetTransform( entity_id )

				local effect_id = EntityLoad( "data/entities/misc/effect_twitchy.xml", x, y )
				set_lifetime( effect_id )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/twitchy.png", event )
			end
		end,
	},
	{
		id = "SPAWN_PERK",
		ui_name = "$streamingevent_spawn_perk",
		ui_description = "$streamingeventdesc_spawn_perk",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.25,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			local players = get_players()
			
			for i,entity_id in ipairs( players ) do
				local x,y = EntityGetTransform( entity_id )
				local pid = perk_spawn_random( x, y )
				perk_pickup( pid, entity_id, "", true, false )
			end
		end,
	},
	{
		id = "MATTER_EATER",
		ui_name = "$streamingevent_matter_eater",
		ui_description = "$streamingeventdesc_matter_eater",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_matter_eater.xml", x, y )
				set_lifetime( effect_id, 0.5 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/matter_eater.png", event )
			end
		end,
	},
	{
		id = "INVISIBLE_PLAYER",
		ui_name = "$streamingevent_invisible_player",
		ui_description = "$streamingeventdesc_invisible_player",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_invisibility.xml", x, y )
				set_lifetime( effect_id, 0.75 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/invisibility.png", event )
			end
		end,
	},
	{
		id = "INVISIBLE_ENEMY",
		ui_name = "$streamingevent_invisible_enemy",
		ui_description = "$streamingeventdesc_invisible_enemy",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(500) ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_invisibility.xml", x, y )
				set_lifetime( effect_id, 0.75 )
				EntityAddChild( entity_id, effect_id )
			end
		end,
	},
	{
		id = "NEUTRALIZED",
		ui_name = "$streamingevent_neutralized",
		ui_description = "$streamingeventdesc_neutralized",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.2,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_neutralized.xml", x, y )
				set_lifetime( effect_id, 0.4 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/neutralized.png", event )
			end
			
			for i,entity_id in pairs( get_enemies_in_radius(500) ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_neutralized.xml", x, y )
				set_lifetime( effect_id, 0.4 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_above_head( effect_id, "data/ui_gfx/status_indicators/neutralized.png", event )
			end
		end,
	},
	{
		id = "HIGH_SPREAD",
		ui_name = "$streamingevent_high_spread",
		ui_description = "$streamingeventdesc_high_spread",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 1.0,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/effect_high_spread.xml", x, y )
				set_lifetime( effect_id, 0.75 )
				EntityAddChild( entity_id, effect_id )
				
				add_icon_in_hud( effect_id, "data/ui_gfx/status_indicators/high_spread.png", event )
			end
		end,
	},
	{
		id = "SPAWN_PERK_ENEMY",
		ui_name = "$streamingevent_spawn_perk_enemy",
		ui_description = "$streamingeventdesc_spawn_perk_enemy",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(500) ) do
				local x, y = EntityGetTransform( entity_id )
				
				SetRandomSeed( x, y * entity_id )
				
				if ( Random( 1, 3 ) == 1 ) then
					give_random_perk_to_enemy( entity_id )
				end
			end
		end,
	},
	{
		id = "ALL_ACCESS_TELEPORT",
		ui_name = "$streamingevent_all_access_teleport",
		ui_description = "$streamingeventdesc_all_access_teleport",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.5,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_enemies_in_radius(500) ) do
				EntityRemoveTag( entity_id, "teleportable_NOT" )
				EntityAddTag( entity_id, "teleportable" )
			end
		end,
	},
	{
		id = "HOLIDAY_MOOD",
		ui_name = "$streamingevent_holiday_mood",
		ui_description = "$streamingeventdesc_holiday_mood",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				local effect_id = EntityLoad( "data/scripts/streaming_integration/entities/holiday_mood.xml", x, y )
			end
		end,
	},
	{
		id = "FIREWORKS",
		ui_name = "$streamingevent_fireworks",
		ui_description = "$streamingeventdesc_fireworks",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.01,
		kind = STREAMING_EVENT_BAD,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local x, y = EntityGetTransform( entity_id )
				
				EntityLoad( "data/scripts/streaming_integration/entities/fireworks.xml", x, y )
			end
		end,
	},
	{
		id = "ADD_ALWAYS_CAST",
		ui_name = "$streamingevent_add_always_cast",
		ui_description = "$streamingeventdesc_add_always_cast",
		ui_icon = "data/ui_gfx/streaming_event_icons/speedy_enemies.png",
		ui_author = STREAMING_EVENT_AUTHOR_NOLLAGAMES,
		weight = 0.1,
		kind = STREAMING_EVENT_NEUTRAL,
		action = function(event)
			for i,entity_id in pairs( get_players() ) do
				local good_cards = { "DAMAGE", "CRITICAL_HIT", "HOMING", "SPEED", "ACID_TRAIL", "SINEWAVE" }

				-- "FREEZE", "MATTER_EATER", "ELECTRIC_CHARGE"
				local x, y = EntityGetTransform( entity_id )
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

				local wand = find_the_wand_held( entity_id )
				
				if ( wand ~= NULL_ENTITY ) then
					local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
					
					if ( comp ~= nil ) then
						local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
						local deck_capacity2 = EntityGetWandCapacity( wand )
						
						local always_casts = deck_capacity - deck_capacity2
						
						if ( always_casts < 4 ) then
							AddGunActionPermanent( wand, card )
						end
					end
				end
			end
		end,
	},
	--[[
	- Pelaaja polymorffaa
	/ Pelaajan maksimihp kasvaa
	/ Pelaajan maksimihp laskee
	/ Regen field
	/ Pelaaja kuolematon
	/ Viholliset saa shieldin
	/ Pelaaja saa shieldin
	/ Pelaaja nopeutuu
	/ Pelaaja hidastuu
	/ Viholliset hidastuu
	/ Refresh spells
	- Varastaa rahaa
	/ Kultasade
	/ Matosade
	/ Pommisade
	/ Zombisade
	/ Tynnyrisade
	/ Potionsade
	/ Sea of X
	/ Transmutation disease
	/ Pelaaja kastuu
	/ Pelaaja �ljyyntyy
	/ Pelaaja alkoholisoituu
	/ Pelaaja limautuu
	/ Viholliset limautuu
	/ Pelaajan kohdalla r�j�ht�� nuke (ei satuta pelaajaa)
	/ 1 x Mato
	/ 1 x Steve
	/ Kimpoilevat ammukset
	/ Bumerangiammukset
	/ Fizzle
	/ R�j�ht�v�t ammukset
	/ X trail
	/ 1 vihollinen saa randomsauvan
	/ Pelaaja saa randomsauvan
	/ Nesteet katoavat
	/ Sein�t katoavat
	/ Berserkviholliset
	/ Pelaajalle sieniefekti
	Pelaaja levitt�� kaasua
	/ Personal fireball thrower vihollisille
	/ Personal fireball thrower pelaajalle
	/ Gravity field pelaajalle
	- Pelaaja menett�� kaikki stainit
	/ Chest ilmestyy
	/ Kaikki projectilet muuttuvat giga_disc_bulleteiksi
	/ Kaikki t�m�nhetkiset projectilet muuttuvat nukeiksi
	/ Vihollisten p��lle ilmestyy gravity_field
	Pelaajalle contact damage
	Vihollisille contact damage
	Skeittilauta spawnaa
	Random fyssaobjekteja spawnaa
	Pelaajan sauva sököilee
	Parantaja-aave
	Shieldiaave
	Väliaikainen pora tms
	Hetkellinen exploding corpses
	]]-- 
}

--[[
gun_extra_modifiers.lua has new effects for these:
fizzle
explosive_projectile
projectile_fire_trail
projectile_acid_trail
projectile_oil_trail
projectile_water_trail
projectile_gunpowder_trail
projectile_lava_trail
projectile_poison_trail

using coroutines in an event's action:
async(function()
	GamePrint("1")
	wait(60)
	GamePrint("2")
	wait(60)
	GamePrint("3")
	wait(60)
	GamePrint("Done")
end)

]]--
