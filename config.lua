Config = {}

--How much more ore should be obtainable via dirty mining?
Config.dirtyOreFactor = settings.startup["dirty-ore-factor"].value--1.4

Config.trashYield = math.max(0.25, settings.startup["trash-yield"].value)--1.0