dofile( "data/scripts/lib/coroutines.lua" )
dofile( "data/scripts/lib/utilities.lua" )


async(function()

	local px = 4024
	local py = 1024

	-- move camera to force pixel scene loading
	GameSetCameraFree( true )
	GameSetCameraPos( px-512, py )
	wait(5)
	GameSetCameraPos( px, py+512 )
	wait(5)

	DebugEnableTrailerMode()

	-- set up the scene
	GameSetCameraPos( px, py )
	LoadPixelScene( "data/biome_impl/demonic_altar.png", "data/biome_impl/demonic_altar_visual.png", px-256-128, py-200, "data/biome_impl/demonic_altar_background.png", true )
	EntityLoad("data/entities/items/trailer_wand.xml", px-32, py)
	
	wait(5)
	
	--EntityLoad( "data/entities/trailer/altar_torch_midas.xml", px, py )
	EntityLoad( "data/entities/trailer/altar_torch_midas.xml", (px-(256)+96)-7, (py+(200)-96)-36 )
	EntityLoad( "data/entities/trailer/altar_torch_midas.xml", (px+(256)-96)-7, (py+(200)-96)-36 )
	EntityLoad( "data/entities/trailer/altar_torch_midas.xml", (px-(256)+72)-7, (py+(200)-80)-36 )
	EntityLoad( "data/entities/trailer/altar_torch_midas.xml", (px+(256)-72)-7, (py+(200)-80)-36 )
	
	--EntityLoad( "data/entities/props/physics_skull_01.xml", (px-256)+200, (py+200)-160)
	--EntityLoad( "data/entities/props/physics_skull_02.xml", px+12, (py+200)-160)
	
	wait(360)
	
	EntityLoad("data/entities/trailer/midas.xml", px, py)

	wait(50)
	EntityLoad("data/entities/trailer/gold_effect.xml", px, py)
	wait(50)
	LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_01.png" )
	wait(20)
	LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_02.png" )
	EntityLoad("data/entities/trailer/midas_chunks.xml", px, py)
	EntityLoad("data/entities/trailer/midas_sand.xml", px, py)
	wait(20)
	LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_03.png" )
	wait(20)
	LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_04.png" )
	wait(20)
	--LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_05.png" )
	wait(20)
	--LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_06.png" )
	wait(20)
	--LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_07.png" )
	wait(20)
	--LooseChunk( px-256, py-200, "data/entities/trailer/altar_chunk_08.png" )

end)
