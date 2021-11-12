dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 160, "homing_target" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent" )
		local plague_found = false
		
		if ( variablestorages ~= nil ) then
			for j,storage_id in ipairs( variablestorages ) do
				local var_name = ComponentGetValue( storage_id, "name" )
				if ( var_name == "plague_rats" ) then
					plague_found = true
					break
				end
			end
		end

		if ( plague_found == false and ( EntityHasTag( target_id, "polymorphed") == false) ) then
			EntityAddComponent( target_id, "VariableStorageComponent", 
			{ 
				name = "plague_rats",
			} )
			
			EntityAddComponent( target_id, "LuaComponent", 
			{ 
				script_death = "data/scripts/perks/plague_rats_death.lua",
				execute_every_n_frame = "-1",
			} )
		end
	end
end