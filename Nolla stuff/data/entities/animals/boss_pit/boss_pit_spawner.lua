dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )

if ( Random( 1, 10 ) == 5 ) then
	EntityLoad( "data/entities/animals/boss_pit/boss_pit.xml", x, y )
end

EntityKill( entity_id )