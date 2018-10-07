data:extend({
        {
            type = "double-setting",
            name = "dirty-ore-factor",
            setting_type = "startup",
            default_value = 1.4,
            order = "r",
        },
        {
            type = "double-setting",
            name = "trash-yield",
            setting_type = "startup",
            default_value = 1.0,
			minimum_value = 0.25,
            order = "r",
        },
        {
            type = "double-setting",
            name = "water-factor",
            setting_type = "startup",
            default_value = 1.0,
			minimum_value = 0.5,
			maximum_value = 5,
            order = "r",
        },
})
