dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( root_id )

local comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
if ( comp ~= nil ) then
	local max_hp = ComponentGetValue2( comp, "max_hp" )
	ComponentSetValue2( comp, "hp", max_hp )
	
	EntityLoad( "data/entities/particles/poof_green.xml", x, y )
	
	local eid = EntityLoad( "data/entities/misc/effect_protection_all_short.xml", x, y )
	EntityAddChild( root_id, eid )
end

EntityKill( entity_id )