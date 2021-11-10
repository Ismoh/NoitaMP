dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = Random( 1, 2 )
local types = { "worm", "worm_big", "worm_tiny" }

for i=1,count do
	local rnd = Random( 1, #types )
	local entity = types[rnd]
	
	local off_x,off_y = 0,0
	
	while ( math.abs( off_x ) + math.abs( off_y ) < 140 ) do
		off_x = Random( -256, 256 )
		off_y = Random( -256, 256 )
	end
	
	if ( entity ~= nil ) then
		EntityLoad( "data/entities/animals/" .. entity .. ".xml", pos_x + off_x, pos_y - off_y )
	end
end

GameScreenshake( 30 )
