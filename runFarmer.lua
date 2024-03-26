local function findFuel()
	for i=1,i<17 do
		local item = turtle.getItemDetail(i)
		if (item.name == "minecraft:coal") then
			return i
		end
	end
	return 0
end

local function refuel()
	local chest = peripheral.find("minecraft:chest")
	if (chest == nil) then
		print("No storage chest found, please place storage chest with fuel below the turtle")
	end
	local inventory = chest.list()
	print(textutils.serialise(inventory))
	for slot, item in pairs(inventory) do
		if (item.name == "minecraft:coal") then
			chest.pushItems("down", slot, nil, 1)
			turtle.suckDown(1)
			local fuelSlot = findFuel()
			print("Fuel slot: " .. fuelSlot)
			if (fuelSlot == 0 ) then
				print("No fuel source found")
			end
			turtle.select(fuelSlot)
			-- turtle.refuel(1)
			turtle.select(1)
			return true
		end
	end
	return false
end

local function startFarming()
	local pretty = require("cc.pretty")
	local sizeOfFarm = "9" -- Number of blocks from one diagonal edge to the other
	local minFuelLevel = 80
	print("Farmer v0.2")
	print("Checking fuel")
	local fuelLevel = turtle.getFuelLevel()
	if (fuelLevel < minFuelLevel and not(refuel())) then
		print("Insufficient fuel, please add fuel to the storage chest")
		return
	end
	
end

local function start()
	startFarming()
end

start()