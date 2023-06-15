ENT.Type = "anim"
ENT.Base = "mcom_ent_base"

ENT.PrintName = "Computer"
-- ENT.Category = "Mirai Computer System"
ENT.Spawnable = true
ENT.AdminOnly = true

-- ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "The physical computer idk"
ENT.Instructions = "Wire up and use"
-- ENT.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

-- ENT.Editable = true

-- MCom = MCom or {}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "IP")
    self:NetworkVar("Entity", 0, "User")
end

ENT.sounds = {
    
}