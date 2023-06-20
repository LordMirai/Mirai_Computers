ENT.Type = "anim"
ENT.Base = "mcom_peripheral_base" -- test if this works

ENT.PrintName = "Button"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Mirai Computer System"

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "A button input"
ENT.Instructions = "Writes the value to a pin"


function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "Type") -- peripheral type, freeform
    self:NetworkVar("Entity", 0, "Parent") -- terminal or similar parent
    self:NetworkVar("String", 3, "Port") -- parent port
    self:NetworkVar("Bool", 0, "Active")
end

ENT.sounds = {
    
}