--!strict
local process = require("@lune/process")
local fs = require("@lune/fs")

local Types = require("types")

local runStatement = require("runStatement")

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

local function interpretProgram(program: string)
	local runContext: Types.RunContext = {
		variables = {},
		stack = {},
		nextStatement = 1,
	}

	local statements = program:split(";")

	while statements[runContext.nextStatement] do
		local lineNumber = runContext.nextStatement
		local statement = statements[runContext.nextStatement]

		runStatement(runContext, lineNumber, statement)

		print("Program State:")
		for variable, value in runContext.variables do
			print(`{variable}: {value}`)
		end
		print("\n")
	end
end

interpretProgram(program)
