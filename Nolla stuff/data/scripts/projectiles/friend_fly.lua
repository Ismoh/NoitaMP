dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local target_id = 0
local targetstorage = 0
local radius = 64

local home_id = component_get_value_int( entity_id, "ProjectileComponent", "mWhoShot", 0 )

local vel_x,vel_y = GameGetVelocityCompVelocity( entity_id )
if ( vel_x > 0 ) then
	edit_component( entity_id, "SpriteComponent", function(comp,vars)
		ComponentSetValue2( comp, "special_scale_x", 1 )
	end)
elseif ( vel_x < 0 ) then
	edit_component( entity_id, "SpriteComponent", function(comp,vars)
		ComponentSetValue2( comp, "special_scale_x", -1 )
	end)
end

if ( home_id ~= nil ) and ( home_id ~= NULL_ENTITY ) then
	local px,py = EntityGetTransform( home_id )
	
	if ( px ~= nil ) and ( py ~= nil ) then
		local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
		if ( variablestorages ~= nil ) then
			for j,storage_id in ipairs(variablestorages) do
				local var_name = ComponentGetValue( storage_id, "name" )
				if ( var_name == "target" ) then
					target_id = ComponentGetValue2( storage_id, "value_int" )
					targetstorage = storage_id
				end
			end
			
			local hdist = math.abs( py - y ) + math.abs( px - x )
			
			if ( target_id ~= 0 ) and ( targetstorage ~= 0 ) then
				local tx, ty = EntityGetTransform( target_id )
				local found = true
				
				if ( hdist > radius * 2.5 ) then
					found = false
				else
					if ( tx == nil ) or ( ty == nil ) then
						found = false
					else
						local dist = math.abs( ty - y ) + math.abs( tx - x )
						local hdist2 = math.abs( ty - py ) + math.abs( tx - px )
						
						if ( dist > radius * 2) or ( hdist2 > radius * 3 ) then
							found = false
						end
					end
				end
				
				if ( found == false ) then
					target_id = 0
					ComponentSetValue2( targetstorage, "value_int", target_id )
					
					edit_component( entity_id, "HomingComponent", function(comp,vars)
						ComponentSetValue2( comp, "predefined_target", 0 )
						ComponentSetValue2( comp, "target_who_shot", true )
					end)
				end
			else
				local targets = EntityGetInRadiusWithTag( px, py, radius, "mortal" )
				
				for i,v in ipairs( targets ) do
					local root_id = EntityGetRootEntity( v )
					
					if ( root_id ~= entity_id ) and ( root_id ~= home_id ) then
						target_id = root_id
						
						edit_component( entity_id, "HomingComponent", function(comp,vars)
							ComponentSetValue2( comp, "predefined_target", target_id )
							ComponentSetValue2( comp, "target_who_shot", false )
						end)
						
						ComponentSetValue2( targetstorage, "value_int", target_id )
						
						break
					end
				end
			end
		end
	else
		EntityKill( entity_id )
	end
end