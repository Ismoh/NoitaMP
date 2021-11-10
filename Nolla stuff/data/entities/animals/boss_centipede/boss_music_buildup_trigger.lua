dofile( "data/scripts/lib/utilities.lua" )

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	print("Boss buildup music triggered")

	GlobalsSetValue( "BOSS_ARENA_BUILDUP_TRIGGERED", "1" )
	GameTriggerMusicEvent( "music/boss_arena/buildup", true,  pos_x, pos_y )
end