MCom = MCom or {}

-- ! We will define a new structure, MCom ExecutionResult, which will be returned by the interpreter when a command is executed. 
-- ! It contains last message, error, category, and maybe suggestions.
MCom.ExecutionResult = {}
MCom.ExecutionResult.__index = MCom.ExecutionResult


function MCom.ExecutionResult.__call(self, message, errorCode, category, suggestions) -- ! Test intensively if it actually works like this
    message = message or "No message provided."
    errorCode = errorCode or MCom.Execution.None
    category = category or "None"
    suggestions = suggestions or "No suggestions."

    local self = setmetatable({}, MCom.ExecutionResult)
    self.message = message -- i.e. "Missing argument #2"
    self.errorCode = errorCode -- i.e. MCom.Execution.ArgumentError
    self.category = category -- i.e. "Argument"
    self.suggestions = suggestions -- i.e. "Use help command to get more information."

    MCom.lastError = self.errorCode
    return self
end

function MCom.ExecutionResult.__concat(self, other)
    return self.message..other
end

function MCom.ExecutionResult.__tostring(self)
    return self.message
end

function MCom.ExecutionResult.__len(self)
    return errorCode -- ? just a shorthand for getting the error code
end

function MCom.ExecutionResult.__eq(self, other)
    return self.errorCode == other.errorCode
end

-- ^ end of struct

function MCom.getLastError()
    return MCom.lastError or MCom.Execution.None
end

function MCom.stdErr(msg, categ, suggestion)
    categ = categ or "General"
    suggestion = suggestion or "Use help command to get more information."
    return MCom.ExecutionResult(msg, MCom.Execution.Error, categ, suggestion)
end

function MCom.success(msg)
    return MCom.ExecutionResult(msg, MCom.Execution.Success, "Execution", "Command executed successfully.")
end