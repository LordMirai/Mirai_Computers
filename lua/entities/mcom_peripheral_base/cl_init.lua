include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:IOConfiguration(comp)
	local ply = LocalPlayer()
	local frame = vgui.Create("DFrame")
	local title = string.format("IO Configuration - %s - %s", self:GetSerial(), self:GetType())
	frame:SetSize(300, 200)
	frame:SetTitle(title)
	frame:Center()
	frame:MakePopup()
	
	-- when patience arrives, have 2 lists, one for perip inputs and one for comp outputs. LAZY LOAD
	local inputs = vgui.Create("DScrollPanel", frame)
	inputs:SetSize(140, 150)
	inputs:SetPos(10, 20)


	local outputs = vgui.Create("DScrollPanel", frame)
	outputs:SetSize(140, 150)
	outputs:SetPos(150, 20)

	
	local btn = vgui.Create("DButton", frame)
	btn:SetText("Save")
	btn:SetSize(100, 25)
	btn:SetPos(10, 175)
	function btn:Doclick()

	end

	local btn2 = vgui.Create("DButton", frame)
	btn2:SetText("Close")
	btn2:SetSize(100, 25)
	btn2:SetPos(190, 175)
	function btn2:Doclick()
		frame:Close()
	end

	function inputs.populate(tblIn)
		inputs.Clear()
		
		local lb = vgui.Create("DLabel", inputs)
		lb:SetText("Inputs")
		lb:SetSize(100, 25)
		lb:SetPos(10, 10)
		lb:SetTextColor(MCom.Colors.GreenLight)
		lb:SetFont("CloseCaption_Normal")

		for k,v in pairs(tblIn) do
			local btn = vgui.Create("DButton", inputs)
			btn:SetText(v)
			btn:SetSize(100, 25)
			btn:SetPos(10, 40 + (k * 30))
			function btn:Doclick()
				-- TBI
			end
		end
	end

	function outputs.populate(tblOut)
		outputs.Clear()

		local lb = vgui.Create("DLabel", outputs)
		lb:SetText("Outputs")
		lb:SetSize(100, 25)
		lb:SetPos(10, 10)
		lb:SetTextColor(MCom.Colors.RedLight)
		lb:SetFont("CloseCaption_Normal")

		for k,v in pairs(tblOut) do
			local btn = vgui.Create("DButton", outputs)
			btn:SetText(v)
			btn:SetSize(100, 25)
			btn:SetPos(10, 40 + (k * 30))
			function btn:Doclick()
				-- TBI
			end
		end
	end


	MCom.activeIOConfig = frame -- toplevel for IO config. used for lazy loading

	MCom.requestInputs(self)
	MCom.requestOutputs(comp)
end