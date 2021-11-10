dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- convert items
local converted = false

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "card_summon_portal_broken")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)
		EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
		CreateItemActionEntity( "SUMMON_PORTAL", x, y)
		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "broken_wand")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)
		EntityLoad("data/entities/items/wand_level_05_better.xml", x, y - 5)
		EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "tablet")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)

		local item_comps = EntityGetComponent( id, "ItemComponent" )
		local new_desc = ""
		local item_name

		if ( item_comps ~= nil ) then
			for i,itemc in ipairs(item_comps) do
				item_name = ComponentGetValue( itemc, "item_name" )

				-- if( item_name == "$booktitle01" ) then new_desc = "$bookdesc01_forged" end
				if( item_name == "$booktitle02" ) then new_desc = "$bookdesc02_forged" end
				-- if( item_name == "$booktitle03" ) then new_desc = "$bookdesc03_forged" end
				if( item_name == "$booktitle04" ) then new_desc = "$bookdesc04_forged" end
				if( item_name == "$booktitle05" ) then new_desc = "$bookdesc05_forged" end
				if( item_name == "$booktitle06" ) then new_desc = "$bookdesc06_forged" end
				if( item_name == "$booktitle07" ) then new_desc = "$bookdesc07_forged" end
				if( item_name == "$booktitle08" ) then new_desc = "$bookdesc08_forged" end
				if( item_name == "$booktitle09" ) then new_desc = "$bookdesc09_forged" end
				if( item_name == "$booktitle10" ) then new_desc = "$bookdesc10_forged" end

			end
		end


		if( new_desc ~= "" ) then
			local forged_book = EntityLoad("data/entities/items/books/base_forged.xml", x, y - 5)
			item_comps = EntityGetComponent( forged_book, "ItemComponent" )
			if ( item_comps ~= nil ) then
				for i,itemc in ipairs(item_comps) do
					ComponentSetValue( itemc, "item_name", item_name )
					ComponentSetValue( itemc, "ui_description", new_desc )
				end
			end

			local uiinfo_comp = EntityGetComponent( forged_book, "UIInfoComponent" )
			if( uiinfo_comp ~= nil ) then
				for i,uiinfoc in ipairs(uiinfo_comp) do
					ComponentSetValue( uiinfoc, "name", item_name )
				end
			end

			local ability_comp = EntityGetComponent( forged_book, "AbilityComponent" )
			if( ability_comp ~= nil ) then
				for i,abic in ipairs(ability_comp) do
					ComponentSetValue( abic, "ui_name", item_name )
				end
			end

			EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
			EntityKill(id)
		end
		converted = true
	end
end

if converted then
	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/dark_01", true, pos_x, pos_y )
end