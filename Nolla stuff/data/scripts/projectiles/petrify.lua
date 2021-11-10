dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if EntityHasTag(root_id, "polymorphable_NOT") then
	EntityKill(entity_id)
	return
end

component_readwrite( EntityGetFirstComponent(root_id, "DamageModelComponent" ), { hp = 0, max_hp = 0, ragdoll_material = "meat" }, function(comp)
	local health_ratio = 0.4
	local convert_radius = 25

	local x, y = EntityGetFirstHitboxCenter(root_id)

	if comp.hp / comp.max_hp <= health_ratio then
		EntityRemoveFromParent(entity_id) -- detach to avoid being killed along with the enemy

		-- mWhoShot
		local who_shot = 0
		component_read(get_variable_storage_component(entity_id, "projectile_who_shot"), { value_int = 0 }, function(varstor_comp)
			who_shot = varstor_comp.value_int
		end)

		EntityInflictDamage(root_id, comp.max_hp, "DAMAGE_CURSE", "$damage_curse", "NONE", 0, 0, who_shot)
		
		-- convert ragdoll material
		EntityAddComponent( entity_id, "MagicConvertMaterialComponent", 
		{ 
			from_material = CellFactory_GetType(comp.ragdoll_material),
			to_material = CellFactory_GetType("sand_petrify"),
			radius = convert_radius,
			steps_per_frame = 1,
			kill_when_finished = "1",
		} )

		-- convert gold
		EntityAddComponent( entity_id, "MagicConvertMaterialComponent", 
		{ 
			from_material = CellFactory_GetType("gold_box2d"),
			to_material = CellFactory_GetType("air"),
			radius = convert_radius,
			steps_per_frame = convert_radius,
			loop = "1",
		} )

		-- spawn rock
		EntityLoad("data/entities/props/physics_stone_0" .. ProceduralRandomi(x, y, 1, 4) .. ".xml", x-1, y-7)
	else
		EntityKill(entity_id)
	end
end)

