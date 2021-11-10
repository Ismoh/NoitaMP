dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y, d = EntityGetTransform( GetUpdatedEntityID() )

local players = EntityGetWithTag( "player_unit" )

if ( players ~= nil ) and ( #players > 0 ) then
	local player = players[1]
	local px,py = EntityGetTransform( player )
	local dir = math.atan2( py - y, px - x )

	EntitySetTransform( entity_id, x, y, dir )
end