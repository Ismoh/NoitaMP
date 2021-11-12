dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )

	local x,y = EntityGetTransform( entity_item )

	GameTriggerMusicFadeOutAndDequeueAll( 10.0 )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/sampo_pick/create", x, y )
	GameTriggerMusicEvent( "music/boss_arena/battle", false, x, y )
	SetRandomSeed( x, y )
	GlobalsSetValue( "FINAL_BOSS_ACTIVE", "1" )

	EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
	print("Sampo pickup: " .. tostring(x) .. ", " .. tostring(y))

	local entities = EntityGetWithTag( "sampo_or_boss" )
	if ( #entities == 0 ) then
		print_error("boss - couldn't find sampo")
		return
	end

	local reference = EntityGetWithTag( "reference" )
		
	if( #reference == 0 ) then
		print_error("boss - couldn't find reference")
		return
	end
	
	local reference_id = reference[1]
	x,y = EntityGetTransform( reference_id )

	local enemies_killed = tonumber( StatsGetValue("enemies_killed") )

	local fight_player = true
	
	-- pacifist
	if( enemies_killed == 0 ) then 
		fight_player = false
		
		for key,entity_id in pairs(entities) do
			EntitySetComponentsWithTagEnabled( entity_id, "enabled_at_start", false )
		end
	end
	
	-- debug
	-- Note( Petri ): Boss should actually fight you all the time, since it's a more interesting problem for the player to 
	-- to do a complete pacifist run. Which I think is totally doable
	fight_player = true

	if( fight_player ) then
	
		for key,entity_id in pairs(entities) do
			EntitySetComponentsWithTagEnabled( entity_id, "disabled_at_start", true )
			EntitySetComponentsWithTagEnabled( entity_id, "enabled_at_start", false )
			PhysicsSetStatic( entity_id, false )

			if EntityHasTag( entity_id, "boss_centipede" ) then
				EntityAddTag( entity_id, "boss_centipede_active" )
				
				local child_entities = EntityGetAllChildren( entity_id )
				local child_to_remove = 0
				
				if ( child_entities ~= nil ) then
					for i,child_id in ipairs( child_entities ) do
						EntityHasTag( child_id, "protection" )
						child_to_remove = child_id
					end
				end
				
				if ( child_to_remove ~= 0 ) then
					EntityKill( child_to_remove )
				end
			end
		end
		
		EntityLoad("data/entities/animals/boss_centipede/loose_lavaceiling.xml", x-235, y-73)
		EntityLoad("data/entities/animals/boss_centipede/loose_lavaceiling.xml", x+264, y-50)
		EntityLoad("data/entities/animals/boss_centipede/loose_lavabridge.xml", x-235, y+282)
		EntityLoad("data/entities/animals/boss_centipede/loose_lavabridge.xml", x+257, y+262)
		
		local player = EntityGetWithTag( "player_unit" )
		
		if( #player == 0 ) then
			print_error("boss - couldn't find player_unit")
			return
		end
		
		local player_id = player[1]
		x,y = EntityGetTransform( player_id )
		
		--local sampo_effect = EntityLoad("data/entities/animals/boss_centipede/ending/sampo_effect.xml", x, y)
		--EntityAddChild( player_id, sampo_effect )
	end

	if( fight_player == false ) then
		y = y + 50
		EntityLoad( "data/entities/buildings/teleport_ending_victory.xml", x, y )
	end

end