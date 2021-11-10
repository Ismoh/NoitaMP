
function spawn_rewards(x, y)
	
	local MAX_ORB_COUNT = 12

	local enemies_killed = tonumber( StatsGetValue("enemies_killed") )
	local time_in_seconds = tonumber( StatsGetValue("playtime") )
	local projectiles_shot = tonumber( StatsGetValue("projectiles_shot") )
	local money_now = tonumber( StatsGetValue("gold") )
	local money_all_time = tonumber( StatsGetValue("gold_all") )
	local orbs = tonumber( GameGetOrbCountThisRun() )
	local damage_taken = tonumber( StatsGetValue("damage_taken") )
	local wands_edited = tonumber( StatsGetValue("wands_edited" ) )
	local kicks = tonumber( StatsGetValue("kicks" ) )
	local boss_kill_count = tonumber( GlobalsGetValue( "GLOBAL_BOSS_KILL_COUNT", "0" ) )
	local biomes_with_wands = tonumber( StatsGetValue("biomes_visited_with_wands" ) )

	-- reward_nowands,No wands,,,,,,,,,,,,,
	-- reward_almostpacifist,Almost a pacifist,,,,,,,,,,,,,
	-- reward_notinkeringofwands,Abstained from wand tinkering,,,,,,,,,,,,,
	-- reward_kicksonly,The Mighty Foot,,,,,,,,,,,,,
	-- new game plusses ?
	-- local perks =  ? 
	-- projectiles_shot

	local e_id = EntityGetClosestWithTag( x, y, "player_unit")
	local wallet_comp = EntityGetFirstComponent( e_id, "WalletComponent" )

	if( wallet_comp ~= nil ) then 
		money_now = tonumber( ComponentGetValue( wallet_comp, "money" ) )
		money_all_time = money_now + tonumber( ComponentGetValue( wallet_comp, "money_spent" ) )
	end

	print( "enemies_killed: " .. tostring(enemies_killed) )
	print( "time_in_seconds: " .. tostring(time_in_seconds) )
	print( "projectiles_shot: " .. tostring(projectiles_shot) )
	print( "money_now: " .. tostring(money_now ) )
	print( "money_all_time: " .. tostring(money_all_time ) )
	print( "orbs collected: " .. tostring( orbs ) )
	print( "kicks: " .. tostring(kicks) )
	
	-- less than 1 minutes -> minit watering can
	-- less than 5 minutes
	-- - 0 kills -> pacifist
	-- - 0 gold picked up (0 logo)
	-- - over 500k
	--- over 1milj

	-- TODO: - over 1000000
	-- killed only boss?
	-- no wands
	-- no items

	local spawned_n = 0
	local entity = 0

	-- pacifist
	if( enemies_killed <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_peace.xml", x + spawned_n * 20, y - spawned_n * 10)
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_pacifist" )
	elseif( enemies_killed <= boss_kill_count ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_almostpacifist.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end

	-- kicks only
	if( projectiles_shot <= 0 and kicks > 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_kicksonly.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end
	
	-- undamaged
	if( damage_taken <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nohit.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_nohit" )
	end

	-- no wands / no wand editing
	if( biomes_with_wands <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nowands.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	elseif( wands_edited <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_notinkeringofwands.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end

	-- time
	if( time_in_seconds <= 60.0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_minit.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_minit" )
	elseif( time_in_seconds <= 5 * 60 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_clock.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_clock" )
	end

	-- orbs
	if( orbs >= MAX_ORB_COUNT ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_crown.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end

	-- money
	if( money_all_time <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nolla.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_nogold" )
	end

	if( money_now >= 1000000 ) then
		EntityLoad( "data/entities/animals/boss_centipede/rewards/giant_dollar.xml", x + 100, y - 75 )
		-- entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nolla.xml", x + spawned_n * 20, y - spawned_n * 10 )
	end
	if( money_now >= 500000 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_dollar.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end

	if( spawned_n <= 0 ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/gold_reward.xml", x, y )
	end
	
	-- sun
	
	if GameHasFlagRun( "sun_kill" ) then
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_sun.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
		
		AddFlagPersistent( "progress_sunkill" )
	end
end