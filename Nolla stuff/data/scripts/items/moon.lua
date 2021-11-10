dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 96
local float_range = 50
local float_force = 3
local float_sensor_sector = math.pi * 0.3

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

if is_in_camera_bounds(x,y,250) then
	function calculate_force_at(body_x, body_y)
		local distance = math.sqrt( ( x - body_x ) ^ 2 + ( y - body_y ) ^ 2 )
		if distance < 12 then
			-- stop attracting when near enough to prevent some collisions against moon
			return 0,0
		end
		local direction = 0 - math.atan2( ( y - body_y ), ( x - body_x ) )

		local gravity_percent = ( distance_full - distance ) / distance_full
		local gravity_coeff = 196
		
		local fx = math.cos( direction ) * ( gravity_coeff * gravity_percent )
		local fy = -math.sin( direction ) * ( gravity_coeff * gravity_percent )

	    return fx,fy
	end

	-- attract projectiles
	local entities = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")
	for _,id in ipairs(entities) do	
		local physicscomp = EntityGetFirstComponent(id, "PhysicsBody2Component") or EntityGetFirstComponent( id, "PhysicsBodyComponent")
		if physicscomp == nil then -- velocity for physics bodies is done later
			local px, py = EntityGetTransform( id )

			local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )
			if ( velocitycomp ~= nil ) then
				local fx, fy = calculate_force_at(px, py)
				edit_component( id, "VelocityComponent", function(comp,vars)
					local vel_x,vel_y = ComponentGetValue2( comp, "mVelocity")
					
					vel_x = vel_x + fx
					vel_y = vel_y + fy

					ComponentSetValue2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
		end
	end


	-- force field for physics bodies
	function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
		local fx, fy = calculate_force_at(body_x, body_y)

		fx = fx * 0.11 * body_mass
		fy = fy * 0.11 * body_mass

	    return body_x,body_y,fx,fy,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
	end
	local size = distance_full * 0.5
	PhysicsApplyForceOnArea( calculate_force_for_body, entity_id, x-size, y-size, x+size, y+size )
end

-- float by raycasting down and applying opposite physical force
do
	local dir_x = 0
	local dir_y = float_range
	dir_x, dir_y = vec_rotate(dir_x, dir_y, ProceduralRandomf(x, y + GameGetFrameNum(), -float_sensor_sector, float_sensor_sector))
	
	local did_hit,hit_x,hit_y = RaytracePlatforms( x, y, x + dir_x, y + dir_y )
	if did_hit then
		local dist = get_distance(x, y, hit_x, hit_y)
		dist = math.max(6, dist) -- tame a bit on close encounters
		dir_x = -dir_x / dist * float_force
		dir_y = -dir_y / dist * float_force
		PhysicsApplyForce(entity_id, dir_x, dir_y)
	end
end
