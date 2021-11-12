dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

local x,y = EntityGetTransform( root_id )
local curseflag = EntityHasTag( root_id, "effect_CURSE" )

if ( curseflag == false ) then
	local eid = EntityLoad( "data/entities/misc/curse_stronger.xml", x, y )
	EntityAddChild( root_id, eid )
	EntityAddTag( root_id, "effect_CURSE" )
else
	local c = EntityGetAllChildren( root_id )
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "effect_CURSE" ) then
				local comp = EntityGetFirstComponent( v, "LifetimeComponent", "effect_curse_lifetime" )
				
				if ( comp ~= nil ) then
					ComponentSetValue2( comp, "creation_frame", GameGetFrameNum() )
					ComponentSetValue2( comp, "kill_frame", GameGetFrameNum() + 300 )
					
					comp = EntityGetFirstComponent( v, "VariableStorageComponent", "effect_curse_damage" )
					
					if ( comp ~= nil ) then
						local damage = ComponentGetValue2( comp, "value_float" )
						damage = damage + 0.08
						ComponentSetValue2( comp, "value_float", damage )
					end
				end
				
				break
			end
		end
	end
end

EntityKill( entity_id )