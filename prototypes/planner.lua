data:extend({

  {
    type = "selection-tool",
    name = "dirty-planner",
    icon = "__DirtyMining__/graphics/icons/planner.png",
    icon_size = 32,
    stack_size = 1,
    subgroup = "tool",
    order = "c[automated-construction]-d[dirty-planner]",
    flags = {},
    selection_color = {r = 1.0, g = 0.2, b = 1.0, a = 0.3},
    alt_selection_color = {r = 0.2, g = 0.8, b = 0.3, a = 0.3},
    selection_mode = {"any-entity"},
    alt_selection_mode = {"any-entity"},
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "entity"
    
  },
  {
    type = "recipe",
    name = "dirty-planner",
    enabled = false,
    energy_required = 1,
    ingredients =
    {
		{"blueprint", 1},
		{"advanced-circuit", 4},
		{"electric-mining-drill", 2}
    },
    result = "dirty-planner"
  }
})