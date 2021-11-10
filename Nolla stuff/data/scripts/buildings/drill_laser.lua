dofile_once("data/scripts/lib/utilities.lua")

-- machine is turned on when the machine is jolted with electricity and fuel is present
-- machine turns off when fuel runs out

function set_lasers(on)
	-- lasers
	local entity_id = GetUpdatedEntityID()
	local children = EntityGetAllChildren(entity_id)
	for i,child in ipairs( children ) do
		if EntityHasTag( child, "drill_laser" ) then
			for _,comp in pairs(EntityGetComponent(child, "LaserEmitterComponent")) do
				component_write( comp, { is_emitting = on } )
			end
			EntitySetComponentsWithTagEnabled( child, "laser_fx", on )
		end
	end

	-- fuel igniter drip
	EntitySetComponentsWithTagEnabled(entity_id, "igniter", on)
end

function electricity_receiver_switched(on)
	-- only fuel running out will turn off the lasers
	if not on then return end

	-- turn lasers on when jolted with electricity and fuel is present
	local entity_id = GetUpdatedEntityID()
	local comp = get_variable_storage_component( entity_id, "is_fueled" )
	on = ComponentGetValue2(comp, "value_bool")

	-- print("switched on: " .. tostring(on))
	set_lasers(on)
end

function material_area_checker_success(pos_x, pos_y)
	-- fuel present
	local entity_id = GetUpdatedEntityID()
	local comp = get_variable_storage_component( entity_id, "is_fueled" )
	ComponentSetValue2(comp, "value_bool", true)
	-- print("fuel present")
end

function material_area_checker_failed(pos_x, pos_y)
	-- fuel gone
	local entity_id = GetUpdatedEntityID()
	local comp = get_variable_storage_component( entity_id, "is_fueled" )
	ComponentSetValue2(comp, "value_bool", false)

	set_lasers(false)
	-- print("fuel gone")
end

