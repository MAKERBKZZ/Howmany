if game.CoreGui:FindFirstChild("AutoFarmUI") then game.CoreGui:FindFirstChild("AutoFarmUI"):Destroy() end

local UIMods = {}

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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
MainFrame.BackgroundTransparency = 0.4 -- Transparan
MainFrame.Size = UDim2.new(0, 300, 0, 215)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)

local mainFrameCorner = UICorner:Clone()
mainFrameCorner.Parent = MainFrame

-- Color gradient (background)
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
TitleLabel.Text = "Autofarm Information"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextScaled = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Initial color

-- InfoLabel properties
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(0, 200, 0, 20)
InfoLabel.Position = UDim2.new(0, 15, 0, 40)
InfoLabel.Text = "Information on your autofarm status"
InfoLabel.Font = Enum.Font.SciFi
InfoLabel.TextScaled = true
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Initial color

-- Function to create dynamic color change
local function createDynamicColor(instance)
    coroutine.wrap(function()
        while true do
            local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local goalColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            local tween = TweenService:Create(instance, tweenInfo, {BackgroundColor3 = goalColor})
            tween:Play()
            tween.Completed:Wait()
        end
    end)()
end

-- Apply dynamic color change to MainFrame, TitleLabel, and InfoLabel
createDynamicColor(MainFrame)
createDynamicColor(TitleLabel)
createDynamicColor(InfoLabel)

-- Setup function for sections
local function setupSection(section, text, position, size, font)
    section.BackgroundTransparency = 0.5
    section.Size = size
    section.Position = position
    section.Text = text .. "\nN/A"
    section.TextScaled = false
    section.TextSize = 14
    section.TextWrapped = true
    section.TextColor3 = Color3.fromRGB(255, 255, 255) -- Initial color
    section.Font = font
    section.Parent = MainFrame

    local corner = UICorner:Clone()
    corner.Parent = section

    -- Apply dynamic color change to each section
    createDynamicColor(section)
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

-- Functions to update sections text
function UIMods:updateTeleportText(newText)
    Sections.Teleport.Text = "Teleporting in\n" .. newText
end

function UIMods:updateDestinationText(newText)
    Sections.Destination.Text = "Destination\n" .. newText
end

function UIMods:updateCountdownText(newText)
    Sections.Countdown.Text = `discord.gg/{newText}`
end

function UIMods:updateTotalMoneyText(newText)
    Sections.TotalMoney.Text = "Total Money\n" .. newText
end

function UIMods:updateTotalTimeText(newText)
    Sections.TotalTime.Text = "Total Time\n" .. newText
end

function UIMods:updateTotalEarningsText(newText)
    Sections.TotalEarnings.Text = "Total Earning Money\n" .. newText
end

return UIMods
