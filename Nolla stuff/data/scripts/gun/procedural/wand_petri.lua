dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_enums.lua")
dofile("data/scripts/gun/procedural/wands.lua")

-- TODO - Move this to its own file
-- deck_capacity
gun_probs = { }
	
gun_probs[ "deck_capacity" ] = 
	{
		name = "deck_capacity",
		total_prob = 0,
		{
			-- name = "normal",
			prob = 1,
			min = 3,
			max = 10,
			mean = 6,
			sharpness = 2,
		},
		{
			-- name = "unshuffled",
			prob = 0.1,
			min = 2,
			max = 7,
			mean = 4,
			sharpness = 4,
			extra = function( gun ) gun["prob_unshuffle"] = gun["prob_unshuffle"] + 0.8 end
		},
		{
			-- name = "unshuffled tiny",
			prob = 0.05,
			min = 1,
			max = 5,
			mean = 3,
			sharpness = 4,
			extra = function( gun ) gun["prob_unshuffle"] = gun["prob_unshuffle"] + 0.8 end
		},
		{
			-- name = "machine gun",
			prob = 0.15,
			min = 5,
			max = 11,
			mean = 8,
			sharpness = 2,
		},
		{
			-- name = "everything goes",
			prob = 0.12,
			min = 2,
			max = 20,
			mean = 8,
			sharpness = 4,
		},
		{
			-- name = "shotgun",
			prob = 0.15,
			min = 3,
			max = 12,
			mean = 6,
			sharpness = 6,
			extra = function( gun ) gun["prob_draw_many"] = gun["prob_draw_many"] + 0.8 end
		},
		{
			-- name = "linear_crazyw",
			prob = 1,
			min = 1,
			max = 20,
			mean = 6,
			sharpness = 0,
		},
	}

-------------------------------------------------------------------------------

gun_probs[ "reload_time" ] =
	{
		name = "reload_time",
		total_prob = 0,
		{
			-- name = "normal",
			prob = 1,
			min = 5,
			max = 60,
			mean = 30,
			sharpness = 2,
		},
		{
			-- name = "normal",
			prob = 0.5,
			min = 1,
			max = 100,
			mean = 40,
			sharpness = 2,
		},
		{
			-- name = "linear",
			prob = 0.02,
			min = 1,
			max = 100,
			mean = 40,
			sharpness = 0,
		},
		{
			-- name = "linear_crazy",
			prob = 0.35,
			min = 1,
			max = 240,
			mean = 40,
			sharpness = 0,
			extra = function( gun ) gun["prob_unshuffle"] = gun["prob_unshuffle"] + 0.5 end
		},
	}

-------------------------------------------------------------------------------

gun_probs[ "fire_rate_wait" ] =
	{
		-- 5 = machine gun
		-- 24 = shotgun 
		-- 1 = submachinegun
		-- 50 = rocket launcher
		name = "fire_rate_wait",
		total_prob = 0,
		{
			-- name = "machine gun",
			prob = 1,
			min = 1,
			max = 30,
			mean = 5,
			sharpness = 2,
		},
		{
			-- name = "shotgun",
			prob = 0.1,
			min = 1,
			max = 50,
			mean = 15,
			sharpness = 3,
		},
		{
			-- name = "submachine gun",
			prob = 0.1,
			min = -15,
			max = 15,
			mean = 0,
			sharpness = 3,
		},
		{
			-- name = "linear_anything goes",
			prob = 0.45,
			min = 0,
			max = 35,
			mean = 12,
			sharpness = 0,
		},
	}

-------------------------------------------------------------------------------

gun_probs[ "spread_degrees" ] =
	{
		-- -35 - 35
		-- 0 = pistol
		-- 5 = machine gun
		-- 1 = shotgun
		name = "spread_degrees",
		total_prob = 0,
		{
			-- name = "pistol",
			prob = 1,
			min = -5,
			max = 10,
			mean = 0,
			sharpness = 3,
		},
		--[[
		{
			-- name = "shotgun",
			prob = 0.02,
			min = 1,
			max = 10,
			mean = 3,
			sharpness = 3,
		},
		{
			-- name = "machine gun",
			prob = 0.02,
			min = 1,
			max = 11,
			mean = 5,
			sharpness = 3,
		},
		{
			-- name = "snipper",
			prob = 0.02,
			min = -35,
			max = 0,
			mean = -10,
			sharpness = 2,
		},]]--
		{
			-- name = "linear_crazy",
			prob = 0.1,
			min = -35,
			max = 35,
			mean = 0,
			sharpness = 0,
		},
	}


