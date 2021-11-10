dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

local angle = 0
local rotation = 0
local owner_id = 0
local length = 40

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( variablestorages ~= nil ) then
	local anglestorage
	
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "angle" ) then
			angle = ComponentGetValue2( storage_id, "value_float" )
			anglestorage = storage_id
		elseif ( var_name == "rot" ) then
			rotation = ComponentGetValue2( storage_id, "value_int" )
		elseif ( var_name == "owner" ) then
			owner_id = ComponentGetValue2( storage_id, "value_int" )
		end
	end
	
	angle = angle + rotation * 0.015
	
	ComponentSetValue2( anglestorage, "value_float", angle )
end

angle = angle + rotation

if ( owner_id ~= NULL_ENTITY ) then
	local x, y = EntityGetTransform( owner_id )
	
	if ( x ~= nil ) and ( y ~= nil ) then
		local px = x + math.cos( angle ) * length
		local py = y - math.sin( angle ) * length
		
		EntitySetTransform( entity_id, px, py )
	else
		EntityKill( entity_id )
	end
end