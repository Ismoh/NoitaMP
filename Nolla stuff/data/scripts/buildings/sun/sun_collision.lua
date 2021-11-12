dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 180, "seed_f" )

if ( #targets > 0 ) then
	for i,v in ipairs( targets ) do
		EntityKill( v )
	end
	
	EntityLoad( "data/entities/particles/supernova.xml", x, y )
	GameScreenshake( 100, x, y )
	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/sun/supernova", x, y )
	
	local players = EntityGetWithTag( "player_unit" )
	local mortals = EntityGetWithTag( "mortal" )
	
	for i,v in ipairs( players ) do
		local eid = EntityLoad( "data/entities/misc/eradicate.xml", x, y )
		EntityAddChild( v, eid )
		
		local px,py = EntityGetTransform( v )
		EntityLoad( "data/entities/particles/supernova.xml", px, py )
	end
	
	for i,v in ipairs( mortals ) do
		local test = EntityGetFirstComponent( v, "DamageModelComponent" )
		
		if ( test ~= nil ) then
			EntityInflictDamage( v, 500, "DAMAGE_CURSE", "$damage_supernova", "DISINTEGRATED", 0, 0, entity_id )
		end
	end
	
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "snowrock_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "snow_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "steel_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "lavarock_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_static_rainforest" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "cloud" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_grey" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_noedge_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static" ), CellFactory_GetType( "fire" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static_vertical" ), CellFactory_GetType( "fire" ) )
	
	AddFlagPersistent( "secret_supernova" )
	
	EntityKill( entity_id )
end