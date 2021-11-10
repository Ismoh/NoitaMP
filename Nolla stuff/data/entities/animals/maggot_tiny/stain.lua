dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
local radius = 40

local t = EntityGetInRadiusWithTag( x, y, radius, "mortal" )
for i,v in ipairs( t ) do
	EntityAddRandomStains( v, CellFactory_GetType( "material_darkness" ), 20 )
end