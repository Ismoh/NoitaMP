dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local speed = 15
local dir = 0

-- propel forward only when close to ground
if RaytracePlatforms(x,y+15,x,y+35) then	
	local is_reversed = ComponentGetValue2(get_variable_storage_component(entity_id, "reverse"), "value_bool")
	dir = is_reversed and -1 or 1
end
speed = speed * dir

-- apply speed to motors
for _,comp in pairs(EntityGetComponent(entity_id, "PhysicsJoint2MutatorComponent")) do
	component_write( comp, { motor_speed = speed })
end

-- extra gravity for traction + some direct force for smoother movement
PhysicsApplyForce(entity_id, speed * 0.25, 5)

