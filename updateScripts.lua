local pretty = require("cc.pretty")

local function getScriptName(name)
	local urlArray = {}
	for word in string.gmatch(name, "([^*/]+)") do
		table.insert(urlArray, word)
	end
	return urlArray[#urlArray]
end

local function updateFile()
	
end

local function getNumOfLines(file)
	local file = fs.open(file, "r")
	local lines = {}
	while true do
		local line = file.readLine()

		if not line then
			break
		end

		lines[#lines+1] = line
	end
	file.close()
	return #lines
end

local function updateScript()
	local scriptToUpdate = "https://raw.githubusercontent.com/Khaleel432/CCScripts/main/runFarmer.lua"
	local request = http.get(scriptToUpdate);
	local scriptName = getScriptName(scriptToUpdate);
	local isFileExists = fs.exists(scriptName)
	if(isFileExists == false) then
		local file = fs.open(scriptName, "w")
		file.write(request.readAll())
		file.close()
	else
		local tempFile = fs.open("tempFile", "w")
		tempFile.write(request.readAll())
		print(tempFile)
		tempFile.close()
		print(getNumOfLines("tempFile"))
		print(getNumOfLines(scriptName))
		
	end
	request.close()
end

local function start()
	updateScript()
end

start()