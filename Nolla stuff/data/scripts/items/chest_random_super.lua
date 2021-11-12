dofile_once("data/scripts/lib/utilities.lua")

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

	if( Random( 0, 100000) >= 100000 ) then
		EntityLoadEndGameItem( "data/entities/animals/boss_centipede/sampo.xml", x, y )
		count = 0
		return 
	end


	while( count > 0 ) do
		count = count - 1
		local rnd = Random(1,100)

		if( rnd <= 30 ) then
			-------------------------------------------------------------------
			-- Potion
			-------------------------------------------------------------------
			rnd = Random(0,100)
			if (rnd <= 30) then
				table.insert( entities, { "data/entities/items/pickup/potion.xml" } )
				table.insert( entities, { "data/entities/items/pickup/potion.xml" } )
				table.insert( entities, { "data/entities/items/pickup/potion_secret.xml" } )
			else
				table.insert( entities, { "data/entities/items/pickup/potion_secret.xml" } )
				table.insert( entities, { "data/entities/items/pickup/potion_secret.xml" } )
				table.insert( entities, { "data/entities/items/pickup/potion_random_material.xml" } )
			end
		elseif( rnd <= 33 ) then
			table.insert( entities, { "data/entities/projectiles/rain_gold.xml" } )
		elseif( rnd <= 38 ) then
			local rnd2 = Random(1,30)
			
			if (rnd2 ~= 30) then
				table.insert( entities, { "data/entities/items/pickup/waterstone.xml" } )
			else
				table.insert( entities, { "data/entities/items/pickup/poopstone.xml" } )
			end
		elseif( rnd <= 39 ) then
		
			-------------------------------------------------------------------
			-- Wand
			-------------------------------------------------------------------

			rnd = Random(0,100)
			
			if( rnd <= 25 ) then
				table.insert( entities, { "data/entities/items/wand_level_03.xml" } )
			elseif( rnd <= 50 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_03.xml" } )
			elseif( rnd <= 75 ) then
				table.insert( entities, { "data/entities/items/wand_level_04.xml" } )
			elseif( rnd <= 90 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_04.xml" } )
			elseif( rnd <= 96 ) then
				table.insert( entities, { "data/entities/items/wand_level_05.xml" } )
			elseif( rnd <= 98 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_05.xml" } )
			elseif( rnd <= 99 ) then
				table.insert( entities, { "data/entities/items/wand_level_06.xml" } )
			elseif( rnd <= 100 ) then
				table.insert( entities, { "data/entities/items/wand_unshuffle_06.xml" } )
			end
		elseif( rnd <= 60 ) then
			-------------------------------------------------------------------
			-- Heart(s)
			-------------------------------------------------------------------
			rnd = Random(0,100)
			
			if (rnd <= 89) then
				table.insert( entities, { "data/entities/items/pickup/heart.xml" } )
			elseif (rnd <= 99) then
				table.insert( entities, { "data/entities/items/pickup/heart_better.xml" } )
			else
				table.insert( entities, { "data/entities/items/pickup/heart_fullhp.xml" } )
			end
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