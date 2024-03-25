local function getScriptName(name)
	local urlArray = {}
	for word in string.gmatch(name, "([^*/]+)") do
		table.insert(urlArray, word)
	end
	return urlArray[#urlArray]
end

local function updateScript()
	local scriptToUpdate = "https://raw.githubusercontent.com/Khaleel432/CCScripts/main/runFarmer.lua"
	local request = http.get(scriptToUpdate);
	local scriptName = getScriptName(scriptToUpdate);
	local isFileExists = fs.exists(scriptName)
	print(scriptName)
	if(isFileExists == false) then
		local file = fs.open(scriptName, "w")
		file.write(request.readAll())
		file.close()
	end
	print(fs.exists(scriptName))
	request.close()
end

local function start()
	updateScript()
end

start()