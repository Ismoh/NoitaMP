dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 260, "homing_target" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent" )

		if ( EntityHasTag( target_id, "sunegg_target" ) == false ) and ( EntityHasTag( target_id, "sunegg_target") == false) then
			EntityAddTag( target_id, "sunegg_target" )
			
			EntityAddComponent( target_id, "VariableStorageComponent", 
			{ 
				name = "sunegg_target",
			} )
			
			EntityAddComponent( target_id, "LuaComponent", 
			{ 
				script_death = "data/scripts/buildings/sun/spot_3_death.lua",
				execute_every_n_frame = "-1",
			} )
		end
	end
end

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "sunegg_kills" )
if ( comp ~= nil ) then
	local kills = ComponentGetValue2( comp, "value_int" )
	
	if ( kills >= 100 ) then
		EntityLoad("data/entities/items/pickup/sun/sunbaby.xml", x, y)
		EntityLoad("data/entities/projectiles/deck/explosion_giga.xml", x, y)
		EntityKill(entity_id)
		
		GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
		GameTriggerMusicEvent( "music/oneshot/dark_01", true, x, y )
		
		GamePrintImportant( "$log_new_step", "$logdesc_new_step" )
	end
end