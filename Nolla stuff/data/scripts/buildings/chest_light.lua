dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local keys = EntityGetInRadiusWithTag( x, y, 24, "alchemist_key" )

if ( #keys > 0 ) then
	local key_id = keys[1]
	
	local variables = EntityGetComponent( key_id, "VariableStorageComponent" )
	local status = 0
	
	if ( variables ~= nil ) then
		for i,comp in ipairs(variables) do
			local name = ComponentGetValue2( comp, "name" )
			
			if ( name == "music_machine" ) then
				status = ComponentGetValue2( comp, "value_int" )
			end
		end
	end
	
	local already_done = HasFlagPersistent( "card_unlocked_musicbox" )
	
	if ( status == 4 ) then
		if ( already_done == false ) then
			GamePrintImportant( "$log_alchemist_key_alt_reward", "$logdesc_alchemist_key_alt_reward" )
			EntitySetComponentsWithTagEnabled( entity_id, "chest_enable", true )
			EntitySetComponentsWithTagEnabled( entity_id, "chest_disable", false )
			CreateItemActionEntity( "DIVIDE_2", x - 48, y )
			CreateItemActionEntity( "DIVIDE_3", x - 24, y )
			CreateItemActionEntity( "DIVIDE_4", x, y )
			CreateItemActionEntity( "BURST_8", x + 24, y )
			CreateItemActionEntity( "BURST_X", x + 48, y )
			AddFlagPersistent( "card_unlocked_musicbox" )
		else
			GamePrintImportant( "$log_alchemist_chest_opened_alt", "$logdesc_alchemist_chest_opened_alt" )
			local opts = { "DIVIDE_2", "DIVIDE_3", "DIVIDE_4", "BURST_8", "BURST_X" }
			SetRandomSeed( x, y * GameGetFrameNum() )
			
			for i=1,3 do
				local rnd = Random( 1, #opts )
				local opt = opts[rnd]
				
				CreateItemActionEntity( opt, x - 8 + (i-1) * 16, y )
			end
		end
		
		AddFlagPersistent( "secret_chest_light" )
		
		EntityLoad( "data/entities/particles/particle_explosion/main_swirly_green.xml", x, y )
		EntityLoad( "data/entities/projectiles/circle_water.xml", x, y )
		GamePlaySound( "data/audio/Desktop/misc.bank", "misc/chest_dark_open", x, y )
		
		EntityKill( key_id )
		EntityKill( entity_id )
	end
end		