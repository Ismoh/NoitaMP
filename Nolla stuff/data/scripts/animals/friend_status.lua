dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local c = EntityGetComponent( entity_id, "VariableStorageComponent" )
local count = 0
local tcount = tonumber( GlobalsGetValue( "ULTIMATE_KILLER_KILLS", "0" ) )
local countcomp = 0

if ( c ~= nil ) then
	for i,v in ipairs( c ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "friend_status" ) then
			countcomp = v
			count = ComponentGetValue2( v, "value_int" )
			break
		end
	end
end

if ( count < tcount ) and ( countcomp ~= 0 ) then
	c = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	
	local ac = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )
	if ( ac ~= nil ) then
		ComponentSetValue2( ac, "attack_ranged_entity_file", "data/entities/projectiles/machinegun_bullet_roboguard_big.xml" )
	end
	
	local c = EntityGetComponent( entity_id, "SpriteComponent", "health_bar" )
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			ComponentSetValue2( v, "visible", true )
		end
	end
	
	for i=count,tcount do
		if ( c ~= nil ) then
			local max_hp = ComponentGetValue2( c, "max_hp" )
			max_hp = max_hp * 1.5
			ComponentSetValue2( c, "max_hp", max_hp )
			ComponentSetValue2( c, "hp", max_hp )
			
			local pr = ComponentObjectGetValue2( c, "damage_multipliers", "projectile" )
			pr = pr - 0.1
			ComponentObjectSetValue2( c, "damage_multipliers", "projectile", pr )
			
			pr = ComponentObjectGetValue2( c, "damage_multipliers", "slice" )
			pr = pr - 0.1
			ComponentObjectSetValue2( c, "damage_multipliers", "slice", pr )
		end
		
		if ( ac ~= nil ) then
			local delay = ComponentGetValue2( ac, "attack_ranged_frames_between" )
			delay = math.max( delay - 1, 10 )
			ComponentSetValue2( ac, "attack_ranged_frames_between", delay )
		end
		
		if ( count == 0 ) then
			local game_effect_comp = GetGameEffectLoadTo( entity_id, "PROTECTION_MELEE", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			game_effect_comp = GetGameEffectLoadTo( entity_id, "BREATH_UNDERWATER", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			EntityAddTag( entity_id, "polymorphable_NOT" )
		elseif ( count == 1 ) then
			local game_effect_comp = GetGameEffectLoadTo( entity_id, "PROTECTION_FIRE", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			game_effect_comp = GetGameEffectLoadTo( entity_id, "PROTECTION_EXPLOSION", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			EntityAddTag( entity_id, "touchmagic_immunity" )
		elseif ( count == 2 ) then
			local game_effect_comp = GetGameEffectLoadTo( entity_id, "PROTECTION_FREEZE", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			game_effect_comp = GetGameEffectLoadTo( entity_id, "PROTECTION_ELECTRICITY", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			EntityAddTag( entity_id, "curse_NOT" )
		end
		
		local game_effect_comp = GetGameEffectLoadTo( entity_id, "CRITICAL_HIT_BOOST", true )
		if ( game_effect_comp ~= nil ) then
			ComponentSetValue2( game_effect_comp, "frames", -1 )
		end
	end
	
	ComponentSetValue2( countcomp, "value_int", tcount )
end