MCom = MCom or {}

function MCom.openAdminMenu()
    local ply = LocalPlayer()

    if not ply:IsAdmin() then
        MCom.Error("How did you get here?")
        return
    end

    -- UI.
end