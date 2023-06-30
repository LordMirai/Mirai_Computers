MCom = MCom or {}
MCom.net = MCom.net or {}

local net = net

-- ! This file serves the simple net messages, without cluttering the main files. This covers both sending and receiving messages (serverside)

-- ! SENDING
function MCom.net.sendMessage(ply,msg,col,full)
    net.Start("MCom_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.WriteBool(full or false)
    net.Send(ply)
end

function MCom.net.broadcast(msg,col)
    net.Start("MCom_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Broadcast()
end
    
function MCom.net.openMenu(ply)
    net.Start("MCom_AdminMenu")
    net.Send(ply)
end

function MCom.net.computerMenu(ply, ent)
    print("sending SV")
    net.Start("MCom_ComputerMenu")
    net.WriteEntity(ent)
    net.Send(ply)
end

function MCom.net.configure(perip, comp, ply)
    net.Start("MCom_ConfigureIO")
    net.WriteEntity(perip)
    net.WriteEntity(comp)
    net.Send(ply)
end

function MCom.net.sendLazy(ply, ent, data, isOutput)
    net.Start("MCom_LazyLoadReturnCL")
    net.WriteEntity(ent)
    net.WriteBool(isOutput)
    net.WriteString(util.TableToJSON(data))
    net.Send(ply)
end




-- * RECEIVING
net.Receive("MCom_RequestMessage", function(len,ply)
    local ent = net.ReadEntity()
    local msg = net.ReadString()
    local col = net.ReadColor()
    local brd = net.ReadBool()

    if brd then
        MCom.Broadcast(msg, col)
    else
        MCom.Message(ent, msg, col)
    end
end)

net.Receive("MCom_ExecuteCommand", function(len, ply)
    local issuer = net.ReadEntity()
    local origin = net.ReadEntity()
    local cmd = net.ReadString()

    print(issuer, origin, cmd)

    if not IsValid(issuer) or not IsValid(origin) then return end
    origin:executeCommand(issuer, cmd)
end)

net.Receive("MCom_CloseTerminal", function(len, ply)
    print(ply, "closed terminal")
    local terminal = net.ReadEntity()
    if not IsValid(terminal) then return end
    terminal:endUse()
end)

net.Receive("MCom_LazyLoad", function(len, ply)
    local ent = net.ReadEntity()
    local isOutput = net.ReadBool()
    if not IsValid(ent) then return end
    
    local data = {}

    if ent.isPeripheral then
        for _,v in ipairs(ent.Ports) do
            if (v.read and not isOutput) or ((not v.read) and isOutput) then -- read xor isOutput
                table.insert(data, v)
            end
        end
    elseif ent.isComputer then
        if isOutput then
            for i = 1,ent.portCount do
                table.insert(data, ent:getOutput(i))
            end
        else
            for i = 1,ent.portCount do
                table.insert(data, ent:getInput(i))
            end
        end
    end

    MCom.net.sendLazy(ply, ent, data, isOutput)
end)
