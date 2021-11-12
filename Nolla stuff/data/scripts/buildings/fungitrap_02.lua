dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), entity_id + y )

local entities = EntityGetInRadiusWithTag( x, y, 160, "fungitrap_02" )

if ( #entities < 4 ) then
	local rnd = Random( 1, 7 )
	local angle = math.rad( Random( 1, 180 ) )
	local speed = 200

	local vel_x = math.cos( 0 - angle ) * speed
	local vel_y = 0 - math.sin( 0 - angle ) * speed

	if ( rnd == 5 ) then
		shoot_projectile( entity_id, "data/entities/buildings/fungitrap_02_projectile.xml", x, y, vel_x, vel_y )
	end
end