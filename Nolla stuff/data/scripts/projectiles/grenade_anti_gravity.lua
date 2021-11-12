dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
 
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local comp2 = EntityGetFirstComponent( entity_id, "VelocityComponent" )

if ( comp ~= nil ) and ( comp2 ~= nil ) then
	local owner_id = ComponentGetValue2( comp, "mWhoShot" )
	
	if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) then
		local px, py = EntityGetTransform( owner_id )
		
		if ( px ~= nil ) and ( py ~= nil ) then
			if ( py > y ) then
				ComponentSetValue2( comp2, "gravity_y", 600 )
			elseif ( py < y ) then
				ComponentSetValue2( comp2, "gravity_y", -600 )
			end
		end
	end
end