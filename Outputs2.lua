repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace:WaitForChild("Lives")
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer.PlayerGui

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/Howmany/refs/heads/main/UITransparant.lua"))() 
UI:updateCountdownText("Dellstorecpm")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local g = Rayfield:CreateWindow({
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

local homeTab = g:CreateTab("Home", 4483362458)
local statsSection = homeTab:CreateSection("Stats")
local totalCashParagraph = homeTab:CreateParagraph({Title = "Total Cash", Content = ""})
local totalEarningsParagraph = homeTab:CreateParagraph({Title = "Total Money Earned", Content = ""})

shared.ClientTime = homeTab:CreateParagraph({Title = "Elapsed Farming Time", Content = "You Haven't Start AutoFarming"})
shared.ClientInformation = homeTab:CreateParagraph({Title = "Status", Content = "AutoFarm Is Idle"})

task.spawn(function()
    while task.wait() do
        shared.TotalCash = PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
        shared.TotalEarnings = PlayerGui.PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value.Text
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            totalCashParagraph:Set({Title = "Total Cash", Content = shared.TotalCash})
            UI:updateTotalEarningsText(shared.TotalEarnings)
            totalEarningsParagraph:Set({Title = "Total Cash", Content = shared.TotalEarnings})
        end)
    end
end)

shared.FarmConfig = {
    TargetMoney = 9999999999999999999,
    webhookLinks = "N/A",
    TeleportCooldown = 50,
    ElapsedTime = ""
}

local mainTab = g:CreateTab("Main")
mainTab:CreateSection("Farm Configuration")
mainTab:CreateInput({
    Name = "Target Cash",
    PlaceholderText = tostring(shared.FarmConfig.TargetMoney),
    RemoveTextAfterFocusLost = false,
    Callback = function(a) shared.FarmConfig.TargetMoney = tonumber(a) end
})
mainTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "N/A",
    RemoveTextAfterFocusLost = false,
    Callback = function(a) shared.FarmConfig.webhookLinks = a end
})
mainTab:CreateInput({
    Name = "Teleport Wait Time",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(a) shared.FarmConfig.TeleportCooldown = tonumber(a) end
})

mainTab:CreateSection("Auto Farming")
mainTab:CreateButton({
    Name = "Start Autofarm",
    Callback=function()
        task.spawn(function()
            PerformAction("sTimer")
        end
    )
        PerformAction("FireJob")
        task.wait(0.5)
        shared.ClientInformation:Set({
            Title = "Status",
            Content = "Getting Job"
        })
        f:updateDestinationText("Getting Job")
        PerformAction("setDestinationToSemarang")
        task.wait(0.5)
        shared.ClientInformation:Set({
            Title = "Status",
            Content = "Set Destination"
        })
        f:updateDestinationText("Set Destination")
        PerformAction("SpawnMinigunTruck")
        task.wait(0.5)
        PerformAction("newFarming")
    end
})

mainTab:CreateSection("Game")
mainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6911148748, LocalPlayer)
    end
})

function CarTween(targetCFrame, callback)
    local cFrameValue = Instance.new("CFrameValue")
    cFrameValue.Parent = workspace
    local vehicle = workspace.Vehicles:FindFirstChild(LocalPlayer.Name .. "sCar")
    
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
    local ownsGamePass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
    
    local cashText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text
    local frameText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
    local cleanedFrameText = cleanMoneyString(frameText)
    local cleanedCashText = cleanMoneyString(cashText)
    
    local formattedFrameText = formatRupiah(cleanedFrameText)
    local formattedTargetMoney = formatRupiah(shared.FarmConfig.TargetMoney)
    
    local hours, minutes, seconds = estimateTime(cleanedFrameText, shared.FarmConfig.TargetMoney, cleanedCashText)
    local estimatedTimeString = string.format("```%d Hours, %d Minutes, %d Seconds```", hours, minutes, seconds)
    
    local logDateTime = getCurrentDateTime()
    
    local webhookUrl
    if shared.FarmConfig.webhookLinks == "N/A" then
        webhookUrl = "https://discord.com/api/webhooks/1307291627869700097/mkN_JskJJ6tg2AdNgICrA3x6czl1u3iLqBSqsK-ACpvhej2189PquNrrqWDH8c9YrNqM"
    else
        webhookUrl = shared.FarmConfig.webhookLinks
    end
    
    local fields = {
        {name = "Webhook Name", value = string.format(player.Name), inline = true},
        {name = "Cash", value = string.format(Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text), inline = true},
        {name = "Money Earned", value = shared.TotalEarnings, inline = false},
        {name = "Elapsed Time", value = shared.FarmConfig.ElapsedTime}
    }
    
    local estimatedTimeField = {
        ["name"] = ownsGamePass and "Estimated Time [GP]" or "Estimated Time [Non GP]",
        ["value"] = (shared.FarmConfig.TargetMoney < cleanedFrameText) and "```Target have been reached```" or string.format("%s", estimatedTimeString),
        ["inline"] = true
    }
    
    local embed = {
        title = 'DELLSTORE HUB',
        url = 'https://discord.gg/QZFHK4NrsK',
        color = tonumber(16777215),
        fields = fields,
        author = {name = "AutoFarming Logs", icon_url = ''},
        footer = {text = 'DELLSTORE HUB | ' .. logDateTime, icon_url = ''}
    }
    
    local estimatedTimeEmbed = {
        title = '',
        url = '',
        color = tonumber(16777215),
        fields = {estimatedTimeField}
    }
    
    local requestBody = {
        embeds = {embed, estimatedTimeEmbed}
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

function PerformAction(action)
    local player = Players.LocalPlayer
    
    if action == "FireJob" then
        FireJob()
    elseif action == "setDestinationToSemarang" then
        setDestinationToSemarang()
    elseif action == "SpawnMinigunTruck" then
        SpawnMinigunTruck()
    elseif action == "newFarming" then
        newFarming()
    end
end
