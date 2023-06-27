MCom = MCom or {}
MCom.Commands = MCom.Commands or {}

MCom.Callbacks = MCom.Callbacks or {}

-- command callbacks, including precondition and postcondition

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

local function tickerFunc(origin, count)
    -- print(count)
    count = tonumber(count) or 3
    origin:output("Tick - " .. count)
    origin:wait(1, function(origin)
        if count > 1 then
            tickerFunc(origin, count - 1)
        end
    end, origin)
end

MCom.Callbacks["tick"] = function(ply, origin, count)
    tickerFunc(origin,count)
end

local function clock(origin, pin, interval)
    if not IsValid(origin) then return end
    origin:toggleOutput(pin)
    timer.Simple(interval, function()
        clock(origin, pin, interval)
    end)
end

MCom.Callbacks["clock"] = function(ply, origin, pin, interval)
    interval = tonumber(interval) or 1
    origin:output(string.format("Starting clock on pin %s with interval %s", pin, interval))
    clock(origin, pin, interval)
end

MCom.Callbacks["echo"] = function(ply origin, ...) -- not sure how I haven't implemented this yet
    local msg = table.concat({...}, " ")
    origin:output(msg)
end

MCom.Callbacks["random"] = function(ply, origin, reg, min, max)
    min = min or 0
    max = max or 100

    local rand = math.random(min, max)
    local success = origin:write(reg, rand, false)
    if success then
        origin:output(string.format("Wrote %s to %s", rand, reg))
    else
        origin:output("Failed to write to register. Register does not exist.")
    end
end

-- ? Network system

MCom.Callbacks["net"] = function(ply, origin)
    local msg = "Network system. Based on IP and uses network ports.\n"
    msg = msg .. "Available commands:\n"
    origin:output(msg)
end

MCom.Callbacks["net_ping"] = function(ply, origin, ip)
    local msg = string.format("Pinging %s...\n", ip)
    origin:ping(ip) -- TBI
end

MCom.Callbacks["net_connect"] = function(ply, origin, ip)
    local msg = string.format("Connecting to %s...\n", ip)
    origin:connectNetwork(ip) -- TBI
end

MCom.Callbacks["net_disconnect"] = function(ply, origin, ip)
    local msg = string.format("Disconnecting from %s...\n", ip)
    origin:connectNetwork(ip) -- TBI
end

MCom.Callbacks["net_send"] = function(ply, origin, ip, port, ...)
    local msgIn = table.concat({...}, " ")
    local msg = string.format("Sending message %s to %s:%s...\n", msgIn, ip, port)
    origin:sendNetwork(ip, port, msg) -- TBI. Will write the thing to the receiver
end


-- ? IO system

MCom.Callbacks["io"] = function(ply, origin)
    local msg = "IO system. Based on pins.\n"
    msg = msg .. "Available commands:\n"
    origin:output(msg)
end

MCom.Callbacks["io_write"] = function(ply, origin, pin, val)
    local out = (val == "true" or val == "1") and true or false
    -- origin:output("Writing " .. tostring(out) .. " to pin " .. pin)
    local msg = string.format("Writing %s to pin %s", tostring(out), pin)
    origin:output(msg)
    origin:setOutput(pin, out)
end

MCom.Callbacks["io_read"] = function(ply, origin, pin)
    local msg = string.format("Reading pin %s: %s", pin, tostring(origin:getInput(pin)))
    origin:output(msg)
end

MCom.Callbacks["io_toggle"] = function(ply, origin, pin)
    local msg = string.format("Toggling pin %s", pin)
    origin:output(msg)
    origin:toggleOutput(pin)
end

MCom.Callbacks["io_getall"] = function(ply, origin)
    local msg = "Pin values:\n\nInput:\n"
    for i=1,10 do
        msg = msg .. string.format("Pin%s = %s\n", i, origin:getInput(i))
    end
    msg = msg .. "\nOutput:\n"
    for i=1,10 do
        msg = msg .. string.format("Pin%s = %s\n", i, origin:getOutput(i))
    end
end

MCom.Callbacks["io_setall"] = function(ply, origin, val)
    val = (val == 1) or false
    for i=1,10 do
        origin:setOutput(val)
    end
    origin:output("All pins set to "..tostring(val))
end


-- ? System commands

MCom.Callbacks["sys"] = function(ply, origin)
    local msg = "System commands:\n"
    msg = msg .. "Available commands:\n"
    origin:output(msg)
end

MCom.Callbacks["sys_info"] = function(ply, origin)
    local msg = "System info:\n"
    msg = msg .. string.format("Serial: %s\n", origin:getSerial())
    msg = msg .. string.format("MAC: %s\n", origin:getMAC())
    msg = msg .. string.format("IP: %s\n", origin:getIP())
    msg = msg .. string.format("System up for %s ticks\n", origin:read("TC"))
    msg = msg .. "Peripheral info:\n"
    for _,v in ipairs(origin:getPeripherals()) do
        local data = v:connectionInfo() -- ! TBI priority
        msg = msg .. string.format("%s: %s\n", v:getName(), data)
    end
    origin:output(msg)
end


-- ? Peripheral

MCom.Callbacks["peripheral"] = function(ply, origin)
    local msg = "Peripheral commands:\n"
    origin:output(msg)
end

MCom.Callbacks["peripheral_list"] = function(ply, origin)
    local msg = "Peripherals:\n"
    for k,v in pairs(origin:getPeripherals()) do
        msg = msg .. string.format("%s: %s\n", k, v:connectionInfo())
    end
    origin:output(msg)
end

