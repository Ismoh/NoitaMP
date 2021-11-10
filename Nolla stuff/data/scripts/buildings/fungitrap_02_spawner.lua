dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local entities = EntityGetInRadiusWithTag( x, y, 200, "fungitrap_02" )

if ( #entities < 6 ) then
	EntityLoad( "data/entities/props/physics_fungus_trap.xml", x, y )
	EntityKill( entity_id )
end