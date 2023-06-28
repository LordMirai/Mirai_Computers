MCom = MCom or {}
MCom.net = MCom.net or {}

local net = net

-- ! Clientside equivalent for net calls

-- ! SENDING
function MCom.net.reqSendMessage(ply, msg, col)
    local isBroadcast = not ply:IsValid()

    net.Start("MCom_RequestMessage")
    net.WriteEntity(isBroadcast and nil or ply)
    net.WriteString(msg)
    net.WriteColor(col)
    net.WriteBool(isBroadcast)
    net.SendToServer()
end


function MCom.net.terminalCommand(ply, origin, cmd)
    if not ply:IsValid() then 
        ply = Entity(0) -- default to worldspawn
        return
    end
    if not origin:IsValid() then
        origin = Entity(0)
    end

    net.Start("MCom_ExecuteCommand")
    net.WriteEntity(ply)
    net.WriteEntity(origin)
    net.WriteString(cmd)
    net.SendToServer()
end

function MCom.net.terminalClose(ent)
    net.Start("MCom_CloseTerminal")
    net.WriteEntity(ent)
    net.SendToServer()
end

function MCom.net.lazy(ent, output)
    net.Start("MCom_LazyLoad")
    net.WriteEntity(ent)
    net.WriteBool(output)
    net.SendToServer()
end









-- * RECEIVING
net.Receive("MCom_Message", function()
    local msg = net.ReadString()
    local col = net.ReadColor()
    local full = net.ReadBool()

    MCom.Message(msg,col,full)
end)

net.Receive("MCom_AdminMenu", function()
    MCom.openAdminMenu()
end)

net.Receive("MCom_ComputerMenu", function()
    local ent = net.ReadEntity()
    ent:tempMenu()
end)

net.Receive("MCom_ConfigureIO", function()
    local ent = net.ReadEntity()
    local parent = net.ReadEntity()
    ent:IOConfiguration(parent)
end)

net.Receive("MCom_LazyLoadReturnCL", function()
    local ent = net.ReadEntity()
    local output = net.ReadBool()
    local data = net.ReadString()
    data = util.JSONToTable(data)
    
    if MCom.activeIOConfig then
        if not output then
            MCom.activeIOConfig.inputs.populate(data)
        else
            MCom.activeIOConfig.outputs.populate(data)
        end
    end
end)