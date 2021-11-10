-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')


function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )
	
	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	local is_rare = 0
	if( D(20) == 1 ) then is_rare = 1 end
	local add_default_actions = true

	if( ability_comp ~= nil ) then 

		local actions = ComponentObjectGetValue( ability_comp, "gun_config", "actions_per_round" )
		local reload = ComponentObjectGetValue( ability_comp, "gun_config", "reload_time" )
		local good_thing = 0

		actions = 1 --  otherwise it's not very machinegunny

		reload = 110 - 5 * D(10)
		if( is_rare == 1 ) then reload = reload * 0.5 end

		local name = ComponentGetValue( ability_comp, "ui_name" )
		if( gun_names ~= nil ) then 
			local rand_i = Random( 1, #gun_names )
			name = gun_names[ Random( 1, #gun_names ) ] .. ' ' .. name 
		end

		AddGunAction( entity_id, "LIGHT_BULLET_TIMER" )
		AddGunAction( entity_id, "Y_SHAPE" )
		AddGunAction( entity_id, "BULLET" )
		AddGunAction( entity_id, "BULLET" )

		-- change the bullets
		-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/handgun_", Random( 0, 7 )  )

		ComponentSetValue( ability_comp, "ui_name", name )
		ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", actions )
		ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", reload )
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

