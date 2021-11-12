dofile("data/scripts/gun/procedural/wands.lua")

local fire_rate_wait_min = 1000
local fire_rate_wait_max = 0
local actions_per_round_min = 1000
local actions_per_round_max = 0
local shuffle_deck_when_empty_min = 1000
local shuffle_deck_when_empty_max = 0
local deck_capacity_min = 1000
local deck_capacity_max = 0
local spread_degrees_min = 1000
local spread_degrees_max = 0
local reload_time_min = 1000
local reload_time_max = 0

function Min( x, y ) 
	if( x < y ) then return x else return y end
end

function Max( x, y ) 
	if( x > y ) then return x else return y end
end

for k,wand in pairs(wands) do
	fire_rate_wait_min = Min( fire_rate_wait_min, wand.fire_rate_wait )
	fire_rate_wait_max = Max( fire_rate_wait_max, wand.fire_rate_wait )

	actions_per_round_min = Min( actions_per_round_min, wand.actions_per_round )
	actions_per_round_max = Max( actions_per_round_max, wand.actions_per_round )

	shuffle_deck_when_empty_min = Min( shuffle_deck_when_empty_min, wand.shuffle_deck_when_empty )
	shuffle_deck_when_empty_max = Max( shuffle_deck_when_empty_max, wand.shuffle_deck_when_empty )

	deck_capacity_min = Min( deck_capacity_min, wand.deck_capacity )
	deck_capacity_max = Max( deck_capacity_max, wand.deck_capacity )

	spread_degrees_min = Min( spread_degrees_min, wand.spread_degrees )
	spread_degrees_max = Max( spread_degrees_max, wand.spread_degrees )

	reload_time_min = Min( reload_time_min, wand.reload_time )
	reload_time_max = Max( reload_time_max, wand.reload_time )
end

function WandDiff( gun, wand )
	local score = 0
	score = score + math.abs( gun.fire_rate_wait - wand.fire_rate_wait )
	score = score + math.abs( gun.actions_per_round - wand.actions_per_round )
	score = score + math.abs( gun.shuffle_deck_when_empty - wand.shuffle_deck_when_empty )
	score = score + math.abs( gun.deck_capacity - wand.deck_capacity )
	score = score + math.abs( gun.spread_degrees - wand.spread_degrees )
	score = score + math.abs( gun.reload_time - wand.reload_time )
	return score
end

function GetWandDebug( fire_rate_wait, actions_per_round, shuffle_deck_when_empty, deck_capacity, spread_degrees, reload_time )
	local best_wand = nil
	local best_score = 1000
	local gun_in_wand_space = {}
	gun_in_wand_space.fire_rate_wait = fire_rate_wait
	gun_in_wand_space.actions_per_round = actions_per_round
	gun_in_wand_space.shuffle_deck_when_empty = shuffle_deck_when_empty
	gun_in_wand_space.deck_capacity = deck_capacity
	gun_in_wand_space.spread_degrees = spread_degrees
	gun_in_wand_space.reload_time = reload_time
	
	SetRandomSeed( GameGetFrameNum(), fire_rate_wait )

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
end

function clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end


function WandDiff( gun, wand )
	local score = 0
	score = score + math.abs( gun.fire_rate_wait - wand.fire_rate_wait )
	score = score + math.abs( gun.actions_per_round - wand.actions_per_round )
	score = score + math.abs( gun.shuffle_deck_when_empty - wand.shuffle_deck_when_empty )
	score = score + math.abs( gun.deck_capacity - wand.deck_capacity )
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


	gun_in_wand_space.fire_rate_wait = clamp(((gun["fire_rate_wait"] + 5) / 10)-1, 0, 2)
	gun_in_wand_space.actions_per_round = clamp(gun["actions_per_round"]-1,0,2)
	gun_in_wand_space.shuffle_deck_when_empty = clamp(gun["shuffle_deck_when_empty"], 0, 1)
	gun_in_wand_space.deck_capacity = clamp( (gun["deck_capacity"]-3)/2, 0, 7 ) -- TODO
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

local gun = {}
gun["fire_rate_wait"] = 15	
gun["actions_per_round"] = 1	
gun["shuffle_deck_when_empty"] = 1	
gun["deck_capacity"] = 	7.36	
gun["spread_degrees"] = 1	
gun["reload_time"] = 39	

local bwand = GetWand( gun )
-- local bwand = GetWand( 1, 2, 1, 2, 1, 1 )
print( "bwand: ", bwand.fire_rate_wait, bwand.actions_per_round, bwand.shuffle_deck_when_empty, bwand.deck_capacity, bwand.spread_degrees, bwand.reload_time )


print( "fire_rate_wait: ", fire_rate_wait_min, " - ", fire_rate_wait_max  )
print( "actions_per_round: ", actions_per_round_min, " - ", actions_per_round_max  )
print( "shuffle_deck_when_empty: ", shuffle_deck_when_empty_min, " - ", shuffle_deck_when_empty_max  )
print( "deck_capacity: ", deck_capacity_min, " - ", deck_capacity_max  )
print( "spread_degrees: ", spread_degrees_min, " - ", spread_degrees_max  )
print( "reload_time: ", reload_time_min, " - ", reload_time_max  )