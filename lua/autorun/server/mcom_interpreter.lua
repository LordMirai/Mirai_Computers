MCom = MCom or {}
MCom.Interpreter = MCom.Interpreter or {} -- the interpreter is the thing that finds the command and applies args respectively
MCom.ExecutionResult = MCom.ExecutionResult or {} -- the result of the execution of a command
MCom.Commands = MCom.Commands or {} -- the commands table


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


function MCom.Interpreter.executeCommand(ply, origin, stringIn) -- main function. origin = terminal entity (computer) or nil if console
    local cmd, args, argsNoCase = MCom.Interpreter.extractArgs(stringIn, false, true, true) -- extract the command and the args
    local cmdData = MCom.Commands[cmd] -- get the command data

    if not cmdData then -- if the command doesn't exist
        local msg = string.format("Command %s does not exist.", cmd)
        MCom.Interpreter.warning(msg)
        MCom.Error(ply, msg)
        return MCom.stdErr("Command does not exist.")
    end

    if not cmdData.name then cmdData.name = cmd end -- fallback in case the command doesn't have a pretty name
    if not cmdData.action then -- if the command doesn't have an action
        local msg = string.format("Command %s does not have an action.", cmd)
        MCom.Interpreter.error(msg)
        MCom.Error(ply, msg) -- if too much spam, remove
        return MCom.stdErr("Command does not have an action.", MCom.Execution.Unknown)
    end

    if cmdData.disabled then -- if the command is disabled
        MCom.Error(ply, "That command is disabled.")
        return MCom.stdErr("Command is disabled.")
    end

    local wrappedFunction = MCom.Interpreter.wrapFunction(ply, origin, cmdData, args, argsNoCase) -- wrap the function
    return wrappedFunction() -- finally execute the function
end


function MCom.Interpreter.wrapFunction(ply, origin, cmdData, args, argsNoCase) -- wrap the function
    -- only preconditions are required to pass, if they exist

    if cmdData.admin then
        if not ply:IsAdmin() then
            MCom.Message(ply, "This command is admin only.")
            return MCom.stdErr("Admin Only - "..cmdData.name, MCom.Execution.Unauthorized)
        end
    end

    local arguments = cmdData.ignoreCase and argsNoCase or args -- use the correct arguments, from command table

    local precond = true
    if cmdData.preconditions then
        precond = cmdData.preconditions(ply, origin, arguments)
    end
    if not precond then
        return MCom.stdErr("Preconditions failed.", "Execution")
    end

    local execResult = cmdData.action(ply, origin, arguments) -- execute the command

    local post = cmdData.postconditions and cmdData.postconditions(ply, origin, execResult, arguments) or true
    return MCom.success(cmdData.name)
end