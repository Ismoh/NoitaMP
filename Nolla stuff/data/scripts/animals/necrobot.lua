dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 144

local targets = EntityGetInRadiusWithTag( x, y, radius, "mortal" )
local found = false

for i,v in ipairs( targets ) do
	if ( EntityHasTag( v, "player_unit" ) == false ) and ( EntityHasTag( v, "necrobot_NOT" ) == false ) then
		local file = EntityGetFilename( v )
		
		if ( file ~= nil ) and ( #file > 0 ) and ( string.find( file, "entities/animals/" ) ~= nil ) then
			EntityAddComponent( v, "LuaComponent", 
			{ 
				script_death = "data/scripts/status_effects/necrobot.lua",
				execute_every_n_frame = "-1",
			} )
			
			local eid = EntityLoad( "data/entities/particles/tinyspark_green_sparse.xml", x, y )
			EntityAddChild( v, eid )
		end
		
		EntityAddTag( v, "necrobot_NOT" )
	end
end