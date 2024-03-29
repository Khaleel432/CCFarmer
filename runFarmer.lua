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
	return nil
end

local function turnRight()
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()
end

local function plantSeed()
	local seedSlot = findItem(crop.seed)
	if (seedSlot == nil) then
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

local function getStorages()
	local modem = peripheral.find("modem")
	if (modem == nil) then
		printError("Unable to find modem")
		return nil
	end
	local storages = modem.getNamesRemote()
	local storageTable = {}
	for i = 1, #storages do
		local storageName = storages[i]
		local storage = peripheral.wrap(storageName)
		for slot, item in pairs(storage.list()) do
			storageTable[item.name] = {
				name = storageName,
				slot = slot
			}
		end
	end
	return storageTable
end

local function refuel()
	local modem = peripheral.find("modem")
	if(modem == nil) then
		printError("Unable to find modem")
		return nil
	end
	local storageTable = getStorages()
	if(next(storageTable) == nil) then
		printError("No fuel found in connected storage")
		return nil
	end
	for item, storageInfo in pairs(storageTable) do
		if(item == "minecraft:coal") then
			local storage = peripheral.wrap(storageInfo.name)
			storage.pushItems(modem.getNameLocal(),storageInfo.slot,1)
			local fuelSlot = findItem("minecraft:coal")
			if (fuelSlot == nil ) then
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

local function dumpInventory()
	local modem = peripheral.find("modem")
	if (modem == nil) then
		printError("Unable to find modem")
		return nil
	end
	local storageTable = getStorages()
	if(next(storageTable) == nil) then
		printError("No storage found, cannot store items")
		return nil
	end
	for i=1,numTurtleSlots do
		local item = turtle.getItemDetail(i)
		if(item ~= nil) then
			local storageInfo = storageTable[item.name]
			if(storageInfo == nil) then
				printError("No storage for: " .. item.name)
			else
				local storage = peripheral.wrap(storageInfo.name)
				local itemsTransferred = storage.pullItems(modem.getNameLocal(), i)
				if(itemsTransferred == 0) then
					printError("Unable to store items, please add more storage space")
				end
			end
		end
	end
	return true
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

local function findEmptySlot()
	for i=1,numTurtleSlots do
		if(turtle.getItemDetail(i)==nil) then
			return i
		end
	end
	return nil
end

local function isDiamondHoe(didEquip, slot)
	if(didEquip ~= nil) then
		local tool = turtle.getItemDetail(slot)
		if(tool ~= nil) then
			turtle.equipLeft()
			if (tool.name == "minecraft:diamond_hoe") then
				return true
			end
		end
	end
	return false
end

local function isFarmingTurtle()
	local didFindHoe = false
	local slot = findEmptySlot()
	if(slot == nil) then
		return false
	end
	turtle.select(slot)
	local didEquip, reason = turtle.equipLeft()
	didFindHoe = isDiamondHoe(didEquip,slot)
	if(didFindHoe) then
		return true
	end
	didEquip, reason = turtle.equipRight()
	didFindHoe = isDiamondHoe(didEquip,slot)
	if(didFindHoe) then
		return true
	end
	return false
end

local function startFarming()
	print("Farmer v0.2")
	local errorFlag = false
	if(not(isFarmingTurtle())) then
		printError("Please equip diamond hoe")
		return
	end
	while not(errorFlag) do
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
		if(dumpInventory() == nil) then
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