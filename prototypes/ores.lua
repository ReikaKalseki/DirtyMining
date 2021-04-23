require "config"

local multiplyConstant = 1--20

local ores = {}

data:extend({
	{
		type = "recipe-category",
		name = "ore-cleaning"
	},
	{
		type = "simple-entity",
		name = "dirty-ore-overlay",
        flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
        icon = "__DirtyMining__/graphics/icons/dirty_overlay.png",
		icon_size = 32,
        subgroup = "raw-material",
        order = "z",
        collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selectable_in_game = false,
		destructible = false,
		collision_mask = {},
        render_layer = "decorative",
        pictures =
        {
          {
            filename = "__DirtyMining__/graphics/entity/dirty_overlay-3.png",
            width = 64,
            height = 64,
			scale = 1.25/2
          }
        }
	},
	  {
		type = "item",
		name = "pebbles",
		icon = "__DirtyMining__/graphics/icons/pebbles.png",
		icon_size = 32,
		flags = {},
		subgroup = "raw-resource",
		order = "d[pebbles]",
		stack_size = 500
	  },
	  {
		type = "item",
		name = "twig",
		icon = "__DirtyMining__/graphics/icons/twig.png",
		icon_size = 32,
		flags = {},
		subgroup = "raw-resource",
		order = "d[twig]",
		stack_size = 500,
		fuel_value = "100kJ",
		fuel_category = "chemical",
	  },
	  {
		type = "recipe",
		name = "pebbles-to-stone",
		enabled = true,
		ingredients = {{"pebbles", 20}},
		result = "stone",
		result_count = 1,
		allow_decomposition = false,
	  },
	  {
		type = "recipe",
		name = "twig-to-wood",
		enabled = true,
		ingredients = {{"twig", 20}},
		result = "wood",
		result_count = 1,
		allow_decomposition = false,
	  },
})

for name,assembler in pairs(data.raw["assembling-machine"]) do
	if name ~= "assembling-machine-1" and string.find(name, "assembling-machine", 1, true) then
		table.insert(assembler.crafting_categories, "ore-cleaning")
	end
end

local function getOreBaseIconSize(base)
	if base.icon_size and base.icon_size > 0 then
		return base.icon_size
	end
	if base.icons then
		for _,ico in pairs(base.icons) do
			if ico and ico.icon_size and ico.icon_size > 0 then
				return ico.icon_size
			end
		end
	end
	return 32
end

local function getOreBaseIcon(base)
	if base.icon and string.len(base.icon) > 0 then
		return base.icon
	end
	if base.icons then
		for _,ico in pairs(base.icons) do
			if ico and ico.icon and string.len(ico.icon) > 0 then
				return ico.icon
			end
		end
	end
	return "__DirtyMining__/graphics/icons/mod-no-tex.png"
end

local function createDirtyOre(base)
	log("Creating dirty ore for " .. base.name)
	
	local dirtyname = "dirty-ore-" .. base.name
	
	local ore = table.deepcopy(base)
	ore.name = dirtyname
	ore.icon = nil
	ore.icon_mipmaps = 0
	ore.icons = {{icon=getOreBaseIcon(base), icon_size = getOreBaseIconSize(base)}, {icon_size = 32, icon="__DirtyMining__/graphics/icons/dirty_overlay.png"}}
	ore.localised_name = {"dirty-ore.suffix", {"entity-name." .. base.name}}
	--ore.localised_name = {"entity-name." .. base.name} --same visual name
	ore.minable.mining_time = ore.minable.mining_time/Config.dirtyOreFactor
	ore.autoplace = nil
	
	return ore
end

local function createDirtyOreItem(name)
	if name == nil then
		error(serpent.block("Could not create dirty ore item for null name!"))
	end
	local dirtyname = "dirty-ore-" .. name
	local base = data.raw.item[name]
	if not base then
		base = data.raw.tool[name]
	end
	if base == nil then
		error(serpent.block("Could not create dirty ore item " .. dirtyname .. ", parent " .. name .. " does not exist."))
	end
	
	log("Creating dirty ore item for " .. name)
	
	local item = table.deepcopy(base)
	item.name = dirtyname
	item.icon_mipmaps = 0
	item.icons = {{icon=getOreBaseIcon(base), icon_size = getOreBaseIconSize(base)}, {icon_size = 32, icon="__DirtyMining__/graphics/icons/dirty_overlay.png"}}
	item.subgroup = "raw-material"
	item.localised_name = {"dirty-ore.prefix", {"item-name." .. name}}
	item.fuel_value = nil
	item.fuel_category = nil
	item.fuel_acceleration_multiplier = nil
	item.fuel_top_speed_multiplier = nil
	item.fuel_emissions_multiplier = nil
	item.fuel_glow_color = nil
	if item.pictures then
		for i,pic in ipairs(item.pictures) do
			local orig = table.deepcopy(pic)
			item.pictures[i] = {layers = {orig, {size = 32, filename = "__DirtyMining__/graphics/icons/dirty_overlay.png", scale = 0.5}}}
		end
	end
	
	local f = 1+multiplyConstant/5
	local out = {{name=name, amount=1*multiplyConstant}, {name="pebbles", amount=1, probability = math.min(1, 0.2*Config.trashYield*f)}, {name="stone", amount=1, probability = math.min(1, 0.005*Config.trashYield*f)}, {name="twig", amount=1, probability = math.min(1, 0.02*Config.trashYield*f)}}
	if data.raw.item.sand then
		table.insert(out, {name = "sand", amount = 1, probability = math.min(1, 0.05*Config.trashYield*f)})
	end
	
	local rec = "ore-cleaning-" .. name
	local time = 2.5*multiplyConstant
	
	data:extend(
	{
	  item,

	  {
		type = "recipe",
		name = rec,
		enabled = "false",
		energy_required = time,
		icon = getOreBaseIcon(base),
		icon_size = getOreBaseIconSize(base),
		subgroup = "raw-material",
		category = "ore-cleaning",
		localised_name = {"dirty-ore.recipe-name", {"item-name." .. base.name}},
		ingredients =
		{
		  {dirtyname, 1*multiplyConstant},
		  {type="fluid", name = "water", amount = multiplyConstant*Config.waterPerSecond/Config.washerSpeed*time},
		},
		results = out,
		allow_decomposition = false,
	  }
	})
	
	table.insert(data.raw.technology["dirty-mining"].effects, {type = "unlock-recipe", recipe = rec})
	
	return item
end

for name,ore in pairs(data.raw.resource) do
	if name ~= "stone" then
		log("Checking ore " .. name .. "; category = " .. (ore.category and ore.category or "nil"))
		if ore.category == nil or ore.category == "basic-solid" then
			local new = createDirtyOre(ore)
			if new.minable.results then
				for i,drop in ipairs(new.minable.results) do
					new.minable.results[i] = {name=createDirtyOreItem(drop.name).name, amount = drop.amount, amount_min = drop.amount_min, amount_max = drop.amount_max, probability = drop.probability}
				end
				table.insert(ores, new) --only insert if has a minable of some form
				log("Adding ore " .. ore.name .. " > " .. new.name)
			elseif new.minable.result then
				new.minable.result = createDirtyOreItem(ore.minable.result).name
				table.insert(ores, new)
				log("Adding ore " .. ore.name .. " > " .. new.name)
			end
		end
	end
end

for _,ore in pairs(ores) do
	data:extend(
	{
	  ore
	})
end