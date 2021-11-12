dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

function collision_trigger()
	local duplicator_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( duplicator_id )
	
	local entity_id = EntityGetClosestWithTag( x, y, "card_action" )
	local action_id = ""

	edit_component( entity_id, "ItemActionComponent", function(comp,vars)
		action_id = ComponentGetValue( comp, "action_id")
	end)

	if action_id == "" or action_id == nil then
		return -- HACK: if we got no action_id the entity is not in_world
	end

	---- duplicate the entity, now that we know we're actually interested in it
	
	print("Found card with entity_id " .. tostring(entity_id) .. " and action_id " .. tostring(action_id) )
	
	local eid = CreateItemActionEntity( string.lower(action_id), x, y )
	local cardcost = 100
	
	for i,carddata in pairs(actions) do
		if (carddata.id == action_id) then
			cardcost = math.floor(tonumber(carddata.price) * 1.2)
		end
	end
	
	EntityAddComponent( eid, "SpriteComponent", { 
		_tags="shop_cost,enabled_in_world",
		image_file="data/fonts/font_pixel_white.xml", 
		is_text_sprite="1", 
		offset_x="7", 
		offset_y="25", 
		update_transform="1" ,
		update_transform_rotation="0",
		text="111",
		} )

	EntityAddComponent( eid, "ItemCostComponent", { 
		_tags="shop_cost", 
		cost=cardcost 
		} )
		
	EntityAddComponent( eid, "LuaComponent", { 
		script_item_picked_up="data/scripts/items/shop_effect.lua",
		} )
	-- shop_item_pickup2.lua

	-- display uses remaining, if any
	edit_component( eid, "ItemComponent", function(comp,vars)
		local uses_remaining = tonumber( ComponentGetValue(comp, "uses_remaining" ) )
		if uses_remaining > -1 then
			EntityAddComponent( eid, "SpriteComponent", { 
				_tags="shop_cost,enabled_in_world",
				image_file="data/fonts/font_pixel_white.xml", 
				is_text_sprite="1", 
				offset_x="16", 
				offset_y="32", 
				has_special_scale="1",
				special_scale_x="0.5",
				special_scale_y="0.5",
				update_transform="1" ,
				update_transform_rotation="0",
				text=tostring(uses_remaining),
				} )
		end
	end)

	EntityKill( duplicator_id )
end