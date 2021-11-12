dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, name )
	GamePrintImportant( "$log_endcrystal", "$logdesc_endcrystal" )
	
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

	local max_hp = 0
	
	if( damagemodels ~= nil ) then
		for i,v in ipairs(damagemodels) do
			max_hp = tonumber( ComponentGetValue( v, "max_hp" ) )
			-- if( hp > max_hp ) then hp = max_hp end
			ComponentSetValue( v, "hp", max_hp)
		end
	end

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	--EntityLoad( "data/entities/animals/ending_placeholder/boss_limbs/boss_limbs.xml", x, y - 160 )
	EntityLoad( "data/entities/animals/ending_placeholder/boss_dragon_endcrystal.xml", x, y - 256 )
	EntityLoad( "data/entities/particles/particle_explosion/main_pink.xml", x, y )
	GameScreenshake( 40 )
	EntityKill( entity_item )
end