function AddGunActionPermanent( entity_id, action_id )
	if( action_id == "" ) then return 0 end
	local action_entity_id = CreateItemActionEntity( action_id )
	if action_entity_id ~= 0 then
		EntityAddChild( entity_id, action_entity_id )
	end

	-- we need to add a slot to the ability_comp
	local ability_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "AbilityComponent" )
	if( ability_comp ~= nil ) then
		local deck_capacity = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" ) )
		deck_capacity = deck_capacity + 1
		ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", deck_capacity )
	end

	--[[edit_component( action_entity_id, "ItemComponent", function(comp, vars)
		vars.permanently_attached = "1"
	end)]]--
	local item_component = EntityGetFirstComponent( action_entity_id, "ItemComponent" )
	if( item_component ~= nil ) then 
		ComponentSetValue( item_component, "permanently_attached", "1" )
	end

	if action_entity_id ~= nil then
		EntitySetComponentsWithTagEnabled( action_entity_id, "enabled_in_world", false )
	end
end

function AddGunAction( entity_id, action_id )
	if( action_id == "" ) then return 0 end
	local action_entity_id = CreateItemActionEntity( action_id )
	if action_entity_id ~= 0 then
		EntityAddChild( entity_id, action_entity_id )
		EntitySetComponentsWithTagEnabled( action_entity_id, "enabled_in_world", false )
	end
end


function find_the_wand_held( entity_id )
	local children = EntityGetAllChildren( entity_id )
	if ( children == nil ) then return 0 end

	local backup_result = 0

	-- Inventory2Component
	-- mActiveItem
	local inventory2_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "Inventory2Component" )
	if ( inventory2_comp ~= nil ) then
		local active_item = ComponentGetValue( inventory2_comp, "mActiveItem" )
		if ( EntityHasTag( active_item, "wand" ) ) then
			return active_item
		end
	end
	
	-- if that doesn't work (e.g. player is holding something else than a wand)
	for i,child in ipairs( children ) do
		if( EntityHasTag( child, "wand" ) ) then
			if ( EntityGetFirstComponent( child, "ItemComponent") ~= nil ) then
				return child
			end
			if ( ComponentGetIsEnabled( EntityGetFirstComponentIncludingDisabled( child, "ItemComponent") ) ) then
				backup_result = child
			end
		else
			local temp_result = find_the_wand_held( child )
			if ( temp_result ~= 0 ) then
				if ( EntityGetFirstComponent( temp_result, "ItemComponent") ~= nil ) then
					return temp_result
				else
					backup_result = temp_result
				end
			end
		end
	end

	return backup_result
end



function IMPL_find_all_wands_held( entity_id, out_array )
	local children = EntityGetAllChildren( entity_id )
	if( children == nil ) then return 0 end
	
	for i,child in ipairs( children ) do
		if( EntityHasTag( child, "wand" ) ) then
			table.insert( out_array, child )
		else
			IMPL_find_all_wands_held( child, out_array )
		end
	end

end

function find_all_wands_held( entity_id )
	local children = EntityGetAllChildren( entity_id )
	if( children == nil ) then return 0 end

	local result = { }
	
	IMPL_find_all_wands_held( entity_id, result )
	
	return result
end
