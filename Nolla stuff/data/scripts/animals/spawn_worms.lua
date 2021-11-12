dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = Random(1,3)
local types = { "worm", "worm_big", "worm_tiny" }

for i=1,count do
	local rnd = Random( 1, #types )
	local entity = types[rnd]
	
	if ( entity ~= nil ) then
		entity_id = EntityLoad( "data/entities/animals/" .. entity .. ".xml", pos_x + Random( -360, 360 ), pos_y - 300 )
	end
end

GameScreenshake( 30 )
