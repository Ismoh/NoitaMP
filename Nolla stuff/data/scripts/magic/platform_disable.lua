dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local test = EntityGetInRadiusWithTag( x, y, 200, "evil_eye" )
local found = false

for i,v in ipairs( test ) do
	local c = EntityGetComponent( v, "LightComponent" )
	
	if ( c ~= nil ) then
		found = true
		break
	end
end

if ( found == false ) then
	local c_ = EntityGetComponent( entity_id, "ParticleEmitterComponent" )
	
	if ( c_ ~= nil ) then
		EntitySetComponentsWithTagEnabled( entity_id, "magic_eye", false )
		
		local c = EntityGetAllChildren( entity_id )
		
		if ( c ~= nil ) then
			for a,b in ipairs( c ) do
				EntityKill( b )
			end
		end
	end
else
	local c = EntityGetComponent( entity_id, "ParticleEmitterComponent" )
	
	if ( c == nil ) then
		EntitySetComponentsWithTagEnabled( entity_id, "magic_eye", true )
		
		local eid = EntityLoad( "data/entities/misc/platform_wide_collision.xml", x, y )
		EntityAddChild( entity_id, eid )
	end
end