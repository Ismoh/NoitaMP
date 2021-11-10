dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

perk_spawn_random( x, y )

EntityKill( entity_id )
