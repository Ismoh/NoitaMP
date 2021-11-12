dofile_once("data/scripts/lib/utilities.lua")

local lerp_amount = 0.993

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local parent_id = EntityGetRootEntity(GetUpdatedEntityID())
local age = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")

-- make sure clouds continue from the same position when a new curse cloud is spawned
-- only keep the newest cloud alive
for _,id in pairs(EntityGetAllChildren(parent_id)) do
	if EntityHasTag(id, "curse_cloud") and id ~= entity_id then
		-- compare ages
		local comp = EntityGetFirstComponent(id, "LuaComponent", "curse_cloud_script")
		if comp and ComponentGetValue2(comp, "mTimesExecuted") < age then
			-- not youngest anymore. move the younger cloud here & kill self
			EntitySetTransform(id, pos_x, pos_y, 0, 1, 1)
			EntityKill(entity_id)
			return
		end
	end
end
	
-- move to parent when spawned if no other clouds present
if age <= 1 and pos_x == 0 and pos_y == 0 then
	pos_x, pos_y = EntityGetTransform(parent_id)
	EntitySetTransform( entity_id, pos_x, pos_y, 0, 1, 1)
	return
end

-- lerp towards target
local target_x, target_y = EntityGetTransform(parent_id)
if target_x == nil then return end

-- move towards target
pos_x,pos_y = vec_lerp(pos_x, pos_y, target_x, target_y, lerp_amount)
EntitySetTransform( entity_id, pos_x, pos_y, 0, 1, 1)
