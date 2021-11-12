dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/coroutines.lua")

async(function ()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	GameScreenshake( 40 )
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", pos_x, pos_y-12 )
	
	wait( 40 )

	GameScreenshake( 40 )
	PhysicsRemoveJoints( pos_x - 80, pos_y - 80, pos_x + 80, pos_y + 20 )

	wait( 20 )
	
	GameScreenshake( 40 )
	EntityLoad("data/entities/misc/loose_chunks_workshop.xml", pos_x, pos_y-12)
	
	Debug_SaveTestPlayer()
end)