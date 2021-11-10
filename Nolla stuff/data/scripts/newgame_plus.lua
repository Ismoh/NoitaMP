function do_newgame_plus()
	-- GameDoEnding2()
	-- BiomeMapLoad( "mods/nightmare/files/biome_map.lua" )

	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	-- print( newgame_n )
	newgame_n = newgame_n + 1
	SessionNumbersSetValue( "NEW_GAME_PLUS_COUNT", newgame_n )

	-- scale the enemy difficulty
	SessionNumbersSetValue( "DESIGN_SCALE_ENEMIES", "1" )

	local hp_scale_min = 7 + ( (newgame_n-1) * 2.5 )
	local hp_scale_max = 25 + ( (newgame_n-1) * 10 )
	local hp_attack_speed = math.pow( 0.5, newgame_n )
	
	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", hp_scale_min )
	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", hp_scale_max )
	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", hp_attack_speed )

	-- fixes the autosave issues
	-- SessionNumbersSave()

	-- scale the player damage intake
	local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")
	local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			
			local melee = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "melee" ) )
			local projectile = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ) )
			local explosion = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ) )
			local electricity = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "electricity" ) )
			local fire = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ) )
			local drill = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ) )
			local slice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ) )
			local ice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ) )
			local healing = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "healing" ) )
			local physics_hit = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "physics_hit" ) )
			local radioactive = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ) )
			local poison = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ) )

			melee = melee * 3
			projectile = projectile * 2
			explosion = explosion * 2
			electricity = electricity * 2
			fire = fire * 2
			drill = drill * 2
			slice = slice * 2
			ice = ice * 2
			radioactive = radioactive * 2
			poison = poison * 3

			ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(melee) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "electricity", tostring(electricity) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(healing) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "physics_hit", tostring(physics_hit) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive) )
			ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison) )

		end
	end

	-- Load the actual biome map

	BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml" )
	SessionNumbersSave()
	-- BiomeMapLoad( "data/biome_impl/biome_map.png" )

	-- clean up entrances to biomes
	LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 1534, "", true, true )
	LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 3070, "", true, true )
	LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 6655, "", true, true )
	LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 10750, "", true, true )


	local text = GameTextGetTranslatedOrNot("$new_game_for_newgame_plus")
	text = text .. " "
	local plusses = ""
	for i=1,newgame_n do
		plusses = plusses .. "+"
	end

	text = text .. plusses

	GamePrintImportant( text, "" )
end