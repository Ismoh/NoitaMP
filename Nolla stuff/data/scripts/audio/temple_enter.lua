dofile_once("data/scripts/biomes/temple_shared.lua" )

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	-- this is now handled by game_music.cpp via the below flag
	--[[if GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) == "1" then
		GameTriggerMusicEvent( "music/temple/necromancer_shop", true, pos_x, pos_y )
	else
		GameTriggerMusicEvent( "music/temple/enter", true, pos_x, pos_y )
	end]]--

	temple_set_active_flag( pos_x, pos_y, "1" )
end