-------------------------------------------------------------------------------

gun_probs[ "speed_multiplier" ] =
	{
		-- 0.8 - 1.2
		name = "speed_multiplier",
		total_prob = 0,
		{
			-- name = "standard",
			prob = 1,
			min = 0.8,
			max = 1.2,
			mean = 1,
			sharpness = 6,
		},
		{
			-- name = "faster bullets",
			prob = 0.05,
			min = 1,
			max = 2,
			mean = 1.1,
			sharpness = 3,
		},
		{
			-- name = "slow bullets",
			prob = 0.05,
			min = 0.5,
			max = 1,
			mean = 0.9,
			sharpness = 3,
		},
		{
			-- name = "linear",
			prob = 1,
			min = 0.8,
			max = 1.2,
			mean = 1,
			sharpness = 0,
		},
		{
			-- name = "easter_egg",
			prob = 0.001,
			min = 1,
			max = 10,
			mean = 5,
			sharpness = 2,
		},
	}

-------------------------------------------------------------------------------

gun_probs[ "actions_per_round" ] =
	{
		-- 1 - 5
		name = "actions_per_round",
		total_prob = 0,
		{
			-- name = "standard",
			-- sharpness: 4
			-- 1: 92%
			-- 2: 7.8%
			-- 3: 0.08%
			prob = 1,
			min = 1,
			max = 3,
			mean = 1,
			sharpness = 3,
		},
		{
			-- name = "shotgun",
			prob = 0.2,
			min = 2,
			max = 4,
			mean = 2,
			sharpness = 8,
		},
		-- CONTINUE HERE
		{
			-- name = "crazy",
			prob = 0.05,
			min = 1,
			max = 5,
			mean = 2,
			sharpness = 2,
		},
		{
			-- name = "linear",
			prob = 1,
			min = 1,
			max = 5,
			mean = 2,
			sharpness = 0,
		},
	}

-- prob_draw_many


gun_names = {
  'Deadly','Rusty','Old','New','Shiny','Lethal','Dangerous','Large','Enormous','Tiny','Small','Big','Pretty','Terrifying','Confusing',
  'Mystery','Superior','Inferior','Destructive','Chaotic','Lawful','Good','Bad','Neutral','Worn','Polished','Waxen','Strong','Weak',
  'Complex','Tactical','Horrifying','Scary','Scratched','Untested','Prototype','Type a','Type b','Type x','Secret','Special','Unique',
  'Mega','Super','Giga','Turbo','Hyper','Alpha','Omega','Extreme','Vanilla','Flavourful','Sturdy','Solid','Used','Unused','Grey','Gray',
  'Sepia','Secretly','Actual','Genuine','Powerful','Double','Triple','Stereo','Ancient','Antique','Rustic','Artisan','Slick','Slim',
  'Bulky','Heavy','Efficient','Fast','Quick','Rapid','Slow','Veteran','Agile','Bitcoin','Online',}

  ---------

function AddGunActionPermanent( entity_id, action_id )
	local action_entity_id = CreateItemActionEntity( action_id )
	if action_entity_id ~= nil then
		EntityAddChild( entity_id, action_entity_id )
	end

	edit_component( action_entity_id, "ItemComponent", function(comp, vars)
		vars.permanently_attached = "1"
	end)

	if action_entity_id ~= nil then
		EntitySetComponentsWithTagEnabled( action_entity_id, "enabled_in_world", false )
	end
end

function AddGunAction( entity_id, action_id )
	local action_entity_id = CreateItemActionEntity( action_id )
	if action_entity_id ~= 0 then
		EntityAddChild( entity_id, action_entity_id )
		EntitySetComponentsWithTagEnabled( action_entity_id, "enabled_in_world", false )
	end
end

function SetItemSprite( entity_id, ability_comp, item_file, r )

	if( r < 1000 ) then item_file = item_file .. "0" end
	if( r < 100 ) then item_file = item_file .. "0" end
	if( r < 10 ) then item_file = item_file .. "0" end
	item_file = item_file .. r .. ".png"	

	if( ability_comp ~= nil ) then
		ComponentSetValue( ability_comp, "sprite_file", item_file)
	end

	local sprite_comp = EntityGetFirstComponent( entity_id, "SpriteComponent", "item" )
	if( sprite_comp ~= nil ) then
		ComponentSetValue( sprite_comp, "image_file", item_file)
	end
