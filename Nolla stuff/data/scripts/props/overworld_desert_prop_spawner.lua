dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- avoid spawning near skull (ignores parallel worlds) or underground
if (pos_x > 7110 and pos_x < 7640) or pos_y > 100 then
	EntityKill(entity_id)
	return
end

local props = {
	{
		file = "data/entities/props/overworld/sand_pile_01.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/props/overworld/sand_pile_02.xml",
		probability = 1.0,
	},
	{
		file = "data/entities/props/overworld/desert_ruins_spawner.xml",
		probability = 0.6,
	},
}

local prop = pick_random_from_table_weighted(random_create(pos_x - entity_id, pos_y), props)
--print("spawning prop " .. prop.file .. " at " .. pos_x .. ", " .. pos_y)
EntityLoad(prop.file, pos_x, pos_y)

EntityKill(entity_id)
