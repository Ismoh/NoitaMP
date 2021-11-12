dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y, angle = EntityGetTransform( entity_id )

angle = 0 - angle

local count = 12
local pi = 3.14159
local arc = pi * 0.6
local increment = arc / count
local current = angle - ( arc * 0.5 )
local speed = 220

for i=1,count do
	local vx = math.cos( current ) * speed
	local vy = 0-math.sin( current ) * speed
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/freezing_gaze_beam.xml", x, y, vx, vy )
	current = current + increment
end

EntityKill( entity_id )