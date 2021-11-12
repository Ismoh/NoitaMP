dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

local angle = 0
local rotation = 0
local owner_id = 0
local length = 8

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( variablestorages ~= nil ) then
	local anglestorage
	local lengthstorage
	
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "angle" ) then
			angle = ComponentGetValue2( storage_id, "value_float" )
			anglestorage = storage_id
		elseif ( var_name == "length" ) then
			length = ComponentGetValue2( storage_id, "value_float" )
			lengthstorage = storage_id
		elseif ( var_name == "rot" ) then
			rotation = ComponentGetValue2( storage_id, "value_int" )
		elseif ( var_name == "owner" ) then
			owner_id = ComponentGetValue2( storage_id, "value_int" )
		end
	end
	
	angle = angle + rotation * 0.015
	length = length + 0.8
	
	ComponentSetValue2( anglestorage, "value_float", angle )
	ComponentSetValue2( lengthstorage, "value_float", length )
end

if ( owner_id ~= NULL_ENTITY ) then
	local x, y = EntityGetTransform( owner_id )
	
	if ( x ~= nil ) and ( y ~= nil ) then
		local px = x + math.cos( angle ) * length
		local py = y - math.sin( angle ) * length
		
		EntitySetTransform( entity_id, px, py )
		
		local others = EntityGetWithTag( "all_spells_part" )
		
		for i,eid in ipairs( others ) do
			if ( eid ~= entity_id ) then
				variablestorages = EntityGetComponent( eid, "VariableStorageComponent" )
				local eid_owner = 0
				
				if ( variablestorages ~= nil ) then
					for j,storage_id in ipairs(variablestorages) do
						local var_name = ComponentGetValue( storage_id, "name" )
						if ( var_name == "owner" ) then
							eid_owner = ComponentGetValue2( storage_id, "value_int" )
							break
						end
					end
				end
				
				if ( eid_owner == owner_id ) then
					x, y = EntityGetTransform( eid )
					
					local dir = 0 - math.atan2( y - py, x - px )
					local dist = math.sqrt( ( y - py ) ^ 2 + ( x - px ) ^ 2 ) * 3.24
					
					shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/all_spells_orb.xml", px, py, math.cos(dir) * dist, 0 - math.sin(dir) * dist )
				end
			end
		end
	else
		EntityKill( entity_id )
	end
end