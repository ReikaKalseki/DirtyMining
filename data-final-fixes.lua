require("config")

require("prototypes.ores")

if data.raw.item["steel-pipe"] then
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"steel-pipe", 15})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"steel-pipe", 30})
else
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"pipe", 30})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"pipe", 45})
end

if data.raw.item["bronze-alloy"] then
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"bronze-alloy", 24})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"bronze-alloy", 40})
else
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"steel-plate", 12})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"steel-plate", 18})
end

if data.raw.item["steel-bearing"] then
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"steel-bearing", 6})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"steel-bearing", 20})
end

if data.raw.item["steel-gear-wheel"] then
	table.insert(data.raw.recipe["ore-washer"].normal.ingredients, {"steel-gear-wheel", 2})
	table.insert(data.raw.recipe["ore-washer"].expensive.ingredients, {"steel-gear-wheel", 6})
end