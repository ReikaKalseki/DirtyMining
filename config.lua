Config = {}

--How much more ore should be obtainable via dirty mining?
Config.dirtyOreFactor = settings.startup["dirty-ore-factor"].value--[[@as number]]

Config.trashYield = math.max(0.25, settings.startup["trash-yield"].value--[[@as number]])

Config.washerSpeed = 50*2 --this brings it to exactly one blue belt
Config.waterPerSecond = 160*settings.startup["water-factor"].value