dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local eid = EntityLoad( "data/entities/animals/boss_alchemist/projectile_counter.xml", x, y )
EntityAddChild( entity_id, eid )

local c = EntityGetFirstComponent( entity_id, "LuaComponent", "counter" )
if ( c ~= nil ) then
	ComponentSetValue2( c, "execute_every_n_frame", 600 )
end

edit_component( entity_id, "HitboxComponent", function(comp,vars)
	ComponentSetValue2( comp, "damage_multiplier", 0.0 )
end)