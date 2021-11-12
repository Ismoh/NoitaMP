
x, y = EntityGetTransform( GetUpdatedEntityID() )
SetRandomSeed( x, y )

for i=1,9 do
	local e = EntityLoad( "data/entities/projectiles/clusterbomb_fragment.xml", x, y )	
	local projectile = EntityGetFirstComponent( e, "ProjectileComponent" )
	if( projectile ~= nil ) then 
		local vel = Random(-150,150)
		ComponentSetValue( projectile, "velocity_x", vel )
		vel = Random(-350,25)
		ComponentSetValue( projectile, "velocity_y", vel )
	end
end

-- EntityLoad( "data/entities/animals/sheep.xml", x, y - 100)
--EntityLoad( "data/entities/animals/sheep.xml", x, y )