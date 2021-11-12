dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- avoid spawning underground
if pos_y > 40 then
	EntityKill(entity_id)
	return
end

local props = {
	{
		file = "data/entities/props/overworld/snowy_rock_01.xml",
		probability = 1,
	},
	{
		file = "data/entities/props/overworld/snowy_rock_02.xml",
		probability = 1.5,
	},
	{
		file = "data/entities/props/overworld/snowy_rock_03.xml",
		probability = 1,
	},
	{
		file = "data/entities/props/overworld/snowy_rock_04.xml",
		probability = 1.3,
	},
	{
		file = "data/entities/props/overworld/snowy_rock_05.xml",
		probability = 1,
	},
	{
		file = "data/entities/props/overworld/snow_pile_01.xml",
		probability = 1.2,
	},
	{
		file = "data/entities/props/overworld/snow_pile_02.xml",
		probability = 1.2,
	},
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
	{
		file = "data/entities/props/overworld/winter_ruins_spawner.xml",
		probability = 0.6,
	},
}

local prop = pick_random_from_table_weighted(random_create(pos_x - entity_id, pos_y), props)
--print("spawning prop " .. prop.file .. " at " .. pos_x .. ", " .. pos_y)
EntityLoad(prop.file, pos_x, pos_y)

EntityKill(entity_id)
