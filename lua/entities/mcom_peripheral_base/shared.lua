ENT.Type = "anim"
ENT.Base = "mcom_ent_base" -- test if this works

ENT.PrintName = "Peripheral"

ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "A peripheral base"
ENT.Instructions = "Wire up and use"


function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "Type")
end

ENT.sounds = {
    
}