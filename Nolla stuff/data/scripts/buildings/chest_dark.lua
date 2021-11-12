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
			
			if ( name == "status" ) then
				status = ComponentGetValue2( comp, "value_int" )
			end
		end
	end
	
	local already_done = HasFlagPersistent( "card_unlocked_alchemy" )
	
	if ( status == 2 ) then
		if ( already_done == false ) then
			GamePrintImportant( "$log_alchemist_chest_open", "$logdesc_alchemist_chest_open" )
			EntitySetComponentsWithTagEnabled( entity_id, "chest_enable", true )
			EntitySetComponentsWithTagEnabled( entity_id, "chest_disable", false )
			CreateItemActionEntity( "ALL_ACID", x - 40, y )
			CreateItemActionEntity( "ALL_NUKES", x - 24, y )
			CreateItemActionEntity( "ALL_DISCS", x - 8, y )
			CreateItemActionEntity( "ALL_ROCKETS", x + 8, y )
			CreateItemActionEntity( "ALL_BLACKHOLES", x + 24, y )
			CreateItemActionEntity( "ALL_DEATHCROSSES", x + 40, y )
			AddFlagPersistent( "card_unlocked_alchemy" )
		else
			GamePrintImportant( "$log_alchemist_chest_opened", "$logdesc_alchemist_chest_opened" )
			local opts = { "ALL_ACID", "ALL_NUKES", "ALL_DISCS", "ALL_ROCKETS", "ALL_BLACKHOLES", "ALL_DEATHCROSSES" }
			SetRandomSeed( x, y * GameGetFrameNum() )
			
			for i=1,3 do
				local rnd = Random( 1, #opts )
				local opt = opts[rnd]
				
				CreateItemActionEntity( opt, x - 16 + (i-1) * 16, y )
			end
		end
		
		AddFlagPersistent( "secret_chest_dark" )
		
		EntityLoad( "data/entities/particles/particle_explosion/main_swirly_red.xml", x, y )
		EntityLoad( "data/entities/projectiles/circle_blood.xml", x, y )
		GamePlaySound( "data/audio/Desktop/misc.bank", "misc/chest_dark_open", x, y )
		
		EntityKill( key_id )
		EntityKill( entity_id )
	end
end		