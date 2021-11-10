dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local test = get_flag_name( "noita" )
local result = get_flag_name( "best_gymtipz" )

local targets = EntityGetInRadiusWithTag( x, y, 48, test )

if ( #targets > 0 ) then
	for i,v in ipairs( targets ) do
		EntityKill( v )
	end
	
	EntityAddTag( entity_id, result )	
	AddFlagPersistent( result )
	
	local c = EntityGetAllChildren( entity_id )
	local s = EntityGetFirstComponent( entity_id, "SpriteComponent" )
	
	if ( s ~= nil ) then
		ComponentSetValue2( s, "image_file", "data/enemies_gfx/body_old_test.xml" )
	end
	
	local handled = {}
	
	EntitySetComponentsWithTagEnabled( entity_id, "testcheck", false )
	
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			local sprite = EntityGetComponent( v, "SpriteComponent" )
			
			if ( sprite ~= nil ) then
				for a,b in ipairs( sprite ) do
					if ( handled[b] == nil ) then
						local f = ComponentGetValue2( b, "image_file" )
						
						if ( string.sub( f, -10 ) ~= "_green.xml" ) then
							f = string.sub( f, 1, #f - 4 )
							f = f .. "_green.xml"
							ComponentSetValue2( b, "image_file", f )
							handled[b] = 1
						end
					end
				end
			end
		end
	end
end