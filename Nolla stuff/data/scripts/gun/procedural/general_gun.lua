-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')


function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )

	if( ability_comp ~= nil ) then 

		local actions = 1
		local actions_D10 = D10()

		if( actions_D10 >= 1 and actions_D10 <= 2 ) then actions = 1 end
		if( actions_D10 >= 3 and actions_D10 <= 9 ) then actions = 2 end
		if( actions_D10 == 10 ) then actions = 3 end


		local reload = 10 + (D10() * 5)


		local shuffle = 1
		local shuffle_D10 = D10()

		if( shuffle_D10 == 10 ) then shuffle = 0 end

		local capacity = D10() + 4

		local name = ComponentGetValue( ability_comp, "ui_name" )
		if( gun_names ~= nil ) then name = gun_names[ Random( 1, #gun_names ) ] .. ' ' .. name end

		ComponentSetValue( ability_comp, "ui_name", name )
		ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", actions )
		ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", reload )
		ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", shuffle )
		ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", capacity  )

		-- debug
		--[[
		print( ComponentGetValue( ability_comp, "ui_name" ) )
		print( ComponentObjectGetValue( ability_comp, "gun_config", "actions_per_round" ))
		print( ComponentObjectGetValue( ability_comp, "gun_config", "reload_time" ))
		print( ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty" ))
		print( ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" ))
		print( ComponentGetValue( ability_comp, "add_these_child_actions" ) )
		]]--

	end
end

generate_gun()

