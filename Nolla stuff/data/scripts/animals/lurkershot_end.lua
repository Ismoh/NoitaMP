dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "lurkershot_id" )
if ( comp ~= nil ) then
	local lurker_id = ComponentGetValue2( comp, "value_int" )
	
	local f, nx, ny, d = GetSurfaceNormal( x, y, 16, 8 )
	
	if f then
		x = x - nx * d
		y = y - ny * d
	end
	
	local test = EntityGetTransform( lurker_id )
	
	--print( tostring( nx ) .. ", " .. tostring( ny ) .. ", " .. tostring( d ) )
	
	if ( lurker_id ~= nil ) and ( lurker_id ~= NULL_ENTITY ) and ( test ~= nil ) then
		EntitySetTransform( lurker_id, x , y )
		EntityApplyTransform( lurker_id, x, y )
		EntitySetComponentsWithTagEnabled( lurker_id, "lurker_data", true )
	end
end