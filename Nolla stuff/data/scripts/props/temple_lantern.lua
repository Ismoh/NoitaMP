-- creates a chain to ceiling

dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local segment_length = 6
local search_dist = 200
local break_force_mid = 6
local break_force_end = 15
local break_distance_end = 20
local break_distance_mid = 3

local count = 0
local mat = CellFactory_GetType( "metal_chain_nohit" )

-- create chains
local offset_x = 3
local offset_y = 0
local x = pos_x + offset_x
local y = pos_y + offset_y

local ceiling_found,_,ceiling_y = RaytracePlatforms( x, y, x, y - search_dist )
local dist = y - ceiling_y

if ceiling_found == true and dist > segment_length then
	-- to local space
	y = offset_y - segment_length
	x = offset_x

	local body_id = 101

	-- bottom segment. attach to root with id 100
	EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
	{
		body_id = body_id,
		offset_x = x,
		offset_y = y,
		image_file = "data/props_gfx/torch_hang_chain.png",
		material = mat
	})
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT",
		offset_x = x + 1.5, -- center the joint
		offset_y = y + segment_length, -- joint is on the bottom of the shape
		body1_id = 100,
		body2_id = body_id,
		break_force = break_force_end,
		break_distance = break_distance_end,
	})
	y = y - segment_length

	-- middle segments
	for i=0, dist / segment_length - 2 do
		body_id = body_id + 1
		EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
		{
			body_id = body_id,
			offset_x = x,
			offset_y = y,
			image_file = "data/props_gfx/torch_hang_chain.png",
			material = mat
		})
		EntityAddComponent2( entity_id, "PhysicsJoint2Component",
		{
			type = "REVOLUTE_JOINT",
			offset_x = x + 1.5,
			offset_y = y + segment_length,
			body1_id = body_id - 1,
			body2_id = body_id,
			break_force = break_force_mid,
			break_distance = break_distance_mid,
		})
		y = y - segment_length
	end

	-- attach to ceiling
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = x + 1.5,
		offset_y = y + segment_length,
		body1_id = body_id,
		break_force = break_force_end,
		break_distance = break_distance_end,
		ray_x = 0,
		ray_y = -32,
	})
end


-- done
PhysicsBody2InitFromComponents( entity_id )
EntitySetComponentIsEnabled( entity_id, GetUpdatedComponentID(), false)
