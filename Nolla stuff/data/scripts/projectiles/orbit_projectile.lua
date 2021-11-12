dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local root_id    = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), x + y + entity_id )

local projtype = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "orbit_projectile_type" )
local projspeed = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "orbit_projectile_speed" )

if ( projtype ~= nil ) and ( projspeed ~= nil ) then
	local projfile = ComponentGetValue2( projtype, "value_string" )
	local proj = "data/entities/misc/" .. projfile .. ".xml"
	
	if ( projfile == "orbit_larpa" ) then
		proj = ""
		
		local comps = EntityGetComponent( root_id, "VariableStorageComponent" )
		if ( comps ~= nil ) then
			for i,comp in ipairs( comps ) do
				local name = ComponentGetValue2( comp, "name" )
				if ( name == "projectile_file" ) then
					proj = ComponentGetValue2( comp, "value_string" )
					break
				end
			end
		end
	end
	
	if ( proj ~= nil ) and ( #proj > 0 ) then
		local speed = Random( -1, 1 ) * 0.1
		while ( speed == 0 ) do
			speed = Random( -1, 1 ) * 0.1
		end
		
		ComponentSetValue2( projspeed, "value_float", speed )
		
		for i=1,4 do
			local eid = shoot_projectile_from_projectile( entity_id, proj, x, y, 0, 0 )
			EntityAddChild( entity_id, eid )
			
			if ( projfile == "orbit_larpa" ) then
				EntityAddTag( eid, "orbit_projectile" )
				EntityAddTag( eid, "projectile_cloned" )
				
				local comp = EntityGetFirstComponent( eid, "ProjectileComponent" )
				if ( comp ~= nil ) then
					ComponentSetValue2( comp, "lifetime", 7200 )
					ComponentSetValue2( comp, "die_on_low_velocity", false )
				end
				
				comp = EntityGetFirstComponent( eid, "LifetimeComponent" )
				if ( comp ~= nil ) then
					ComponentSetValue2( comp, "lifetime", 7200 )
				end
			end
		end
	end
end