dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local luac = EntityGetFirstComponent( entity_id, "LuaComponent" )
if ( luac ~= nil ) then
	SetRandomSeed( x, y )
	local rnd = Random( 40, 150 )
	ComponentSetValue2( luac, "execute_every_n_frame", rnd )
end