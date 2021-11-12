dofile_once( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local doing_newgame_plus = false

-- stats & locations
local endpoint_underground = EntityGetWithTag( "ending_sampo_spot_underground" )
local endpoint_mountain = EntityGetWithTag( "ending_sampo_spot_mountain" )
local enemies_killed = tonumber( StatsGetValue("enemies_killed") )
local orb_count = GameGetOrbCountThisRun()

-- print( "orb_count: " .. orb_count )

-- orb count 33 and on top of the mountain!

-- handle newgame+
-- if orb_count >= 5 and we're on top of the mountain
-- 5 + new_game_plus_number
local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
if ( newgame_n >= 3 ) then
	AddFlagPersistent( "progress_newgameplusplus3" )
end

local greed = GameHasFlagRun( "greed_curse" )
local greed_gone = GameHasFlagRun( "greed_curse_gone" )
local nightmare = GameHasFlagRun( "run_nightmare" )

if greed and ( greed_gone == false ) then
	AddFlagPersistent( "secret_greed" )
end

if nightmare then
	AddFlagPersistent( "progress_nightmare" )
end

local essence_1 = GameHasFlagRun( "essence_fire" )
local essence_2 = GameHasFlagRun( "essence_air" )
local essence_3 = GameHasFlagRun( "essence_water" )
local essence_4 = GameHasFlagRun( "essence_laser" )

if essence_1 and essence_2 and essence_3 and essence_4 then
	AddFlagPersistent( "secret_allessences" )
end

local newgame_orbs_required = 5 + newgame_n
if( orb_count < 33 
	and 
	( ( orb_count > ORB_COUNT_IN_WORLD and newgame_orbs_required >= ORB_COUNT_IN_WORLD and orb_count >= newgame_orbs_required ) or 
	 ( orb_count >= newgame_orbs_required and orb_count < ORB_COUNT_IN_WORLD ) ) ) then
	
	local distance_from_mountain = 1000
	--local distance_from_bottom = 1000

	if( #endpoint_mountain > 0 ) then
		local ex, ey = EntityGetTransform( endpoint_mountain[1] )
		distance_from_mountain = math.abs(x - ex) + math.abs(y - ey)
	end

	if ( distance_from_mountain < 32 ) then
		-- on top of mountain -> new game+
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/new_game_plus/create", x, y )
		EntityKill( entity_id )
		GameClearOrbsFoundThisRun()

		-- move player up 25 pixels, so they don't end up inside the ground at start
		local player_id = EntityGetClosestWithTag( x, y, "player_unit")
		if( player_id ~= nil and player_id ~= 0 ) then
			local px, py = EntityGetTransform( player_id )
			py = py - 25
			EntitySetTransform( player_id, px, py )
		end
		
		AddFlagPersistent( "progress_ngplus" )
		doing_newgame_plus = true
		do_newgame_plus()

	end
end

-- "normal ending handlings"
if( doing_newgame_plus == false ) then
	print("Sampo: " .. tostring(x) .. ", " .. tostring(y))

	GameAddFlagRun( "ending_game_completed" )	-- this affects the look of the game over screen
	GameOnCompleted() -- this does the achievement

	--SetTimeOut( 15.0, "data/entities/animals/boss_centipede/ending/sampo_show_ending_ui.lua", "main" )

	--EntityLoad("data/entities/particles/gold_pickup.xml", x, y)
	-- print("Enemies killed: " .. tostring(enemies_killed) )

	print(tostring(endpoint_underground))

	if( orb_count >= 33 ) then
		-- ORBS >= 33 ENDINGs
		-- on top -> new game+
		AddFlagPersistent( "secret_amulet" )
		
		if ( orb_count > 33 ) then
			-- AddFlagPersistent( "secret_amulet_gem" )
			GameAddFlagRun( "ending_game_completed_with_34_orbs" )
		end
		
		local distance_from_mountain = 1000

		if( #endpoint_mountain > 0 ) then
			local ex, ey = EntityGetTransform( endpoint_mountain[1] )
			distance_from_mountain = math.abs(x - ex) + math.abs(y - ey)
		end

		if ( distance_from_mountain < 32 ) then
			-- ending 2, everyone is happy
			EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
			
			local player_id = EntityGetWithTag( "player_unit" )
			
			-- "progress_ending2"
			AddFlagPersistent( "progress_ending2" )
			GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/happy_ending/create", x, y )

			GameDoEnding2()
			
			EntityKill( entity_id )

			-- this is done in GameDoEnding2()
			-- GamePrintImportant( "$ending_above_part_a", "$ending_above_part_b" )
		end
	--[[
	elseif ( orb_count >= ORB_COUNT_IN_WORLD) then
		-- in practice this the 12 orb ending
		-- ORBS >= 11 ENDINGs
		-- on top -> new game+
		local distance_from_mountain = 1000

		if( #endpoint_mountain > 0 ) then
			local ex, ey = EntityGetTransform( endpoint_mountain[1] )
			distance_from_mountain = math.abs(x - ex) + math.abs(y - ey)
		end

		if ( distance_from_mountain < 32 ) then

			local endpoint_id = endpoint_mountain[1]
			local ex, ey = EntityGetTransform( endpoint_id )
			
			local distance = math.abs(x - ex) + math.abs(y - ey)
			
			if (distance < 32) then
				EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
				
				local player_id = EntityGetWithTag( "player_unit" )
				
				if ( #player_id > 0 ) then
					print(player_id[1])
					local midas_id = EntityLoad( "data/entities/animals/boss_centipede/ending/midas.xml", x, y )
					EntityAddChild( player_id[1], midas_id )
				end
				
				AddFlagPersistent( "progress_ending1" )
				
				EntityLoad( "data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y )
				EntityLoad( "data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y )
				GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/midas_above/create", x, y )

				EntityKill( entity_id )

				-- this sets the INFINITE GOLD action
				local world_entity_id = GameGetWorldStateEntity()
				if( world_entity_id ~= nil ) then
					local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
					if( comp_worldstate ~= nil ) then
						ComponentSetValue( comp_worldstate, "INFINITE_GOLD_HAPPENING", "1" )
					end
				end
			end
		end
	]]--
	elseif ( #endpoint_underground > 0 ) then
		-- NORMAL ENDING
		local endpoint_id = endpoint_underground[1]
		local ex, ey = EntityGetTransform( endpoint_id )
		
		local distance = math.abs(x - ex) + math.abs(y - ey)
		
		if (distance < 32) then
			EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
			
			AddFlagPersistent( "progress_ending0" )
			
			EntityLoad( "data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y )
			EntityLoad( "data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y )
			EntityLoad( "data/entities/animals/boss_centipede/ending/midas_walls.xml", x, y )
			EntityLoad( "data/entities/animals/boss_centipede/sampo_working.xml", ex, ey - 30 )
			
			-- Note( Petri ): This is what kills the player
			-- if( enemies_killed > 0 ) then
			if( orb_count ~= ORB_COUNT_IN_WORLD ) then
				EntityLoad( "data/entities/animals/boss_centipede/ending/gold_effect.xml", x, y )
			end
			-- end

			GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/midas/create", x, y )
			
			local ambience = EntityGetWithTag( "victoryroom_ambience" )
			
			for a,b in ipairs( ambience ) do
				EntityKill( b )
			end
			
			EntityKill( entity_id )
		end
		
		local machine = EntityGetWithTag( "ending_mechanism" )
		
		if ( #machine > 0 ) then
			print("Machineryfound, trying to animate")
			local machine_id = machine[1]
			local machine_sprite = EntityGetFirstComponent( machine_id, "SpriteComponent" )
			if ( machine_sprite ~= nil ) then
				ComponentSetValue( machine_sprite, "rect_animation", "active" )
			end
		end
	elseif ( #endpoint_mountain > 0 ) then
		-- SECRET ENDING
		local endpoint_id = endpoint_mountain[1]
		local ex, ey = EntityGetTransform( endpoint_id )
		
		local distance = math.abs(x - ex) + math.abs(y - ey)
		
		if (distance < 32) then
			EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
			
			local player_id = EntityGetWithTag( "player_unit" )
			
			if ( #player_id > 0 ) then
				print(player_id[1])
				local midas_id = 0
				if( orb_count == ORB_COUNT_IN_WORLD ) then
					midas_id = EntityLoad( "data/entities/animals/boss_centipede/ending/midas.xml", x, y )
					AddFlagPersistent( "progress_ending1_gold" )
				else
					midas_id = EntityLoad( "data/entities/animals/boss_centipede/ending/midas_radioactive.xml", x, y )
					AddFlagPersistent( "progress_ending1_toxic" )
				end

				-- turn player extra vurnable to radioactive materials
				local comp_damagemodel = EntityGetFirstComponent( player_id[1], "DamageModelComponent" )
				if( comp_damagemodel ~= nil ) then
					ComponentSetValue( comp_damagemodel, "materials_damage_proportional_to_maxhp", "1" )
				end

				EntityAddChild( player_id[1], midas_id )
			end
			
			AddFlagPersistent( "progress_ending1" )
			
			EntityLoad( "data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y )
			EntityLoad( "data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y )
			GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/midas_above/create", x, y )

			EntityKill( entity_id )

			-- this sets the INFINITE GOLD action
			local world_entity_id = GameGetWorldStateEntity()
			if( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "INFINITE_GOLD_HAPPENING", "1" )
				end
			end

		end
	end
end