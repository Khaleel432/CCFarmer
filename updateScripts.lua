local function getScriptName(name)
	local urlArray = {}
	for word in string.gmatch(name, "([^*/]+)") do
		table.insert(urlArray, word)
	end
	return urlArray[#urlArray]
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

local function updateFile(filename, content)
	-- local isFileExists = fs.exists(filename)
	-- if(isFileExists == false) then
		local file = fs.open(filename, "w")
		file.write(content)
		file.close()
	-- else
	-- 	local tempFile = fs.open("tempFile", "w")
	-- 	tempFile.write(content)
	-- 	if (getNumOfLines("tempFile") ~= getNumOfLines(filename)) then
	-- 		local scriptFile = fs.open(filename, "w+")
	-- 		scriptFile.write(content)
	-- 		scriptFile.close();
	-- 		print("File updated")
	-- 	end
	-- 	tempFile.close()
	-- 	fs.delete("tempFile")
	-- end
end

local function updateScript()
	local scriptToUpdate = "https://raw.githubusercontent.com/Khaleel432/CCScripts/main/runFarmer.lua"
	local request = http.get(scriptToUpdate);
	local content = request.readAll();
	local scriptName = getScriptName(scriptToUpdate);
	request.close()
	updateFile(scriptName, content)
	shell.execute(scriptName)
end

local function start()
	updateScript()
end

start()