dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	local px, py = EntityGetTransform( projectile_id )
	
	--local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
	
	--[[
	if ( projectilecomponents ~= nil ) then
		for j,comp_id in ipairs(projectilecomponents) do
			ComponentSetValue( comp_id, "on_death_explode", "0" )
			ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
		end
	end
	]]--
	
	EntityLoad("data/entities/particles/neutralized.xml", px, py)
	EntityKill( projectile_id )
end