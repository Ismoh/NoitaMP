dofile_once("data/scripts/lib/utilities.lua")

function physics_body_modified( is_destroyed )
	-- print("damage")
	local entity_id = GetUpdatedEntityID()
	EntityKill( entity_id );

	edit_all_components( entity_id, "PhysicsBodyComponent", function(comp,vars)
		vars.on_death_really_leave_body = 1
	end)

	-- on_death_really_leave_body = 1

	--[[
	local components_to_remove = { 
		"ParticleEmitterComponent",
		"SpriteComponent",
		"LightComponent",
		"PhysicsBodyComponent"
	}
	
	for i0,comp_name in ipairs(components_to_remove) do
		local comp_ids = EntityGetComponent( entity_id, comp_name )
		if( comp_ids ~= nil ) then
			for i1,component_id in ipairs(comp_ids) do
				EntityRemoveComponent( entity_id, component_id )
			end
		end
	end

	local lua_components = EntityGetComponent( entity_id, "LuaComponent" )
	if( lua_components ~= nil ) then
		for i,v in ipairs(lua_components) do
			ComponentSetValue( v, "script_physics_body_modified", "")
		end
	end
	]]--
end