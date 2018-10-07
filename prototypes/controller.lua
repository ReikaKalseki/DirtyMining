local function createCircuitSprite()
	local ret = {
        filename = "__DirtyMining__/graphics/entity/connection.png",
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

local function create(name, signals)
  return {
    type = "constant-combinator",
    name = "washer-" .. name,
    icon = "__base__/graphics/icons/constant-combinator.png",
	icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "not-on-map", "placeable-off-grid", "not-blueprintable", "not-deconstructable"},
	order = "z",
	max_health = 100,
	destructible = false,
	--selectable_in_game = false,
	
	--collision_mask = {},

    --collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

    item_slot_count = signals,

    sprites = {
      north = createCircuitSprite(),
      west = createCircuitSprite(),
      east = createCircuitSprite(),
      south = createCircuitSprite(),
    },

    activity_led_sprites = {
	  north = createCircuitActivitySprite(),
      west = createCircuitActivitySprite(),
      east = createCircuitActivitySprite(),
      south = createCircuitActivitySprite(),
    },

    activity_led_light =
    {
      intensity = 0.8,
      size = 1,
    },

    activity_led_light_offsets =
    {
      {-0.296875, -0.078125},
      {-0.296875, -0.078125},
      {-0.296875, -0.078125},
      {-0.296875, -0.078125},
    },

    circuit_wire_connection_points = {
      createCircuitConnections(),
      createCircuitConnections(),
      createCircuitConnections(),
      createCircuitConnections(),
    },

    circuit_wire_max_distance = 7.5
  }
end

data:extend({
	create("control", 0), create("output", 1)
})