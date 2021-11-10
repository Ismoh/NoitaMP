dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
local hpdiff = 0.0
local hp = 0.0
local max_hp = 0.0

if ( variablestorages ~= nil ) then
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "effect_hearty" ) then
			hpdiff = ComponentGetValue2( storage_id, "value_float" )
		end
	end
end

if ( hpdiff > 0 ) then
	edit_component( player_id, "DamageModelComponent", function(comp,vars)
		hp = ComponentGetValue2( comp, "hp" )
		max_hp = ComponentGetValue2( comp, "max_hp" )
		
		local diff = hp / max_hp
		
		max_hp = max_hp * 2.0
		hp = max_hp * diff
		
		ComponentSetValue2( comp, "max_hp", max_hp )
		ComponentSetValue2( comp, "hp", hp )
	end)
end