dofile( "data/scripts/lib/coroutines.lua" )
dofile( "data/scripts/lib/utilities.lua" )


async(function()

	local px = -512
	local py = -512

	-- move camera to force pixel scene loading
	GameSetCameraFree( true )
	GameSetCameraPos( -355, -500 )
	wait(5)
	GameSetCameraPos( -275, -100 )
	wait(5)

	DebugEnableTrailerMode()

	-- set up the scene
	GameSetCameraPos( -275, -370 )
	LoadPixelScene( "data/biome_impl/nolla_games.png", "data/biome_impl/nolla_games_visual.png", px-87, py-115, "", true )
	LoadPixelScene( "data/biome_impl/nolla_games_bottom.png", "data/biome_impl/nolla_games_bottom_visual.png", px-87, py+365, "", true )
	LoadPixelScene( "data/biome_impl/nolla_games_left.png", "data/biome_impl/nolla_games_left_visual.png", px-247, py-115, "", true )
	LoadPixelScene( "data/biome_impl/nolla_games_right.png", "data/biome_impl/nolla_games_right_visual.png", px+553, py-115, "", true )
	--EntityLoad("data/entities/props/physics_logo.xml", px+240, py-200)
	--EntityLoad("data/entities/animals/crawler.xml", px+270, py+35)
	--EntityLoad("data/entities/animals/crawler.xml", px+210, py+100)
	--EntityLoad("data/entities/animals/crawler.xml", px+160, py+180)
	wait(100)

	-- come on baby light my fire
	--shoot_projectile( entity_id, "data/entities/projectiles/deck/meteor.xml", px+115, py-200, -90, 300 )

end)
