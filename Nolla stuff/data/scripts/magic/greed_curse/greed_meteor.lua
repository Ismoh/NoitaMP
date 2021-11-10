dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local how_many = 6
local circle = math.pi * 2.0
local dir = circle / how_many

SetRandomSeed( x, y )
local opts = { "goldnugget", "goldnugget_10", "goldnugget_50" }

for i=0,how_many-1 do
	local ox = x + math.cos(i * dir) * 12
	local oy = y - math.sin(i * dir) * 12
	
	local rnd = Random( 0, 2 ) * Random( 0, 1 ) * Random( 0, 1 )
	local opt = opts[rnd+1]
	
	EntityLoad( "data/entities/items/pickup/" .. opt .. ".xml", ox, oy )
end