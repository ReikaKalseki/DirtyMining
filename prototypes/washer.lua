local speed = 50*2

data:extend({
  {
    type = "assembling-machine",
    name = "ore-washer",
    icon = "__DirtyMining__/graphics/icons/ore-washer.png",
	icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "ore-washer"},
    max_health = 350,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0.5, -2.5} }},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = false
    },
    collision_box = {{-1.8, -1.8}, {1.8, 1.8}},
    selection_box = {{-2, -2}, {2, 2}},
    animation =
    {
      layers =
      {
        {
          filename = "__DirtyMining__/graphics/entity/ore-washer/ore-washer.png",
          priority = "high",
          width = 108,
          height = 110,
          frame_count = 1,
          line_length = 1,
          shift = util.by_pixel(0, 4),
		  animation_speed = 1/speed,
		  scale = 4/3,
          hr_version = {
            filename = "__DirtyMining__/graphics/entity/ore-washer/hr-ore-washer.png",
            priority = "high",
            width = 214,
            height = 218,
            frame_count = 1,
            line_length = 1,
            shift = util.by_pixel(0, 4),
            scale = 0.5*4/3,
			animation_speed = 1/speed,
          }
        },
        {
          filename = "__DirtyMining__/graphics/entity/ore-washer/ore-washer-shadow.png",
          priority = "high",
          width = 98,
          height = 82,
          frame_count = 1,
          line_length = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(12, 5),
		  animation_speed = 1/speed,
		  scale = 4/3,
          hr_version = {
            filename = "__DirtyMining__/graphics/entity/ore-washer/hr-ore-washer-shadow.png",
            priority = "high",
            width = 196,
            height = 163,
            frame_count = 1,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(12, 4.75),
            scale = 0.5*4/3,
			animation_speed = 1/speed,
          }
        },
      },
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = {
        {
          filename = "__DirtyMining__/sound/washer.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_categories = {"ore-cleaning"},
    crafting_speed = speed,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.08
    },
    energy_usage = "80kW",
    ingredient_count = 2,
    module_specification =
    {
      module_slots = 0
    },
    allowed_effects = nil,
  },
})

data:extend({
  {
    type = "item",
    name = "ore-washer",
    icon = "__DirtyMining__/graphics/icons/ore-washer.png",
	icon_size = 32,
    flags = { "goes-to-quickbar" },
    subgroup = "production-machine",
    order = "f[ore-washer]",
    place_result = "ore-washer",
    stack_size = 20
  }
})

data:extend({
  {
    type = "recipe",
    name = "ore-washer",
    icon = "__DirtyMining__/graphics/icons/ore-washer.png",
	icon_size = 32,
    energy_required = 2,
    enabled = "false",
    ingredients =
    {
      {"assembling-machine-2", 1},
	  {"steel-plate", 4},
      {"pipe", 20}
    },
    result = "ore-washer"
  },
})