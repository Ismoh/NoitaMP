dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )
local rats = EntityGetWithTag( "fungus_tiny_bad" )

if ( #rats < 30 ) then
	if ( Random( 1, 30 ) == 5 ) then
		local eid = EntityLoad( "data/entities/animals/fungus_tiny.xml", x, y )
	end
end

EntityKill( entity_id )