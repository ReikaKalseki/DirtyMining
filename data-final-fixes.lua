require("config")

require("prototypes.ores")

if data.raw.item["steel-pipe"] then
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"steel-pipe", 15})
else
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"pipe", 30})
end

if data.raw.item["bronze-alloy"] then
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"bronze-alloy", 25})
else
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"steel-plate", 12})
end

if data.raw.item["steel-bearing"] then
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"steel-bearing", 6})
end

if data.raw.item["steel-gear-wheel"] then
	table.insert(data.raw.recipe["ore-washer"].ingredients, {"steel-gear-wheel", 2})
end