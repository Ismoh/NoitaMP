dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x * GameGetFrameNum(), y )

local orbdata = orb_map_get()

local pw,mx = check_parallel_pos( x )

if ( Random( 1, 25 ) == 4 ) then
	local closest = -1
	local cdist = 999999

	for i,v in ipairs(orbdata) do
		local ox = v[1] * 512 + 256
		local oy = v[2] * 512 + 256
		
		local dist = get_distance( mx, y, ox, oy )
		
		if ( dist < cdist ) then
			cdist = dist
			closest = i
		end
	end

	if ( closest > -1 ) then
		local v = orbdata[closest]
		local ox = v[1] * 512 + 256
		local oy = v[2] * 512 + 256
		
		-- print( "Closest orb is at " .. tostring(v[1]) .. ", " .. tostring(v[2]) .. " (parallel: " .. tostring(pw) .. ", " .. tostring(mx) .. ")" )
		
		local dir = get_direction( ox, oy, mx, y )
		
		local vel_x = math.cos( dir ) * 400
		local vel_y = 0 - math.sin( dir ) * 400
		
		shoot_projectile( entity_id, "data/entities/misc/orb_line.xml", x, y, vel_x, vel_y )
	end
end

EntityKill( entity_id )
