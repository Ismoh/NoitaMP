dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local segment_length = 10
local search_dist = 60
local break_force_mid = 5
local break_force_end = 15

if not DoesWorldExistAt( pos_x - search_dist, pos_y, pos_x + search_dist, pos_y ) then return end

local _,x_max = RaytracePlatforms( pos_x, pos_y, pos_x + search_dist, pos_y )
local _,x_min = RaytracePlatforms( pos_x, pos_y, pos_x - search_dist, pos_y )

-- min length check
if x_max - x_min < 30 then
	EntityKill(entity_id)
	return
end

-- look for ceiling anchor positions
local anchors = {}
for x = x_min, x_max, 30 do
	if RaytracePlatforms( x, pos_y, x, pos_y - 15 ) then anchors[#anchors+1] = x end
end

if #anchors == 0 then
	EntityKill(entity_id)
	return
end

-- add one last anchor if needed
if math.abs(x_max - anchors[#anchors]) > 5 then
	if RaytracePlatforms( x_max, pos_y, x_max, pos_y - 15 ) then anchors[#anchors+1] = x end
end

local mat = CellFactory_GetType( "metal_wire_nohit" )
local body_id = 1000
function do_wire(from_x, to_x)
	local x = from_x - pos_x -- in local space
	local dist = to_x - from_x
	local y = 0

	-- start segment. go downwards for some added slack
	EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
	{
		body_id = body_id,
		offset_x = x,
		offset_y = y,
		image_file = "data/props_breakable_gfx/wire_vertical_10_00.png",
		material = mat
	})
	-- left ceiling joint
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = x + 0.5, -- take thickness into account
		offset_y = y,
		body1_id = body_id,
		break_force = break_force_end,
		break_distance = 16,
		ray_x = 0,
		ray_y = -32,
	})
	y = y + segment_length
	x = x + 0.5

	-- middle segments horizontally
	for i=0, dist / segment_length - 1 do
		body_id = body_id + 1
		EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
		{
			body_id = body_id,
			offset_x = x,
			offset_y = y,
			image_file = "data/props_breakable_gfx/wire_horizontal_10_00.png",
			material = mat
		})
		EntityAddComponent2( entity_id, "PhysicsJoint2Component",
		{
			type = "REVOLUTE_JOINT",
			offset_x = x,
			offset_y = y + 0.5, -- take thickness into account,
			body1_id = body_id - 1,
			body2_id = body_id,
			break_force = break_force_mid,
			break_distance = 6,
		})
		x = x + segment_length
	end

	-- last segment goes back up
	body_id = body_id + 1
	EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
	{
		body_id = body_id,
		offset_x = x,
		offset_y = y - segment_length,
		image_file = "data/props_breakable_gfx/wire_vertical_10_00.png",
		material = mat,
	})
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT",
		offset_x = x,
		offset_y = y + 0.5,
		body1_id = body_id - 1,
		body2_id = body_id,
		break_force = break_force_mid,
		break_distance = 6,
	})

	-- right ceiling joint
	y = y - segment_length
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = x + 0.5,
		offset_y = y,
		body1_id = body_id,
		break_force = break_force_end,
		break_distance = 30,
		ray_x = 0,
		ray_y = -32,
	})

	body_id = body_id + 1
end

-- init
if #anchors >= 4 then
	local mid_anchor = ProceduralRandomi(pos_x, pos_y, 2, #anchors - 1)
	do_wire(anchors[1], anchors[mid_anchor])
	pos_x = pos_x - 2 -- bit of spacing between 2 wires
	do_wire(anchors[mid_anchor], anchors[#anchors])
	PhysicsBody2InitFromComponents( entity_id )
elseif #anchors >= 2 then
	do_wire(anchors[1], anchors[#anchors])
	PhysicsBody2InitFromComponents( entity_id )
end
