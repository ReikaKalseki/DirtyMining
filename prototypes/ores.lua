require "config"

local multiplyConstant = 20

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
		flags = {"goes-to-main-inventory"},
		subgroup = "raw-resource",
		order = "d[pebbles]",
		stack_size = 500
	  },
	  {
		type = "item",
		name = "twig",
		icon = "__DirtyMining__/graphics/icons/twig.png",
		flags = {"goes-to-main-inventory"},
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
		result_count = 1
	  },
	  {
		type = "recipe",
		name = "twig-to-wood",
		enabled = true,
		ingredients = {{"twig", 10}},
		result = "wood",
		result_count = 1
	  },
})

for name,assembler in pairs(data.raw["assembling-machine"]) do
	if name ~= "assembling-machine-1" and string.find(name, "assembling-machine", 1, true) then
		table.insert(assembler.crafting_categories, "ore-cleaning")
	end
end

local function createDirtyOre(base)
	--log("Creating dirty ore for " .. base.name)
	
	local dirtyname = "dirty-ore-" .. base.name
	
	local ore = table.deepcopy(base)
	ore.name = dirtyname
	ore.icons = {{icon=base.icon}, {icon="__DirtyMining__/graphics/icons/dirty_overlay.png"}}
	ore.localised_name = {"dirty-ore.suffix", {"entity-name." .. base.name}}
	--ore.localised_name = {"entity-name." .. base.name} --same visual name
	ore.minable.mining_time = ore.minable.mining_time/Config.dirtyOreFactor
	
	table.insert(ores, ore)
	
	return ore
end

local function createDirtyOreItem(name)
	if name == nil then
		error(serpent.block("Could not create dirty ore item for null name!"))
	end
	local dirtyname = "dirty-ore-" .. name
	local base = data.raw.item[name]
	if base == nil then
		error(serpent.block("Could not create dirty ore item " .. dirtyname .. ", parent " .. name .. " does not exist."))
	end
	
	--log("Creating dirty ore item for " .. name)
	
	local item = table.deepcopy(base)
	item.name = dirtyname
	item.icons = {{icon=base.icon}, {icon="__DirtyMining__/graphics/icons/dirty_overlay.png"}}
	item.subgroup = "raw-material"
	item.localised_name = {"dirty-ore.prefix", {"item-name." .. name}}
	
	local f = 1+multiplyConstant/5
	local out = {{name=name, amount=1*multiplyConstant}, {name="pebbles", amount=1, probability = math.min(1, 0.2*Config.trashYield*f)}, {name="stone", amount=1, probability = math.min(1, 0.005*Config.trashYield*f)}, {name="twig", amount=1, probability = math.min(1, 0.02*Config.trashYield*f)}}
	if data.raw.item.sand then
		table.insert(out, {name = "sand", amount = 1, probability = math.min(1, 0.05*Config.trashYield*f)})
	end
	
	data:extend(
	{
	  item,

	  {
		type = "recipe",
		name = "ore-cleaning-" .. name,
		enabled = "true",
		energy_required = 5*multiplyConstant,
		icon = base.icon,
		subgroup = "raw-material",
		category = "ore-cleaning",
		localised_name = {"dirty-ore.recipe-name", {"item-name." .. base.name}},
		ingredients =
		{
		  {dirtyname, 1*multiplyConstant},
		  {type="fluid", name = "water", amount = 10*multiplyConstant},
		},
		results = out
	  }
	})
	
	return item
end

for name,ore in pairs(data.raw.resource) do
	if name ~= "stone" then
		log("Checking ore " .. name .. " ; cat = " .. (ore.category and ore.category or "nil"))
		if ore.category == nil or ore.category == "basic-solid" then
			local new = createDirtyOre(ore)
			if new.minable.results then
				for i,drop in ipairs(new.minable.results) do
					new.minable.results[i] = createDirtyOreItem(drop.name)
				end
			elseif new.minable.result then
				new.minable.result = createDirtyOreItem(ore.minable.result).name
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