dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "LuaComponent", "vacuum_powder_helper" )
local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if ( comp ~= nil ) and ( comp2 ~= nil ) then
	local lifetime = ComponentGetValue2( comp2, "mStartingLifetime" )
	
	ComponentSetValue2( comp, "execute_every_n_frame", lifetime - 1 )
end