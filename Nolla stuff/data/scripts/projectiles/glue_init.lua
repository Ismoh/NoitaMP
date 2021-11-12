dofile_once("data/scripts/lib/utilities.lua")

local max_dist = 40
local tag = "hittable"

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

-- set initial position
local children = EntityGetAllChildren(entity_id)
for _,anchor in ipairs(children) do
	if EntityHasTag(anchor, "glue_anchor") then
		EntitySetTransform(anchor, pos_x, pos_y)
	end
end

-- optimization: remove when it gets crowded
if #EntityGetInRadiusWithTag( pos_x, pos_y, 80, "glue") > 10 then
	EntityKill(entity_id)
	return
end

-- identify target & check that it's valid
local target = EntityGetClosestWithTag( pos_x, pos_y, tag)
if target == nil or target == 0 then return end

target = EntityGetRootEntity(target)
local tx, ty = EntityGetTransform(target)
if get_distance(pos_x, pos_y, tx, ty) > max_dist or EntityHasTag( target, "glue_NOT" ) then return end

-- assign a target to glue anchor
component_write( EntityGetFirstComponent( children[1], "VariableStorageComponent" ), { value_int = target } )

-- optional secondary target
local targets = EntityGetInRadiusWithTag( pos_x, pos_y, max_dist, tag)
if #targets < 2 then return end

SetRandomSeed(pos_x, pos_y + GameGetFrameNum())
local target2 = EntityGetRootEntity(random_from_array(targets))
if target2 ~= target then
	component_write( EntityGetFirstComponent( children[2], "VariableStorageComponent" ), { value_int = target2 } )
end
