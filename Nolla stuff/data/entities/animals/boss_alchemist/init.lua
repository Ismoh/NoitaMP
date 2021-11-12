dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local styles =
{
	{
		name = "darkness",
		proj = "data/entities/projectiles/enlightened_laser_dark_wand.xml",
	},
	{
		name = "electricity",
		proj = "data/entities/projectiles/enlightened_laser_elec_wand.xml",
	},
	{
		name = "light",
		proj = "data/entities/projectiles/enlightened_laser_light_wand.xml",
	},
	{
		name = "fire",
		proj = "data/entities/projectiles/enlightened_laser_fire_wand.xml",
	},
}

SetRandomSeed( x * entity_id, y * entity_id )

local rnd = Random( 1, #styles )
local style = styles[rnd]

local s = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( s ~= nil ) then
	for i,v in ipairs( s ) do
		local name = ComponentGetValue2( v, "name" )
		
		if ( name == "type" ) then
			ComponentSetValue2( v, "value_string", style.proj )
		end
	end
end