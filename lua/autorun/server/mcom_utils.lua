MCom = MCom or {}
MCom.net = MCom.net or {}

local plyMeta = FindMetaTable("Player")

function MCom.canUse(ply, ent)
    if not ent.MComEntity then return false end

    return ply.MComNoUse[ent:GetClass()] != nil
end

function MCom.Message(ply, msg, col)
    col = col or MCom.Colors.White
    msg = string.Trim(msg)
    MCom.net.sendMessage(ply, msg, col)
end

function MCom.Broadcast(msg, col)
    col = col or MCom.Colors.White
    msg = string.Trim(msg)
    MCom.net.broadcast(msg,col)
end

function MCom.tellAdmins(msg, col)
    col = col or MCom.Colors.White
    msg = string.Trim(msg)
    for k,v in pairs(MCom.getAdmins()) do
        MCom.net.sendMessage(v, msg, col)
    end
end

function MCom.getAdmins()
    local admins = {}
    for k,v in pairs(player.GetAll()) do
        if v:IsAdmin() then
            table.insert(admins, v)
        end
    end
    return admins
end