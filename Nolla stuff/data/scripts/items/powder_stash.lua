 dofile_once("data/scripts/lib/utilities.lua")

-- NOTE( Petri ): 
-- There is a mods/nightmare potion.lua which overwrites this one.

materials_standard = 
{
	{
		material="sand",
		cost=300,
	},
	{
		material="soil",
		cost=200,
	},
	{
		material="snow",
		cost=200,
	},
	{
		material="salt",
		cost=200,
	},
	{
		material="coal",
		cost=200,
	},
	{
		material="gunpowder",
		cost=200,
	},
	{
		material="fungisoil",
		cost=200,
	},
}

materials_magic = 
{
	{
		material="copper",
		cost=500,
	},
	{
		material="silver",
		cost=500,
	},
	{
		material="gold",
		cost=500,
	},
	{
		material="brass",
		cost=500,
	},
	{
		material="bone",
		cost=800,
	},
	{
		material="purifying_powder",
		cost=800,
	},
	{
		material="fungi",
		cost=800,
	},
}

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed
	local potion_material = "sand"

	if( Random( 0, 100 ) <= 75 ) then
		-- 0.05% chance of magic_liquid_
		potion_material = random_from_array( materials_magic )
		potion_material = potion_material.material
	else
		potion_material = random_from_array( materials_standard )
		potion_material = potion_material.material
	end

	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
	if ( total_capacity > 1000 ) then
		local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
			
		if ( comp ~= nil ) then
			ComponentSetValue( comp, "barrel_size", total_capacity )
		end
		
		EntityAddTag( entity_id, "extra_potion_capacity" )
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
end