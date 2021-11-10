dofile_once( "data/scripts/lib/utilities.lua" )
local init_biome_modifiers = dofile_once( "data/scripts/biome_modifiers.lua")

--[[
-- function OnPlayerSpawned( player_entity )
-- function OnPlayerDied( player_entity )
-- function OnMagicNumbersAndWorldSeedInitialized()
-- function OnBiomeConfigLoaded()
-- function OnWorldInitialized()
-- function OnWorldPreUpdate()
-- function OnWorldPostUpdate()
-- function OnPausedChanged( is_paused, is_inventory_pause )
-- function OnModSettingsChanged() -- Will be called when the game is unpaused, if player changed any mod settings while the game was paused.
-- function OnPausePreUpdate() -- Will be called when the game is paused, either by the pause menu or some inventory menus. Please be careful with this, as not everything will behave well when called while the game is paused.
]]--

-- weather config

local snowfall_chance = 1 / 12
local rainfall_chance = 1 / 15
local rain_duration_on_run_start = 4 * 60 * 60

local RAIN_TYPE_NONE = 0
local RAIN_TYPE_SNOW = 1
local RAIN_TYPE_LIQUID = 2

local snow_types =
{
	{
		chance = 1.0,
		rain_material = "snow",
		rain_particles_min = 1,
		rain_particles_max = 4,
		rain_duration = -1,
		rain_draw_long_chance = 0.5,
		rain_type = RAIN_TYPE_SNOW,
	},
	{
		chance = 0.25,
		rain_material = "slush",
		rain_particles_min = 3,
		rain_particles_max = 5,
		rain_duration = rain_duration_on_run_start,
		rain_draw_long_chance = 0.5,
		rain_type = RAIN_TYPE_SNOW,
	},
}

local rain_types =
{
	{
		chance = 1.0, -- light rain
		rain_material = "water",
		rain_particles_min = 4,
		rain_particles_max = 7,
		rain_duration = rain_duration_on_run_start,
		rain_draw_long_chance = 1.0,
		rain_type = RAIN_TYPE_LIQUID,
	},
	{

		chance = 0.05, -- heavy rain
		rain_material = "water",
		rain_particles_min = 10,
		rain_particles_max = 15,
		rain_duration = rain_duration_on_run_start / 2,
		rain_draw_long_chance = 1.0,
		rain_type = RAIN_TYPE_LIQUID,
	},
	{
		chance = 0.001,
		rain_material = "blood",
		rain_particles_min = 10,
		rain_particles_max = 15,
		rain_duration = rain_duration_on_run_start / 2,
		rain_draw_long_chance = 1.0,
		rain_type = RAIN_TYPE_LIQUID,
	},
	{
		chance = 0.0002,
		rain_material = "acid",
		rain_particles_min = 10,
		rain_particles_max = 15,
		rain_draw_long_chance = 1.0,
		rain_duration = rain_duration_on_run_start / 2,
		rain_type = RAIN_TYPE_LIQUID,
	},
	{
		chance = 0.0001,
		rain_material = "slime",
		rain_particles_min = 1,
		rain_particles_max = 4,
		rain_draw_long_chance = 1.0,
		rain_duration = rain_duration_on_run_start / 2,
		rain_type = RAIN_TYPE_LIQUID,
	},
}

-- weather impl

function pick_random_from_table_backwards( t, rnd )
	local result = nil
	local len = #t

	for i=len,1, -1 do
		if random_next( rnd, 0.0, 1.0 ) <= t[i].chance then
			result = t[i]
			break
		end
	end

	if result == nil then
		result = t[1]
	end

	return result
end

local weather = nil

