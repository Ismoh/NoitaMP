-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')

function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	local is_rare = 0
	if( D(20) == 1 ) then is_rare = 1 end

	if( ability_comp ~= nil ) then 

		local actions = ComponentObjectGetValue( ability_comp, "gun_config", "actions_per_round" )
		local reload = ComponentObjectGetValue( ability_comp, "gun_config", "reload_time" )
		local shuffle = ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty" )
		local deck_capacity = ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" )
		-- actions=2, maybe if your extra lucky it's 3
		-- reload should be low...
		if( is_rare == 1 and D(3) == 1 ) then
			actions = 3
		end

		-- 45 - 80?
		reload = 40 + 5 * D(8)
		if( is_rare == 1 ) then reload = reload - 5 * D(6) end

		if( is_rare == 1 and D(3) == 1 ) then 
			shuffle = 0 
		end

		deck_capacity = deck_capacity + D(3) - 1

		if( is_rare == 1 ) then deck_capacity = deck_capacity + D(4) end
		if( shuffle == 0 and deck_capacity > 6 ) then deck_capacity = 6 end

		-- set the bullets
		if( D(10) == 1 ) then
			AddGunAction( entity_id, "BURST_3" )
			AddGunAction( entity_id, "HEAVY_BULLET" )
			AddGunAction( entity_id, "HEAVY_BULLET" )
			AddGunAction( entity_id, "BULLET" )
		else
			AddGunAction( entity_id, "SCATTER_3" )
			AddGunAction( entity_id, "HEAVY_BULLET" )
			AddGunAction( entity_id, "HEAVY_BULLET" )
			AddGunAction( entity_id, "BULLET" )
		end

		if( D(10) == 1 ) then
			AddGunAction( entity_id, "BULLET" )
		end

		if( is_rare == 1 ) then 
			AddGunAction( entity_id, "BURST_3" ) 
		end
		
		local name = ComponentGetValue( ability_comp, "ui_name" )
		if( is_rare == 1 ) then name = 'Legendary ' .. name end
		if( is_rare == 0 and gun_names ~= nil ) then name = gun_names[ Random( 1, #gun_names ) ] .. ' ' .. name end


		-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/shotgun_", Random( 0, 12 ) )
		ComponentSetValue( ability_comp, "ui_name", name )
		ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", actions )
		ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", reload )
		ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", shuffle )
		ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", deck_capacity  )
	end

	-- set the color of the light
	if( is_rare == 1 ) then
		local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )
		if( light_comp ~= nil ) then
			ComponentSetValue( light_comp, "update_properties", 1)
			ComponentSetValue( light_comp, "r", 128 )
			ComponentSetValue( light_comp, "g", 0 )
			ComponentSetValue( light_comp, "b", 255 )
		end
	end
end

generate_gun()

