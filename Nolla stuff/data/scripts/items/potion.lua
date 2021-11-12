 dofile_once("data/scripts/lib/utilities.lua")

-- NOTE( Petri ): 
-- There is a mods/nightmare potion.lua which overwrites this one.

materials_standard = 
{
	{
		material="lava",
		cost=300,
	},
	{
		material="water",
		cost=200,
	},
	{
		material="blood",
		cost=200,
	},
	{
		material="alcohol",
		cost=200,
	},
	{
		material="oil",
		cost=200,
	},
	{
		material="slime",
		cost=200,
	},
	{
		material="acid",
		cost=400,
	},
	{
		material="radioactive_liquid",
		cost=300,
	},
	{
		material="gunpowder_unstable",
		cost=400,
	},
	{
		material="liquid_fire",
		cost=400,
	},
	{
		material="blood_cold",
		cost=300,
	}
}

materials_magic = 
{
	{
		material="magic_liquid_unstable_teleportation",
		cost=500,
	},
	{
		material="magic_liquid_polymorph",
		cost=500,
	},
	{
		material="magic_liquid_random_polymorph",
		cost=500,
	},
	{
		material="magic_liquid_berserk",
		cost=500,
	},
	{
		material="magic_liquid_charm",
		cost=800,
	},
	{
		material="magic_liquid_invisibility",
		cost=800,
	},
	{
		material="material_confusion",
		cost=800,
	},
	{
		material="magic_liquid_movement_faster",
		cost=800,
	},
	{
		material="magic_liquid_faster_levitation",
		cost=800,
	},
	{
		material="magic_liquid_worm_attractor",
		cost=800,
	},
	{
		material="magic_liquid_protection_all",
		cost=800,
	},
	{
		material="magic_liquid_mana_regeneration",
		cost=500,
	},
}

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed
	local potion_material = "water"

	if( Random( 0, 100 ) <= 75 ) then
		-- 0.05% chance of magic_liquid_
		if( Random( 0, 100000 ) <= 50 ) then
			potion_material = "magic_liquid_hp_regeneration"
		elseif( Random( 200, 100000 ) <= 250 ) then
			potion_material = "purifying_powder"
		else
			potion_material = random_from_array( materials_magic )
			potion_material = potion_material.material
		end
	else
		potion_material = random_from_array( materials_standard )
		potion_material = potion_material.material
	end

	-- load the material from VariableStorageComponent
	
	local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()

	
	if ((( month == 5 ) and ( day == 1 )) or (( month == 4 ) and ( day == 30 ))) and (Random( 0, 100 ) <= 20) then
		potion_material = "sima"
	end

	if( jussi and Random( 0, 100 ) <= 9 ) then
		potion_material = "juhannussima"
	end

	if ( month == 2 and day == 14 and Random( 0, 100 ) <= 8) then
		potion_material = "magic_liquid_charm"
	end

	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
	if ( total_capacity > 1000 ) then
		local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
			
		if ( comp ~= nil ) then
			ComponentSetValue( comp, "barrel_size", total_capacity )
		end
		
		EntityAddTag( entity_id, "extra_potion_capacity" )
	end
	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "potion_material") then
				potion_material = ComponentGetValue( comp_id, "value_string" )
			end
		end
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
end