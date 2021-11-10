dofile_once("data/scripts/lib/utilities.lua")

local n_sprites = 6

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local segments = ProceduralRandom(pos_x, pos_y, 2, 10)
local has_two_joints = ProceduralRandom(pos_y, pos_x) < 0.4
if has_two_joints then segments = segments * 2 end

EntityAddComponent2(entity_id, "VerletPhysicsComponent", {
	num_points = segments,
	stiffness = 1.5,
	velocity_dampening = 0.95,
	resting_distance = 8 ,
	pixelate_sprite_transforms = true,
	follow_entity_transform = false,
	simulate_wind = true,
	wind_change_speed = 0.025,
	simulate_gravity = true
})

-- random segments
local prev_sprite = -1
for i=1,segments do
	local function randomize(seed) return math.floor(ProceduralRandom(pos_x + i, pos_y + seed, 1, n_sprites + 1)) end
	local sprite_i = randomize(0)
	local tries = 0
	-- avoid repeats
	while sprite_i == prev_sprite and tries < 10 do
		sprite_i = randomize(tries)
		tries = tries + 1
	end
	prev_sprite = sprite_i
	EntityLoadToEntity("data/entities/verlet_chains/root/root_parts/root_verlet_" .. tostring(sprite_i) .. ".xml", entity_id)
end

-- MoveToSurfaceOnCreateComponent
local joint_type
if has_two_joints then
	joint_type = "VERLET_ROPE_TWO_JOINTS"
else
	joint_type = "VERLET_ROPE_ONE_JOINT"
end
EntityAddComponent2(entity_id, "MoveToSurfaceOnCreateComponent", {
	verlet_min_joint_distance = 16,
	type = joint_type
})
