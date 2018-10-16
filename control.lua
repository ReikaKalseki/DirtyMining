require "config"

local function initGlobal(force)
	if force or global.ores == nil then
		global.ores = {}
	end
	if force or global.ores.washers == nil then
		global.ores.washers = {}
	end
	if force or global.ores.filters == nil then
		global.ores.filters = {}
	end
end

script.on_init(function()
	initGlobal(false)
end)

script.on_configuration_changed(function()
	initGlobal(false)
end)

local function isDirtyOre(entity)
	return string.find(entity.name, "dirty-ore-", 1, true)
end

local function convertEntity(entity, new, dirty)
	local surf = entity.surface
	local pos = entity.position
	local amt = dirty and math.floor(entity.amount*Config.dirtyOreFactor) or math.ceil(entity.amount/Config.dirtyOreFactor)
	local force = entity.force
	entity.destroy()
	surf.create_entity({name = new, position = pos, force = force, amount = amt})
	if dirty then
		surf.create_entity({name = "dirty-ore-overlay", position = pos, force = force})
	end
end

local function getCleanOre(ore)
	return string.sub(ore.name, string.len("dirty-ore-")+1)
end

local function getDirtyOre(ore)
	return "dirty-ore-" .. ore.name
end

local function clearDirtyMarkers(surface, area)
	for _,entity in pairs(surface.find_entities_filtered({name="dirty-ore-overlay", area = area})) do
		local ores = surface.find_entities_filtered({type = "resource", position=entity.position})
		local flag = false
		for _,ore in pairs(ores) do
			if isDirtyOre(ore) and ore.amount > 0 then
				flag = true
			end
		end
		if not flag then
			entity.destroy()
		end
	end
end

local function markOres(player, surface, area, entities, mark)
	for _,entity in pairs(entities) do
		if entity.valid then
			if entity.type == "resource" and game.entity_prototypes[entity.name].resource_category == "basic-solid" and entity.name ~= "stone" then
				if isDirtyOre(entity) then
					if not mark then
						convertEntity(entity, getCleanOre(entity), false)
					end
				else
					if mark then
						convertEntity(entity, getDirtyOre(entity), true)
					end
				end
			else
				if (not mark) and entity.name == "dirty-ore-overlay" then
					--entity.destroy()
				end
			end
		else
			player.print("Found an invalid entity!")
		end
	end
	
	if not mark then
		clearDirtyMarkers(surface, {{area.left_top.x-2, area.left_top.y-2}, {area.right_bottom.x+2, area.right_bottom.y+2}})
	end
end

local function onEntityCreated(event)
	local entity = event.created_entity
	if entity.name == "ore-washer" then
		local conn = entity.surface.create_entity{name = "washer-control", position = {entity.position.x-1, entity.position.y+1}, force = entity.force}
		conn.operable = false
		global.ores.washers[entity.unit_number] = {entity = entity, connection = conn}
	elseif entity.name == "dirty-ore-signal-filter" then
		global.ores.filters[entity.unit_number] = {entity = entity, type = "input"}
	end
end

local function onEntityRemoved(event)
	local entity = event.entity
	if entity.name == "ore-washer" then
		local entry = global.ores.washers[entity.unit_number]
		if entry then
			entry.connection.disconnect_neighbour(defines.wire_type.red)
			entry.connection.disconnect_neighbour(defines.wire_type.green)
			entry.connection.destroy()
			global.ores.washers[entity.unit_number] = nil
		end
	elseif entity.name == "dirty-ore-signal-filter" then
		global.ores.filters[entity.unit_number] = nil
	end
end

local function onTick(event)
	if event.tick%240 == 0 then
		for unit,entry in pairs(global.ores.washers) do
			if entry.entity.valid and entry.connection.valid then
				if entry.entity.get_recipe() == nil or (not entry.entity.get_inventory(defines.inventory.assembling_machine_input)[1].valid_for_read) then
					local network = entry.connection.get_circuit_network(defines.wire_type.red)
					if not network then network = entry.connection.get_circuit_network(defines.wire_type.green) end
					if network then
						local signals = network.signals
						if signals and #signals > 0 then
							for _,signal in pairs(signals) do
								if signal.count > 0 and signal.signal.type == "item" then
									local item = signal.signal.name
									if string.find(item, "dirty-ore", 1, true) then
										local base = string.sub(item, string.len("dirty-ore")+2)
										local name = "ore-cleaning-" .. base
										--game.print(name)
										local recipe = entry.entity.force.recipes[name]
										--game.print(recipe ~= nil)
										if recipe then
											local items = entry.entity.set_recipe(recipe)
											assert(not items or #items == 0)
											break
										end
									end
								end
							end
						end
					end
				end
			else
				global.ores.washers[unit] = nil
			end
		end
	end--[[
	if event.tick%30 == 0 then
		for unit,entry in pairs(global.ores.filters) do
			if entry.entity.valid then
				local network = entry.connection.get_circuit_network(defines.wire_type.red)
				if not network then network = entry.connection.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input) end
				if network then
					local signals = network.signals
					if signals and #signals > 0 then
						for _,signal in pairs(signals) do
							if signal.count > 0 and signal.signal.type == "item" then
								local item = signal.signal.name
								if string.find(item, "dirty-ore", 1, true) then
									local base = string.sub(item, string.len("dirty-ore")+2)
									local name = "ore-cleaning-" .. base
									--game.print(name)
									local recipe = entry.entity.force.recipes[name]
									--game.print(recipe ~= nil)
									if recipe then
										local items = entry.entity.set_recipe(recipe)
										assert(not items or #items == 0)
										break
									end
								end
							end
						end
					end
				end
			else
				global.ores.filters[unit] = nil
			end
		end
	end--]]
end

script.on_event(defines.events.on_resource_depleted, function(event)
	local surface = event.entity.surface
	local area = {{event.entity.position.x-5, event.entity.position.y-5}, {event.entity.position.x+5, event.entity.position.y+5}}
	clearDirtyMarkers(surface, area)
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	if event.item == "dirty-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		markOres(player, surface, event.area, event.entities, false)
	end
end)

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "dirty-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		markOres(player, surface, event.area, event.entities, true)
	end
end)

script.on_event(defines.events.on_built_entity, onEntityCreated)
script.on_event(defines.events.on_robot_built_entity, onEntityCreated)

script.on_event(defines.events.on_pre_player_mined_item, onEntityRemoved)
script.on_event(defines.events.on_robot_pre_mined, onEntityRemoved)
script.on_event(defines.events.on_entity_died, onEntityRemoved)

script.on_event(defines.events.on_tick, onTick)