-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')


function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	local is_rare = 0
	if( D(20) == 1 ) then is_rare = 1 end

	AddGunAction( entity_id, "ROCKET" )

	--print( D(20) )
	if( ability_comp ~= nil ) then 

		local actions = ComponentObjectGetValue( ability_comp, "gun_config", "actions_per_round" )
		local reload = ComponentObjectGetValue( ability_comp, "gun_config", "reload_time" )
		local shuffle = ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty" )
		local deck_capacity = ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" )
		local good_thing = 0

		-- actions=1 otherwise it's not very machinegunny
		-- reload should be low...
		reload = reload + 1 - D(6)
		if( is_rare == 1 ) then reload = reload - D(6) end
		
		if( is_rare == 1 ) then shuffle = 0 end

		if( D(25) == 1 ) then 
			shuffle = 0 
			good_thing = 1
		end

		deck_capacity = deck_capacity + D(6) - D(3)
		if( is_rare == 1 ) then deck_capacity = 11 + D(4) end

		if( is_rare or D(25) == 1 ) then
			actions = actions + 1
		end

		local name = ComponentGetValue( ability_comp, "ui_name" )
		if( gun_names ~= nil ) then name = gun_names[ Random( 1, #gun_names ) ] .. ' ' .. name end

		-- change the bullets
		if( D(10) == 1 ) then
			AddGunAction( entity_id, "SCATTER_2" )
		end

		if( good_thing == 0 and D(25) == 1 ) then
			AddGunAction( entity_id, "BURST_2" )
		end

		if( is_rare and shuffle == 0 ) then
			if( D(25) == 1 ) then
				AddGunAction( entity_id, "BURST_2" )
				AddGunAction( entity_id, "NUKE" )
			end
			local rocket_c = 6 + D(3)
			for i=1,rocket_c do
				AddGunAction( entity_id, "ROCKET" )
			end
		end

		local rocket_c = D(3)
		for i=1,rocket_c do
			AddGunAction( entity_id, "ROCKET" )
		end

		if( shuffle == 0 and deck_capacity > 6 ) then deck_capacity = 6 end

		-- add_these_child_actions = "ROCKET,ROCKET"

		-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/launcher_", Random( 0, 11 ) )
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

