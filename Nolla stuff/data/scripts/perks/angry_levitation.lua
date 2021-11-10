dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 240, "homing_target" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent" )
		local found = false
		
		if ( EntityHasTag( target_id, "angry_levitation" ) == false ) then
			if ( variablestorages ~= nil ) then
				for j,storage_id in ipairs( variablestorages ) do
					local var_name = ComponentGetValue( storage_id, "name" )
					if ( var_name == "angry_levitation" ) then
						found = true
						break
					end
				end
			end

			if ( found == false and ( EntityHasTag( target_id, "polymorphed") == false) ) then
				EntityAddTag( target_id, "angry_levitation" )
				
				EntityAddComponent( target_id, "VariableStorageComponent", 
				{ 
					name = "angry_levitation",
					value_int = entity_id,
				} )
				
				EntityAddComponent( target_id, "LuaComponent", 
				{ 
					script_death = "data/scripts/perks/angry_levitation_death.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end
	end
end