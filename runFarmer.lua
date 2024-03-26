local function refuel()
	local chest = peripheral.find("minecraft:chest")
	if (chest == nil) then
		print("No storage chest found, please place storage chest with fuel below the turtle")
	end
	local inventory = chest.list()
	print(textutils.serialise(inventory))
	for slot, item in pairs(inventory) do
		if (item.name == "minecraft:coal") then
			inventory.pullItems(chest, slot, 1, 1)
			return true
		end
	end
	return false
end

local function startFarming()
	local pretty = require("cc.pretty")
	local sizeOfFarm = "9" -- Number of blocks from one diagonal edge to the other
	local minFuelLevel = 80
	print("Initiating farming procedure")
	print("Checking fuel")
	local fuelLevel = turtle.getFuelLevel()
	print(fuelLevel)
	print(turtle.getFuelLimit())
	if (fuelLevel < minFuelLevel and !refuel()) then
		pretty.pretty_print(turtle.inspectDown())
		print("Insufficient fuel, please add fuel to the storage chest")
		return
	end
	
end

local function start()
	startFarming()
end

start()