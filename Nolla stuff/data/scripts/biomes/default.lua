-- default biome functions that get called if we can't find a a specific biome that works for us

function spawn_small_enemies(x, y, w, h)
	SetRandomSeed( x, y )
	x = x + Random(0,5)
	y = y + Random(0,5)
	EntityLoad( "data/entities/animals/sheep.xml", x, y )
end

function spawn_big_enemies(x, y, w, h)
	SetRandomSeed( x, y )
	x = x + Random(0,5)
	y = y + Random(0,5)
	EntityLoad( "data/entities/animals/worm_big.xml", x, y )
end

function spawn_items(x, y, w, h)
end


function spawn_lamp(x, y, w, h)
end

function spawn_barrels(x, y, w, h)
end