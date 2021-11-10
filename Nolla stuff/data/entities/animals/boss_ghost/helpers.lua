dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local help = EntityGetWithTag( "boss_ghost_helper" )
if ( #help < 2 ) then
	EntityLoad( "data/entities/animals/ethereal_being.xml", x, y )
end