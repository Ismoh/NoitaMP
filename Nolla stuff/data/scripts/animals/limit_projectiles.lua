dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 220
local limit = 15

local targets = EntityGetInRadiusWithTag( x, y, radius, "projectile_item" )
local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

if ( comp ~= nil ) then
	if ( #targets < limit ) then
		ComponentSetValue2( comp, "attack_ranged_enabled", true )
	else
		ComponentSetValue2( comp, "attack_ranged_enabled", false )
	end
end