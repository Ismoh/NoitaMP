function D10()
	return Random(1,10)
end

function D( size )
	return Random(1,size)
end

gun_names = {
  'Deadly','Rusty','Old','New','Shiny','Lethal','Dangerous','Large','Enormous','Tiny','Small','Big','Pretty','Terrifying','Confusing',
  'Mystery','Superior','Inferior','Destructive','Chaotic','Lawful','Good','Bad','Neutral','Worn','Polished','Waxen','Strong','Weak',
  'Complex','Tactical','Horrifying','Scary','Scratched','Untested','Prototype','Type a','Type b','Type x','Secret','Special','Unique',
  'Mega','Super','Giga','Turbo','Hyper','Alpha','Omega','Extreme','Vanilla','Flavourful','Sturdy','Solid','Used','Unused','Grey','Gray',
  'Sepia','Secretly','Actual','Genuine','Powerful','Double','Triple','Stereo','Ancient','Antique','Rustic','Artisan','Slick','Slim',
  'Bulky','Heavy','Efficient','Fast','Quick','Rapid','Slow','Veteran','Agile','Bitcoin','Online',}


function AddGunAction( entity_id, action_id )
	local action_entity_id = CreateItemActionEntity( action_id )
	if action_entity_id ~= 0 then
		EntityAddChild( entity_id, action_entity_id )
		EntitySetComponentsWithTagEnabled( action_entity_id, "enabled_in_world", false )
	end
end

function SetItemSprite( entity_id, ability_comp, item_file, r )

	if( r < 100 ) then item_file = item_file .. "0" end
	if( r < 10 ) then item_file = item_file .. "0" end
	item_file = item_file .. r .. ".xml"	

	if( ability_comp ~= nil ) then
		ComponentSetValue( ability_comp, "sprite_file", item_file)
	end

	local sprite_comp = EntityGetFirstComponent( entity_id, "SpriteComponent", "item" )
	if( sprite_comp ~= nil ) then
		ComponentSetValue( sprite_comp, "image_file", item_file)
	end
end

function gun_gen(gun,entity_id)

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	local capacity = ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" )
	local actions = ComponentObjectGetValue( ability_comp, "gun_config", "actions_per_round" )
	local reload = ComponentObjectGetValue( ability_comp, "gun_config", "reload_time" )
	local shuffle = ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty" )
	local firerate = ComponentObjectGetValue( ability_comp, "gunaction_config", "fire_rate_wait" )
	local spread = ComponentObjectGetValue( ability_comp, "gunaction_config", "spread_degrees" )
	local bullet_speed = ComponentObjectGetValue( ability_comp, "gunaction_config", "speed_multiplier" )
	
	local rare_chance = 0
	local rare_type = ""
	local g = {}
	
	local name = ComponentGetValue( ability_comp, "ui_name" )
	if( gun_names ~= nil ) then name = gun_names[Random(1, #gun_names)] .. ' ' .. name end
	
	if (gun.capacity ~= nil) then
		capacity = gun.capacity
	end
	
	if (gun.actions_per_round ~= nil) then
		actions = gun.actions_per_round
	end
	
	if (gun.reload ~= nil) then
		reload = gun.reload
	end
	
	if (gun.shuffle ~= nil) then
		shuffle = gun.shuffle
	end
	
	if (gun.rare_chance ~= nil) then
		rare_chance = gun.rare_chance * 1000
	end
	
	if (gun.rare_type ~= nil) then
		rare_type = gun.rare_type
	end
	
	if (gun.firerate ~= nil) then
		firerate = gun.firerate
	end
	
	if (gun.spread ~= nil) then
		spread = gun.spread
	end
	
	if (gun.bullet_speed ~= nil) then
		bullet_speed = gun.bullet_speed
	end
	
	for i,card in ipairs(gun.actions) do
		AddGunAction(entity_id, card)
	end
	
	local prob = math.random(1,1000)
	if (rare_chance >= prob) then
		g.capacity = capacity
		g.firerate = firerate
		g.spread = spread
		g.bullet_speed = bullet_speed
		g.actions_per_round = actions_per_round
		g.reload = reload
		g.shuffle = shuffle
		g.rare_type = rare_type
	
		capacity,actions_per_round,reload,shuffle,firerate,spread,bullet_speed = rare_gun(g,entity_id)
		
		local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )
		local light_r = 128
		local light_g = 0
		local light_b = 255
		
		
		if (gun.r ~= nil) and (gun.g ~= nil) and (gun.b ~= nil) then
			r = gun.light_r
			g = gun.light_g
			b = gun.light_b
		end
		
		if( light_comp ~= nil ) then
			ComponentSetValue( light_comp, "update_properties", 1)
			ComponentSetValue( light_comp, "r", light_r )
			ComponentSetValue( light_comp, "g", light_g )
			ComponentSetValue( light_comp, "b", light_b )
		end
	end
	
	local shuffle_ = convert_to_int(shuffle)
	
	-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/submachinegun_", Random( 0, 7 ) )
	ComponentSetValue( ability_comp, "ui_name", name )
	ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", actions )
	ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", reload )
	ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", capacity )
	ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", shuffle_ )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "fire_rate_wait", firerate )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", spread )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", bullet_speed )
end

function convert_to_int(value)
	local result = 0
	if (value == true) then
		result = 1
	end
	return result
end