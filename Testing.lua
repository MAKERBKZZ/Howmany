
-- Improved version of the code

-- Services
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/Howmany/refs/heads/main/UITransparant.lua"))() 
UI:updateCountdownText("Dellstorecpm")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
-- Variables
local localPlayer = players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local workspace = game.Workspace
local vehicles = workspace.Vehicles

-- Functions
local function cleanMoneyString(str)
    return str:gsub("RP. ", ""):gsub(",", ""):gsub("%.", ""):gsub("+", "")
end

local function formatRupiah(num)
    num = math.floor(num)
    local str = tostring(num)
    local result = ""
    local count = 0
    for i = #str, 1, -1 do
        result = str:sub(i, i) .. result
        count = count + 1
        if count % 3 == 0 and i ~= 1 then
            result = "," .. result
        end
    end
    return "RP. " .. result
end

local function estimateTime(current, target, earnings)
    local diff = target - current
    if diff <= 0 then
        return 0, 0, 0
    end
    local time = math.ceil(diff / earnings) * 50
    return math.floor(time / 3600), math.floor((time % 3600) / 60), math.floor(time % 60)
end

local function safelyTeleportCar(car, cframe)
    if not car or not cframe then
        return
    end
    local success, err = pcall(function()
        car:SetPrimaryPartCFrame(cframe)
        workspace.Gravity = -5
        wait(1)
        workspace.Gravity = 500
        wait(0.5)
        car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
        car.PrimaryPart.AngularVelocity = Vector3.new(0, 0, 0)
    end)
    if not success then
        warn("Error teleporting car: " .. err)
    end
end

local function sendLog()
    local marketplaceService = game:GetService("MarketplaceService")
    local gamepassId = 37328594
    local player = players.LocalPlayer
    local hasGamepass = marketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
    local cash = playerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
    local earnings = playerGui.Main.Container.Hub.CashFrame.TextLabel.Text
    local cleanCash = cleanMoneyString(cash)
    local cleanEarnings = cleanMoneyString(earnings)
    local formattedCash = formatRupiah(cleanCash)
    local formattedEarnings = formatRupiah(cleanEarnings)
    local hours, minutes, seconds = estimateTime(cleanCash, shared.FarmConfig.TargetMoney, cleanEarnings)
    local time = string.format("%d Hours, %d Minutes, %d Seconds", hours, minutes, seconds)
    local log = {
        title = "DELLSTORE HUB",
        url = "https://discord.gg/QZFHK4NrsK",
        color = 16777215,
        fields = {
            { name = "Webhook Name", value = player.Name, inline = true },
            { name = "Cash", value = cash, inline = true },
            { name = "Money Earned", value = earnings, inline = false },
            { name = "Elapsed Time", value = shared.FarmConfig.ElapsedTime }
        },
        author = { name = "AutoFarming Logs", icon_url = "" },
        footer = { text = "DELLSTORE HUB | " .. getCurrentDateTime(), icon_url = "" }
    }
    local estimatedTime = {
        title = "",
        url = "",
        color = 16777215,
        fields = {
            { name = hasGamepass and "Estimated Time [GP]" or "Estimated Time [Non GP]", value = (shared.FarmConfig.TargetMoney < cleanCash) and "Target have been reached" or time, inline = true }
        }
    }
    local request = (syn and syn.request or http_request)({
        Url = shared.FarmConfig.webhookLinks,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode({ embeds = { log, estimatedTime } })
    })
end

local function getCurrentDateTime()
    local date = os.date("%d/%m/%Y")
    local time = os.date("%I:%M %p")
    return "📅 Date " .. date .. " ⏰ Time " .. time
end

local function PerformAction(action)
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
    elseif action == "cwaypoint" then
        countdown(shared.FarmConfig.TeleportCooldown)
    elseif action == "sTimer" then
        sTimer()
    elseif action == "recallJob" then
        recallJob()
    end
end

local function FireJob()
    recallJob()
    workspace.Gravity = 10
    wait(0.5)
    workspace.Gravity = 0
    local cframe = CFrame.new(-21799.8, 1042.65, -26797.7)
    Tween(cframe)
    workspace.Gravity = 10
end

local function setDestinationToSemarang()
    repeat
        wait(1)
        local waypoint = workspace.Etc.Waypoint:FindFirstChild("Waypoint")
        local textLabel = waypoint:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")
        if textLabel.Text ~= "Rojod Semarang" then
            recallJob()
            fireproximityprompt(workspace.Etc.Job.Truck.Starter.Prompt)
        end
    until textLabel.Text == "Rojod Semarang"
end

