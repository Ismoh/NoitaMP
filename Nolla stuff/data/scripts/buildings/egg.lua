function damage_received( damage, desc, entity_who_caused, is_fatal )

	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
	
	if( Random( 0, 100 ) < 60 ) then
		EntityLoad( "data/entities/animals/boss_dragon.xml", pos_x, pos_y - 16 )
	end
end
