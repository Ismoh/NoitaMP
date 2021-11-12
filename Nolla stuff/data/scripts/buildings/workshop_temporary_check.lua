dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetInRadiusWithTag( x, y, 240, "player_unit" )

if ( #p == 0 ) then
	EntityKill( entity_id )
end