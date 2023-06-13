MCom = MCom or {}
MCom.net = MCom.net or {}

local net = net


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















-- * RECEIVING
net.Receive("MCom_Message", function()
    local msg = net.ReadString()
    local col = net.ReadColor()

    MCom.Message(msg,col)
end)

net.Receive("MCom_AdminMenu", function()
    MCom.openAdminMenu()
end)