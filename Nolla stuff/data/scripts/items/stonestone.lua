
function kick()
	x, y = EntityGetTransform( GetUpdatedEntityID() )
	EntityLoad( "data/entities/misc/loose_chunks_projectile.xml", x, y )
	GameScreenshake( 60, x, y )
end