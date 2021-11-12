dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local radius = 64
local e = EntityGetInRadiusWithTag( x, y, radius, "hittable" )
local p = EntityGetInRadiusWithTag( x, y, radius, "projectile" )

--print( tostring( #e ) .. ", " .. tostring( #p ) )

for i,v in ipairs( e ) do
	local hm = EntityGetTransform( v )
	if ( hm ~= nil ) then
		EntitySetTransform( v, x, y )
		EntityApplyTransform( v, x, y )
	end
end

for i,v in ipairs( p ) do
	local hm = EntityGetTransform( v )
	if ( hm ~= nil ) then
		EntitySetTransform( v, x, y )
		EntityApplyTransform( v, x, y )
	end
end