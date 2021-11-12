dofile_once("data/scripts/lib/utilities.lua")

function electricity_receiver_switched(on)
	local children = EntityGetAllChildren( GetUpdatedEntityID() )
	for i,child in ipairs( children ) do
		if EntityGetName( child ) == "laser" then
			for _,comp in pairs(EntityGetComponent(child, "LaserEmitterComponent")) do
				component_write( comp, { is_emitting = on } )
			end
		end
	end
end

function damage_received( damage, message, entity_thats_responsible, is_fatal )
	local children = EntityGetAllChildren( GetUpdatedEntityID() )
	for i,child in ipairs( children ) do
		if EntityGetName( child ) == "laser" then
			local vars = get_variable_storage_component( child, "laser_duration" )

			for _,comp in pairs(EntityGetComponent(child, "LaserEmitterComponent")) do
				component_write( comp, { emit_until_frame = GameGetFrameNum() + ComponentGetValue2(vars, "value_int" ) } )
			end
		end
	end
end