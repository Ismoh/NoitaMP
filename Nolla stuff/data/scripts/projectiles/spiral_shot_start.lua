dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local how_many = 4
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = math.rad(6)-GameGetFrameNum() / 10.0
local length = 16

for i=1,how_many do
	local new_x = pos_x + math.cos( theta ) * length
	local new_y = pos_y + math.sin( theta ) * length

	local eid = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/spiral_part.xml", new_x, new_y, 0, 0 )
	local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "theta" )
	if ( comp ~= nil ) then
		ComponentSetValue2( comp, "value_float", theta )
	end
	
	EntityAddChild( entity_id, eid )
	--shoot_projectile_from_projectile( entity_id, "data/entities/particles/spiral_shot_particle.xml", new_x, new_y, 0, 0 )
	
	theta = theta + angle_inc
end
