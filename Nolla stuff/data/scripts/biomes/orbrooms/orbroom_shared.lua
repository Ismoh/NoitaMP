dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

function spawn_material_checker( x, y, material1_str, lua_filename, image_emitter, image_emitter_x, image_emitter_y )
	local entity = EntityLoad( "data/entities/buildings/orb_room_materialchecker.xml", x, y )

	local material1 = CellFactory_GetType( material1_str )
	local material2 = -1

	local comp_mat = EntityGetFirstComponent( entity, "MaterialAreaCheckerComponent" )
	if comp_mat ~= nil then
		ComponentSetValue( comp_mat, "material", tostring(material1) )
		ComponentSetValue( comp_mat, "material2", tostring(material2) )
	end

	local comp_lua = EntityGetFirstComponent( entity, "LuaComponent" )
	if comp_lua ~= nil then
		ComponentSetValue( comp_lua, "script_material_area_checker_success", lua_filename )
	end

	EntityAddComponent( entity, "VariableStorageComponent", 
	{ 
		name = "emitter_x",
		value_int = image_emitter_x,
	} )

	EntityAddComponent( entity, "VariableStorageComponent", 
	{ 
		name = "emitter_y",
		value_int = image_emitter_y,
	} )

	EntityAddComponent( entity, "VariableStorageComponent", 
	{ 
		name = "emitter",
		value_string = image_emitter,
	} )
end

------------------------------------------------------------------------

function material_area_checker_success( x, y )
	-- orbroom.xml
	print("successs!")
	local entity_id    = GetUpdatedEntityID()
	local image_x = x
	local image_y = y
	local image_emitter = "NULL"


	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			print("VariableStorageComponent")
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "emitter_x") then
				image_x = tonumber( ComponentGetValue( comp_id, "value_int" ) )
			end
			if( var_name == "emitter_y") then
				image_y = tonumber( ComponentGetValue( comp_id, "value_int" ) )
			end
			if( var_name == "emitter") then
				image_emitter = ComponentGetValue( comp_id, "value_string" ) 
			end
		end
	end

	EntityLoad( image_emitter, image_x, image_y )
end