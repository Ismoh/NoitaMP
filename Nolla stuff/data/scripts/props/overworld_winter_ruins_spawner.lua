dofile_once("data/scripts/lib/utilities.lua")

local structure_spacing = 46 -- space between structures and props
local end_spacing = 8 -- add empty space
local structure_height_random = 12 -- randomize vertical placement of structures
local extra_ruins_chance = 0.25
local collapse_chance = 0.4

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local prev_structure = ""

local function load_pixel_scene(file, x, y)
	--print("placing " .. file .. " to " .. x .. ", " .. y)
	LoadPixelScene( file .. ".png", file .. "_visual.png", x, y, "", true)
end

local bases = {
	{
		file = "data/biome_impl/overworld/snowy_ruins_base_01",
		width = 184,
		probability = 0.75,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_base_02",
		width = 93,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_base_03",
		width = 138,
		probability = 1.0,
	},
}

local structures = {
	{
		file = "data/biome_impl/overworld/snowy_ruins_pillar_01",
		height = 84,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_pillar_02",
		height = 35,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_pillar_03",
		height = 113,
		probability = 0.6,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_pillar_04",
		height = 100,
		probability = 0.8,
	},
	{
		file = "data/biome_impl/overworld/snowy_ruins_pillar_05",
		height = 34,
		probability = 1.0,
	},
}

local props = {
	{
		file = "data/entities/props/overworld/banner_01.xml",
		probability = 0.4,
	},
	{
		file = "data/entities/props/overworld/banner_02.xml",
		probability = 0.4,
	},
	{
		file = "data/entities/props/overworld/banner_03.xml",
		probability = 0.5,
	},
}

local snow_piles = {
	{
		file = "data/entities/props/overworld/snow_pile_01.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/props/overworld/snow_pile_02.xml",
		probability = 1.0,
	},
}

local enemies = {
	{
		file = nil,
		probability = 15.0,
	},
	{
		file = "data/entities/animals/miner.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/shotgunner.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/scavenger_mine.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/scavenger_smg.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/scavenger_grenade.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/iceskull.xml",
		probability = 0.1,
	},
	{
		file = "data/entities/animals/icemage.xml",
		probability = 0.1,
	},
}

-- pick base
local base = pick_random_from_table_weighted(random_create(pos_x, -pos_y), bases)
pos_x = pos_x - base.width/2 -- centering
local base_x = pos_x

-- initial coordinates for decorations
local pos_x_max = pos_x + base.width - end_spacing
pos_x = pos_x + end_spacing
--print(pos_x .. " ... " .. pos_x_max)

-- place decorations until available width is spend
while pos_x < pos_x_max do
	local r = ProceduralRandom(pos_y, pos_x * 0.934)
	if r < 0.7 then
		-- random pixel scene structure
		local structure
		local y = pos_y + ProceduralRandomi(pos_x + 214, pos_y, structure_height_random) -- randomize height

		-- avoid repeating structures
		for i=1, 10 do
			structure = pick_random_from_table_weighted(random_create(pos_x, y + i), structures)
			if prev_structure ~= structure.file then break end
		end
		prev_structure = structure.file

		load_pixel_scene(structure.file, pos_x, y - structure.height + 1)
	elseif r < 0.8 then
		-- random prop entity
		local prop = pick_random_from_table_weighted(random_create(pos_x, entity_id), props)
		EntityLoad(prop.file, pos_x, pos_y)
	end
	pos_x = pos_x + structure_spacing
end

-- place base last to cover pillars placed on different heights
load_pixel_scene(base.file, base_x, pos_y)

-- collapse or add snow (we don't want to turn powdery snow into chunks!)
if ProceduralRandom(pos_x * -0.733, pos_y * 3.11) < collapse_chance then
	local x = base_x + base.width * 0.5
	if not RaytracePlatforms(x, pos_y - 115, x, pos_y - 117) then
		-- avoid collapse if inside something solid (a ROUGH approximation)
		EntityLoad("data/entities/misc/ruins_collapse.xml", x, pos_y - 30)
	end
else
	-- sprinkle snow on top
	local x = base_x + end_spacing
	while x < pos_x_max do
		local prop = pick_random_from_table_weighted(random_create(x-41, entity_id - pos_y), snow_piles)
		EntityLoad(prop.file, x, pos_y - 115)
		x = x + structure_spacing * 1.6
	end
end

-- enemies
do
	local x = base_x + end_spacing + structure_spacing * 0.5
	while x < pos_x_max do
		local enemy = pick_random_from_table_weighted(random_create(x-111, pos_y + 7), enemies)
		if enemy.file then EntityLoad(enemy.file, x, pos_y - 115) end
		x = x + structure_spacing * 1.3
	end
end

-- chance for larger structures
if ProceduralRandom(pos_x * 1.353, pos_y - 217) < extra_ruins_chance then
	pos_x = pos_x + ProceduralRandomi(pos_x + 414, pos_y + 7241, 40, 90)
	pos_y = pos_y + ProceduralRandomi(pos_y - 595, pos_x - 4673, -4, 4) * 13
	if not RaytracePlatforms(pos_x, pos_y - 60, pos_x, pos_y - 61) then
		-- try to avoid spawning too deep inside ground
		EntityLoad("data/entities/props/overworld/winter_ruins_spawner.xml", pos_x, pos_y)
	end
end

EntityKill(entity_id)

