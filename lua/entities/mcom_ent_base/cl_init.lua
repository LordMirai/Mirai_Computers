include("shared.lua")

function ENT:initCL()

end

function ENT:Initialize()
	self:initCL()
	self.shouldDraw = true
end

function ENT:Draw()
	if self.shouldDraw then
		self:DrawModel()
	end
end