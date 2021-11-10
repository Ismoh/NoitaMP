dofile_once("data/scripts/lib/utilities.lua")

local time_buildup_start = 120
local time_spawn = time_buildup_start + 100

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local t = GameGetFrameNum()
local comp = get_variable_storage_component(entity_id, "throw_time")
local throw_time = ComponentGetValue2(comp, "value_int")

if throw_time < 0 then return end -- not thrown yet

if t == throw_time + time_buildup_start then
	-- buildup
	local e = EntityLoad("data/entities/particles/image_emitters/safe_haven_buildup.xml", pos_x, pos_y)
	EntityAddChild(entity_id, e)
	EntitySetComponentsWithTagEnabled(entity_id, "enabled_before_spawn", true)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", pos_x, pos_y )
elseif t == throw_time + time_spawn then
	-- spawn safe haven
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heart_fullhp/create", pos_x, pos_y )
	EntityLoad("data/entities/buildings/safe_haven_building.xml", pos_x, pos_y)
	
	-- spawn healing projectiles
	local storage_comp = get_variable_storage_component(entity_id, "player_hp")
	local hp = ComponentGetValue2(storage_comp, "value_float") * 0.6 -- max 60% healing
	local projectile_count = math.floor(math.min(20, hp * 3)) -- limit shots for performance reasons
	--print("total heal: " .. hp .. ". projectile amount " .. projectile_count)
	hp = hp / projectile_count -- hp per shot
	--print("heal per projectile: " .. hp)
	for i=1,projectile_count do
		local x = pos_x + ProceduralRandom(pos_x, pos_y - i, -10, 10)
		local y = pos_y + ProceduralRandom(pos_x + i, pos_y * 0.63, -8, 8) - 10
		local e = EntityLoad("data/entities/projectiles/healshot_safe_haven.xml", x, y)
		-- scale healing power of shots
		comp = EntityGetFirstComponent(e, "ProjectileComponent")
		ComponentObjectSetValue2(comp, "damage_by_type", "healing", -hp)
	end

	-- props
	EntityLoad("data/entities/props/physics/lantern_small.xml", pos_x - 1, pos_y - 32)
	EntityLoad("data/entities/props/furniture_bed.xml", pos_x - 36, pos_y - 8)
	EntityLoad("data/entities/props/furniture_wood_table.xml", pos_x + 41, pos_y - 8)
	EntityLoad("data/entities/props/physics_box_explosive.xml", pos_x + 46, pos_y - 12)
	
	-- cleanup
	EntityKill(entity_id)
end