end


function SetWandSprite( entity_id, ability_comp, item_file, offset_x, offset_y, tip_x, tip_y )

	if( ability_comp ~= nil ) then
		ComponentSetValue( ability_comp, "sprite_file", item_file)
	end

	local sprite_comp = EntityGetFirstComponent( entity_id, "SpriteComponent", "item" )
	if( sprite_comp ~= nil ) then
		ComponentSetValue( sprite_comp, "image_file", item_file)
		ComponentSetValue( sprite_comp, "offset_x", offset_x )
		ComponentSetValue( sprite_comp, "offset_y", offset_y )
	end

	local hotspot_comp = EntityGetFirstComponent( entity_id, "HotspotComponent", "shoot_pos" )
	if( hotspot_comp ~= nil ) then
		ComponentSetValueVector2( hotspot_comp, "offset", tip_x, tip_y )
	end	
end

function RandomFromArray( varray )
	local r = Random( 1, #varray )
	return varray[ r ]
end


function clamp(val, lower, upper)
	assert(val and lower and upper, "not very useful error message here")
	if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
	return math.max(lower, math.min(upper, val))
end

local function shuffleTable( t )
	assert( t, "shuffleTable() expected a table, got nil" )
	local iterations = #t
	local j
	
	for i = iterations, 2, -1 do
		j = Random(i)
		t[i], t[j] = t[j], t[i]
	end
end

function init_total_prob( value )
	value.total_prob = 0
	for i,v in ipairs(value) do
		if( v.prob ~= nil ) then
			value.total_prob = value.total_prob + v.prob
		end
	end
end

function init_gun_probs()
	for k,v in pairs(gun_probs) do
		init_total_prob( gun_probs[k] )
	end
end


function get_gun_probs( what )
	-- if( what == nil ) then print( "ERROR - director_helpers - spawn() ... what = nil") end
    if( gun_probs[what] == nil ) then
		return nil
    end

	if ( gun_probs[what].total_prob == 0 ) then
		init_total_prob( gun_probs[what] )
	end

	local r = Random() * gun_probs[what].total_prob
	for i,v in pairs(gun_probs[what]) do
		if( v.prob ~= nil ) then
			if( r <= v.prob ) then
				return v
			end
			r = r - v.prob
		end
	end

	print( "ERROR - gun_procedural.lua - get_gun_probs() shouldn't reach here")
	return nil
end
---------------------------------------------------------------------------------
------------------------ GENERATION FUNCTIONS -----------------------------------

function apply_random_variable( t_gun, variable )
	-- print( variable )
	local cost = t_gun["cost"]
	local probs = get_gun_probs( variable )

	-- deck_capacity = [10-240]
	-- cost: (60-L2)/5
	if( variable == "reload_time") then
		local min = clamp( 60-(cost*5), 1, 240 )
		local max = 1024

		t_gun[variable] = clamp( RandomDistribution( probs.min, probs.max, probs.mean, probs.sharpness ), min, max )
		t_gun["cost"] = t_gun["cost"] - ( (60 - t_gun[variable]) / 5 )
		return
	end

	-- fire_rate_wait = [1-35] (-50,50)
	-- cost: 16-P2
	if( variable == "fire_rate_wait" ) then
		local min = clamp( 16-(cost), -50, 50 )
		local max = 50
		t_gun[variable] = clamp( RandomDistribution( probs.min, probs.max, probs.mean, probs.sharpness ), min, max )
		t_gun["cost"] = t_gun["cost"] - ( 16 - t_gun[variable] )
		return
	end

	-- spread_degrees = [-50,50]
	-- cost: -1.5 * T2
	if( variable == "spread_degrees" ) then
		local min = clamp( cost / -1.5, -35, 35 )
		local max = 35
		t_gun[variable] = clamp( RandomDistribution( probs.min, probs.max, probs.mean, probs.sharpness ), min, max )
		t_gun["cost"] = t_gun["cost"] - ( 16 - t_gun[variable] )
		return
	end

	-- speed_multiplier = [0.8, 1.2]
	-- cost: 0
	if( variable == "speed_multiplier") then
		-- t_gun[variable] = Random( 0.8, 1.2 )
		t_gun[variable] = RandomDistributionf( probs.min, probs.max, probs.mean, probs.sharpness )
		t_gun["cost"] = t_gun["cost"] - ( 0 )
		return
	end

	-- deck_capacity [ 1 - 20 ]
	-- cost = (deck_capacity-6)*5
	if( variable == "deck_capacity" ) then
		local min = 1
		local max = clamp( (cost/5)+6, 1, 20 )

		if( t_gun["force_unshuffle"] == 1 ) then
			min = 1
			max = ((cost-15)/5)
			if( max > 6 ) then
				max = 6 + ((cost-(15+6*5))/10)
			end
		end			

		max = clamp( max, 1, 20 )
		t_gun[variable] = clamp( RandomDistribution( probs.min, probs.max, probs.mean, probs.sharpness ), min, max )
		t_gun["cost"] = t_gun["cost"] - ( (t_gun[variable]-6)*5 )
		return
	end

	local deck_capacity = t_gun["deck_capacity"]

	-- shuffle_deck_when_empty [0,1]
	-- cost: = 15+deck_capacity*5
	if( variable == "shuffle_deck_when_empty") then
		local random = Random( 0, 1 )
		if( t_gun["force_unshuffle"] == 1 ) then 
			random = 1 
			if( cost < (15+deck_capacity*5) ) then
				-- print( "DEBUG THIS SHOULDN'T HAPPEN!")
			end
		end

		-- clamped unshuffles to deck capacity 9
		if( random == 1 and cost >= (15+deck_capacity*5) and deck_capacity <= 9 ) then
			t_gun[variable] = 0
			t_gun["cost"] = t_gun["cost"] - ( (15+deck_capacity*5) )
			-- print("unshuffling the deck ")
		end
		return
	end

	-- actions_per_round: [1-5]
	-- cost: *
	if( variable == "actions_per_round" ) then
		local action_costs = {
			0, 
			5+(deck_capacity*2),
			15+(deck_capacity*3.5),
			35+(deck_capacity*5),
			45+(deck_capacity*deck_capacity)
		}

		local min = 1
		local max = 1
		for i,acost in ipairs(action_costs) do
			if( acost <= cost ) then
				max = i
			end
		end
		max = clamp( max, 1, deck_capacity )

		t_gun[variable] = clamp( RandomDistribution( probs.min, probs.max, probs.mean, probs.sharpness ), min, max )
		t_gun["cost"] = t_gun["cost"] - ( action_costs[ t_gun[variable] ] )
		return
	end
end

---------------------------------------------------------------------------------

function WandDiff( gun, wand )
	local score = 0
	score = score + ( math.abs( gun.fire_rate_wait - wand.fire_rate_wait ) * 2 )
	score = score + ( math.abs( gun.actions_per_round - wand.actions_per_round ) * 20 )
	score = score + ( math.abs( gun.shuffle_deck_when_empty - wand.shuffle_deck_when_empty ) * 30 )
	score = score + ( math.abs( gun.deck_capacity - wand.deck_capacity ) * 5 )
	score = score + math.abs( gun.spread_degrees - wand.spread_degrees )
	score = score + math.abs( gun.reload_time - wand.reload_time )
	return score
end

function GetWand( gun )
	local best_wand = nil
	local best_score = 1000
	local gun_in_wand_space = {}
	--[[

	-- convert the values to wand_array space
	-- fire_rate_wait:            0  -  2   / 1 - 30 (50)
	-- actions_per_round:         0  -  2 	/  1 - 3	
	-- shuffle_deck_when_empty:   0  -  1 	/ 
	-- deck_capacity:             0  -  7 	/ 3 - 10 / 20 
	-- spread_degrees:            0  -  2 	/ -5 - 10 / -35 - 35
	-- reload_time:               0  -  2 	/ 5 - 100

	--[[
		deck_capacity 
		0 = 3-4
		1 = 5-6
		2 = 7-8
		3 = 8-9
		4 = 10-12
		5 = 13-15
		6 = 15-17
		7 = 17+
	]]-- 


	gun_in_wand_space.fire_rate_wait = clamp(((gun["fire_rate_wait"] + 5) / 7)-1, 0, 4)
	gun_in_wand_space.actions_per_round = clamp(gun["actions_per_round"]-1,0,2)
	gun_in_wand_space.shuffle_deck_when_empty = clamp(gun["shuffle_deck_when_empty"], 0, 1)
	gun_in_wand_space.deck_capacity = clamp( (gun["deck_capacity"]-3)/3, 0, 7 ) -- TODO
	gun_in_wand_space.spread_degrees = clamp( ((gun["spread_degrees"] + 5 ) / 5 ) - 1, 0, 2 )
	gun_in_wand_space.reload_time = clamp( ((gun["reload_time"]+5)/25)-1, 0, 2 )

	for k,wand in pairs(wands) do
		local score = WandDiff( gun_in_wand_space, wand )
		if( score <= best_score ) then
			best_wand = wand
			best_score = score
			-- just randomly return one of them...
			if( score == 0 and Random(0,100) < 33 ) then
				return best_wand
			end
		end
	end
	return best_wand
end



---------------------------------------------------------------------------------


function generate_gun( cost, level, force_unshuffle )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	--[[
	local capacity = ComponentObjectGetValue( ability_comp, "gun_config", 			"deck_capacity" )
	local actions = ComponentObjectGetValue( ability_comp, "gun_config", 			"actions_per_round" )
	local reload = ComponentObjectGetValue( ability_comp, "gun_config", 			"reload_time" )
	local shuffle = ComponentObjectGetValue( ability_comp, "gun_config", 			"shuffle_deck_when_empty" )
	local firerate = ComponentObjectGetValue( ability_comp, "gunaction_config", 	"fire_rate_wait" )
	local spread = ComponentObjectGetValue( ability_comp, "gunaction_config", 		"spread_degrees" )
	local bullet_speed = ComponentObjectGetValue( ability_comp, "gunaction_config", "speed_multiplier" )
	]]--

	-- Algorithm overview
	-- We do the generation of these in random order. Each variable, looks at the cost and tries to figure out what's
	-- the maximum random value it can do for that cost
	-- The random order is first the shuffled variables_01, then variables_02, then variables_03

	if( level == 1 ) then
		if( Random(0,100) < 50 ) then
			cost = cost + 5
		end
	end
	cost = cost + Random(-3, 3)
	-- for temp_i=1,25 do
		local gun = { }
		gun["cost"]	= cost
		gun["deck_capacity"] = 0
		gun["actions_per_round"] = 0
		gun["reload_time"] = 0
		gun["shuffle_deck_when_empty"] = 1
		gun["fire_rate_wait"] = 0
		gun["spread_degrees"] = 0
		gun["speed_multiplier"] = 0
		gun["prob_unshuffle"] = 0.1
		gun["prob_draw_many"] = 0.15
		gun["mana_charge_speed"] = 50*level + Random(-5,5*level)
		gun["mana_max"] = 50 + (150 * level) + (Random(-5,5)*10)
		gun["force_unshuffle"] = 0

		local p = Random(0,100)
		if( p < 15 + level*6 ) then
			gun["force_unshuffle"] = 1
			-- print( "force_unshuffle" ) 
		end

		local is_rare = 0
		p = Random(0,100)
		if( p < 5 ) then
			is_rare = 1
			-- gun["cost"] = gun["cost"] * 2.5
			gun["cost"] = gun["cost"] + 65
			local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )
			if( light_comp ~= nil ) then
				ComponentSetValue( light_comp, "update_properties", 1)
				ComponentSetValue( light_comp, "r", 128 )
				ComponentSetValue( light_comp, "g", 0 )
				ComponentSetValue( light_comp, "b", 255 )
			end
		end
		-- based on capacity:
		-- deck_capacity, shuffle_deck_when_empty, actions_per_round,
		-- reload_time, fire_rate_wait, spread_degrees, speed_multiplier

		local variables_01 = { "reload_time", "fire_rate_wait", "spread_degrees", "speed_multiplier" }
		local variables_02 = { "deck_capacity" }
		local variables_03 = { "shuffle_deck_when_empty", "actions_per_round" }

		shuffleTable( variables_01 );
		if( gun["force_unshuffle"]~= 1 ) then shuffleTable( variables_03 ); end

		for k,v in pairs(variables_01) do
			apply_random_variable( gun, v )
		end

		for k,v in pairs(variables_02) do
			apply_random_variable( gun, v )
		end

		for k,v in pairs(variables_03) do
			apply_random_variable( gun, v )
		end

		-- Do this in 99% of the cases
		if( gun["cost"] > 5 and Random(0,1000) < 995 ) then
			if( gun["shuffle_deck_when_empty"] == 1 ) then
				gun["deck_capacity"] = gun["deck_capacity"] + ( gun["cost"] / 5 )
				gun["cost"] = 0
			else
				-- I don't know if this is correct or not...?
				gun["deck_capacity"] = gun["deck_capacity"] + ( gun["cost"] / 10 )
				gun["cost"] = 0
			end
		end

		--[[
		for k,v in pairs(gun) do
			print(k, tostring( v ))
		end
		]]--

		local name = ComponentGetValue( ability_comp, "ui_name" )
		if( gun_names ~= nil ) then name = gun_names[Random(1, #gun_names)] .. ' ' .. name end
	-- end
	
	-- debug
	if( force_unshuffle ) then
		gun["shuffle_deck_when_empty"] = 0
	end

	-- fix the unshuffle size 1
	-- TODO( Petri ) - if deck_capacity == 1, we should do a digger or a material gun
	if( gun["deck_capacity"] <= 1 ) then
		gun["deck_capacity"] = 2
	end

	-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/submachinegun_", Random( 0, 7 ) )
	ComponentSetValue( ability_comp, "ui_name", name )
	ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "reload_time", gun["reload_time"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", gun["shuffle_deck_when_empty"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "fire_rate_wait", gun["fire_rate_wait"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] )
	ComponentSetValue( ability_comp, "mana_charge_speed", gun["mana_charge_speed"])
	ComponentSetValue( ability_comp, "mana_max", gun["mana_max"])
	ComponentSetValue( ability_comp, "mana", gun["mana_max"])

	ComponentSetValue( ability_comp, "item_recoil_recovery_speed", 15.0 ) -- TODO: implement logic for setting this

	-- stuff in the gun
	x = x + Random( -1024, 1024 )
	y = y + Random( -1024, 1024 )

	local good_cards = 5
	local orig_level = level
	level = level - 1
	local deck_capacity = gun["deck_capacity"]
	local actions_per_round = gun["actions_per_round"]
	local card_count = Random( 1, 3 ) 
	local bullet_card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 0 )

	local random_bullets = 0 
	local good_card_count = 0
	local add_permanent = 0

	-- hax to make op
	if( Random(0, 100 ) < 50 )  then add_permanet = 1 end

	if( Random( 0, 100 ) < 50 ) then random_bullets = 1 end

	good_cards = Random( 10, 50 )

	card_count = Random( 0.6 * deck_capacity, deck_capacity )
	card_count = clamp( card_count, 1, deck_capacity-1 )


	if( add_permanent ) then
		local card = 0
		p = Random(0,100) 
		if( p < 60 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_MODIFIER, 666 )
		elseif( p < 85 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_DRAW_MANY, 666 )
			good_card_count = good_card_count + 1
		else 
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_PROJECTILE, 666 )
		end
		AddGunActionPermanent( entity_id, card )
	end


	for i=1,card_count do
		if( Random(0,100) < good_cards ) then
			-- if actions_per_round == 1 and the first good card, then make sure it's a draw x
			local card = 0
			if( good_card_count == 0 and actions_per_round == 1 ) then
				card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, i )
				good_card_count = good_card_count + 1
			else
				if( Random(0,100) < 83 ) then
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, i )
				else
					card = GetRandomActionWithType( x, y, level, ACTION_TYPE_DRAW_MANY, i )
				end
			end
		
			AddGunAction( entity_id, card )
		else
			AddGunAction( entity_id, bullet_card )
			if( random_bullets == 1 ) then
				bullet_card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, i )
			end
		end
	end


	-- Set wand sprite
	-- print(gun)
	--[[
	print("gun[\"fire_rate_wait\"] = ", gun["fire_rate_wait"] )
	print("gun[\"actions_per_round\"] = ", gun["actions_per_round"] )
	print("gun[\"shuffle_deck_when_empty\"] = ", gun["shuffle_deck_when_empty"] )
	print("gun[\"deck_capacity\"] = ", gun["deck_capacity"] )
	print("gun[\"spread_degrees\"] = ", gun["spread_degrees"] )
	print("gun[\"reload_time\"] = 	", gun["reload_time"]	 )
	]]--

	local wand = GetWand( gun )
	-- local wand = RandomFromArray(wands)

	SetWandSprite( entity_id, ability_comp, wand.file, wand.grip_x, wand.grip_y, (wand.tip_x - wand.grip_x), (wand.tip_y - wand.grip_y) )
	-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/wands/wand_", Random( 0, 999 ) )

	-- this way:
	-- AddGunActionPermanent( entity_id, "ELECTRIC_CHARGE" )
end




generate_gun( 120, 4, true )
