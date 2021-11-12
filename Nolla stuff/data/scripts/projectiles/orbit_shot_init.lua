dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent", "orbit_shot" )

if ( EntityHasTag( entity_id, "orbit_shot" ) == false ) then
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{
		name = "origin_x",
		value_float = x,
	} )
	
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{
		name = "origin_y",
		value_float = y,
	} )
	
	SetRandomSeed( x - 353, y * GameGetFrameNum() )
	local orbit_speed = Random( 30, 70 ) * ( Random( 0, 1 ) * 2 - 1 )
	
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{
		name = "orbit_speed",
		value_int = orbit_speed,
	} )
	
	local vel_x,vel_y = 10,10
	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	end)
	local spd = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
	
	--print( tostring( spd ) )
	
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{
		name = "rot_speed",
		value_float = spd,
	} )
	
	EntityAddTag( entity_id, "orbit_shot" )
end