local function SpawnMinigunTruck()
    task.wait()
    local spawner = workspace.Etc.Job.Truck.Spawner
    local part = spawner.Part
    local position = part.Position
    Tween(CFrame.new(position))
    fireproximityprompt(part.Prompt)
    wait(0.5)
    fireproximityprompt(part.Prompt)
    wait(3)
    repeat
        wait(1)
        local car = vehicles:WaitForChild(localPlayer.Name .. "sCar")
        local cost = car:FindFirstChild("Cost")
        if not cost then
            repeat
                wait()
            until cost
        end
        if cost.Value ~= 401000 then
            fireproximityprompt(part.Prompt)
        end
    until cost.Value == 401000
    local car = vehicles:FindFirstChild(localPlayer.Name .. "sCar")
    wait(2)
    car.DriveSeat:Sit(localPlayer.Character.Humanoid)
    shared.ClientInformation:Set({ Title = "Status", Content = "Spawned Minigun truck" })
    f:updateDestinationText("Spawned Minigun Truck")
    print("Truck ready to teleport")
end

local function settingsDestinationTwo()
    local car = vehicles:FindFirstChild(localPlayer.Name .. "sCar")
    car:SetPrimaryPartCFrame(CFrame.new(-21799.8, 1042.65, -26797.7))
    repeat
        wait(1)
        local waypoint = workspace.Etc.Waypoint:FindFirstChild("Waypoint")
        local textLabel = waypoint:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")
        if textLabel.Text ~= "Rojod Semarang" then
            recallJob()
            fireproximityprompt(workspace.Etc.Job.Truck.Starter.Prompt)
            workspace.Gravity = 10
        end
    until textLabel.Text == "Rojod Semarang"
end

local function newFarming()
    local c = game:GetService("Workspace")
    local a = c.Vehicles:FindFirstChild(a.LocalPlayer.Name.."sCar")
    task.spawn(function()
        while wait() do
            local a = b.Character
            local a = a and a:FindFirstChild("Humanoid")
            if not a or a.SeatPart == nil or a.SeatPart.Name ~= "DriveSeat" then return end
            local a = game:GetService("Players").LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text
            local a = cleanMoneyString(a)
            local a = tonumber(a)
            if shared.FarmConfig.TargetMoney <= a then 
                sendLog() 
                break 
            end
            countdown(shared.FarmConfig.TeleportCooldown)
            local a = GetWaypointName()
            local a = c.Etc.Waypoint.Waypoint:FindFirstChild("BillboardGui")
            local a = a and a.TextLabel.Text
            CarTween(CFrame.new(-50889.6602,1017.86719,-86514.7969), function()
                shared.ClientInformation:Set({Title="Status",Content="Started new farm"})
                f:updateDestinationText("Started New Farm")
            end)
            wait(1)
            local a = GetWaypointName()
            if a == "Silambat Palimanan" or a == "PT.CDID Cargo Cirebon" then 
                print("destination is Silambat Palimanan or PT.CDID Cargo Cirebon")
                countdown(shared.FarmConfig.TeleportCooldown)
                if a == "Silambat Palimanan" then 
                    local a = c.Etc.Waypoint.Waypoint.Position
                    CarTween(CFrame.new(a))
                else 
                    CarTween(CFrame.new(-21803.8867,1046.98877,-27817.0586,0,0,-1,0,1,0,1,0,0))
                end
                task.wait(2)
                local a = GetWaypointName()
                if a == "Rojod Semarang" then 
                    print("destination is Rojod Semarang")
                    countdown(shared.FarmConfig.TeleportCooldown)
                    CarTween(CFrame.new(-50889.6602,1017.86719,-86514.7969))
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

local function countdown(seconds)
    for i = seconds, 0, -1 do
        f:updateTeleportText(tostring(i) .. " seconds")
        task.wait(1)
    end
    f:updateTeleportText("")
end

-- Timer function with improved readability
local function sTimer()
    local startTime = tick()
    local startDate = os.date("%Y-%m-%d")
    while task.wait() do
        local elapsedTime = tick() - startTime
        local hours = math.floor(elapsedTime / 3600)
        local minutes = math.floor((elapsedTime % 3600) / 60)
        local seconds = math.floor(elapsedTime % 60)
        local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        shared.FarmConfig.ElapsedTime = formattedTime
        f:updateTotalTimeText(formattedTime)
        shared.ClientTime:Set({ Title = "Elapsed Farming Time", Content = formattedTime })
    end
end

-- Recall job function with improved readability
local function recallJob()
    local jobName = "Truck"
    game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer(jobName)
end

-- Perform action based on input
local function performAction(action)
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
    elseif action == "cwaypoint" then
        countdown(shared.FarmConfig.TeleportCooldown)
    elseif action == "sTimer" then
        sTimer()
    elseif action == "recallJob" then
        recallJob()
    end
end

-- Check if player is idle
local function checkIdle()
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    if not humanoidRootPart then
        print("HumanoidRootPart is nil")
        task.wait(1)
    end
end

-- Connect events
local function connectEvents()
    local player = game.Players.LocalPlayer
    local function onChildAdded(child)
        if child.Name == player.Name then
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
        if child.Name == player.Name then
            print(player.Name .. " has been removed")
        end
    end

    c.ChildAdded:Connect(onChildAdded)
    c.ChildRemoved:Connect(onChildRemoved)
end

-- Anti-idle function
local function antiIdle()
    local player = game.Players.LocalPlayer
    local idled = player.Idled:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
    end)
end

-- Initialize
task.spawn(checkIdle)
connectEvents()
antiIdle()
