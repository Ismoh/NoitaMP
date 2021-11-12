dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 220

local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
local found = false

for i,v in ipairs( targets ) do
	local comp = EntityGetFirstComponent( v, "GenomeDataComponent" )
	
	if ( v ~= entity_id ) and ( comp ~= nil ) and ( EntityGetHerdRelation( entity_id, v ) >= 40 ) then
		found = true
		break
	end
end

local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

if ( comp ~= nil ) then
	if found then
		ComponentSetValue2( comp, "attack_ranged_enabled", true )
	else
		ComponentSetValue2( comp, "attack_ranged_enabled", false )
	end
end