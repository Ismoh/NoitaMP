dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

--if( entity_who == entity_id ) then return end

local dirs = {{1,0}, {0,-1}, {-1,0}, {0,1}}

GameEntityPlaySound( entity_id, "duplicate" )

for i,dir in ipairs(dirs) do
	local ox = dir[1]
	local oy = dir[2]
	
	shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_centipede/orb_homing_part.xml", pos_x, pos_y, ox * 100, oy * 100 )
end