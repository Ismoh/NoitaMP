
function getPath(str,sep)
	sep=sep or'/'
	return str:match("(.*"..sep..")")
end

function getFilename(inputstr, sep)
	sep=sep or'/'
	local last_element
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		last_element = str
	end
	return last_element
end

function IMPL_load_entity_hp_mods_with_camera_bound( entity_file, x, y, hp_multiplier, biome )

	if( getPath(entity_file) == "data/entities/animals/" ) then

		-- print( getFilename(entity_file) )
		local entity = EntityLoad( entity_file, x, y)
		local components_damagemodel = EntityGetFirstComponent( entity, "DamageModelComponent" )
		if components_damagemodel ~= nil then
			local m_hp = ComponentGetValue( components_damagemodel, "hp" )
			m_hp = hp_multiplier * m_hp
			ComponentSetValue( components_damagemodel, "max_hp", m_hp )
			ComponentSetValue( components_damagemodel, "hp", m_hp )
		end

		entity_file = getPath( entity_file ) .. biome .. "/" .. getFilename(entity_file)

		print( "saving to", getPath( entity_file ) )
		EntitySave( entity, entity_file  )
		return entity_file
	else
		EntityLoadCameraBound( entity_file, x, y )
		return entity_file
	end

end


function entity_load_camera_bound_hp(entity_data, x, y, rand_x, rand_y, hp_multiplier, biome)
	-- if true then return nil end  -- enable 2 disable spawns
	if rand_x == nil then rand_x = 4 end
	if rand_y == nil then rand_y = 4 end

	-- load groups
	if( entity_data.entities ~= nil ) then
		for j,ev in ipairs(entity_data.entities) do
			if( type( ev ) == 'table' ) then
				local count = 1
				if( ev.min_count ~= nil ) then
					count = ev.min_count
					if( ev.max_count ~= nil ) then
						count = ProceduralRandom( x+j, y, ev.min_count, ev.max_count )
					end
				end

				for i = 1,count do
					local pos_x = x + ProceduralRandom(x+j, y+i, -rand_x, rand_x)
					local pos_y = y + ProceduralRandom(x+j, y+i, -rand_y, rand_y)
					if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
					if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end
					ev.entity = IMPL_load_entity_hp_mods_with_camera_bound( ev.entity, pos_x, pos_y, hp_multiplier, biome )

				end
			else
				if( ev ~= nil ) then
					local pos_x = x + ProceduralRandom(x+j, y, -rand_x, rand_x)
					local pos_y = y + ProceduralRandom(x+j, y, -rand_y, rand_y)
					if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
					if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end

					ev = IMPL_load_entity_hp_mods_with_camera_bound( ev, pos_x, pos_y, hp_multiplier, biome )
				end
			end
		end
	end

	if( entity_data.entity == nil or  entity_data.entity == '' ) then
		return 0
	end

	local how_many = ProceduralRandom(x,y,entity_data.min_count,entity_data.max_count)
	if( how_many <= 0 ) then
		return 0
	end
	
	local pos_x = x
	local pos_y = y

	for i = 1,how_many do
		pos_x = x + ProceduralRandom(x+i,y,-rand_x, rand_x)
		pos_y = y + ProceduralRandom(x+i,y,-rand_y, rand_y)
		if( entity_data.offset_y ~= nil ) then pos_y = pos_y + entity_data.offset_y end
		if( entity_data.offset_x ~= nil ) then pos_x = pos_x + entity_data.offset_x end

		entity_data.entity = IMPL_load_entity_hp_mods_with_camera_bound( entity_data.entity, pos_x, pos_y, hp_multiplier, biome )
	end

	return 1
end



function spawn_hp_mult(what, x, y, rand_x, rand_y, hp_multiplier, biome)
	local x_offset,y_offset = 5,5
	-- if( what == nil ) then print( "ERROR - director_helpers - spawn() ... what = nil") end
	local v = random_from_table( what, x, y )
	if ( v ~= nil ) then
		entity_load_camera_bound_hp( v, x + x_offset, y + y_offset, rand_x, rand_y, hp_multiplier, biome )
	end
end