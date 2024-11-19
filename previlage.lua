-- discord.gg/boronide, code generated using luamin.js™

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lives = workspace:WaitForChild("Lives")
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer.PlayerGui

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/Howmany/refs/heads/main/UITransparant.lua"))()
UI:updateCountdownText("Dellstorecpm")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "DELLSTORE HUB | Version 1.0.0",
    LoadingTitle = "DELLSTORE HUB | Version Beta",
    LoadingSubtitle = "By DELLSTORECPM",
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "Big Hub"},
    KeySystem = true,
    KeySettings = {
        Title = "DELLSTORE HUB | Version Beta",
        Subtitle = "Key System",
        Note = "Join the discord to get the key !!",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"CMZSTORE", "vyvernisacutie"}
    }
})

shared.TotalCash = "0"
shared.TotalEarnings = "0"

local HomeTab = Window:CreateTab("Home", 4483362458)
local StatsSection = HomeTab:CreateSection("Stats")
local TotalCashParagraph = HomeTab:CreateParagraph({Title = "Total Cash", Content = ""})
local TotalEarningsParagraph = HomeTab:CreateParagraph({Title = "Total Money Earned", Content = ""})
shared.ClientTime = HomeTab:CreateParagraph({Title = "Elapsed Farming Time", Content = "You Haven't Start AutoFarming"})
shared.ClientInformation = HomeTab:CreateParagraph({Title = "Status", Content = "AutoFarm Is Idle"})

task.spawn(function()
    while task.wait() do
        shared.TotalCash = PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
        shared.TotalEarnings = PlayerGui.PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value.Text
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            TotalCashParagraph:Set({Title = "Total Cash", Content = shared.TotalCash})
            UI:updateTotalEarningsText(shared.TotalEarnings)
            UI:updateTotalMoneyText(shared.TotalCash)
            TotalEarningsParagraph:Set({Title = "Total Cash", Content = shared.TotalEarnings})
        end)
    end
end)

shared.FarmConfig = {
    TargetMoney = 9999999999999999999,
    webhookLinks = "N/A",
    TeleportCooldown = 50,
    ElapsedTime = ""
}

local MainTab = Rayfield:CreateTab("Main")
MainTab:CreateSection("Farm Configuration")
MainTab:CreateInput({
    Name = "Target Cash",
    PlaceholderText = tostring(shared.FarmConfig.TargetMoney),
    RemoveTextAfterFocusLost = false,
    Callback = function(value) shared.FarmConfig.TargetMoney = tonumber(value) end
})
MainTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "N/A",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) shared.FarmConfig.webhookLinks = value end
})
MainTab:CreateInput({
    Name = "Teleport Wait Time",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) shared.FarmConfig.TeleportCooldown = tonumber(value) end
})

MainTab:CreateSection("Auto Farming")
MainTab:CreateButton({
    Name = "Start Autofarm",
    Callback = function()
        task.spawn(function() PerformAction("sTimer") end)
        PerformAction("FireJob")
        task.wait(0.5)
        shared.ClientInformation:Set({Title = "Status", Content = "Getting Job"})
        UI:updateDestinationText("Getting Job")
        PerformAction("setDestinationToSemarang")
        task.wait(0.5)
        shared.ClientInformation:Set({Title = "Status", Content = "Set Destination"})
        UI:updateDestinationText("Set Destination")
        PerformAction("SpawnMinigunTruck")
        task.wait(0.5)
        PerformAction("newFarming")
    end
})

MainTab:CreateSection("Game")
 MainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6911148748, Players.LocalPlayer)
    end
})

function CarTween(targetCFrame, callback)
    local cFrameValue = Instance.new("CFrameValue")
    cFrameValue.Parent = workspace
    local vehicle = workspace.Vehicles:FindFirstChild(Players.LocalPlayer.Name .. "sCar")
    
    if not vehicle then
        warn("Vehicle not found.")
        return
    end
    
    local tweenInfo = TweenInfo.new(50, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0)
    cFrameValue.Value = vehicle:GetPivot()
    local tween = TweenService:Create(cFrameValue, tweenInfo, {Value = targetCFrame})
    tween:Play()
    
    cFrameValue.Changed:Connect(function(newCFrame)
        vehicle:PivotTo(newCFrame)
    end)
    
    tween.Completed:Wait()
    sendLog()
    
    if callback then
        callback()
    end
    
    cFrameValue:Destroy()
