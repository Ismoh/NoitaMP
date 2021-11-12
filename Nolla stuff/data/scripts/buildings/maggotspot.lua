dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local t = EntityGetInRadiusWithTag( pos_x, pos_y, 220, "player_unit" )

if ( #t > 0 ) then
	local eid = EntityLoad( "data/entities/animals/maggot_tiny/maggot_tiny.xml", pos_x, pos_y )
	EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", pos_x, pos_y )

	EntityKill( entity_id )
end