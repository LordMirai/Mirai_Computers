ENT.Type = "anim"
ENT.Base = "mcom_peripheral_base" -- test if this works

ENT.PrintName = "Monitor"
ENT.Category = "Mirai Computer System"

ENT.Spawnable = true -- set this to false in template
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "A peripheral template"
ENT.Instructions = "Wire up and use"


function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Serial")
    self:NetworkVar("String", 1, "MAC")
    self:NetworkVar("String", 2, "Type") -- peripheral type, freeform
    self:NetworkVar("Entity", 0, "Parent") -- terminal or similar parent
    self:NetworkVar("String", 3, "Port") -- parent port
    self:NetworkVar("Bool", 0, "Active")
    self:NetworkVar("String", 4, "Text")
end

ENT.sounds = {
    
}