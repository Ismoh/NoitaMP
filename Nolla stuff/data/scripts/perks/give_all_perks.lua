dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local players = EntityGetWithTag( "player_unit" )

SetRandomSeed( x, y )

if ( #players > 0 ) then
	local player_id = players[1]
	
	for i,v in ipairs( perk_list ) do
		local perk_id = v.id
		
		perk_pickup( 0, player_id, perk_id, false, false, true )
	end
end

EntityKill( entity_id )
	