end

function sendLog()
    local MarketplaceService = game:GetService("MarketplaceService")
    local gamePassId = 37328594
    local player = Players.LocalPlayer
    local ownsGamePass = MarketplaceService:User OwnsGamePassAsync(player.UserId, gamePassId)
    
    local currentCash = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text
    local totalCash = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
    local cleanedTotalCash = cleanMoneyString(totalCash)
    local cleanedCurrentCash = cleanMoneyString(currentCash)
    local formattedTotalCash = formatRupiah(cleanedTotalCash)
    local formattedTargetMoney = formatRupiah(shared.FarmConfig.TargetMoney)
    local hours, minutes, seconds = estimateTime(cleanedTotalCash, shared.FarmConfig.TargetMoney, cleanedCurrentCash)
    local estimatedTimeString = string.format("```%d Hours, %d Minutes, %d Seconds```", hours, minutes, seconds)
    
    local webhookUrl = shared.FarmConfig.webhookLinks == "N/A" and 
        "https://discord.com/api/webhooks/1307291627869700097/mkN_JskJJ6tg2AdNgICrA3x6czl1u3iLqBSqsK-ACpvhej2189PquNrrqWDH8c9YrNqM" or 
        shared.FarmConfig.webhookLinks
    
    local embedFields = {
        {name = "Webhook Name", value = string.format(player.Name), inline = true},
        {name = "Cash", value = string.format(Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text), inline = true},
        {name = "Money Earned", value = shared.TotalEarnings, inline = false},
        {name = "Elapsed Time", value = shared.FarmConfig.ElapsedTime}
    }
    
    local estimatedTimeField = {
        ["name"] = ownsGamePass and "Estimated Time [GP]" or "Estimated Time [Non GP]",
        ["value"] = (shared.FarmConfig.TargetMoney < cleanedTotalCash) and "```Target have been reached```" or string.format("%s", estimatedTimeString),
        ["inline"] = true
    }
    
    local embed = {
        title = 'DELLSTORE HUB',
        url = 'https://discord.gg/QZFHK4NrsK',
        color = tonumber(16777215),
        fields = embedFields,
        author = {name = "AutoFarming Logs", icon_url = ''},
        footer = {text = 'DELLSTORE HUB | ' .. getCurrentDateTime(), icon_url = ''}
    }
    
    local additionalEmbed = {
        title = '',
        url = '',
        color = tonumber(16777215),
        fields = {estimatedTimeField}
    }
    
    local requestBody = {
        embeds = {embed, additionalEmbed}
    }
    
    local request = (syn and syn.request or http_request)({
        Url = webhookUrl,
        Method = 'POST',
        Headers = {['Content-Type'] = 'application/json'},
        Body = game:GetService('HttpService'):JSONEncode(requestBody)
    })
end

function getCurrentDateTime()
    local date = os.date("%d/%m/%Y")
    local time = os.date("%I:%M %p")
    return "📅 Date " .. date .. " ⏰ Time " .. time
end

-- Additional functions and logic can be added here as needed

task.spawn(function()
    while task.wait() do
        local humanoidRootPart = Players.Local Player.Character:WaitForChild("HumanoidRootPart")
        if not humanoidRootPart then
            task.wait(1)
            print("HumanoidRootPart is nil")
        end
    end
end)

local function onPlayerAdded(player)
    if player.Name == LocalPlayer.Name then
        PerformAction("FireJob")
        task.wait(0.5)
        PerformAction("setDestinationToSemarang")
        task.wait(0.5)
        PerformAction("SpawnMinigunTruck")
        task.wait(0.5)
        PerformAction("newFarming")
    end
end

local function onPlayerRemoved(player)
    if player.Name == LocalPlayer.Name then
        print(LocalPlayer.Name .. " has been removed")
    end
end

Players.ChildAdded:Connect(onPlayerAdded)
Players.ChildRemoved:Connect(onPlayerRemoved)

local function preventIdle()
    local idleConnection = Players.LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
    end)
end

preventIdle()
