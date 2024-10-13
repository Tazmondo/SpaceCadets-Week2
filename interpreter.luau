--!strict
local process = require("@lune/process")
local fs = require("@lune/fs")

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

local variables = {}

local statements = program:gsub("\r\n", "\n"):gsub("\n", ""):split(";")
-- statements[#statements] = nil

for lineNumber, line in statements do
	local words = line:split(" ")

	print(`Executing: {lineNumber}: {line}`)

	if words[1] == "clear" then
		local variable = words[2]
		variables[variable] = 0
	elseif words[1] == "incr" then
		local variable = words[2]
		if not variables[variable] then
			error(`Line: {lineNumber}: Variable {variable} did not exist!`)
		end
		variables[variable] += 1
	elseif words[1] == "decr" then
		local variable = words[2]
		if not variables[variable] then
			error(`Line: {lineNumber}: Variable {variable} did not exist`)
		end
		variables[variable] -= 1
	else
		continue
	end

	print("Program State:")
	for variable, value in variables do
		print(`{variable}: {value}`)
	end
	print("\n")
end
