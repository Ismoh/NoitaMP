dofile_once("data/scripts/lib/utilities.lua")

function enabled_changed( entity_id, is_enabled )
	local x,y
	if is_enabled then
		x, y = EntityGetTransform( EntityGetParent( entity_id ) )
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/tiny_ghost/activate", x, y )
	else
		x, y = EntityGetTransform( entity_id )
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/tiny_ghost/deactivate", x, y )
	end
	
	EntityLoad( "data/entities/particles/tiny_ghost_poof.xml", x, y )
end