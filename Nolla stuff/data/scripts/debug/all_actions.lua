dofile("data/scripts/gun/gun_actions.lua")

function entity_chest_with_all_actions( x, y )
	local entity = EntityLoad( "data/entities/items/chest.xml", x, y)
	local components_item_chest = EntityGetComponent( entity, "ItemChestComponent" )

	local string_actions = ""
	
	for i,action in ipairs(actions) do

		string_actions = string_actions .. action.id .. ","
	end

	-- print( string_actions)

	ComponentSetValue( components_item_chest[1], "actions", string_actions )
end

local mouse_x, mouse_y = DEBUG_GetMouseWorld()
entity_chest_with_all_actions( mouse_x, mouse_y )