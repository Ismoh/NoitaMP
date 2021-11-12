
dofile("data/scripts/biomes/coalmine.lua")

local mouse_x, mouse_y = DEBUG_GetMouseWorld()
-- DEBUG_spawn_all( g_items, mouse_x, mouse_y, 20 )

-- this is needed to initialize the spawnActionItems
EntityLoad( "data/entities/items/chest.xml", mouse_x, mouse_y - 20 )

-- g_items
for i=1,7 do
	spawn(g_items,mouse_x,mouse_y)
end

for i=1,40 do
	SpawnActionItem( mouse_x, mouse_y, 0 )
end
