ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Peripheral"
ENT.Category = "Mirai Computer System"
ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "A peripheral base"
ENT.Instructions = "Wire up and use"
ENT.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

ENT.Editable = true

MCom = MCom or {}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "Type")
end

ENT.sounds = {
    
}