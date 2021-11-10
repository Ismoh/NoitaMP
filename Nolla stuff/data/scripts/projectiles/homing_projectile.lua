dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
local radius = 300
local targets = EntityGetInRadiusWithTag( x, y, radius, "projectile" )
local comp = EntityGetFirstComponent( entity_id, "HomingComponent", "homing_projectile" )

if ( comp ~= nil ) then
	local target = ComponentGetValue2( comp, "predefined_target" )
	
	local test = EntityGetFirstComponent( target, "ProjectileComponent" )
	
	if ( test == nil ) or ( target == NULL_ENTITY ) then
		for i,v in ipairs( targets ) do
			if ( v ~= entity_id ) and ( v ~= root_id ) then
				ComponentSetValue2( comp, "predefined_target", v )
				return
			end
		end
	end
end
