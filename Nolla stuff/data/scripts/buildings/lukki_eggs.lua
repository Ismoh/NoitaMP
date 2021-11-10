function spawn_lukki( entity_id, pos_x, pos_y )	
	GamePlaySound( "data/audio/Desktop/animals.bank", "lukki_eggs/destroy", pos_x, pos_y )
	EntityLoad( "data/entities/animals/lukki/lukki_tiny.xml", pos_x, pos_y )
end

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
	
	if ( is_fatal or Random(0,100) < 10 ) and ( damage > 0.1 ) then
		spawn_lukki( entity_id, pos_x, pos_y )
	end
end
