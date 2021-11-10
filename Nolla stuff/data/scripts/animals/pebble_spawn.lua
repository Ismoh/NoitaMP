dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local normalfound,normalx,normaly,normaldist = GetSurfaceNormal( x, y, 5, 16 )
local offsetx,offsety = x, y

if normalfound then
	--print("Found normal! " .. tostring(normalx) .. ", " .. tostring(normaly) .. ", " .. tostring(normaldist))
	
	offsetx = offsetx + normalx * (0 - math.abs(normaldist))
	offsety = offsety + normaly * (0 - math.abs(normaldist))
end

EntityLoad( "data/entities/animals/pebble_physics.xml", offsetx, offsety )