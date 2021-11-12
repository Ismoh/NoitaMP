dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

-- twist
if is_in_camera_bounds(x,y,50) then
	local t = GameGetFrameNum() * 0.02 + entity_id * 2.721
	local speed_mult = ProceduralRandomf(entity_id, 4, 0.1, 0.75)

	edit_all_components2( entity_id, "PhysicsJoint2MutatorComponent", function(comp,vars)
		local joint = ComponentGetValue2( comp, "joint_id" )
		local time_offset = joint * 0.632
		local spd = math.sin(t + time_offset) * speed_mult

		if joint == 1 then
			vars.motor_speed = -spd
		else
			vars.motor_speed = spd
		end
	end)
end

-- lift
-- use variable storage to get better result with various sizes
local storage_comp = get_variable_storage_component(entity_id, "lift")
component_read( storage_comp, { value_int = 0 }, function(comp)
	PhysicsApplyForce(entity_id, 0, comp.value_int)
end)
