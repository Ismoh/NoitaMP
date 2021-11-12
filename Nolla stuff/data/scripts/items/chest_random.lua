dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_actions.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

-------------------------------------------------------------------------------

function make_random_card( x, y )
	-- this does NOT call SetRandomSeed() on purpouse. 
	-- SetRandomSeed( x, y )

	local item = ""
	local valid = false

	while ( valid == false ) do
		local itemno = Random( 1, #actions )
		local thisitem = actions[itemno]
		item = string.lower(thisitem.id)
		
		if ( thisitem.spawn_requires_flag ~= nil ) then
			local flag_name = thisitem.spawn_requires_flag
			local flag_status = HasFlagPersistent( flag_name )
			
			if flag_status then
				valid = true
			end

			-- 
			if( thisitem.spawn_probability == "0" ) then 
				valid = false
			end
			
		else
			valid = true
		end
	end


	if ( string.len(item) > 0 ) then
		local card_entity = CreateItemActionEntity( item, x, y )
		return card_entity
	else
		print( "No valid action entity found!" )
	end
end

function chest_load_gold_entity( entity_filename, x, y, remove_timer )
	local eid = load_gold_entity( entity_filename, x, y, remove_timer )
	local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

	-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
	if item_comp ~= nil then
		if( ComponentGetValue2( item_comp, "auto_pickup") ) then
			ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
		end
	end
end

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local set_rnd = false 
	if( set_rnd_ ~= nil ) then set_rnd = set_rnd_ end

	if( set_rnd ) then
		SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	end
	
	local good_item_dropped = true
	
	-- using deferred loading of entities, since loading some of them (e.g. potion.xml) will call SetRandomSeed(...)
	-- if position is not given (in entities table), will load the entity to rand_x, rand_y and then move it to chest position
	-- reason for this is that then the SetRandomSeed() of those entities will be deterministic 
	-- but for some reason it cannot be done to random_card.xml, since I'm guessing
	local entities = {}

	local count = 1
	while( count > 0 ) do
		count = count - 1
		local rnd = Random(1,100)

		if( rnd <= 7 ) then
			-------------------------------------------------------------------
			-- Bomb
			-------------------------------------------------------------------
			table.insert( entities, { "data/entities/projectiles/bomb_small.xml" } )
			-- EntityLoad( "data/entities/projectiles/bomb_small.xml", x + Random(-10,10), y - 4 + Random(-10,10) )
			good_item_dropped = false
			
		elseif( rnd <= 40 ) then
			-------------------------------------------------------------------
			-- Gold (I think the reason there's empty is chests is goldnuggets)
			-------------------------------------------------------------------
			local remove_gold_timer = false
	
			local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
			if( comp_worldstate ~= nil ) then
				if( ComponentGetValue2( comp_worldstate, "perk_gold_is_forever" ) ) then
					remove_gold_timer = true
				end
			end

			local amount = 5
			rnd = Random(0,100)
			if (rnd <= 80) then
				amount = 7
			elseif (rnd <= 95) then
				amount = 10
			elseif (rnd <= 100) then
				amount = 20
			end

			rnd = Random(0,100)
			if( rnd > 30 and rnd <= 80 ) then
				chest_load_gold_entity( "data/entities/items/pickup/goldnugget_50.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
			elseif (rnd <= 95) then
				chest_load_gold_entity( "data/entities/items/pickup/goldnugget_200.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
			elseif (rnd <= 99) then
				chest_load_gold_entity( "data/entities/items/pickup/goldnugget_1000.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
			else
				local tamount = Random( 1, 3 )
				for i=1,tamount do
					chest_load_gold_entity( "data/entities/items/pickup/goldnugget_50.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
				end
				if( Random(0, 100 ) > 50 ) then
					tamount = Random( 1, 3 )
					for i=1,tamount do
						chest_load_gold_entity( "data/entities/items/pickup/goldnugget_200.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
					end
				end
				if( Random(0, 100 ) > 80 ) then
					tamount = Random( 1, 3 )
					for i=1,tamount do
						chest_load_gold_entity( "data/entities/items/pickup/goldnugget_1000.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
					end
				end
			end


			for i=1,amount do
				chest_load_gold_entity( "data/entities/items/pickup/goldnugget.xml", x + Random(-10,10), y - 4 + Random(-10,5), remove_gold_timer )
			end
		elseif( rnd <= 50 ) then
			-------------------------------------------------------------------
			-- Potion
			-------------------------------------------------------------------
			rnd = Random(0,100)
			if (rnd <= 94) then
				table.insert( entities, { "data/entities/items/pickup/potion.xml" } )
			elseif (rnd <= 98) then
				table.insert( entities, { "data/entities/items/pickup/powder_stash.xml" } )
			elseif (rnd <= 100) then
				rnd = Random(0,100)
				if( rnd <= 98 ) then
					table.insert( entities, { "data/entities/items/pickup/potion_secret.xml" } )
				elseif( rnd <= 100 ) then
					table.insert( entities, { "data/entities/items/pickup/potion_random_material.xml" } )
				end
			end
		elseif( rnd <= 54 ) then
			-------------------------------------------------------------------
			-- Spell refresh
			-------------------------------------------------------------------
			table.insert( entities, { "data/entities/items/pickup/spell_refresh.xml" } )
		
		elseif( rnd <= 60 ) then
			-------------------------------------------------------------------
			-- Misc items
			-------------------------------------------------------------------
			local opts = { "data/entities/items/pickup/safe_haven.xml", "data/entities/items/pickup/moon.xml", "data/entities/items/pickup/thunderstone.xml", "data/entities/items/pickup/evil_eye.xml", "data/entities/items/pickup/brimstone.xml", "runestone", "die", "orb" }
			rnd = Random( 1, #opts )
			local opt = opts[rnd]
			
			if ( opt == "die" ) then
				local flag_status = HasFlagPersistent( "card_unlocked_duplicate" )
				
				if flag_status then
					if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
						opt = "data/entities/items/pickup/physics_greed_die.xml"
					else
						opt = "data/entities/items/pickup/physics_die.xml"
					end
				else
					opt = "data/entities/items/pickup/potion.xml"
				end
			elseif ( opt == "runestone" ) then
				local r_opts = { "laser", "fireball", "lava", "slow", "null", "disc", "metal" }
				rnd = Random( 1, #r_opts )
				local r_opt = r_opts[rnd]
				
				opt = "data/entities/items/pickup/runestones/runestone_" .. r_opt .. ".xml"
			elseif ( opt == "orb" ) then
				if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
					opt = "data/entities/items/pickup/physics_gold_orb_greed.xml"
				else
					opt = "data/entities/items/pickup/physics_gold_orb.xml"
				end
			end
			
			table.insert( entities, { opt, x, y - 10 } )
			
		elseif( rnd <= 65 ) then
			-------------------------------------------------------------------
			-- Random card
			-------------------------------------------------------------------
			-- NOTE( Petri ): random_card.xml is bad, it leaves an empty entity hanging around
			-- table.insert( entities, { "data/entities/items/pickup/random_card.xml",  x + Random(-10,10), y - 4 + Random(-5,5) } )
			-- this does NOT call SetRandomSeed() on purpouse
			local amount = 1
			rnd = Random(0,100)
			if (rnd <= 50) then
				amount = 1
			elseif (rnd <= 70) then
				amount = amount + 1
			elseif (rnd <= 80) then
				amount = amount + 2
			elseif (rnd <= 90) then
				amount = amount + 3
			else
				amount = amount + 4
			end

			for i=1,amount do
				make_random_card( x + (i - (amount / 2)) * 8, y - 4 + Random(-5,5) )
			end
		elseif( rnd <= 84 ) then
			-------------------------------------------------------------------
			-- Wand
			-------------------------------------------------------------------

			rnd = Random(0,100)
			
			if( rnd <= 25 ) then
				table.insert( entities, { "data/entities/items/wand_level_01.xml" } )
			elseif( rnd <= 50 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_01.xml" } )
			elseif( rnd <= 75 ) then
				table.insert( entities, { "data/entities/items/wand_level_02.xml" } )
			elseif( rnd <= 90 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_02.xml" } )
			elseif( rnd <= 96 ) then
				table.insert( entities, { "data/entities/items/wand_level_03.xml" } )
			elseif( rnd <= 98 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_03.xml" } )
			elseif( rnd <= 99 ) then
				table.insert( entities, { "data/entities/items/wand_level_04.xml" } )
			elseif( rnd <= 100 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_04.xml" } )
			end
		elseif( rnd <= 95 ) then
			-------------------------------------------------------------------
			-- Heart(s)
			-------------------------------------------------------------------
			rnd = Random(0,100)
			
			if (rnd <= 88) then
				table.insert( entities, { "data/entities/items/pickup/heart.xml" } )
			elseif (rnd <= 89) then
				table.insert( entities, { "data/entities/animals/illusions/dark_alchemist.xml" } )
			elseif (rnd <= 99) then
				table.insert( entities, { "data/entities/items/pickup/heart_better.xml" } )
			else
				table.insert( entities, { "data/entities/items/pickup/heart_fullhp.xml" } )
			end
		elseif( rnd <= 98 ) then
			-------------------------------------------------------------------
			-- Converts the chest into gold
			-------------------------------------------------------------------
			EntityConvertToMaterial( entity_id, "gold")
		elseif( rnd <= 99 ) then
			-------------------------------------------------------------------
			-- exploding "dice"
			-------------------------------------------------------------------

			-- explode the random table
			-- do random reward 2 times...
			count = count + 2
		elseif( rnd <= 100 ) then
			-- explode the random table
			-- do random reward 3 times...
			count = count + 3
		end
	end

	for i,entity in ipairs(entities) do
		local eid = 0 
		if( entity[2] ~= nil and entity[3] ~= nil ) then 
			eid = EntityLoad( entity[1], entity[2], entity[3] ) 
		else
			eid = EntityLoad( entity[1], rand_x, rand_y )
			EntityApplyTransform( eid, x + Random(-10,10), y - 4 + Random(-5,5)  )
		end

		local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

		-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
		if item_comp ~= nil then
			if( ComponentGetValue2( item_comp, "auto_pickup") ) then
				ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
			end
		end
	end


	return good_item_dropped
end

function drop_money( entity_item )
	
	-- 
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local rand_x = x
	local rand_y = y

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent( entity_item, "PositionSeedComponent" )
	if( position_comp ) then
		rand_x = tonumber(ComponentGetValue( position_comp, "pos_x") )
		rand_y = tonumber(ComponentGetValue( position_comp, "pos_y") )
	end

	SetRandomSeed( rand_x, rand_y )

	-- money
	-- card
	-- potion
	-- wand
	-- bunch of spiders
	-- bomb
	local good_item_dropped = drop_random_reward( x, y, entity_item, rand_x, rand_y, false )
	
	if good_item_dropped then
		EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
	else
		EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	GamePrintImportant( "$log_chest", "" )
	-- GameTriggerMusicCue( "item" )

	--if (remove_entity == false) then
	--	EntityLoad( "data/entities/misc/chest_random_dummy.xml", x, y )
	--end

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	-- GamePrint( "A chest was broken open" )
	-- GameTriggerMusicCue( "item" )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end