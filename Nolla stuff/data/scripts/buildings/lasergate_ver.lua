dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local arc = math.cos( GameGetFrameNum() * 0.03 + x * 0.05 )

local comp = EntityGetFirstComponent( entity_id, "LaserEmitterComponent" )
if ( comp ~= nil ) then
	if ( arc < 0 ) then
		ComponentSetValue2( comp, "is_emitting", true )
	else
		ComponentSetValue2( comp, "is_emitting", false )
	end
end