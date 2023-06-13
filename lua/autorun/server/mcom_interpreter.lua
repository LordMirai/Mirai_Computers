MCom = MCom or {}
MCom.Interpreter = MCom.Interpreter or {} -- the interpreter is the thing that finds the command and applies args respectively

function MCom.Interpreter.warning(msg)
    local head = "[MCom - Interpreter] Warning: "
    print(head .. tostring(msg)) -- print the warning to sv console
    MCom.tellAdmins("Interpreter warning received. Check console.", MCom.Colors.Orange)
end

function MCom.Interpreter.error(msg)
    local head = "[MCom - Interpreter] Error: "
    print(head .. tostring(msg)) -- print the error to sv console
    MCom.tellAdmins("Interpreter error received! Check console.", MCom.Colors.Red)
end

-- ! We will define a new structure, MCom ExecutionResult, which will be returned by the interpreter when a command is executed. It contains last message, error, category, and maybe suggestions
MCom.ExecutionResult = {}
MCom.ExecutionResult.__index = MCom.ExecutionResult


function MCom.ExecutionResult.new(message, errorCode, category, suggestions) -- ! Test intensively if it actually works like this
    message = message or "No message provided."
    errorCode = errorCode or MCom.Execution.None
    category = category or "None"
    suggestions = suggestions or "No suggestions."
    
    local self = setmetatable({}, MCom.ExecutionResult)
    self.message = message
    self.errorCode = errorCode
    self.category = category
    self.suggestions = suggestions
    return self
end


function MCom.Interpreter.extractArgs(strIn, ignoreFirst, returnSeparate, ignoreCase)
    ignoreFirst = ignoreFirst or false -- ignore the first argument (the command) if we already have it
    returnSeparate = returnSeparate or false -- return the command and the args separately
    ignoreCase = ignoreCase or false -- ignore case when comparing args (most of the time, we should do this)
    -- ! It might seem counterintuitive, but we'll save a copy of the arguments, without case, in case the function uses that instead of the original args.

    while string.find(strIn, "  ") do
        strIn = string.Replace(strIn, "  ", " ") -- remove all unnecessary double spaces to clean up args
    end

    local args = string.Explode(" ", strIn)
    local argsNoCase = {}
    
    if table.IsEmpty(args) then return {} end

    if ignoreFirst then -- in case we already have the command ready
        table.remove(args, 1)
    end

    if ignoreCase then -- in case we care about that.
        for k, v in pairs(args) do
            argsNoCase[k] = string.lower(v)
        end
    end

    if returnSeparate then
        if ignoreFirst then -- if we're ignoring the first argument, there might be an issue
            local msg = "[MCom] There might be an issue? You are ignoring the first argument but also returning it."
            MCom.Interpreter.warning(msg)
        end
        local cmd = args[1]
        table.remove(args, 1)
        return cmd, args, argsNoCase -- return the command and the args separately
    end
    
    return args
end


function MCom.Interpreter.executeCommand(stringIn) -- main function
    local cmd, args, argsNoCase = MCom.Interpreter.extractArgs(stringIn, false, true, true) -- extract the command and the args
    local cmdData = MCom.Commands[cmd] -- get the command data

    if not cmdData then -- if the command doesn't exist
        local msg = string.format("Command %s does not exist.", cmd)
        MCom.Interpreter.warning(msg)
        return false, msg
    end

end

function MCom.Interpreter.executeCmdEx(tblIn)
    --[[
        Table Input structure
        {
            player = ply, -- the player who executed the command
            stringIn = stringIn, -- the string that was inputted
            origin = ent, -- the entity that the command was executed from (a computer) or nil if it was executed from the console
        }
    ]]
    local execResult = MCom.Interpreter.executeCommand(tblIn.stringIn) -- execute the command
    if not execResult then -- if the command failed
        MCom.tellPlayer(tblIn.player, "Command failed to execute. Check console.", MCom.Colors.Red)
        MCom.Interpreter.warning("Command failed to execute. Check console.")
        return false
    end
end