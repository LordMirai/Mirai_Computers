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

