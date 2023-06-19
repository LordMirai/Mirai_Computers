MCom = MCom or {}
MCom.Commands = MCom.Commands or {}

MCom.Callbacks = MCom.Callbacks or {}

-- command callbacks, including precondition and postcondition

MCom.Callbacks["register"] = function(ply, origin, regIn)
    regIn = regIn or ""
    if not IsValid(origin) then return end

    local registers = origin.Architecture.Registers
    local msg = "Register values:\n"
    if regIn != "" then
        local reg = registers[regIn]
        if not reg then 
            msg = string.format("Register %s does not exist.\n", regIn)
        else
            msg = string.format("%s%s: %s\n", msg, regIn, reg.Value)
        end
    else
        for k, v in pairs(registers) do
            msg = string.format("%s%s: %s\n", msg, k, v.Value)
        end
    end

    origin:output(msg)
end


-- ^ OS
MCom.Callbacks["os"] = function(ply, origin)
    -- print available OS commands (shutdown, restart, etc)
    print("os callback")
    origin:output("Available OS commands:\n")
end

MCom.Callbacks["os_shutdown"] = function(ply, origin)
    origin:output("Shutting down...")
    origin:wait(1, function(origin) -- this effectively waits for one tick then proceeds to execute the rest
        origin:shutdown()
    end, origin)
end

MCom.Callbacks["os_restart"] = function(ply, origin)
    origin:output("Restarting...")
    origin:wait(1, function(origin)
        origin:shutdown()
        origin:startup()
    end, origin)
end

--[[
    What's stupid about this implementation of :wait() is that if you want to implement this idea:
    >>do thing
    sleep for 2 ticks
    do other thing
    sleep for 3 ticks
    do smth else<<
    
    you'd need to do 
    function()
        do thing
        origin:wait(2, function(origin)
            do other thing
            origin:wait(3, function(origin)
                do smth else
            end, origin)
        end, origin)
    end

]]