dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/biomes/temple_shared.lua" )

function material_area_checker_failed( pos_x, pos_y )

	if( GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) == "1" ) then
		GamePrintImportant( "$logdesc_temple_peace_temple_break", "" )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", pos_x, pos_y )
		return
	end

	local leak_name = "TEMPLE_LEAKED_" .. temple_pos_to_id( pos_x, pos_y )

	-- spawn workshop guard
	if( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) ~= "1" ) then
		temple_spawn_guardian( pos_x, pos_y )
	end

	GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" )


	if( GlobalsGetValue( leak_name ) ~= "1" ) then
		if tonumber(GlobalsGetValue("STEVARI_DEATHS", 0)) < 3 then
			GamePrintImportant( "$logdesc_temple_spawn_guardian", "" )
		else
			GamePrintImportant( "$logdesc_gods_are_very_angry", "" )
			GameGiveAchievement( "GODS_ENRAGED" )
		end
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", pos_x, pos_y )
		GameScreenshake( 150 )
		-- NOTE( Petri ): Disabled loosing perks for now, since guardian
		--[[ 
		local perk_count = GlobalsGetValue( "TEMPLE_PERK_COUNT" )
		if( perk_count == "" ) then 
			perk_count = 3
		else
			perk_count = tonumber(perk_count)
		end

		perk_count = perk_count - 1
		GlobalsSetValue( "TEMPLE_PERK_COUNT", tostring(perk_count) )
		-- remove all the perks
		local perk_id = EntityGetClosestWithTag( pos_x, pos_y, "perk" )
		
		if (perk_id ~= 0) then
			EntityKill( perk_id )
		end
		]]--
	end

	GlobalsSetValue( leak_name, "1" )

end

--[[function material_area_checker_failed( pos_x, pos_y )

	local h = math.floor( pos_y / 512 )
	-- print( h )
	-- local temple_leaks = tonumber( GlobalsGetValue( "TEMPLE_LEAKED" ) )
	if( GlobalsGetValue( "TEMPLE_LEAKED" ) ~= "1" ) then
		GamePrintImportant( "You have angered the Gods", "" )
		GameScreenshake( 150 )
	end

	GlobalsSetValue( "TEMPLE_LEAKED", "1" )

	-- remove all the perks
	local all_perks = EntityGetWithTag( "perk" )
	
	if ( #all_perks > 0 ) then
		for i,entity_perk in ipairs(all_perks) do
			EntityKill( entity_perk )
		end
	end
end
]]--