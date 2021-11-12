dofile_once("data/scripts/lib/utilities.lua")

function spawn_ghost()
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )
	
	local opts = { "acidshooter", "worm_big", "scavenger_grenade", "scavenger_mine", "enlightened_alchemist", "shaman", "tank", "wizard_swapper" }
	
	SetRandomSeed( GameGetFrameNum(), x + entity_id )
	
	local raycasts = 4
	local dir = ( math.pi * 2.0 ) / raycasts
	local length = 8
	
	local rnd = Random( 1, #opts )
	local opt = "data/entities/animals/illusions/" .. opts[rnd] .. ".xml"
	
	local max_radius = 512
	local p = EntityGetInRadiusWithTag( x, y, max_radius, "player_unit" )
	
	if ( #p > 0 ) then
		local t = p[1]
		local px, py = EntityGetTransform( t )
		
		local dx = px + Random( -200, 200 )
		local dy = py + Random( -200, 200 )
		
		local dist = math.abs( py - dy ) + math.abs( px - dx )
		local limit = 0
		local wall = true
		
		while ( ( dist < 100 ) or wall ) and ( limit < 20 ) do
			dx = px + Random( -200, 200 )
			dy = py + Random( -200, 200 )
			dist = math.abs( py - dy ) + math.abs( px - dx )
			limit = limit + 1
			
			for j=0,raycasts-1 do
				local ex = dx + math.cos( j * dir ) * length
				local ey = dy - math.sin( j * dir ) * length
				
				wall = RaytraceSurfaces( dx, dy, ex, ey )
				
				if wall then
					break
				end
			end
		end
		
		EntityLoad( "data/entities/particles/poof_blue.xml", dx, dy )
		EntityLoad( opt, dx, dy )
	end
end

spawn_ghost()
