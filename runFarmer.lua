local function startFarming()
	local sizeOfFarm = "9" -- Number of blocks from one diagonal edge to the other
	local minFuelLevel = 80
	print("Initiating farming procedure")
	print("Checking fuel")
	local fuelLevel = turtle.getFuelLevel()
	print(fuelLevel)
	print(turtle.getFuelLimit())
	if (fuelLevel < minFuelLevel) then
		print("Insufficient fuel, please fuel turtle up")
		return
	end
	
end

local function start()
	startFarming()
end

start()