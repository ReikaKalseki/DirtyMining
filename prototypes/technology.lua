require "config" 

data:extend({
	{
		type = "technology",
		name = "dirty-mining",
		prerequisites =
		{
			"mining-productivity-1", --actually gates it after #3, since all three are "grouped"
			"advanced-electronics",
		},
		icon = "__DirtyMining__/graphics/technology/tech.png",
		effects =
		{
		  {
			type = "unlock-recipe",
			recipe = "dirty-planner"
		  },
		  {
			type = "unlock-recipe",
			recipe = "ore-washer"
		  },
		},
		unit =
		{
		  count = 350,
		  ingredients =
		  {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
		  },
		  time = 40
		},
		order = "[steam]-2",
		icon_size = 128,
		}
})