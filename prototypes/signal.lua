require("__DragonIndustries__.cloning")

local function createCircuitSprite(spr)
	local ret = {
        filename = "__DirtyMining__/graphics/entity/" .. spr .. ".png",
        x = 0,
        y = 0,
        width = 61,
        height = 50,
        frame_count = 1,
        shift = {0.140625, 0.140625},
    }
	return ret
end

local function createCircuitActivitySprite()
	local ret = {
        filename = "__base__/graphics/entity/combinator/activity-leds/constant-combinator-LED-S.png",
        width = 11,
        height = 11,
        frame_count = 1,
        shift = {-0.296875, -0.078125},
    }
	return ret
end

local function createCircuitConnections()
	local ret = {
        shadow = {
          red = {0.375, 0.5625},
          green = {-0.125, 0.5625}
        },
        wire = {
          red = {0.375, 0.15625},
          green = {-0.125, 0.15625}
        }
    }
	return ret
end

local i = createFixedSignalAnchor("ore-type-signal-in", "ore-type-signal/ore-signal-in")
local o1 = createFixedSignalAnchor("ore-type-signal-out1", "ore-type-signal/ore-signal-out1")
local o2 = createFixedSignalAnchor("ore-type-signal-out2", "ore-type-signal/ore-signal-out2")
i.item_slot_count = 0
o1.item_slot_count = 1
o2.item_slot_count = 1

data:extend({
    i, o1, o2
})

	local name = "ore-type-signal"
	local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
	entity.name = name
    entity.collision_box = {{ -0.75, -0.75}, {0.75, 0.75}}
    entity.selection_box = {{ -1, -1}, {1, 1}}
	entity.circuit_wire_max_distance = 0
	entity.minable.result = name
	entity.icon = "__DirtyMining__/graphics/icons/combinator.png"
	entity.icon_size = 32
	entity.sprites = make_4way_animation_from_spritesheet({ layers =
      {
        {
          filename = "__DirtyMining__/graphics/entity/ore-type-signal/base.png",
          width = 58,
          height = 52,
          frame_count = 1,
          shift = util.by_pixel(0, 5),
          hr_version =
          {
            scale = 0.5,
            filename = "__DirtyMining__/graphics/entity/ore-type-signal/hr.png",
            width = 114,
            height = 102,
            frame_count = 1,
            shift = util.by_pixel(0, 5)
          }
        },
        {
          filename = "__DirtyMining__/graphics/entity/ore-type-signal/shadow.png",
          width = 50,
          height = 34,
          frame_count = 1,
          shift = util.by_pixel(9, 6),
          draw_as_shadow = true,
          hr_version =
          {
            scale = 0.5,
            filename = "__DirtyMining__/graphics/entity/ore-type-signal/hr-shadow.png",
            width = 98,
            height = 66,
            frame_count = 1,
            shift = util.by_pixel(8.5, 5.5),
            draw_as_shadow = true
          }
        }
      }
    })
	entity.energy_source = {type = "electric", usage_priority = "secondary-input"}
	entity.active_energy_usage = "20KW"
	local item = table.deepcopy(data.raw.item["constant-combinator"])
	item.name = name
	item.icon = entity.icon
	item.icon_size = 32
	item.place_result = name
	item.localised_name = entity.localised_name
	local recipe = table.deepcopy(data.raw.recipe["constant-combinator"])
	recipe.name = name
	recipe.result = name
	table.insert(recipe.ingredients, {"advanced-circuit", 1})
	
	data:extend({entity, item, recipe})