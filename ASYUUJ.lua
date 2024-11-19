repeat 
    task.wait() 
until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lives = workspace:WaitForChild("Lives")
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer.PlayerGui

local UITransparant = loadstring(game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/Howmany/refs/heads/main/UITransparant.lua"))()
UITransparant:updateCountdownText("Dellstorecpm")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "DELLSTORE HUB | Version 1.0.0",
    LoadingTitle = "DELLSTORE HUB | Version Beta",
    LoadingSubtitle = "By DELLSTORECPM",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },
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
local TotalMoneyParagraph = HomeTab:CreateParagraph({Title = "Total Money Earned", Content = ""})

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
            UITransparant:updateTotalEarningsText(shared.TotalEarnings)
            UITransparant:updateTotalMoneyText(shared.TotalCash)
            TotalMoneyParagraph:Set({Title = "Total Money Earned", Content = shared.TotalEarnings})
        end)
    end
end)

shared.FarmConfig = {
    TargetMoney = 9999999999999999999,
    webhookLinks = "N/A",
    TeleportCooldown = 50,
    ElapsedTime = ""
}

local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Farm Configuration")
MainTab:CreateInput({
    Name = "Target Cash",
    PlaceholderText = tostring(shared.FarmConfig.TargetMoney),
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        shared.FarmConfig.TargetMoney = tonumber(input)
    end
})

MainTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "N/A",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        shared.FarmConfig.webhookLinks = input
    end
})

MainTab:CreateInput({
    Name = "Teleport Wait Time",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        shared.FarmConfig.TeleportCooldown = tonumber(input)
    end
})

MainTab:CreateSection("Auto Farming")
MainTab:CreateButton({
    Name = "Start Autofarm",
    Callback = function()
        task.spawn(function()
            PerformAction("sTimer")
        end)
        PerformAction("FireJob")
        task.wait(0.5)
        shared.ClientInformation:Set({Title = "Status", Content = "Getting Job"})
        UITransparant:updateDestinationText("Getting Job")
        PerformAction("setDestinationToSemarang")
        task.wait(0.5)
        shared.ClientInformation:Set({Title = "Status", Content = "Set Destination"})
        UITransparant:updateDestinationText("Set Destination")
        PerformAction("SpawnMinigunTruck")
        task.wait(0.5)
        PerformAction("newFarming")
    end
})

MainTab: CreateSection("Game")
MainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6911148748, game.Players.LocalPlayer)
    end
})

function CarTween(targetCFrame, callback)
    local cFrameValue = Instance.new("CFrameValue")
    cFrameValue.Parent = workspace
    local vehicle = workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name .. "sCar")
    
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
    
    local cashText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text
    local frameText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
    local cleanedFrameText = cleanMoneyString(frameText)
    local cleanedCashText = cleanMoneyString(cashText)
    local formattedFrameText = formatRupiah(cleanedFrameText)
    local formattedTargetMoney = formatRupiah(shared.FarmConfig.TargetMoney)
    
    local hours, minutes, seconds = estimateTime(cleanedFrameText, shared.FarmConfig.TargetMoney, cleanedCashText)
    local estimatedTimeString = string.format("```%d Hours, %d Minutes, %d Seconds```", hours, minutes, seconds)
    
    local function getCurrentDateTime()
        local date = os.date("%d/%m/%Y")
        local time = os.date("%I:%M %p")
        return "📅 Date " .. date .. " ⏰ Time " .. time
    end
    
    function LogHook(logMessage)
        local currentDateTime = getCurrentDateTime()
        local webhookUrl = shared.FarmConfig.webhookLinks == "N/A" and 
            "https://discord.com/api/webhooks/1307291627869700097/mkN_JskJJ6tg2AdNgICrA3x6czl1u3iLqBSqsK-ACpvhej2189PquNrrqWDH8c9YrNqM" or 
            shared.FarmConfig.webhookLinks
        
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
            footer = {text = 'DELLSTORE HUB | ' .. currentDateTime, icon_url = ''}
        }
        
        local secondEmbed = {
            title = '',
            url = '',
            color = tonumber(16777215),
            fields = {estimatedTimeField}
        }
        
        local requestBody = game:GetService('HttpService'):JSONEncode({embeds = {embed, secondEmbed}})
        local request = (syn and syn.request or http_request)({
            Url = webhookUrl,
            Method = 'POST',
            Headers = {['Content-Type'] = 'application/json'},
            Body = requestBody
        })
    end
    
    LogHook(estimatedTime ) 
end

