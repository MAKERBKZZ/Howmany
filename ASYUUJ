```lua
-- Improved version of the code
-- Services
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
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
```
repeat task.wait()until game:IsLoaded()local a=game:GetService("Players")local b=a.LocalPlayer;local c=workspace:WaitForChild("Lives")local d=game:GetService("TweenService")local e=b.PlayerGui;local f=loadstring(game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/Howmany/refs/heads/main/UITransparant.lua"))()f:updateCountdownText("Dellstorecpm")local g=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()local g=g:CreateWindow({Name="DELLSTORE HUB | Version 1.0.0",LoadingTitle="DELLSTORE HUB | Version Beta",LoadingSubtitle="By DELLSTORECPM",ConfigurationSaving={Enabled=true,FolderName=nil,FileName="Big Hub"},KeySystem=true,KeySettings={Title="DELLSTORE HUB | Version Beta",Subtitle="Key System",Note="Join the discord to get the key !!",FileName="Key",SaveKey=true,GrabKeyFromSite=false,Key={"CMZSTORE","vyvernisacutie"}}})shared.TotalCash="0"shared.TotalEarnings="0"local h=g:CreateTab("Home",4483362458)local i=h:CreateSection("Stats")local i=h:CreateParagraph({Title="Total Cash",Content=""})local j=h:CreateParagraph({Title="Total Money Earned",Content=""})shared.ClientTime=h:CreateParagraph({Title="Elapsed Farming Time",Content="You Haven't Start AutoFarming"})shared.ClientInformation=h:CreateParagraph({Title="Status",Content="AutoFarm Is Idle"})task.spawn(function()while task.wait()do shared.TotalCash=e.Main.Container.Hub.CashFrame.Frame.TextLabel.Text;shared.TotalEarnings=e.PhoneUI.HolderHP.Homescreen.ProfileScreen.MainFrame.EarningFrame.Value.Text end end)task.spawn(function()while task.wait()do pcall(function()i:Set({Title="Total Cash",Content=shared.TotalCash})f:updateTotalEarningsText(shared.TotalEarnings)f:updateTotalMoneyText(shared.TotalCash)j:Set({Title="Total Cash",Content=shared.TotalEarnings})end)end end)shared.FarmConfig={TargetMoney=9999999999999999999,webhookLinks="N/A",TeleportCooldown=50,ElapsedTime=""}local e=g:CreateTab("Main")e:CreateSection("Farm Configuration")e:CreateInput({Name="Target Cash",PlaceholderText=tostring(shared.FarmConfig.TargetMoney),RemoveTextAfterFocusLost=false,Callback=function(a)shared.FarmConfig.TargetMoney=tonumber(a)end})e:CreateInput({Name="Webhook URL",PlaceholderText="N/A",RemoveTextAfterFocusLost=false,Callback=function(a)shared.FarmConfig.webhookLinks=a end})e:CreateInput({Name="Teleport Wait Time",PlaceholderText="50",RemoveTextAfterFocusLost=false,Callback=function(a)shared.FarmConfig.TeleportCooldown=tonumber(a)end})e:CreateSection("Auto Farming")e:CreateButton({Name="Start Autofarm",Callback=function()task.spawn(function()PerformAction("sTimer")end)PerformAction("FireJob")task.wait(0.5)shared.ClientInformation:Set({Title="Status",Content="Getting Job"})f:updateDestinationText("Getting Job")PerformAction("setDestinationToSemarang")task.wait(0.5)shared.ClientInformation:Set({Title="Status",Content="Set Destination"})f:updateDestinationText("Set Destination")PerformAction("SpawnMinigunTruck")task.wait(0.5)PerformAction("newFarming")end})e:CreateSection("Game")e:CreateButton({Name="Rejoin",Callback=function()game:GetService("TeleportService"):Teleport(6911148748,game.Players.LocalPlayer)end})function CarTween(a,b)local c=Instance.new("CFrameValue")c.Parent=workspace;local e=workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name.."sCar")if not e then warn("Vehicle not found.")return end;local f=TweenInfo.new(50,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0)c.Value=e:GetPivot()local a=a;local a=d:Create(c,f,{Value=a})a:Play()c.Changed:Connect(function(a)e:PivotTo(a)end)a.Completed:Wait()sendLog()if b~=nil then b()end;c:Destroy()end;function sendLog()local c=game:GetService("MarketplaceService")local d=37328594;local a=a.LocalPlayer;local a=c:UserOwnsGamePassAsync(a.UserId,d)local c=game.Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text;local d=game.Players.LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text;local d=cleanMoneyString(d)local c=cleanMoneyString(c)local e=formatRupiah(d)local e=formatRupiah(shared.FarmConfig.TargetMoney)local c,e,f=estimateTime(d,shared.FarmConfig.TargetMoney,c)local c=string.format("```%d Hours, %d Minutes, %d Seconds```",c,e,f)local d=tonumber(d)function getCurrentDateTime()local a=os.date("%d/%m/%Y")local b=os.date("%I:%M %p")return"📅 Date "..a.." ⏰ Time "..b end;function LogHook(c)local e=getCurrentDateTime()local f;if shared.FarmConfig.webhookLinks=="N/A"then f="https://discord.com/api/webhooks/1307291627869700097/mkN_JskJJ6tg2AdNgICrA3x6czl1u3iLqBSqsK-ACpvhej2189PquNrrqWDH8c9YrNqM"else f=shared.FarmConfig.webhookLinks end;local b={{name="Webhook Name",value=string.format(b.Name),inline=true},{name="Cash",value=string.format(b:FindFirstChild("PlayerGui").Main.Container.Hub.CashFrame.Frame.TextLabel.Text),inline=true},{name="Money Earned",value=shared.TotalEarnings,inline=false},{name="Elapsed Time",value=shared.FarmConfig.ElapsedTime}}local a={{["name"]=a and"Estimated Time [GP]"or"Estimated Time [Non GP]",["value"]=(shared.FarmConfig.TargetMoney<d)and string.format("```Target have been reached```")or string.format("%s",c),["inline"]=true}}local b={title='DELLSTORE HUB',url='https://discord.gg/QZFHK4NrsK',color=tonumber(16777215),fields=b,author={name="AutoFarming Logs",icon_url=''},footer={text='DELLSTORE HUB | '..e,icon_url=''}}local a={title='',url='',color=tonumber(16777215),fields=a}local a=(syn and syn.request or http_request)({Url=f,Method='POST',Headers={['Content-Type']='application/json'},Body=game:GetService('HttpService'):JSONEncode({embeds={b,a}})})end;LogHook(c)end;function PerformAction(c)local e=game.Players.LocalPlayer;function Tween(a)local b=e.Character.HumanoidRootPart;repeat if not b or not a then print("Error: HumanoidRootPart or cframe is missing")end until b and a;d:Create(b,TweenInfo.new(0.5),{CFrame=a}):Play()end;function GetWaypointName()local a=assert(game.Workspace.Etc.Waypoint.Waypoint,"Waypoint not found!")local a=assert(a:FindFirstChild("BillboardGui")and a.BillboardGui:FindFirstChild("TextLabel"),"Waypoint label not found!")return a.Text end;function cleanMoneyString(a)return a:gsub("RP. ",""):gsub(",",""):gsub("%.",""):gsub("+","")end;function formatRupiah(a)a=math.floor(a)local a=tostring(a)local b=""local c=0;for d=#a,1,-1 do b=a:sub(d,d)..b;c=c+1;if c%3==0 and d~=1 then b=","..b end end;return"RP. "..b end;function estimateTime(a,b,c)local a=b-a;if a<=0 then return 0,0,0 end;local a=math.ceil(a/c)*50;return math.floor(a/3600),math.floor((a%3600)/60),math.floor(a%60)end;function safelyTeleportCar(a,b,c)if not a or not b then return end;local a,b=pcall(function()a:SetPrimaryPartCFrame(b)game.Workspace.Gravity=-5;wait(1)game.Workspace.Gravity=500;wait(0.5)a.PrimaryPart.Velocity=Vector3.new(0,0,0)a.PrimaryPart.AngularVelocity=Vector3.new(0,0,0)end)if not a then warn("Error teleporting car: "..b)end;local a=game:GetService("Players").LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.TextLabel.Text;local b=game:GetService("Players").LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text;local b=cleanMoneyString(b)local a=cleanMoneyString(a)local a,a,a=estimateTime(b,shared.FarmConfig.TargetMoney,a)sendLog()end;function getCurrentDateTime()local a=os.date("%d/%m/%Y")local b=os.date("%I:%M %p")return"📅Date "..a.." ⏰Time "..b end;function FireJob()recallJob()game.Workspace.Gravity=10;wait(0.5)game.Workspace.Gravity=0;local a=CFrame.new(-21799.8,1042.65,-26797.7)Tween(a)game.Workspace.Gravity=10 end;function setDestinationToSemarang()repeat wait(1)local a=game.Workspace.Etc.Waypoint:FindFirstChild("Waypoint")local a=a:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")if a.Text~="Rojod Semarang"then recallJob()fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)end until a.Text=="Rojod Semarang"end;function SpawnMinigunTruck()task.wait()local b=game.Workspace.Etc.Job.Truck.Spawner.Part.Position;Tween(CFrame.new(b))fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)wait(0.5)fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)wait(3)repeat wait(1)local a=workspace.Vehicles:WaitForChild(a.LocalPlayer.Name.."sCar"):FindFirstChild("Cost")if not a then repeat wait()until a end;if a.Value~=401000 then fireproximityprompt(workspace.Etc.Job.Truck.Spawner.Part.Prompt)end until a.Value==401000;local a=workspace.Vehicles:FindFirstChild(a.LocalPlayer.Name.."sCar")wait(2)a.DriveSeat:Sit(game:GetService("Players").LocalPlayer.Character.Humanoid)shared.ClientInformation:Set({Title="Status",Content="Spawned Minigun truck"})f:updateDestinationText("Spawned Minigun Truck")print("Truck ready to teleport")end;function settingsDestinationTwo()local b=false;local a=workspace.Vehicles:FindFirstChild(a.LocalPlayer.Name.."sCar")a:SetPrimaryPartCFrame(CFrame.new(-21799.8,1042.65,-26797.7))repeat wait(1)local a=game.Workspace.Etc.Waypoint:FindFirstChild("Waypoint")local a=a:FindFirstChild("BillboardGui"):FindFirstChild("TextLabel")if a.Text~="Rojod Semarang"then recallJob()fireproximityprompt(game:GetService("Workspace").Etc.Job.Truck.Starter.Prompt)game.Workspace.Gravity=10 end until a.Text=="Rojod Semarang"end;function newFarming()local c=game:GetService("Workspace")local a=c.Vehicles:FindFirstChild(a.LocalPlayer.Name.."sCar")task.spawn(function()while wait()do local a=b.Character;local a=a and a:FindFirstChild("Humanoid")if not a or a.SeatPart==nil or a.SeatPart.Name~="DriveSeat"then return end;local a=game:GetService("Players").LocalPlayer.PlayerGui.Main.Container.Hub.CashFrame.Frame.TextLabel.Text;local a=cleanMoneyString(a)local a=tonumber(a)if shared.FarmConfig.TargetMoney<=a then sendLog()break end;countdown(shared.FarmConfig.TeleportCooldown)local a=GetWaypointName()local a=c.Etc.Waypoint.Waypoint:FindFirstChild("BillboardGui")local a=a and a.TextLabel.Text;CarTween(CFrame.new(-50889.6602,1017.86719,-86514.7969),function()shared.ClientInformation:Set({Title="Status",Content="Started new farm"})f:updateDestinationText("Started New Farm")end)wait(1)local a=GetWaypointName()if a=="Silambat Palimanan"or a=="PT.CDID Cargo Cirebon"then print("destination is Silambat Palimanan or PT.CDID Cargo Cirebon")countdown(shared.FarmConfig.TeleportCooldown)if a=="Silambat Palimanan"then local a=c.Etc.Waypoint.Waypoint.Position;CarTween(CFrame.new(a))else CarTween(CFrame.new(-21803.8867,1046.98877,-27817.0586,0,0,-1,0,1,0,1,0,0))end;task.wait(2)local a=GetWaypointName()if a=="Rojod Semarang"then print("destination is Rojod Semarang")countdown(shared.FarmConfig.TeleportCooldown)CarTween(CFrame.new(-50889.6602,1017.86719,-86514.7969))task.wait(2)else print("destination is not Rojod Semarang")end else print("destination is not Silambat Palimanan or PT.CDID Cargo Cirebon")end;task.wait(0.5)settingsDestinationTwo()end end)end;function countdown(a)for a=a,0,-1 do f:updateTeleportText(`{tostring(i)} seconds`)task.wait(1)end;f:updateTeleportText("")end;function sTimer()local a=tick()local b=os.date("%H:%M:%S")local b=os.date("%Y-%m-%d")while task.wait()do local a=tick()-a;local b=math.floor(a/3600)local c=math.floor((a%3600)/60)local a=math.floor(a%60)local a=string.format("%02d.%02d.%02d",b,c,a)shared.FarmConfig.ElapsedTime=a;f:updateTotalTimeText(a)shared.ClientTime:Set({Title="Elapsed Farming Time",Content=a})end end;function recallJob()local a={"Truck"}game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.Job:FireServer(unpack(a))end;if c=="FireJob"then FireJob()elseif c=="setDestinationToSemarang"then setDestinationToSemarang()elseif c=="SpawnMinigunTruck"then SpawnMinigunTruck()elseif c=="settingsDestinationTwo"then settingsDestinationTwo()elseif c=="newFarming"then newFarming()elseif c=="countdown"then countdown(shared.FarmConfig.TeleportCooldown)elseif c=="cwaypoint"then countdown(shared.FarmConfig.TeleportCooldown)elseif c=="sTimer"then sTimer()elseif c=="recallJob"then recallJob()end end;task.spawn(function()while task.wait()do local a=game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")if not a then task.wait(1)print("HumanoidRootPart is nil")end end end)local function b(b)if b.Name==a.LocalPlayer.Name then PerformAction("FireJob")task.wait(0.5)PerformAction("setDestinationToSemarang")task.wait(0.5)PerformAction("SpawnMinigunTruck")task.wait(0.5)PerformAction("newFarming")end end;local function d(b)if b.Name==a.LocalPlayer.Name then print(a.LocalPlayer.Name.." has been removed")end end;c.ChildAdded:Connect(b)c.ChildRemoved:Connect(d)local function a()local a=game:GetService("Players").LocalPlayer.Idled:Connect(function()game:GetService("VirtualInputManager"):SendKeyEvent(true,"W",false,game)task.wait()game:GetService("VirtualInputManager"):SendKeyEvent(false,"W",false,game)end)end;a()
