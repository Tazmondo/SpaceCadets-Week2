export type WhileLoop = {
	type: "While",
	conditionLine: number,
	endLine: number?,
	failed: boolean,
}

export type StackMember = WhileLoop

export type RunContext = {
	variables: { [string]: number },
	stack: { StackMember },
	nextStatement: number,
}

return nil