function PerformAction(action)
    local player = game.Players.LocalPlayer

    function Tween(targetCFrame)
        local humanoidRootPart = player.Character.HumanoidRootPart
        repeat
            if not humanoidRootPart or not targetCFrame then
                print("Error: HumanoidRootPart or targetCFrame is missing")
            end
        until humanoidRootPart and targetCFrame
        
        TweenService:Create(humanoidRootPart, TweenInfo.new(0.5), {CFrame = targetCFrame}):Play()
    end

    function GetWaypointName()
        local waypoint = assert(game.Workspace.Etc.Waypoint.Waypoint, "Waypoint not found!")
        local waypointLabel = assert(waypoint:FindFirstChild("BillboardGui") and waypoint.BillboardGui:FindFirstChild("TextLabel"), "Waypoint label not found!")
        return waypointLabel.Text
    end

    function cleanMoneyString(moneyString)
        return moneyString:gsub("RP. ", ""):gsub(",", ""):gsub("%.", ""):gsub("+", "")
    end

    function formatRupiah(amount)
        amount = math.floor(amount)
        local amountStr = tostring(amount)
        local formattedStr = ""
        local count = 0
        
        for i = #amountStr, 1, -1 do
            formattedStr = amountStr:sub(i, i) .. formattedStr
            count = count + 1
            if count % 3 == 0 and i ~= 1 then
                formattedStr = "," .. formattedStr
            end
        end
        
        return "RP. " .. formattedStr
    end

    function estimateTime(currentAmount, targetAmount, elapsedAmount)
        local difference = targetAmount - currentAmount
        if difference <= 0 then return 0, 0, 0 end
        
        local estimatedTime = math.ceil(difference / elapsedAmount) * 50
        return math.floor(estimatedTime / 3600), math.floor((estimatedTime % 3600) / 60), math.floor(estimatedTime % 60)
    end

    function safelyTeleportCar(car, targetCFrame)
        if not car or not targetCFrame then return end
        
        local success, errorMessage = pcall(function()
            car:SetPrimaryPartCFrame(targetCFrame)
            game.Workspace.Gravity = -5
            wait(1)
            game.Workspace.Gravity = 500
            wait(0.5)
            car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
            car.PrimaryPart.AngularVelocity = Vector3.new(0, 0, 0)
        end)
        
        if not success then
            warn("Error teleporting car: " .. errorMessage)
        end
        
        local cashText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text
        local frameText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
        local cleanedFrameText = cleanMoneyString(frameText)
        local cleanedCashText = cleanMoneyString(cashText)
        local hours, minutes, seconds = estimateTime(cleanedFrameText, shared.FarmConfig.TargetMoney, cleanedCashText)
        sendLog()
    end

    function FireJob()
        recallJob()
        game.Workspace.Gravity = 10
        wait(0.5)
        game.Workspace.Gravity = 0
        local targetCFrame = CFrame.new(-21799.8, 1042.65, -26797.7)
        Tween(targetCFrame)
        game.Workspace.Gravity = 10
    end

    function setDestinationToSemarang()
        repeat
            wait(1)
            local waypoint = game.Workspace.Etc.Waypoint:FindFirstChild("Waypoint")
            local waypointLabel = waypoint:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")
            if waypointLabel.Text ~= "Rojod Semarang" then
                recallJob()
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
            end
        until waypointLabel.Text == "Rojod Semarang"
    end

    function SpawnMinigunTruck()
        task.wait()
        local spawnerPosition = game.Workspace.Etc.Job.Truck.Spawner.Part.Position
        Tween(CFrame.new(spawnerPosition))
        fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)
        wait(0.5)
        fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)
        wait(3)
        
        repeat
            wait(1)
            local car = workspace.Vehicles:WaitForChild(Players.Local Player.Name .. "sCar"):FindFirstChild("Cost")
            if not car then
                repeat wait() until car
            end
            if car.Value ~= 401000 then
                fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)
            end
        until car.Value == 401000
        
        local playerCar = workspace.Vehicles:FindFirstChild(Players.LocalPlayer.Name .. "sCar")
        wait(2)
        playerCar.DriveSeat:Sit(Players.LocalPlayer.Character.Humanoid)
        shared.ClientInformation:Set({Title = "Status", Content = "Spawned Minigun truck"})
        UITransparant:updateDestinationText("Spawned Minigun Truck")
        print("Truck ready to teleport")
    end

    function settingsDestinationTwo()
        local isActive = false
        local playerCar = workspace.Vehicles:FindFirstChild(Players.LocalPlayer.Name .. "sCar")
        playerCar:SetPrimaryPartCFrame(CFrame.new(-21799.8, 1042.65, -26797.7))
        
        repeat
            wait(1)
            local waypoint = game.Workspace.Etc.Waypoint:FindFirstChild("Waypoint")
            local waypointLabel = waypoint:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")
            if waypointLabel.Text ~= "Rojod Semarang" then
                recallJob()
                fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)
                game.Workspace.Gravity = 10
            end
        until waypointLabel.Text == "Rojod Semarang"
    end

    function newFarming()
        local workspaceService = game:GetService("Workspace")
        local playerCar = workspaceService.Vehicles:FindFirstChild(Players.LocalPlayer.Name .. "sCar")
        
        task.spawn(function()
            while wait() do
                local character = Players.LocalPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if not humanoid or humanoid.SeatPart == nil or humanoid.SeatPart.Name ~= "DriveSeat" then
                    return
                end
                
                local cashText = Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
                local cleanedCashText = cleanMoneyString(cashText)
                local currentCash = tonumber(cleanedCashText)
                
                if shared.FarmConfig.TargetMoney <= currentCash then
                    sendLog()
                    break
                end
                
                countdown(shared.FarmConfig.TeleportCooldown)
                local waypointName = GetWaypointName()
                local waypointLabel = workspaceService.Etc.Waypoint.Waypoint:FindFirstChild("BillboardGui")
                local waypointText = waypointLabel and waypointLabel.TextLabel.Text
                
                CarTween(CFrame.new(-50889.6602, 1017.86719, -86514.7969), function()
                    shared.ClientInformation:Set({Title = "Status", Content = "Started new farm"})
                    UITransparant:updateDestinationText("Started New Farm")
                end)
                
                wait(1)
                local currentWaypointName = GetWaypointName()
                if currentWaypointName == "Silambat Palimanan" or currentWaypointName == "PT.CDID Cargo Cirebon" then
                    print("destination is Silambat Palimanan or PT.CDID Cargo Cirebon")
                    countdown(shared.FarmConfig.TeleportCooldown)
                    if currentWaypointName == "Silambat Palimanan" then
                        local waypointPosition = workspaceService.Etc.Waypoint.Waypoint.Position
                        CarTween(CFrame.new(waypointPosition))
                    else
                        CarTween(CFrame.new(-21803.8867, 1046.98877, -27817.0586, 0, 0, -1, 0, 1, 0, 1, 0, 0))
                    end
                    task.wait(2)
                    local finalWaypointName = GetWaypointName()
                    if finalWaypointName == "Rojod Semarang" then
                        print("destination is Rojod Semarang")
                        countdown(shared.FarmConfig.TeleportCooldown)
                        CarTween(CFrame.new(-50889.6602, 1017.86719, -86514.7969))
                        task.wait(2)
                    else
                        print("destination is not Rojod Semarang")
                    end
                else
                    print("destination is not Silambat Palimanan or PT.CDID Cargo Cirebon")
                end
                
                task.wait(0.5)
                settingsDestinationTwo()
            end
        end)
    end

    function countdown(seconds)
        for i = seconds, 0, -1 do
            UITranspar ```lua
            UITransparant:updateTeleportText(tostring(i) .. " seconds")
            task.wait(1)
        end
        UITransparant:updateTeleportText("")
    end

    function sTimer()
        local startTime = tick()
        while task.wait() do
            local elapsedTime = tick() - startTime
            local hours = math.floor(elapsedTime / 3600)
            local minutes = math.floor((elapsedTime % 3600) / 60)
            local seconds = math.floor(elapsedTime % 60)
            local formattedTime = string.format("%02d.%02d.%02d", hours, minutes, seconds)
            shared.FarmConfig.ElapsedTime = formattedTime
            UITransparant:updateTotalTimeText(formattedTime)
            shared.ClientTime:Set({Title = "Elapsed Farming Time", Content = formattedTime})
        end
    end

    function recallJob()
        local jobArgs = {"Truck"}
        game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer(unpack(jobArgs))
    end

    if action == "FireJob" then
        FireJob()
    elseif action == "setDestinationToSemarang" then
        setDestinationToSemarang()
    elseif action == "SpawnMinigunTruck" then
        SpawnMinigunTruck()
    elseif action == "settingsDestinationTwo" then
        settingsDestinationTwo()
    elseif action == "newFarming" then
        newFarming()
    elseif action == "countdown" then
        countdown(shared.FarmConfig.TeleportCooldown)
    elseif action == "sTimer" then
        sTimer()
    elseif action == "recallJob" then
        recallJob()
    end
end

task.spawn(function()
    while task.wait() do
        local humanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if not humanoidRootPart then
            task.wait(1)
            print("HumanoidRootPart is nil")
        end
    end
end)

local function onChildAdded(child)
    if child.Name == Players.LocalPlayer.Name then
        PerformAction("FireJob")
        task.wait(0.5)
        PerformAction("setDestinationToSemarang")
        task.wait(0.5)
        PerformAction("SpawnMinigunTruck")
        task.wait(0.5)
        PerformAction("newFarming")
    end
end

local function onChildRemoved(child)
    if child.Name == Players.LocalPlayer.Name then
        print(Players.LocalPlayer.Name .. " has been removed")
    end
end

workspace.ChildAdded:Connect(onChildAdded)
workspace.ChildRemoved:Connect(onChildRemoved)

local function setupIdleDetection()
    local idleConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
    end)
end

setupIdleDetection()
