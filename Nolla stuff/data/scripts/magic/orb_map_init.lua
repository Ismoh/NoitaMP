dofile_once("data/scripts/lib/utilities.lua")

local current = GlobalsGetValue( "ORB_MAP_STRING", "" )

if (string.len(current) == 0) then
	orb_map_update()
else
	print( "Current orb map is " .. current )
end