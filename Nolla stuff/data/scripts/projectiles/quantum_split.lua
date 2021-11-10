dofile_once("data/scripts/lib/utilities.lua")

local angle = math.pi * 0.04
local slowdown = 0.8

local entity_id    = EntityGetRootEntity( GetUpdatedEntityID() )
local pos_x, pos_y = EntityGetTransform( entity_id )

local storage_comp = get_variable_storage_component(entity_id, "projectile_file")
if not storage_comp then return end
projectile_file = ComponentGetValue2( storage_comp, "value_string" )

local vel_x, vel_y = GameGetVelocityCompVelocity(entity_id)

-- left
local vx, vy = vec_rotate(vel_x, vel_y, -angle)
vx, vy = vec_mult(vx, vy, slowdown)
local left_id = shoot_projectile_from_projectile( entity_id, projectile_file, pos_x, pos_y, vx, vy )
EntityLoadToEntity("data/entities/misc/quantum_split_fx_red.xml", left_id)
EntityAddTag( left_id, "quantum_red" ) -- for death fx
EntityAddTag( left_id, "projectile_cloned" )

-- right
vx, vy = vec_rotate(vel_x, vel_y, angle)
vx, vy = vec_mult(vx, vy, slowdown)
local right_id = shoot_projectile_from_projectile( entity_id, projectile_file, pos_x, pos_y, vx, vy )
EntityLoadToEntity("data/entities/misc/quantum_split_fx_blue.xml", right_id)
EntityAddTag( right_id, "quantum_blue" ) -- for death fx
EntityAddTag( right_id, "projectile_cloned" )

-- nerf clones by removing things that may stack damage
local function modify_projectile(e)
	local projectile_comp = EntityGetFirstComponent( e, "ProjectileComponent")
	component_readwrite( projectile_comp, { penetrate_world = false, penetrate_entities = false }, function(comp)
		comp.penetrate_world = false
		comp.penetrate_entities = false
	end)
end
modify_projectile(left_id)
modify_projectile(right_id)

-- quantum entanglement
local function add_quantum_entity_ref(id, next_id)
	EntityAddComponent( id, "VariableStorageComponent", 
	{ 
		name = "next_quantum_entity",
		value_int = next_id,
	})
	EntityAddComponent( id, "LuaComponent", 
	{ 
		script_source_file="data/scripts/projectiles/quantum_split_kill.lua",
		execute_on_removed=1,
		execute_every_n_frame=-1,
	})
end
add_quantum_entity_ref(entity_id, left_id)
add_quantum_entity_ref(left_id, right_id)
add_quantum_entity_ref(right_id, entity_id)



