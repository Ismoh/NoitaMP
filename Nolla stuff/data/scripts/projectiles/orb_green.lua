local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local herd_id = 0
comp_ids = EntityGetComponent( entity_id, "ProjectileComponent" )
if( comp_ids ~= nil ) then
	herd_id = ComponentGetValue( comp_ids[1], "mShooterHerdId" )
end

local how_many = 8
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = 0
local length = 100

for i=1,how_many do
	GameEntityPlaySound( entity_id, "duplicate" )
	entity_id = EntityLoad( "data/entities/projectiles/orb_green.xml", pos_x, pos_y)

	comp_ids = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comp_ids ~= nil ) then
		ComponentSetValue( comp_ids[1], "mWhoShot", entity_id)
		ComponentSetValue( comp_ids[1], "mShooterHerdId", herd_id)
	end


	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc

	comp_ids = EntityGetComponent( entity_id, "VelocityComponent" )

	if( comp_ids ~= nil ) then
		ComponentSetValueVector2( comp_ids[1], "mVelocity", vel_x, vel_y)
	end
end