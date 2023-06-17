include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

-- temporary computer terminal for testing, before the full computer is implemented
-- will write stdout to CHAT, without much formatting, until display exists

function ENT:tempMenu()

	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 70)
	frame:Center()
	frame:SetTitle("[MCom] Computer Terminal - WIP")
	frame:MakePopup()

	local text = vgui.Create("DTextEntry", frame)
	text:SetSize(350, 30)
	text:SetPos(25, 30)
	text:SetPlaceholderText("Enter command here")

	text.OnEnter = function()
		local cmd = text:GetValue()
		cmd = string.Trim(cmd)
		MCom.net.terminalCommand(LocalPlayer(),self,cmd)
		text:SetText("")
		text:RequestFocus()
	end

	function frame:OnClose()
		MCom.net.terminalClose(self)
	end
end
