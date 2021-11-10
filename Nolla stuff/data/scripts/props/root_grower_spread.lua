dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- don't grow when there's people around
for _,e in pairs(EntityGetInRadiusWithTag( pos_x, pos_y, 10, "mortal" )) do
	if not EntityHasTag(e, "root") then return end
end

-- sense to 2 directions and steer towards the one with most space
local sensor_angle = math.pi * 0.4
local sensor_distance = 100
local steer_strength = 0.2

edit_component2( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	
	if get_magnitude(vel_x, vel_y) < 0.01 then
		-- init to random dir if needed
		vel_y = -1
		vel_x, vel_y = vec_rotate(vel_x, vel_y, ProceduralRandomf(pos_x, pos_y + 12, math.pi * 2))
	end
	
	-- add sine wobble
	local t = GameGetFrameNum()
	t = t + entity_id * 0.01
	local wobble = math.sin(t * 0.2) * 0.3 -- hi freq
	wobble = wobble + math.sin(t * 0.0394) * 0.2 -- low freq
	vel_x, vel_y = vec_rotate(vel_x, vel_y, wobble)

	local original_vel_x = vel_x
	local original_vel_y = vel_y
	local sensor_x = vel_x
	local sensor_y = vel_y
	local max_distance = 0

	-- sense left and right
	sensor_x, sensor_y = vec_rotate(sensor_x, sensor_y, -sensor_angle)
	for i=0, 2 do
		-- offset ray start positions so it won't collide with root itself
		local did_hit,hit_x,hit_y = RaytraceSurfaces(pos_x + sensor_x * 16, pos_y + sensor_y * 16, pos_x + sensor_x * sensor_distance, pos_y + sensor_y * sensor_distance)
		if did_hit then
			local hit_distance = get_distance2(pos_x, pos_y, hit_x, hit_y)
			if hit_distance >= max_distance then
				-- result found
				max_distance = hit_distance
				vel_x = sensor_x
				vel_y = sensor_y
			end
		else
			-- ray hit nothing making it the longest
			max_distance = sensor_distance
			vel_x = sensor_x
			vel_y = sensor_y
		end

		-- rotate sensor from left to right
		if i==0 then
			sensor_x, sensor_y = vec_rotate(sensor_x, sensor_y, sensor_angle * 2)
		end
	end

	-- blend result with old heading for smooth turns
	-- this also helps hide the fact that we have very limited sensors
	vel_x = lerp(vel_x, original_vel_x, steer_strength)
	vel_y = lerp(vel_y, original_vel_y, steer_strength)

	vel_x,vel_y = vec_normalize(vel_x,vel_y) -- these SHOULD remain normalized but let's make sure we don't mess it up in subtle way

	-- store movement heading and move
	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
	EntitySetTransform(entity_id, pos_x + vel_x * 2, pos_y + vel_y * 2) -- coarser movement (multiplier of 2) works well enough
end)

-- spice it up with some extra particles
GameCreateParticle( "grass", pos_x, pos_y - 2, 1, 0, 0, false)
