-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')

local guns =
{
	{
		chance = 0.1,
		capacity = 10,
		actions_per_round = 1,
		reload = 70,
		shuffle = true,
		rare_chance = 0.1,
		rare_type = "test",
		actions = 
		{
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
		},
	},
	{
		chance = 0.2,
		capacity = 8,
		actions_per_round = 1,
		reload = 50,
		shuffle = true,
		actions = 
		{
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
			"SPITTER",
		},
	},
}

function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )
	
	local gun = {}
	local temp = {}
	local totalchance = 0
	for i,g in ipairs(guns) do
		totalchance = totalchance + g.chance * 1000
		table.insert(temp, {id = i, chance = totalchance})
	end
	
	local prob = math.random(1,totalchance)
	local l = 0
	local u = 0
	for i,g in ipairs(temp) do
		u = u + g.chance
		if (prob > l) and (prob <= u) then
			local target_gun = g.id
			gun = guns[target_gun]
		end
		l = u
	end
	
	gun_gen(gun,entity_id)
end

function rare_gun(g,entity_id)
	
	local capacity = g.capacity
	local actions_per_round = g.actions_per_round
	local reload = g.reload
	local shuffle = g.shuffle
	local firerate = g.firerate
	local spread = g.spread
	local bullet_speed = g.bullet_speed
	local rare_type = g.rare_type

	if (rare_type == "test") then
		bullet_speed = 0.9
	end
	
	return capacity,actions_per_round,reload,shuffle,firerate,spread,bullet_speed
end

generate_gun()

