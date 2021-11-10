local entity_id = GetUpdatedEntityID()

local comp_ids = EntityGetComponent( entity_id, "VelocityComponent" )
if( comp_ids ~= nil ) then
	local x,y = ComponentGetValueVector2( comp_ids[1], "mVelocity")
	print( x, y )
end