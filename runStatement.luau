local Types = require("types")
local regex = require("@lune/regex")

local function trim(str: string)
	local re = regex.new("^\\s+|\\s+$")
	return re:replaceAll(str, "")
end

local function runStatement(runContext: Types.RunContext, lineNumber: number, statement: string)
	runContext.nextStatement += 1

	local topStack = runContext.stack[#runContext.stack]
	local words = trim(statement):split(" ")

	if topStack and topStack.type == "While" and topStack.failed and words[1] ~= "end" then
		return
	end

	print(`Executing: {lineNumber}: {statement}`)

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

		-- variables cannot be negative
		runContext.variables[variable] = math.max(0, (runContext.variables[variable] or 0) - 1)
	elseif words[1] == "while" then
		local variable = words[2]
		if not variable then
			error("Must provide a variable to while")
		end
		assert(words[3] == "not" and words[4] == "0" and words[5] == "do", "While loop must end with not 0 do")

		local currentWhile
		if topStack and topStack.type == "While" and topStack.conditionLine == lineNumber then
			currentWhile = topStack
		else
			currentWhile = {
				type = "While",
				conditionLine = lineNumber,
				failed = false,
			}
			table.insert(runContext.stack, currentWhile)
		end

		local value = runContext.variables[variable]
		if not value or value == 0 then
			currentWhile.failed = true
			if currentWhile.endLine then
				runContext.nextStatement = currentWhile.endLine + 1
				runContext.stack[#runContext.stack] = nil
			end
		end
	elseif words[1] == "end" then
		assert(topStack, "Too many ends!")
		if topStack.type == "While" then
			if not topStack.failed then
				runContext.nextStatement = topStack.conditionLine
				topStack.endLine = lineNumber
			else
				runContext.stack[#runContext.stack] = nil
			end
		else
		end
	end
end

return runStatement
