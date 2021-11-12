dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x,y,angle = EntityGetTransform( entity_id )

angle = GameGetFrameNum() * 0.01

EntitySetTransform( entity_id, x, y, angle )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "laser_status" )
if ( comp ~= nil ) then
	local status = ComponentGetValue2( comp, "value_float" )
	
	local comps = EntityGetComponent( entity_id, "LaserEmitterComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			if ( status <= 0 ) then
				ComponentSetValue2( v, "is_emitting", false )
			else
				ComponentSetValue2( v, "is_emitting", true )
			end
			
			ComponentObjectSetValue2( v, "laser", "damage_to_entities", 0.08 + status * 0.01 )
			ComponentObjectSetValue2( v, "laser", "max_length", 8 + status * 8 )
			ComponentObjectSetValue2( v, "laser", "beam_radius", 3 + status * 0.1 )
		end
	end
	
	status = math.max( 0, status - 0.02 )
	
	ComponentSetValue2( comp, "value_float", status )
end