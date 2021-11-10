dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local how_many = 3
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = math.rad(6)-GameGetFrameNum() / 10.0
local length = 40

SetRandomSeed( GameGetFrameNum(), pos_x )
local rotation = ( ( Random( 0, 1 ) * 2 ) - 1 ) * 3

if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
	for i=1,how_many do
		local new_x = pos_x + math.cos( theta ) * length
		local new_y = pos_y + math.sin( theta ) * length
		
		local part_id = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/all_spells_part.xml", new_x, new_y, 0, 0 )
		
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "angle",
				value_float = theta,
			})
			
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "rot",
				value_int = rotation,
			})
			
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "owner",
				value_int = entity_id,
			})
		
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "length",
				value_float = 8.0,
			})
			
		theta = theta + angle_inc
	end
end
