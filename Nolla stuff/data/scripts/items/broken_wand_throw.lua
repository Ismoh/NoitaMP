dofile_once("data/scripts/lib/utilities.lua")

local spell_amount = 18

function throw_item( from_x, from_y, to_x, to_y )
	local entity_id = GetUpdatedEntityID()
	
	-- store spell amount and throw time for broken_wand_spells.lua
	local comp = get_variable_storage_component(entity_id, "spells_remaining")
	ComponentSetValue2(comp, "value_int", spell_amount)

	comp = get_variable_storage_component(entity_id, "throw_time")
	ComponentSetValue2(comp, "value_int", GameGetFrameNum())
end

