MCom = MCom or {}
MCom.Commands = MCom.Commands or {}

MCom.Callbacks = MCom.Callbacks or {}

-- command callbacks, including precondition and postcondition

function MCom.Callbacks["register"](ply, origin, regIn)
    regIn = regIn or ""
    if not IsValid(origin) then return end

    local registers = origin.Architecture.Registers
    local msg = "Register values:\n"
    if regIn != "" then
        local reg = registers[regIn]
        if not reg then 
            msg = "Register " .. regIn .. " does not exist.\n"
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
function MCom.Callbacks["os"](ply, origin)
    -- print available OS commands (shutdown, restart, etc)
end

function MCom.Callbacks["os_shutdown"](ply, origin)
    
end

function MCom.Callbacks["os_restart"](ply, origin)
    
end

