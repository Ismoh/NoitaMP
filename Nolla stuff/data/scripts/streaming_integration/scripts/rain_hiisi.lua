dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = Random( 1, 3 )
local types = { "zombie", "miner", "shotgunner", "scavenger_smg", "scavenger_grenade", "scavenger_heal", "scavenger_mine", "sniper" }

local raycasts = 4
local dir = ( math.pi * 2.0 ) / raycasts
local length = 8

for i=1,count do
	local rnd = Random( 1, #types )
	local entity = types[rnd]
	
	local limit = 0
	local off_x,off_y = 0,0
	local wall = true
	local failed = false
	
	while ( math.abs( off_x ) + math.abs( off_y ) < 100 ) or wall do
		off_x = Random( -256, 256 )
		off_y = Random( -256, 256 )
		
		local sx = pos_x + off_x
		local sy = pos_y + off_y
		
		for j=0,raycasts-1 do
			local ex = sx + math.cos( j * dir ) * length
			local ey = sy - math.sin( j * dir ) * length
			
			wall = RaytraceSurfaces( sx, sy, ex, ey )
			
			if wall then
				break
			end
		end
		
		limit = limit + 1
		if ( limit > 20 ) then
			print( "Couldn't find a good spot" )
			wall = false
			failed = true
		end
	end
	
	if ( entity ~= nil ) and ( failed == false ) then
		EntityLoad( "data/entities/animals/" .. entity .. ".xml", pos_x + off_x, pos_y + off_y )
		EntityLoad( "data/scripts/streaming_integration/entities/empty_circle_small.xml", pos_x + off_x, pos_y + off_y )
	end
end

GameScreenshake( 10 )
