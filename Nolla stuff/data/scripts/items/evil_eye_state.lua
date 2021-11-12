dofile_once("data/scripts/lib/utilities.lua")

function enabled_changed( entity_id, is_enabled )
	local x,y = EntityGetTransform( entity_id )
	local plats = EntityGetInRadiusWithTag( x, y, 200, "magic_eye_platform" )
	
	if is_enabled then
		for i,v in ipairs( plats ) do
			EntitySetComponentsWithTagEnabled( v, "magic_eye", true )
			
			local px,py = EntityGetTransform( v )
			
			local eid = EntityLoad( "data/entities/misc/platform_wide_collision.xml", px, py )
			EntityAddChild( v, eid )
		end
	else
		for i,v in ipairs( plats ) do
			EntitySetComponentsWithTagEnabled( v, "magic_eye", false )
			
			local c = EntityGetAllChildren( v )
			
			if ( c ~= nil ) then
				for a,b in ipairs( c ) do
					EntityKill( b )
				end
			end
		end
	end
end