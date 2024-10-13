--!strict
local process = require("@lune/process")
local fs = require("@lune/fs")
local regex = require("@lune/regex")

local programFile = process.args[1]

-- TODO: a repl
assert(programFile, "Did not provide an input program")
if not fs.isFile(programFile) then
	-- allow for exclusion of the .bb extension
	programFile = programFile .. ".bb"
	if not fs.isFile(programFile) then
		error("Provided program does not exist")
	end
end

local program = fs.readFile(programFile)

local runContext = {
	variables = {},
	nextStatement = 1,
}

local statements = program:gsub("\r\n", "\n"):gsub("\n", ""):split(";")
-- statements[#statements] = nil

local function trim(str: string)
	local re = regex.new("^\\s+|\\s+$")
	return re:replaceAll(str, "")
end

while statements[runContext.nextStatement] do
	local lineNumber = runContext.nextStatement
	local line = statements[runContext.nextStatement]

	runContext.nextStatement += 1

	local words = trim(line):split(" ")

	print(`Executing: {lineNumber}: {line}`)

	if words[1] == "clear" then
		local variable = words[2]
		if not variable then
			error("Must provide a variable to clear")
		end
		runContext.variables[variable] = 0
	elseif words[1] == "incr" then
		local variable = words[2]
		if not variable then
			error("Must provide a variable to incr")
		end
		runContext.variables[variable] = (runContext.variables[variable] or 0) + 1
	elseif words[1] == "decr" then
		local variable = words[2]
		if not variable then
			error("Must provide a variable to decr")
		end
		runContext.variables[variable] = (runContext.variables[variable] or 0) - 1
	else
		continue
	end

	print("Program State:")
	for variable, value in runContext.variables do
		print(`{variable}: {value}`)
	end
	print("\n")
end
