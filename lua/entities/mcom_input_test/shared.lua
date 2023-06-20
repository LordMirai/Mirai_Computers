ENT.Type = "anim"
ENT.Base = "mcom_peripheral_base" -- test if this works

ENT.PrintName = "Input tester"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "An input tester"
ENT.Instructions = "Black if not connected, green if true, red if false"


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