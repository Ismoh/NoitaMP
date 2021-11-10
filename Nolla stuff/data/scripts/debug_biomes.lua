function RegisterSpawnFunction( a, b )
end

dofile("data/scripts/biomes/coalmine.lua")

local mouse_x, mouse_y = DEBUG_GetMouseWorld()
DEBUG_spawn_all( g_items, mouse_x, mouse_y, 20 )
