include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.color = MCom.Colors.Indigo
	self.dirty = true -- Force update

	self.charLimit = 200 -- change if needed, this is placeholder

	self:CreateScreen()
end

local function lineBreak(txt)
	local words = string.Explode(" ", txt)
	local lines = {}
	local line = ""
	for i, word in ipairs(words) do
		if surface.GetTextSize(line .. word) > self.charLimit then
			table.insert(lines, line)
			line = ""
		end
		line = line .. word .. " "
	end
	
	return string.Implode("\n", lines)
end

function ENT:DrawTranslucent(fl)
	self:Draw(fl) -- default draw

	if self.dirty then
		self.dirty = false
		self:CreateScreen()
	end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(self:GetPos() + self:GetUp() * 10, ang, 0.1)
		surface.SetDrawColor(self.color)
		surface.DrawTexturedRect(0, 0, 512, 512)

		-- Draw text
		local text = lineBreak(self:GetText())
		if text and text ~= "" then
			draw.SimpleText(text, "Default", 256, 256, MCom.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end


function ENT:CreateScreen()
	if not self.screen then
		self.screen = GetRenderTarget("MCom_monitor_" .. self:EntIndex(), 512, 512, false)
	end

	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget(self.screen)
	render.Clear(0, 0, 0, 255, true)
	render.SetViewPort(0, 0, 512, 512)
	cam.Start2D()
	
	-- Draw colored rectangle
	surface.SetDrawColor(self.color)
	surface.DrawRect(0, 0, 512, 512)
	
	-- Draw text
	local text = lineBreak(self:GetText())
	surface.SetTextColor(Color(255, 255, 255))
	surface.SetFont("Default")
	local textWidth, textHeight = surface.GetTextSize(text)
	local textX = (512 - textWidth) / 2
	local textY = (512 - textHeight) / 2
	surface.SetTextPos(textX, textY)
	surface.DrawText(text)
	
	cam.End2D()
	render.SetRenderTarget(oldRT)
	render.SetViewPort(0, 0, ScrW(), ScrH())
end



net.Receive("MCom_monitor_changeColor", function()
	local ent = net.ReadEntity()
	local color = net.ReadColor()
	if IsValid(ent) then
		ent.color = color
		ent.dirty = true
	end
end)
