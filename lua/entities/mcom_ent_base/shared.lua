ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "ENTITY BASE"
ENT.Category = "Mirai Computer System"
ENT.Spawnable = false
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "A base ent"
ENT.Instructions = "Idk yet tbh"
ENT.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

ENT.Editable = true

MCom = MCom or {}
MCom.net = MCom.net or {}
MCom.Interpreter = MCom.Interpreter or {}
MCom.Groups = MCom.Groups or {}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial") -- ALL ents MUST have serial and MAC
    self:NetworkVar("String", 1, "MAC")
end

ENT.sounds = {
    
}