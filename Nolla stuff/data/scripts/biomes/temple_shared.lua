
function temple_pos_to_id( pos_x, pos_y )
	local h = math.floor( pos_y / 512 )
	local w = math.floor( ( pos_x + (32*512) ) / (64*512) )

	local result = tostring(w) .. "_" .. tostring(h)
	return result
end

function temple_set_active_flag( pos_x, pos_y, flag )
	local workshop_aabb = EntityGetClosestWithTag( pos_x, pos_y, "workshop_aabb")
	if workshop_aabb ~= 0 then
		local x,y = EntityGetTransform( workshop_aabb )
		local key = "TEMPLE_ACTIVE_" .. tostring(math.floor(x)) .. "_" .. tostring(math.floor(y))
		GlobalsSetValue( key, flag )
	end
end

function temple_spawn_guardian( pos_x, pos_y )

	if( GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) == "1" ) then
		-- peace_with_gods perk
		return
	end

	local guard_spawn_id = EntityGetClosestWithTag( pos_x, pos_y, "guardian_spawn_pos" )
	local guard_x = pos_x
	local guard_y = pos_y

	-- if distance is too far
	if( guard_spawn_id ~= 0  ) then
		guard_x, guard_y = EntityGetTransform( guard_spawn_id )
		
		--[[local distance = math.abs( guard_x - spawn_pos_x ) + math.abs( guard_y - spawn_pos_y )
		if( distance < 640 ) then
			guard_x = spawn_pos_x
			guard_y = spawn_pos_y
		end
		]]--

		-- kill the spawn target, so that it doesn't come and haunt us in subsequent spawns
		EntityKill( guard_spawn_id )
	end

	EntityLoad( "data/entities/misc/spawn_necromancer_shop.xml", guard_x, guard_y )
	-- this is now handled by game_music.cpp
	--[[if BiomeMapGetName() == "$biome_holymountain" then
		GameTriggerMusicFadeOutAndDequeueAll( 4.0 )
		GameTriggerMusicEvent( "music/temple/necromancer_shop", true, pos_x, pos_y )
	end]]--
end

-- return bool
function temple_should_we_spawn_checkers( pos_x, pos_y )
	if( MagicNumbersGetValue( "DESIGN_TEMPLE_CHECK_FOR_LEAKS") == "0" ) then
		return false
	end

	local leak_name = "TEMPLE_LEAKED_" .. temple_pos_to_id( pos_x, pos_y )

	if( GlobalsGetValue( leak_name ) == "1" ) then
		return false
	end

	local collapse_name = "TEMPLE_COLLAPSED_" .. temple_pos_to_id( pos_x, pos_y )

	if( GlobalsGetValue( collapse_name ) == "1" ) then
		return false
	end
	return true
end


-- return values "1", "1"
-- return values spawn_shop, spawn_perks
function temple_random( x, y )
	if( MagicNumbersGetValue( "DESIGN_TEMPLE_CHECK_FOR_LEAKS") == "0" ) then
		return "1", "1"
	end

	--if( GlobalsGetValue( "TEMPLE_LEAKED" ) == "1" ) then
	--	return "1", "0"
	--end

	return "1", "1"
end