function weather_init( year, month, day, hour, minute )
	local rnd = random_create( 7893434, 3458934 )
	local rnd_time = random_create( hour+day, hour+day+1 )

	-- pick weather type
	local snows1 = ( month >= 12 )
	local snows2 = ( month <= 2 )
	local snows = (snows1 or snows2) and (random_next( rnd_time, 0.0, 1.0 ) <= snowfall_chance) -- snow is based on real world time
	local rains = (not snows) and (random_next( rnd, 0.0, 1.0 ) <= rainfall_chance) 			-- rain is based on world seed

	weather = { }
	local rain_type = RAIN_TYPE_NONE
	if snows then
		rain_type = RAIN_TYPE_SNOW
		weather = pick_random_from_table_backwards( snow_types, rnd_time )
		-- apply effects from biome_modifiers.lua
		apply_modifier_if_has_none( "hills", "FREEZING" )
		apply_modifier_if_has_none( "mountain_left_entrance", "FREEZING" )
		apply_modifier_if_has_none( "mountain_left_stub", "FREEZING" )
		apply_modifier_if_has_none( "mountain_right", "FREEZING" )
		apply_modifier_if_has_none( "mountain_right_stub", "FREEZING" )
		apply_modifier_if_has_none( "mountain_tree", "FREEZING" )
		apply_modifier_if_has_none( "mountain_tree", "FREEZING" )
		apply_modifier_from_data( "mountain_lake", biome_modifier_cosmetic_freeze ) -- FREEZING the lake is a bad idea. it glitches the fish and creates unnatural ice formations
	elseif rains then
		rain_type = RAIN_TYPE_LIQUID
		weather = pick_random_from_table_backwards( rain_types, rnd )
	end

	-- init weather struct
	weather.hour = hour
	weather.day = day
	weather.rain_type = rain_type

	-- make it foggy and cloudy if stuff is falling from the sky, randomize rain type
	if weather.rain_type == RAIN_TYPE_NONE then
		weather.fog = 0.0
		weather.clouds = 0.0
	else
		weather.fog = random_next( rnd, 0.3, 0.85 )
		weather.clouds = math.max( weather.fog, random_next( rnd, 0.0, 1.0 ) )
		weather.rain_draw_long = random_next( rnd, 0.0, 1.0 ) <= weather.rain_draw_long_chance
		weather.rain_particles = random_next( rnd, weather.rain_particles_min, weather.rain_particles_max )
	end

	-- set world state
	local world_state_entity = GameGetWorldStateEntity()
	edit_component( world_state_entity, "WorldStateComponent", function(comp,vars)
		vars.fog_target_extra = weather.fog
		vars.rain_target_extra = weather.clouds
	end)
end

function weather_check_duration()
	return (weather.rain_duration < 0) or (GameGetFrameNum() < weather.rain_duration)
end

function weather_update()
	if GameIsIntroPlaying() then
		return
	end

	-- some scripts use the random API incorrectly, without calling SetRandomSeed(), so we better not do that here (every frame), or otherwise those scripts may always get the same random sequence.. SetRandomSeed sets the seed globally for all lua scripts.
	local year,month,day,hour,minute = GameGetDateAndTimeUTC()

	if weather == nil or weather.hour ~= hour or weather.day ~= day then
		weather_init( year, month, day, hour, minute )
	end

	if weather.rain_type == RAIN_TYPE_SNOW and weather_check_duration() then
		GameEmitRainParticles( weather.rain_particles, 1024, weather.rain_material, 30, 60, 10, false, weather.rain_draw_long )
	end
	
	if weather.rain_type == RAIN_TYPE_LIQUID and weather_check_duration() then
		GameEmitRainParticles( weather.rain_particles, 1024, weather.rain_material, 200, 220, 200, true, weather.rain_draw_long )
	end
end


function OnBiomeConfigLoaded()
	init_biome_modifiers()
end

function OnWorldPreUpdate()
	weather_update()
end

function OnPlayerDied( player_entity )
	GameDestroyInventoryItems( player_entity )
	GameTriggerGameOver()
end

function OnCountSecrets()
	local secret_flags = {
		"progress_ending0",
		"progress_ending1",
		"progress_ending2",
		"progress_ngplus",
		"progress_orb_evil",
	}

	local total = GameGetOrbCountTotal() + #secret_flags
	local found = 0
	found = found + GameGetOrbCountAllTime()
	for i,it in ipairs(secret_flags) do
		if ( HasFlagPersistent(it) ) then
			found = found + 1
		end
	end

	return total,found
end

