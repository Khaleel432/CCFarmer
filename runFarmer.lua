local columnLength = 8
local rowLength = 9
local fuelCost = rowLength * rowLength + 1
local numTurtleInventory = 16

local function findFuel()
	for i=1,numTurtleInventory do
		local item = turtle.getItemDetail(i)
		if(item ~= nil) then
			if (item.name == "minecraft:coal") then
				return i
			end
		end
		
	end
	return 0
end

local function refuel()
	local chest = peripheral.wrap("bottom")
	if (chest == nil) then
		print("No storage chest found, please place storage chest with fuel below the turtle")
	end
	local inventory = chest.list()
	for slot, item in pairs(inventory) do
		if (item.name == "minecraft:coal") then
			chest.pushItems("bottom", slot, nil, 1)
			turtle.suckDown(1)
			local fuelSlot = findFuel()
			if (fuelSlot == 0 ) then
				print("No fuel source found")
				return false
			end
			turtle.select(fuelSlot)
			turtle.refuel(1)
			turtle.select(1)
			return true
		end
	end
	return false
end

local function turnRight()
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()
end

local function turnLeft()
	turtle.turnLeft()
	turtle.forward()
	turtle.turnLeft()
end

local function moveColumn(turningDirection) 
	for i = 1, columnLength do
		turtle.forward()
	end
	if (turningDirection == "left") then
		turnLeft()
	elseif( turningDirection == "right") then
		turnRight()
	end
end

local function resetPosition()
	turtle.forward()
	moveColumn("noDirection")
	turtle.turnLeft()
	turtle.forward()
	moveColumn("noDirection")
	turtle.turnLeft()
end

local function handleCrops()
	local turningDirection = "left"
	turtle.forward()
	for i = 1,rowLength do
		moveColumn(turningDirection)
		if(turningDirection == "left") then
			turningDirection = "right"
		else
			turningDirection = "left"
		end
	end
	resetPosition()
end

local function startFarming()
	local pretty = require("cc.pretty")
	local sizeOfFarm = "9" -- Number of blocks from one diagonal edge to the other
	print("Farmer v0.2")
	-- print("Checking fuel")
	local fuelLevel = turtle.getFuelLevel()
	while fuelLevel < fuelCost do
		print("Fueling up")
		if(not(refuel())) then
			print("Insufficient fuel, please add fuel to the storage chest")
			return
		end
	end
	handleCrops()
end

local function start()
	startFarming()
end

start()