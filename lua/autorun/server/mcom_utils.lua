MCom = MCom or {}
MCom.net = MCom.net or {}

local plyMeta = FindMetaTable("Player")

function MCom.canUse(ply, ent)
    if not ent.MComEntity then return false end

    return ply.MComNoUse[ent:GetClass()] != nil
end

function MCom.entUseCooldown(ply, ent)
    ply.MComNoUse = ply.MComNoUse or {}
    if not ply.MComNoUse[ent:GetClass()] then
        ply.MComNoUse[ent:GetClass()] = true -- register no use

        timer.Simple(ent.useCooldown, function()
            if not IsValid(ply) then return end
            if not IsValid(ent) then return end

            ply.MComNoUse[ent:GetClass()] = nil -- unregister no use
        end)
    end
end

function MCom.Message(ply, msg, col)
    col = col or MCom.Colors.White
    msg = string.Trim(msg)
    MCom.net.sendMessage(ply, msg, col)
end

function MCom.Error(ply, msg)
    msg = string.Trim(msg)
    MCom.net.sendMessage(ply, msg, MCom.Colors.Red)
end

function MCom.Warning(ply, msg)
    msg = string.Trim(msg)
    MCom.net.sendMessage(ply, msg, MCom.Colors.Orange)
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

function MCom.getAll()
    local entList = {}
    for k,v in pairs(ents.GetAll()) do
        if v.MComEntity then
            table.insert(entList, v)
        end
    end
end

function MCom.getComputers()
    return ents.FindByClass("mcom_computer")
end

hook.Add("PlayerSay", "MCom_Chat_Commands", function(ply, txt, team)
    -- ! do NOT flood this with chat commands, we should only have a few. MBank had 6 in mind and I ended up with 20. It's a mess.
    local cmd, args = MCom.Interpreter.extractArgs(txt, false, true)

    if (cmd[1] or "") == "?" then -- probably MCom command
        cmd = string.sub(cmd, 2)
        if cmd == "help" then
            -- print chat command elp
        end
    end


end)