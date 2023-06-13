MCom = MCom or {}
MCom.net = MCom.net or {}

local net = net

-- ! This file serves the simple net messages, without cluttering the main files. This covers both sending and receiving messages (serverside)

function MCom.net.sendMessage(ply,msg,col)
    net.Start("MCom_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Send(ply)
end

MCom.net.broadcast(msg,col)
    net.Start("MCom_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Broadcast()
end
