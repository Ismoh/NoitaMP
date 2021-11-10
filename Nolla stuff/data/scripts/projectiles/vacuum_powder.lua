dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
if ( comp ~= nil ) then
	ComponentSetValue2( comp, "kill_now", true )
end

EntityInflictDamage( entity_id, 1000, "DAMAGE_PROJECTILE", "", "NONE", 0, 0 )