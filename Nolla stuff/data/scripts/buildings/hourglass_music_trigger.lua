function collision_trigger()
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform(entity_id)
	
	print("play jingle")
	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/ei_vihuja_01", true, pos_x, pos_y )
end