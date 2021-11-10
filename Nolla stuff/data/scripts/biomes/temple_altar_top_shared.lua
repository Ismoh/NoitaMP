function spawn_altar_top(x, y, is_solid)
	SetRandomSeed( x, y )
	local randomtop = Random( 1, 50 )
	local file_visual = "data/biome_impl/temple/altar_top_visual.png"
	
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x-1, y - 30, 35 )

	if( y > 12000 ) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_boss_arena.png", file_visual, x, y-40, "", true )
	else
		if (randomtop == 5) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", file_visual, x, y-40, "", true )
		elseif (randomtop == 8) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", file_visual, x, y-40, "", true )
		elseif (randomtop == 11) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", file_visual, x, y-40, "", true )
		elseif (randomtop == 13) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", file_visual, x, y-40, "", true )
		elseif (randomtop == 15) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", file_visual, x, y-40, "", true )
		else
			LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
		end
	end	

	if is_solid then LoadPixelScene( "data/biome_impl/temple/solid.png", "", x, y-40+300, "", true ) end
end
