dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = 1

for i=1,count do
	local limit = 0
	local off_x,off_y = 0,0
	local failed = false
	
	while ( math.abs( off_x ) + math.abs( off_y ) < 90 ) do
		off_x = Random( -216, 216 )
		off_y = Random( -166, 166 )
		
		local sx = pos_x + off_x
		local sy = pos_y + off_y
		
		limit = limit + 1
		if ( limit > 20 ) then
			print( "Couldn't find a good spot" )
			failed = true
		end
	end
	
	if ( failed == false ) then
		EntityLoad( "data/entities/projectiles/deck/black_hole_big.xml", pos_x + off_x, pos_y + off_y )
	end
end

GameScreenshake( 20 )
