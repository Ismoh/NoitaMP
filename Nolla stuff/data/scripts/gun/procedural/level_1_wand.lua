dofile_once("data/scripts/gun/procedural/gun_procedural.lua")


function do_level1( level )

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )

	if( ability_comp == nil ) then
		print_error( "Couldn't find AbilityComponent for entity, it is probably not enabled" )
	end

	local reload_time = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "reload_time"  ) )
	local fire_rate_wait = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "fire_rate_wait" ) )
	local spread_degrees = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "spread_degrees" ) )
	local deck_capacity = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" ) )
	local mana_max = tonumber( ComponentGetValue( ability_comp, "mana_max" ) )

	local total = reload_time + fire_rate_wait + spread_degrees
	-- print(total)
	-- print( reload_time + fire_rate_wait + spread_degrees )
	--[[
	ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", gun["shuffle_deck_when_empty"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] )
	]]--

	total = total + Random( -10, 20 )

	local level_1_cards =
	{
		"LIGHT_BULLET",
		"RUBBER_BALL",
		"ARROW",
		"DISC_BULLET",
		"BOUNCY_ORB",
		"BULLET",
		"AIR_BULLET",
		"SLIMEBALL",
	}	

	local card_count = Random( 1, 5 ) 

	-- 0.5
	if( Random( 1, 100 ) <= 85 ) then
		table.insert(level_1_cards, "BUBBLESHOT")
		
		-- 0.25
		if( Random( 1, 100 ) <= 70 ) then
			table.insert(level_1_cards, "SPITTER")
	
			-- 0.125
			if( Random( 1, 100 ) <= 40 ) then
				table.insert(level_1_cards, "LIGHT_BULLET_TRIGGER")
				card_count = 1

				-- 0.0625
				if( Random( 1, 100 ) <= 20 ) then
					table.insert(level_1_cards, "DISC_BULLET_BIG" )
					card_count = 1
					
					-- 0.00625
					if( Random( 1, 100 ) <= 10 ) then
						table.insert(level_1_cards, "TENTACLE_PORTAL" )
						card_count = 1
						if( mana_max < 140 ) then mana_max = 140 end

						-- 0.000625
						if( Random( 1, 100 ) <= 10 ) then
							table.insert(level_1_cards, "BLACK_HOLE_BIG" )
							card_count = 1
							if( mana_max < 240 ) then mana_max = 240 end
						end
					end
				end
			end
		end
	end

	if( total > 50 ) then
		level_1_cards = 
		{
			"GRENADE",
			"BOMB",
			"ROCKET"
		}
		
		if( Random( 1, 100 ) <= 75 ) then
			table.insert(level_1_cards, "DYNAMITE")
			if( Random( 1, 100 ) <= 50 ) then
				table.insert(level_1_cards, "FIREBALL")
				if( Random( 1, 100 ) <= 40 ) then
					table.insert(level_1_cards, "ACIDSHOT")
					if( Random( 1, 100 ) <= 30 ) then
						table.insert(level_1_cards, "GLITTER_BOMB")
						if( Random( 1, 100 ) <= 30 ) then
							table.insert(level_1_cards, "MINE")
						end
					end
				end
			end
		end
		card_count = 1
	end

	local do_util = Random( 0, 100 )
	if( do_util < 30 ) then
		level_1_cards = 
		{
			"CLOUD_WATER",
			"X_RAY",
			"FREEZE_FIELD",
			"BLACK_HOLE",
			"TORCH",
			"SHIELD_FIELD",
		}
		if( Random( 1, 100 ) <= 75 ) then
			table.insert(level_1_cards, "ELECTROCUTION_FIELD")
			if( Random( 1, 100 ) <= 50 ) then
				table.insert(level_1_cards, "DIGGER")

				if( Random( 1, 100 ) <= 50 ) then
					table.insert(level_1_cards, "TORCH_ELECTRIC")

					if( Random( 1, 100 ) <= 50 ) then
						table.insert(level_1_cards, "POWERDIGGER")

						if( Random( 1, 100 ) <= 50 ) then
							table.insert(level_1_cards, "SOILBALL")

							if( Random( 1, 100 ) <= 50 ) then
								table.insert(level_1_cards, "LUMINOUS_DRILL")

								if( Random( 1, 100 ) <= 50 ) then
									table.insert(level_1_cards, "CHAINSAW")
								end
							end
						end
					end
				end
			end
		end

		card_count = 1
	end


	if( card_count > deck_capacity ) then card_count = deck_capacity end

	local card = RandomFromArray( level_1_cards )
	if( card == "BLACK_HOLE" and mana_max < 180 ) then
		mana_max = 180
	end

	for i=1,card_count do
		AddGunAction( entity_id, card )
	end

end

do_level1( 1 )