dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )
local rats = EntityGetWithTag( "plague_rat" )

if ( #rats < 30 ) then
	if ( Random( 1, 20 ) == 5 ) then
		EntityLoad( "data/entities/misc/perks/plague_rats_rat.xml", x, y )
	end
end

EntityKill( entity_id )