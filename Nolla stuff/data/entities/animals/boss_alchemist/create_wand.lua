dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local radius = 260

local proj = ""

local s = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( s ~= nil ) then
	for i,v in ipairs( s ) do
		local name = ComponentGetValue2( v, "name" )
		
		if ( name == "type" ) then
			proj = ComponentGetValue2( v, "value_string" )
		end
	end
end

local targets = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if ( string.len( proj ) > 0 ) and ( #targets > 0 ) then
	for i,v in ipairs( targets ) do
		local px, py = EntityGetTransform( v )
		local vel_x = math.cos( 0 - math.atan2( py - y, px - x ) ) * 2.0
		local vel_y = 0 - math.sin( 0 - math.atan2( py - y, px - x ) ) * 2.0
		
		local eid = shoot_projectile_from_projectile( entity_id, proj, x, y, vel_x, vel_y )
		
		EntityAddTag( eid, "boss_alchemist" )
	end
end