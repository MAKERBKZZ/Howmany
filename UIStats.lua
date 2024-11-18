if game.CoreGui:FindFirstChild("AutoFarmUI") then game.CoreGui:FindFirstChild("AutoFarmUI"):Destroy() end

local UIMods = {}


local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "AutoFarmUI"
ScreenGui.Parent = game.CoreGui

-- MainFrame properties
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 0
MainFrame.Size = UDim2.new(0, 300, 0, 215)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)

local mainFrameCorner = UICorner:Clone()
mainFrameCorner.Parent = MainFrame

-- 	Color properties
local gradient = Instance.new("UIGradient")
gradient.Rotation = 90
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(172, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Parent = MainFrame

-- TitleLabel properties
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 0.5, 0, 10)
TitleLabel.Text = "Autofarm Panel"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextScaled = true
TitleLabel.TextColor3 = Color3.new(1, 1, 1)

-- InfoLabel properties
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(0, 200, 0, 20)
InfoLabel.Position = UDim2.new(0, 15, 0, 40)
InfoLabel.Text = "Information on your autofarm status"
InfoLabel.Font = Enum.Font.SciFi
InfoLabel.TextScaled = true
InfoLabel.TextColor3 = Color3.new(1, 1, 1)

local function setupSection(section, text, position, size, font)
	section.BackgroundTransparency = 0.5
	section.Size = size
	section.Position = position
	section.Text = text .. "\nN/A"
	section.TextScaled = false
	section.TextSize = 14
	section.TextWrapped = true
	section.TextColor3 = Color3.new(1, 1, 1)
	section.Font = font
	section.Parent = MainFrame

	local corner = UICorner:Clone()
	corner.Parent = section
end

-- Sections
local Sections = {
	Teleport = Instance.new("TextLabel"),
	Destination = Instance.new("TextLabel"),
	Countdown = Instance.new("TextLabel"),
	TotalMoney = Instance.new("TextLabel"),
	TotalTime = Instance.new("TextLabel"),
	TotalEarnings = Instance.new("TextLabel"),
}

-- Setup sections
setupSection(Sections.Teleport, "Teleporting in", UDim2.new(0, 10, 0, 70), UDim2.new(0, 115, 0, 40), Enum.Font.SourceSansBold)
setupSection(Sections.Destination, "Destination", UDim2.new(0, 130, 0, 70), UDim2.new(0, 160, 0, 40), Enum.Font.SourceSansBold)
setupSection(Sections.Countdown, "Countdown", UDim2.new(0, 10, 0, 115), UDim2.new(0, 75, 0, 40), Enum.Font.SourceSansBold)
setupSection(Sections.TotalMoney, "Total Money", UDim2.new(0, 90, 0, 115), UDim2.new(0, 200, 0, 40), Enum.Font.SourceSansBold)
setupSection(Sections.TotalTime, "Total Time", UDim2.new(0, 10, 0, 160), UDim2.new(0, 125, 0, 40), Enum.Font.SourceSansBold)
setupSection(Sections.TotalEarnings, "Total Earning Money", UDim2.new(0, 140, 0, 160), UDim2.new(0, 150, 0, 40), Enum.Font.SourceSansBold)

-- Drag Function
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

function UIMods:updateTeleportText(newText)
	Sections.Teleport.Text = "Teleporting in\n" .. newText
	warn('Vyvern On Top')
end

function UIMods:updateDestinationText(newText)
	Sections.Destination.Text = "Destination\n" .. newText
	warn('Vyvern On Top')
end

function UIMods:updateCountdownText(newText)
	Sections.Countdown.Text = `discord.gg/{newText}`
	warn('Vyvern On Top')
end

function UIMods:updateTotalMoneyText(newText)
	Sections.TotalMoney.Text = "Total Money\n" .. newText
	warn('Vyvern On Top')
end

function UIMods:updateTotalTimeText(newText)
	Sections.TotalTime.Text = "Total Time\n" .. newText
	warn('Vyvern On Top')
end

function UIMods:updateTotalEarningsText(newText)
	Sections.TotalEarnings.Text = "Total Earning Money\n" .. newText
	warn('Vyvern On Top')
end


return UIMods

-- Change text in here
--[[updateTeleportText("5 seconds")
updateDestinationText("New Location")
updateCountdownText("10")
updateTotalMoneyText("$1000")
updateTotalTimeText("2 hours")
updateTotalEarningsText("$2000")]]
