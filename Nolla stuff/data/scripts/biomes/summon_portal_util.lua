dofile_once("data/scripts/lib/utilities.lua")

function get_portal_position()
	local biome_x_min = -2450
	local biome_x_max = 1900
	local biome_y_min = 6700
	local biome_y_max = 8000
	local rim = 200
	local portal_x = ProceduralRandomi(209,13,biome_x_min + rim,biome_x_max - rim)
	local portal_y = ProceduralRandomi(211,1.9,biome_y_min + rim,biome_y_max - rim)
	--print("portal position: " .. portal_x .. ", " .. portal_y)
	return portal_x, portal_y
end