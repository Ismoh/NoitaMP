dofile_once( "data/scripts/lib/utilities.lua" )

function collision_trigger(colliding_id)
	local checkpoint_count = 2

	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	-- finish line crossed. see if lap is completed or not
	if EntityHasTag(colliding_id, "finish_line") then
		-- check completed checkpoints
		local completed = 0
		for i=1,checkpoint_count do
			local name = "checkpoint_" .. i
			component_readwrite(get_variable_storage_component(entity_id, name), { name = "", value_bool = false }, function(comp)
				if comp.value_bool then
					completed = completed + 1
					comp.value_bool = false
				end
			end)
		end
		
		-- start new lap		
		component_readwrite(get_variable_storage_component(entity_id, "lap_start_time"), { value_int = 0 }, function(comp)
			local t = GameGetFrameNum()
			local lap_time = 0
			
			if completed >= checkpoint_count then
				-- finish line crossed and lap complete
				lap_time = t - comp.value_int

				-- update previous lap time display
				-- TODO: fx on watch
				local stopwatch_id = EntityGetClosestWithTag(pos_x, pos_y, "stopwatch_prev_lap")
				if stopwatch_id ~= nil then
					ComponentSetValue2(get_variable_storage_component(stopwatch_id, "time"), "value_int", lap_time)
				end
				
				-- did we beat best time
				local comp_best_time = get_variable_storage_component(entity_id, "best_time")
				local best_time = ComponentGetValue2(comp_best_time, "value_int")
				if lap_time < best_time then
					-- my best time: 9.2
					best_time = lap_time
					ComponentSetValue2(comp_best_time, "value_int", best_time)

					-- update best time display
					-- TODO: fx on watch
					stopwatch_id = EntityGetClosestWithTag(pos_x, pos_y, "stopwatch_best_lap")
					if stopwatch_id ~= nil then
						ComponentSetValue2(get_variable_storage_component(stopwatch_id, "time"), "value_int", best_time)
					end
				end

				--print("lap complete: " .. lap_time / 60 .. ". Best time: " .. best_time / 60)
			else
				-- finish line crossed but lap wasn't complete: start a new lap
				-- NOTE: this will always happen in the frame after a lap has been completed
				comp.value_int = t
			end
		end)

		return
	end

	-- checkpoint!
	for i=1,checkpoint_count do
		local name = "checkpoint_" .. i
		if EntityHasTag(colliding_id, name) then
			local storage_comp = get_variable_storage_component(entity_id, name)
			if storage_comp then
				ComponentSetValue2(storage_comp, "value_bool", true)
				return
			end
		end
	end
end


