dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local orbcount = GameGetOrbCountThisRun()
local branches = 8 + math.floor(orbcount / 2) * 2 -- 8,10,12,14...
local space = math.floor(360 / branches)

-- circleshots to 8 directions
local speed = 80
local angle = 0
-- spawn projectiles on each branch
for i=1,branches do
	local vel_x = math.cos( math.rad(angle) ) * speed
	local vel_y = math.sin( math.rad(angle) ) * speed
	shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_centipede/orb_circleshot.xml", pos_x, pos_y, vel_x, vel_y )
	angle = angle + space
end

