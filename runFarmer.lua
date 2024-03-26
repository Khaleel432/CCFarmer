local function startFarming()
	local sizeOfFarm = "9" -- Number of blocks from one diagonal edge to the other
	local startingDirection = "East"
	print("Initiating farming procedure")
	print("Checking fuel")
	local fuelLevel = turtle.getFuelLevel()
	print(fuelLevel)
	print(turtle.getFuelLimit())
end

local function start()
	startFarming()
end

start()