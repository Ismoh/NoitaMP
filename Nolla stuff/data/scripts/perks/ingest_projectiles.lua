dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, responsible_entity, critical_chance )
	local ingest_chance = 0.33
	local ingestion_damage_scale = 250
	local max_ingestion = 150

	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	print("ingest proj")

	--[[if desc ~= "$damage_projectile" or ProceduralRandomf(GameGetFrameNum(), pos_y) > ingest_chance then
		return
	end]]--

	local ingestion = math.min(damage * ingestion_damage_scale, max_ingestion)
	EntityIngestMaterial( entity_id, CellFactory_GetType("water"), ingestion)

	return damage*0.0, critical_chance*0.5

	-- TODO: play audio

	--print("Ingested " .. damage .. " hp as " .. ingestion .. " ingestion.")
end
