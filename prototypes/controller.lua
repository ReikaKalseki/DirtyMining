require("__DragonIndustries__.cloning")

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

local control = createFixedSignalAnchor("washer-control")
control.item_slot_count = 0

data:extend({
    control
})

--[[
local filter = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
filter.name = "dirty-ore-signal-filter"
filter.minable.result = filter.name
local item = table.deepcopy(data.raw.item["decider-combinator"])
item.name = filter.name
item.place_result = item.name
data:extend({filter, item})
--]]