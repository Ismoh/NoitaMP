dofile_once("data/scripts/lib/utilities.lua")

--function collision_trigger(target_id)
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
local target_id = EntityGetClosestWithTag( x, y, "enemy")
if not target_id then return end

if not IsPlayer(target_id) then
	local children = EntityGetAllChildren(entity_id)
	if #children == 0 then return end
	local shield_id = children[1]

	-- don't do more than 1 shield per enemy
	if EntityHasTag(target_id, "has_energy_shield")	then
		EntityKill(entity_id)
		return
	end

	-- reduce health of target for balance
	component_readwrite( EntityGetFirstComponent(target_id, "DamageModelComponent" ), { hp = 0, max_hp = 0 }, function(comp)
	  comp.max_hp = math.max(comp.max_hp * 0.55, comp.max_hp - 4)
	  comp.hp = comp.max_hp
	end)

	-- enable shield
	for _,comp in pairs(EntityGetAllComponents(shield_id)) do
		EntitySetComponentIsEnabled(shield_id, comp, true)
	end

	-- transfer shield & remove spawner
	EntityRemoveFromParent(shield_id)
	EntityAddChild(target_id, shield_id)
	EntityAddTag(target_id, "has_energy_shield")
	EntityKill(entity_id)
end
