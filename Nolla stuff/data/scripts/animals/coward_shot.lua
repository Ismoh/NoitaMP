dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 200

local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )

local owner_id = 0
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( pcomp ~= nil ) then
	owner_id = ComponentGetValue2( pcomp, "mWhoShot" )
end

if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) and ( #targets > 0 ) then
	local target = 0
	
	SetRandomSeed( x - entity_id, y * GameGetFrameNum() )
	local j = Random( 1, #targets )
	local limit = 0
	local found = false
	
	while ( limit < #targets ) and ( found == false ) do
		limit = limit + 1
		local v = targets[j]
		
		local comp = EntityGetFirstComponent( v, "GenomeDataComponent" )
		
		if ( v ~= entity_id ) and ( v ~= owner_id ) and ( comp ~= nil ) and ( EntityGetHerdRelation( v, owner_id ) >= 40 ) then
			target = v
			found = true
			break
		end
		
		j = ( j % #targets ) + 1
	end

	if ( target ~= NULL_ENTITY ) then
		local tx, ty = EntityGetTransform( target )
		local eid = EntityLoad( "data/entities/particles/tinyspark_green_trail.xml", tx, ty )
		EntityAddTag( eid, "coward_effect" )
		EntityAddChild( target, eid )
		
		local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
		
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "target" ) then
					ComponentSetValue2( v, "value_int", target )
					break
				end
			end
		end
	end
end