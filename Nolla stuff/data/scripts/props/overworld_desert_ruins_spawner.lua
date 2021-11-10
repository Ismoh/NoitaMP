dofile_once("data/scripts/lib/utilities.lua")

local structure_spacing = 16 -- space between structures and props
local end_spacing = 8 -- add empty space
local structure_stack_max = 5 -- how many blocks can be stacked
local extra_ruins_chance = 0.3
local collapse_chance = 0.2

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- avoid spawning near skull (ignores parallel worlds)
if pos_x > 7110 and pos_x < 7640 then return end

local function load_pixel_scene(file, x, y)
	--print("placing " .. file .. " to " .. x .. ", " .. y)
	LoadPixelScene( file .. ".png", file .. "_visual.png", x, y, "", true)
end

local bases = {
	{
		file = "data/biome_impl/overworld/desert_ruins_base_01",
		width = 67,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_base_02",
		width = 93,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_base_03",
		width = 83,
		probability = 0.75,
	},
}

local structures = {
	{
		file = "data/biome_impl/overworld/desert_ruins_block_01",
		width = 23,
		height = 20,
		probability = 0.6,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_02",
		width = 21,
		height = 12,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_03",
		width = 25,
		height = 12,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_04",
		width = 16,
		height = 25,
		probability = 1.0,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_05",
		width = 23,
		height = 18,
		probability = 0.6,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_06",
		width = 40,
		height = 10,
		probability = 0.8,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_07",
		width = 20,
		height = 15,
		probability = 0.6,
	},
	{
		file = "data/biome_impl/overworld/desert_ruins_block_08",
		width = 60,
		height = 8,
		probability = 0.8,
	},
}

local props = {
	{
		file = "data/entities/props/physics_bone_01.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_bone_02.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_bone_03.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_bone_04.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_bone_05.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_bone_06.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_skull_01.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_skull_02.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_skull_03.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_vase.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/props/physics_vase_longleg.xml",
		probability = 0.2,
	},
	{
		file = "data/entities/props/physics_temple_rubble_01.xml",
		probability = 2.0,
	},
	{
		file = "data/entities/props/physics_temple_rubble_02.xml",
		probability = 2.0,
	},
	{
		file = "data/entities/props/physics_temple_rubble_03.xml",
		probability = 2.0,
	},
	{
		file = "data/entities/props/physics_temple_rubble_04.xml",
		probability = 2.0,
	},
	{
		file = "data/entities/props/physics_temple_rubble_05.xml",
		probability = 2.0,
	},
	{
		file = "data/entities/props/physics_temple_rubble_06.xml",
		probability = 2.0,
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
		file = "data/entities/animals/zombie.xml",
		probability = 1.5,
	},
	{
		file = "data/entities/animals/scavenger_smg.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/animals/fireskull.xml",
		probability = 0.1,
	},
	{
		file = "data/entities/animals/firemage_weak.xml",
		probability = 0.1,
	},
	{
		file = "data/entities/animals/scorpion.xml",
		probability = 2.0,
	},
}

local sand_piles = {
	{
		file = "data/entities/props/overworld/sand_pile_01.xml",
		probability = 0.4,
	},
	{
		file = "data/entities/props/overworld/sand_pile_02.xml",
		probability = 0.4,
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
	if r < 0.4 then
		local y = pos_y + 1

		-- stack blocks
		local prev_structure = ""
		for i=1,ProceduralRandomi(pos_x+5784, y-14, 1, structure_stack_max) do
			local structure
			
			-- avoid repeating structures
			for j=1, 10 do
				structure = pick_random_from_table_weighted(random_create(pos_x, y + j), structures)
				if prev_structure ~= structure.file then break end
			end
			prev_structure = structure.file

			-- spawn block
			local w = structure.width * 0.25
			local x = pos_x + ProceduralRandomi(pos_x - i * 7.634, y, -structure.width + w, -w)
			load_pixel_scene(structure.file, x, y - structure.height)
			y = y - structure.height + 1
		end
		if r < 0.2 then
			-- prop on top of block stack
			local prop = pick_random_from_table_weighted(random_create(pos_x, entity_id+y), props)
			EntityLoad(prop.file, pos_x, y - 10)
		end
	elseif r < 0.7 then
		-- no blocks, just a random prop
		local prop = pick_random_from_table_weighted(random_create(pos_x, entity_id), props)
		EntityLoad(prop.file, pos_x, pos_y - 10)
	end

	pos_x = pos_x + structure_spacing
end

-- place base
load_pixel_scene(base.file, base_x, pos_y)

-- collapse or add sand (we don't want to turn powder into chunks!)
if ProceduralRandom(pos_x * -0.733, pos_y * 3.11) < collapse_chance then
	local x = base_x + base.width * 0.5
	if not RaytracePlatforms(x, pos_y - 115, x, pos_y - 117) then
		-- avoid collapse if inside something solid (a ROUGH approximation)
		EntityLoad("data/entities/misc/ruins_collapse.xml", x, pos_y - 30)
	end
else
	-- sprinkle sand on top
	local x = base_x + end_spacing
	while x < pos_x_max do
		local prop = pick_random_from_table_weighted(random_create(x-41, entity_id - pos_y), sand_piles)
		EntityLoad(prop.file, x, pos_y - 115)
		x = x + 50
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
	pos_x = pos_x + ProceduralRandomi(pos_x + 414, pos_y + 7241, 0, 40)
	pos_y = pos_y + ProceduralRandomi(pos_y - 595, pos_x - 4673, -2, 3) * 13
	
	EntityLoad("data/entities/props/overworld/desert_ruins_spawner.xml", pos_x, pos_y)
end

EntityKill(entity_id)