MCom.Callbacks["peripheral_get"] = function(ply, origin, name) -- ! check all of the below.
    local msg = string.format("Getting peripheral %s...\n", name)
    origin:output(msg)
    local per = origin:getPeripheral(name)
    if per then
        msg = string.format("Peripheral %s found!\n", name)
        msg = msg .. string.format("Type: %s\n", per:getType())
        msg = msg .. string.format("Connection info: %s\n", per:connectionInfo())
        origin:output(msg)
    else
        msg = string.format("Peripheral %s not found!\n", name)
        origin:output(msg)
    end
end

MCom.Callbacks["peripheral_call"] = function(ply, origin, name, func, ...)
    local msg = string.format("Calling function %s on peripheral %s...\n", func, name)
    origin:output(msg)
    local per = origin:getPeripheral(name)
    if per then
        msg = string.format("Peripheral %s found!\n", name)
        msg = msg .. string.format("Type: %s\n", per:getType())
        msg = msg .. string.format("Connection info: %s\n", per:connectionInfo())
        origin:output(msg)
        local func = per.actions[func]
        if func then
            local args = {...}
            local ret = func(ply, origin, unpack(args))
            msg = string.format("Function %s called with args %s\n", func, table.concat(args, ", "))
            origin:output(msg)
        else
            msg = string.format("Function %s not found!\n", func)
            origin:output(msg)
        end
    else
        msg = string.format("Peripheral %s not found!\n", name)
        origin:output(msg)
    end
end

MCom.Callbacks["peripheral_bind"] = function(ply, origin, identifier, reg) -- binding a peripheral to a register
    if not reg then reg = "P" end
    local msg = string.format("Wrapping peripheral %s to register %s...\n", identifier, reg)
    origin:output(msg)
    local per = origin:getPeripheral(identifier)
    if per then
        local wrapped = per:wrap()
        if wrapped then
            msg = string.format("Peripheral %s bound to register %s!\n", identifier, reg)
        else
            msg = string.format("Peripheral %s could not be bound to register %s!\n", identifier, reg)
        end
        origin:output(msg)
    else
        msg = string.format("Peripheral %s not found!\n", identifier)
        origin:output(msg)
    end
end

MCom.Callbacks["peripheral_wrap"] = function(ply, origin, identifier, name) -- wrapping a peripheral under a name (variable)
    if not name then name = identifier end

    if string.match(string.upper(name), "[A-Z]") or string.upper(name) == "TC" then
        local msg = string.format("Cannot wrap peripherals under name %s (register)!\n", identifier, name)
        origin:output(msg)
        return
    end

    local msg = string.format("Wrapping peripheral %s...\n", identifier)
    origin:output(msg)
    
    local per = origin:getPeripheral(identifier)
    if not per then
        msg = string.format("Peripheral %s not found!\n", identifier)
        origin:output(msg)
        return
    end

    origin:wrap(per, name)

    local msg = string.format("Peripheral %s wrapped under name '%s'...\n", identifier, name)
    origin:output(msg)
end

MCom.Callbacks["peripheral_name"] = function(ply, origin, identifier, name)
    local msg = string.format("Renaming peripheral %s to %s...\n", identifier, name)
    origin:output(msg)
    local per = origin:getPeripheral(identifier)
    if per then
        per:setName(name)
        msg = string.format("Peripheral %s renamed to %s!\n", identifier, name)
        origin:output(msg)
    else
        msg = string.format("Peripheral %s not found!\n", identifier)
        origin:output(msg)
    end
end


-- ? GOD protocols

MCom.Callbacks["god"] = function(ply, origin)
    local msg = "GOD protocol - A way to run commands on the terminal automatically.\n"
    msg = msg .. "Available commands:\n"
    origin:output(msg)
end

MCom.Callbacks["god_test"] = function(ply, origin)
    local msg = "GOD protocol test command.\n"
    origin:output(msg)
    origin:run("tick 2")
    origin:run("clock 1.5 2")
    origin:output("god protocol test complete")
end

MCom.Callbacks["god_inp_test"] = function(ply, origin)
    origin:output("GOD protocol - input test")
    origin:run("")
end



-- ? Registers

MCom.Callbacks["reg"] = function(ply, origin)
    origin:output("register commands:")
end

MCom.Callbacks["reg_read"] = function(ply, origin, regIn)
    regIn = string.upper(regIn) or ""
    if not IsValid(origin) then return end

    local msg = string.format("Register %s has value %s", regIn, tostring(origin:read(regIn)))
    origin:output(msg)
end

MCom.Callbacks["reg_write"] = function(ply, origin, regIn, val)
    regIn = string.upper(regIn) or ""
    if not IsValid(origin) then return end

    local msg = string.format("Register %s set to value %s", regIn, tostring(val))
    origin:output(msg)
    origin:write(regIn, val)
end

MCom.Callbacks["reg_getall"] = function(ply, origin)
    if not IsValid(origin) then return end

    local msg = "Registers:\n"
    for k,v in pairs(origin.Architecture.Registers) do
        msg = msg .. string.format("%s: %s\n", k, tostring(v))
    end
    origin:output(msg)
end

MCom.Callbacks["reg_setall"] = function(ply, origin, val)
    if not IsValid(origin) then return end

    local msg = string.format("All registers set to value %s", tostring(val))
    origin:output(msg)
    for k,v in pairs(origin.Architecture.Registers) do
        origin:write(k, val)
    end
end


-- * break

if MCom.hotReload then -- will only work locally hosted, not on dedicated servers
    MCom.refreshCommands()
    print("hot reload fired")
end