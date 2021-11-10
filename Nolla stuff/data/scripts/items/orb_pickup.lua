dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )
	local orbcomp = EntityGetComponent( entity_item, "OrbComponent" )
	local orb_id = -1
	
	for key,comp_id in pairs(orbcomp) do 
		orb_id = ComponentGetValueInt( comp_id, "orb_id" )
	end
	
	local message_title = ""
	local message_desc = ""
	
	local orb_id_string = string.sub("00" .. tostring(orb_id), -2)
	AddFlagPersistent( "progress_orb_1" )
	
	if (orb_id > -1) then
		if( orb_id >= 100 ) then
			-- special outside bounds orbs only give evil_hearts
			message_title = "$itempickup_orb_evil"
			message_desc = "$itempickupdesc_orb_discovered"
			
			AddFlagPersistent( "progress_orb_evil" )
			
			-- shoot_projectile( entity_id, "data/entities/items/pickup/heart_evil.xml", pos_x, pos_y, 0, 0 )
			EntityLoad( "data/entities/items/pickup/heart_evil.xml", pos_x, pos_y )
		else
			if( GameGetOrbCollectedAllTime(orb_id) or GameIsDailyRunOrDailyPracticeRun() ) then
				-- normal orb
				message_title = "$itempickup_orb_discovered"
				message_desc = "$itempickupdesc_orb_discovered"
				

				-- shoot_projectile( entity_id, "data/entities/items/pickup/heart.xml", pos_x, pos_y, 0, 0 )
				EntityLoad( "data/entities/items/pickup/heart.xml", pos_x, pos_y )
			else
				message_title = "$itempickup_orb"
				message_desc = "$itempickupdesc_orb_" .. orb_id_string
				AddFlagPersistent( "progress_orb_pickup_" .. orb_id_string )
				
				for key,comp_id in pairs(components) do 
					local var_name = ComponentGetValue( comp_id, "name" )
					if( var_name == "card_name") then
						local load_me = ComponentGetValue( comp_id, "value_string" )
						CreateItemActionEntity( load_me, pos_x, pos_y )
					end
				end
			end
		end
	end
	
	local orbs = GameGetOrbCountAllTime()
	if ( orbs >= 11 ) then
		AddFlagPersistent( "progress_orb_all" )
		GameGiveAchievement( "ALL_ORBS" )
	end
	
	-- todo( Petri ): Only do this if the boss has not been beaten
	-- GameAddFlagRun( "boss_centipede_is_dead" )
	if( GameHasFlagRun( "boss_centipede_is_dead" ) == false ) then
		local x,y = EntityGetTransform( entity_who_picked )
		local child_id = EntityLoad( "data/entities/misc/orb_boss_scream.xml", x, y )
		EntityAddChild( entity_who_picked, child_id )
	end
	
	GamePrintImportant( message_title, message_desc )
	
	shoot_projectile( entity_who_picked, "data/entities/particles/image_emitters/orb_effect.xml", pos_x, pos_y, 0, 0 )
	EntityKill( entity_item )
end