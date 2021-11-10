dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 100

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

-- attract projectiles
local entities = EntityGetInRadiusWithTag(x, y, distance_full, "hittable")
for _,id in ipairs(entities) do	
	local comp = EntityGetFirstComponent( id, "DamageModelComponent" )
	if ( comp ~= nil ) then -- velocity for physics bodies is done later
		local eid = EntityLoad( "data/entities/misc/effect_protection_all_ultrashort.xml", x, y )
		EntityAddChild( id, eid )
	end
end