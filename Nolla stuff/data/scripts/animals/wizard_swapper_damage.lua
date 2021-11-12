function damage_received( damage, desc, entity_who_caused, is_fatal )
	if not EntityGetIsAlive( entity_who_caused ) then
		return
	end

	local entity_a    = GetUpdatedEntityID()
	local xa,ya = EntityGetTransform( entity_a )
	
	local entity_b = entity_who_caused
	local xb,yb = EntityGetTransform( entity_b )

	EntitySetTransform( entity_a, xb, yb )
	EntitySetTransform( entity_b, xa, ya )

	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/swapper/swap", xa, ya );
end
