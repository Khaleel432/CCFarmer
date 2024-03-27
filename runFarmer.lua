local columnLength = 9
local rowLength = 9
local fuelCost = rowLength * rowLength + 1 + (rowLength + 1) + (columnLength + 1) -- Size of crop (9x9) + (outside row = rowLength + 1) + (outside column = columnLength + 1) + 1 (moving into farm area)
local numTurtleSlots = 16
local crop = {
	seed = "minecraft:carrot",
	plant = "minecraft:carrots",
	matureStage = 7
}

local function findItem(itemName)
	for i=1,numTurtleSlots do
		local item = turtle.getItemDetail(i)
		if(item ~= nil) then
			if (item.name == itemName) then
				return i
			end
		end
	end
	return 0
end

local function refuel()
	local chest = peripheral.wrap("bottom")
	local name = peripheral.getName(chest)
	local type = peripheral.getType(name)
	if (chest == nil or type ~= "minecraft:chest") then
		printError("No storage chest found, please place storage chest with fuel below the turtle")
		return false
	end
	local inventory = chest.list()
	for slot, item in pairs(inventory) do
		if (item.name == "minecraft:coal") then
			chest.pushItems("bottom", slot, nil, 1)
			turtle.suckDown(1)
			local fuelSlot = findItem("minecraft:coal")
			if (fuelSlot == 0 ) then
				printError("No fuel source found")
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

local function plantSeed()
	local seedSlot = findItem(crop.seed)
	if (seedSlot == 0) then
		printError("Unable to find seeds")
		return
	end
	turtle.select(seedSlot)
	turtle.placeDown()
end

local function tillGround()
	local didTill, result = turtle.digDown()
	if(didTill or result == "Nothing to dig here") then
		plantSeed()
	else
		printError("Unable to plant seeds here")
		printError(result)
	end
end

local function harvest()
	turtle.digDown()
	plantSeed()
end

local function checkCrop(plant)
	if(plant.state.age == crop.matureStage) then
		harvest()
	end
end

local function save(fileName, content)
	local file = fs.open(fileName, "w")
	file.write(content)
	file.close()
end

local function dumpInventory()
	local didInspect, chest = turtle.inspectDown()
	if(chest.name == "minecraft:chest") then
		for i=1,numTurtleSlots do
			turtle.select(i)
			local didDrop, reason = turtle.dropDown()
			if(not(didDrop)) then
				if(reason ~= "No items to drop") then
					printError(reason)
					return -1
				end
			end
		end
	else
		printError("Cannot dump contents, no chest found")
		return -1
	end
	return 1
end

local function farmBlock() 
	local didInspectBlock, currentBlock = turtle.inspectDown()
	if (currentBlock == "No block to inspect") then
		tillGround()
	else
		if(currentBlock.name == crop.plant) then
			checkCrop(currentBlock)
		end
	end
end

local function turnLeft()
	turtle.turnLeft()
	turtle.forward()
	turtle.turnLeft()
end

local function moveColumn(turningDirection) 
	for i = 1, columnLength - 1 do
		if (turningDirection == "noDirection") then
			turtle.forward()
		else
			farmBlock()
			turtle.forward()
		end
	end
	farmBlock()
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
	print("Farmer v0.2")
	print("Farming...")
	print("Checking fuel")
	local errorFlag = false
	while true do
		while turtle.getFuelLevel() < fuelCost do
			print("Fueling up")
			if(not(refuel())) then
				print("Insufficient fuel, please add fuel to the storage chest")
				errorFlag = true
				break
			end
		end
		if(errorFlag) then
			break
		end
		handleCrops()
		if(dumpInventory() == -1) then
			errorFlag = true
			break
		end
		sleep(3600)
	end
end

local function start()
	startFarming()
end

start()