dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 160, "homing_target" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		if ( ( EntityHasTag( target_id, "death_ghost" ) == false ) and ( EntityHasTag( target_id, "polymorphed") == false) ) then
			EntityAddTag( target_id, "death_ghost" )
			
			EntityAddComponent( target_id, "LuaComponent", 
			{ 
				script_death = "data/scripts/perks/death_ghost_death.lua",
				execute_every_n_frame = "-1",
			} )
		end
	end
end