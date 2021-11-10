dofile_once("data/scripts/lib/utilities.lua")

--[[function Component_SetTimeOut( entity_id, frames, script_file )
	local lua_comp = EntityAddComponent( entity_id, "LuaComponent" )

	ComponentSetValue( lua_comp, "mNextExecutionTime", GameGetFrameNum() + frames )
	ComponentSetValue( lua_comp, "script_source_file", script_file )
	ComponentSetValue( lua_comp, "remove_after_executed", "1" )
end
]]

function pressure_plate_change( new_state )
	
	-- find the temple door
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local entity_temple_door = EntityGetClosestWithTag( pos_x, pos_y, "temple_door" )

	if( entity_temple_door ~= nil ) then

		edit_all_components( entity_temple_door, "PhysicsJointComponent", function(comp,vars)
			-- local timer = ComponentGetValueInt( comp, "mEnabled")
			if( new_state == 1 ) then
				vars.mMotorEnabled = 1
			else
				vars.mMotorEnabled = 0
			end
		end)

		-- Component_SetTimeOut( entity_temple_door, 5*60, "data/scripts/props/physics_stopmousejoint.lua" )
	end
end