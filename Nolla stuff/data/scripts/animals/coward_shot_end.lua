dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local vx, vy = 0,0

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local target = 0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vx,vy = ComponentGetValueVector2( comp, "mVelocity", vx, vy)
end)

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "target" ) then
			target = ComponentGetValue2( v, "value_int" )
			break
		end
	end
end

if ( target ~= nil ) and ( target ~= NULL_ENTITY ) then
	local c = EntityGetAllChildren( target )
	
	--print(tostring(vx * 0.02) .. ", " .. tostring(vy * 0.02))
	
	EntitySetTransform( target, x - vx * 0.02, y - vy * 0.02 )
	EntityApplyTransform( target, x - vx * 0.02, y - vy * 0.02 )
	
	--[[
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if ( EntityHasTag( v, "coward_effect" ) then
				EntityKill( v )
			end
		end
	end
	]]--
end