dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = EntityGetRootEntity( GetUpdatedEntityID() )
local pos_x, pos_y = EntityGetTransform( entity_id )

local storage_comp = get_variable_storage_component(entity_id, "next_quantum_entity")

if EntityHasTag(entity_id, "quantum_red") then
	EntityLoad("data/entities/misc/quantum_split_fx_red_die.xml", pos_x, pos_y)
elseif EntityHasTag(entity_id, "quantum_blue") then
	EntityLoad("data/entities/misc/quantum_split_fx_blue_die.xml", pos_x, pos_y)
end
EntityKill(entity_id)

if not storage_comp then return end

local next_id = ComponentGetValue2( storage_comp, "value_int" )
-- disable explosions etc
local projectile_comp = EntityGetFirstComponent(next_id, "ProjectileComponent")
component_write( projectile_comp, {
	on_lifetime_out_explode = false,
	on_death_explode = false,
} )
EntityKill(next_id)
