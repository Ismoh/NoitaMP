dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
local vcomp = 0
local current = 1

local c = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( c ~= nil ) then
	for i,v in ipairs( c ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "shooter_part" ) then
			vcomp = v
			current = ComponentGetValue2( v, "value_int" )
			break
		end
	end
end

if ( current > 0 ) and ( vcomp ~= 0 ) then
	if ( current <= 11 ) then
		local ch = EntityGetAllChildren( entity_id )
		local i_ = 0
		
		if ( ch ~= nil ) then
			for i,v in ipairs( ch ) do
				local comp = EntityGetFirstComponent( v, "GenomeDataComponent" )
				if ( comp ~= nil ) then
					i_ = i_ + 1
					
					if ( i_ == current ) then
						local px,py = EntityGetTransform( v )
						shoot_projectile( entity_id, "data/entities/animals/maggot_tiny/orb.xml", px, py, 0, 0 )
						break
					end
				end
			end
		end
	end
	
	current = current + 1
	if ( current > 33 ) then
		current = 1
	end
	
	ComponentSetValue2( vcomp, "value_int", current )
end