MCom = MCom or {}
MCom.net = MCom.net or {}

function MCom.Message(msg, col, full)
    full = full or false
    local head = full and "[Mirai Computers] " or "[MCom] "

    chat.AddText(MCom.Colors.Yellow, head, col, msg)
end

function MCom.Error(msg)
    MCom.Message(msg, MCom.Colors.Red)
end

function MCom.Warning(msg)
    MCom.Message(msg, MCom.Colors.Orange)
end

function MCom.RequestMessage(ply, msg, col)
    if not ply:IsValid() then return end

    MCom.net.reqSendMessage(ply,msg,col)
end

function MCom.RequestBroadcast(msg, col)
    MCom.net.reqSendMessage(nil, msg, col)
end