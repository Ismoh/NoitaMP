dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "mortal" )
for i,v in ipairs( targets ) do
	if ( EntityHasTag( v, "player_unit" ) == false ) then
		local test = EntityGetFirstComponent( v, "DamageModelComponent" )
		
		if ( test ~= nil ) then
			EntityKill( v )
		end
	end
end