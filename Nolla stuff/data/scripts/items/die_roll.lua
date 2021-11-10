dofile_once("data/scripts/lib/utilities.lua")

function roll()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( variablestorages ~= nil ) then
		for j,storage_id in ipairs(variablestorages) do
			local var_name = ComponentGetValue( storage_id, "name" )
			if ( var_name == "rolling" ) then
				if ( ComponentGetValue2( storage_id, "value_int" ) == 0 ) then
					local players = EntityGetInRadiusWithTag( pos_x, pos_y, 480, "player_unit" )
					
					if ( #players > 0 ) then
						GamePrint( "$item_die_roll" )
					end
				end
				
				ComponentSetValue2( storage_id, "value_int", 1 )
				
				edit_component2( entity_id, "SpriteComponent", function(comp,vars)
					ComponentSetValue2( comp, "rect_animation", "roll")
				end)
			end
		end
	end
end

function damage_received()
	roll()
end

function enabled_changed( entity_id, is_enabled )
	if is_enabled then
		roll()
	end
end

function kick()
	roll()
end