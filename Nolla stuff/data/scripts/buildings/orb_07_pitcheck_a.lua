dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local b = EntityGetWithTag( "pitcheck_b" )
	
	for i,v in ipairs( b ) do
		EntitySetComponentsWithTagEnabled( v, "disabled", true )
	end
end