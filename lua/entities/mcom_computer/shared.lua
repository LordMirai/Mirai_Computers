ENT.Type = "anim"
ENT.Base = "mcom_ent_base"

ENT.PrintName = "Computer"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Purpose = "The physical computer idk"
ENT.Instructions = "Wire up and use"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "IP")
    self:NetworkVar("Entity", 0, "User")
    self:NetworkVar("Float", 0, "State")
end

ENT.sounds = {
    
}

MCom.ComputerState = {
    OFF = 0,
    TRANSITION = 1, -- booting up or shutting down
    ON = 2,
    ERRORED = 3,
    BROKEN = 4,
    REPAIRING = 5
}