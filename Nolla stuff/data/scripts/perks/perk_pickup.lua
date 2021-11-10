dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local kill_other_perks = true

	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )
	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "perk_dont_remove_others") then
				if( ComponentGetValueBool( comp_id, "value_bool" ) ) then
					kill_other_perks = false
				end
			end
		end
	end

	perk_pickup( entity_item, entity_who_picked, item_name, true, kill_other_perks )
end
