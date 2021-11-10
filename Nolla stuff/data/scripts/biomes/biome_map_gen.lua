-- constants (color format is ARGB)
dofile_once("data/scripts/lib/utilities.lua")

local snowcave			= 0xff1775d5
local excavation_site	= 0xff124445
local coalmine			= 0xffd57917
local hills				= 0xff36d517

local shop_room = 0xff3d5ab2
local temple_altar_secret = 0xff93cb5c

local locations =
{
	{
		{23,21},
		{32,19},
	},
	{
		{38,25},
		{32,23},
	},
	{
		{40,28},
		{32,26},
	},
	{
		{22,32},
		{32,30},
	},
	{
		{38,36},
		{32,34},
	},
}

---
local w = 64
local h = 48

BiomeMapSetSize( w, h )
BiomeMapLoadImage( 0, 0, "data/biome_impl/biome_map_metagame.png" )

SetRandomSeed( 0, 0 )
local secretlevel = Random( 1,5 )
--print("Random seed is " .. tostring(secretlevel))

local loc = locations[secretlevel]
local loc1 = loc[1]
local loc2 = loc[2]

BiomeMapSetPixel( loc1[1], loc1[2], shop_room )
BiomeMapSetPixel( loc2[1], loc2[2], temple_altar_secret )

--[[
for y=0,h-1 do
	for x=0,w-1 do

		if y > 19 then
			BiomeMapSetPixel( x, y, snowcave )
		elseif y > 16 then
			BiomeMapSetPixel( x, y, excavation_site )
		elseif y > 14 then
			BiomeMapSetPixel( x, y, coalmine )
		else
			BiomeMapSetPixel( x, y, hills )
		end

	end
end
]]--