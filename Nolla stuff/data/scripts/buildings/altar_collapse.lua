dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/coroutines.lua")

async(function ()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	GameScreenshake( 40 )
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", pos_x, pos_y-58)
	
	wait( 60 )
	
	GameScreenshake( 40 )
	EntityLoad("data/entities/misc/loose_chunks.xml", pos_x, pos_y-32)
end)