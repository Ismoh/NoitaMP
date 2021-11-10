dofile( "data/scripts/game_helpers.lua" )

function spawn_boss_dragon()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	-- disables the dragon with globals
	local is_spawned = GlobalsGetValue("boss_dragon_spawned")
	if( is_spawned == "1") then
		return 0
	end
	
	GlobalsSetValue("boss_dragon_spawned", "1")
	GlobalsSetValue("boss_dragon_spawned_pos_x", pos_x)
	GlobalsSetValue("boss_dragon_spawned_pos_y", pos_y)

	play_animation( entity_id, "open")

	-- disables damage scripts
	local lua_scripts = EntityGetComponent( entity_id, "LuaComponent" )
	if( lua_scripts ~= nil ) then
		for i,v in ipairs(lua_scripts) do
			ComponentSetValue( v, "script_damage_received", "")
		end
	end
	
	-- tried using wait, but it just crashed...
	-- wait(30)
	-- EntityLoad( "data/entities/animals/boss_dragon.xml", pos_x, pos_y )

	SetTimeOut( 0.54, "data/scripts/buildings/egg_damage.lua", "impl_spawn_boss_dragon")
end

function impl_spawn_boss_dragon()
	local pos_x = GlobalsGetValue("boss_dragon_spawned_pos_x")
	local pos_y = GlobalsGetValue("boss_dragon_spawned_pos_y")
	EntityLoad( "data/entities/animals/boss_dragon.xml", pos_x, pos_y - 16 )
end

function damage_received( damage, desc, entity_who, is_fatal )
	-- print(damage)
	if( is_fatal or Random(0,100) < 60 ) then
		spawn_boss_dragon()
	end
end
