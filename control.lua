require "config"

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

local function markOres(surface, area, entities, mark)
	for _,entity in pairs(entities) do
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
	end
	
	if not mark then
		for _,entity in pairs(surface.find_entities_filtered({name="dirty-ore-overlay", area = {{area.left_top.x-2, area.left_top.y-2}, {area.right_bottom.x+2, area.right_bottom.y+2}}})) do
			local ores = surface.find_entities_filtered({type = "resource", position=entity.position})
			local flag = false
			for _,ore in pairs(ores) do
				if isDirtyOre(ore) then
					flag = true
				end
			end
			if not flag then
				entity.destroy()
			end
		end
	end
end

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	local player = game.players[event.player_index]
	local surface = player.surface
	markOres(surface, event.area, event.entities, false)
end)

script.on_event(defines.events.on_player_selected_area, function(event)
	local player = game.players[event.player_index]
	local surface = player.surface
	markOres(surface, event.area, event.entities, true)
end)
--]]