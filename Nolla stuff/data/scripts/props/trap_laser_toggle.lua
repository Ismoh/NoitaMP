dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local s = 0

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "status" ) then
			s = ComponentGetValue2( v, "value_int" )
			
			s = 1 - s
			
			ComponentSetValue2( v, "value_int", s )
			break
		end
	end
end

local onoff = false
if ( s == 1 ) then
	onoff = true
end

EntitySetComponentsWithTagEnabled( entity_id, "laser_toggle", onoff )

local c = EntityGetAllChildren( entity_id )
if ( c ~= nil ) then
	for i,v in ipairs( c ) do
		local l = EntityGetComponent( v, "LaserEmitterComponent" )
		
		if ( l ~= nil ) then
			for a,b in ipairs( l ) do
				ComponentSetValue2( b, "is_emitting", onoff )
			end
		end
	end
end

local luac = EntityGetFirstComponent( entity_id, "LuaComponent" )
if ( luac ~= nil ) then
	ComponentSetValue2( luac, "execute_every_n_frame", 150 )
end