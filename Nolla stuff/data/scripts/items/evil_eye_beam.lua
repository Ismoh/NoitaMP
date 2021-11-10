dofile_once("data/scripts/lib/utilities.lua")

local distance = 9
local iris_distance = 2
local rot_lerp_amount = 0.25

local entity_id = GetUpdatedEntityID()
local children = EntityGetAllChildren(entity_id)
if #children == 0 then return end
local laser_id = children[1]

local item_x, item_y, rot = EntityGetTransform( entity_id )

-- beam direction
local x,y = GameGetVelocityCompVelocity(entity_id)
if get_magnitude(x, y) <= 30 then
	-- align beam with item if moving slow/when in hand
	x,y = 1,0
	x,y = vec_rotate(x,y,rot)
else
	-- get angle from velocity
	x,y = vec_normalize(x,y)
	rot = math.atan2(y,x)
	rot_lerp_amount = 0.15
end

-- smooth out changes in rotation
local _,_,prev_rot = EntityGetTransform(laser_id)
rot = rot_lerp(rot, prev_rot, rot_lerp_amount)

-- iris location
-- NOTE: the iris sprite in the entity stays disabled after this script is run.
-- This seemed like the most dependable way to keep the sprite drawn in the
-- wanted orientation and in front of object
local iris_x,iris_y = vec_normalize(x,y)
iris_x,iris_y = vec_mult(iris_x,iris_y,iris_distance)
iris_x,iris_y = vec_add(iris_x,iris_y,item_x,item_y)
GameCreateSpriteForXFrames( "data/items_gfx/evil_eye_iris.png", iris_x, iris_y )

-- avoid hitting player when moving fast
local root_id = EntityGetRootEntity(entity_id)
if IsPlayer(root_id) then
	local vx,vy = GameGetVelocityCompVelocity(root_id)
	-- offset amount depends on how closely aligned player velocity and beam direction are
	local amount = math.max(vec_dot(vx,vy,x,y), 0) * 0.4
	amount = math.min(amount, 0.2)
	vx,vy = vec_mult(vx,vy, amount)
	x,y = vec_add(vx,vy,x,y)
end

-- apply offset
x,y = vec_mult(x,y,distance)
x,y = vec_add(x,y,item_x,item_y)

EntitySetTransform(laser_id, x, y, rot)

-- enable laser emission, disable iris sprite
local comps = EntityGetAllComponents(laser_id)
if #comps < 2 then return end
ComponentSetValue2( comps[1], "is_emitting", true ) -- enable laser emitter
EntitySetComponentIsEnabled( laser_id, comps[1], true )
EntitySetComponentIsEnabled( laser_id, comps[2], true )

ComponentAddTag(GetUpdatedComponentID(), "enabled_in_world" ) -- laser stays on after picked up once

-- clean up initial iris sprite entity
if #children > 1 then
	EntityKill(children[2])
end