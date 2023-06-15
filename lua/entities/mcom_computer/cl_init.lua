include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

-- temporary computer terminal for testing, before the full computer is implemented
-- will write stdout to CHAT, without much formatting, until display exists

function ENT:tempMenu()

	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 1000)
	frame:Center()
	frame:SetTitle("[MCom] Computer Terminal - WIP")
	frame:MakePopup()

	local text = vgui.Create("DTextEntry", frame)
	text:SetSize(400, 30)
	text:SetPos(50, 50)
	text:SetPlaceholderText("Enter command here")

	function text:OnEnter()
		local cmd = self:GetValue()
		cmd = string.Trim(cmd)
		MCom.net.terminalCommand(LocalPlayer(),self,cmd)
	end

	function frame:OnClose()
		MCom.net.terminalClose(self)
	end
end