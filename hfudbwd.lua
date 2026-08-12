local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Config = {}
local ConfigFolder = "WhiteTeaConfigs"
local ConfigIndexFile = ConfigFolder .. "/config_index.json"

if not isfolder(ConfigFolder) then
    makefolder(ConfigFolder)
end

local function GetConfigList()
    local success, data = pcall(function()
        return readfile(ConfigIndexFile)
    end)
    if success and data then
        local success2, parsed = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and parsed then
            return parsed
        end
    end
    return {configs = {}, activeConfig = "Default"}
end

local function SaveConfigList(configList)
    local json = HttpService:JSONEncode(configList)
    pcall(function()
        writefile(ConfigIndexFile, json)
    end)
end

local function GetConfigFilePath(configName)
    return ConfigFolder .. "/" .. configName .. ".json"
end

local DefaultConfig = {
    Window = { Position = nil, Size = nil },
    Settings = {
        WeatherNotify = false,
        Anchor = false,
        AutoCast = false,
        AutoSkill = false,
        Skills = { Z = true, X = true, C = true, V = true },
        AutoSell = false,
        SellDelay = 5,
        AutoBuyBait = false,
        BaitDelay = 3,
        SelectedBaits = {
            ["Basic Bait"] = false,
            ["Crude Mash Bait"] = false,
            ["Corrupted Essence Bait"] = false,
            ["Elite Bait"] = false,
            ["Ancestral Bait"] = false
        },
        AutoQuest = false,
        BossQTE = false,
        EnzoCam = false,
    },
    BackgroundImageID = "17470093533",
}

function Config.Load(configName)
    local configList = GetConfigList()
    local targetConfig = configName or configList.activeConfig or "Default"
    local filePath = GetConfigFilePath(targetConfig)
    local success, data = pcall(function() return readfile(filePath) end)
    if success and data then
        local success2, parsed = pcall(function() return HttpService:JSONDecode(data) end)
        if success2 and parsed then
            local merged = {}
            for k, v in pairs(DefaultConfig) do
                if type(v) == "table" and parsed[k] then
                    merged[k] = {}
                    for k2, v2 in pairs(v) do merged[k][k2] = parsed[k][k2] ~= nil and parsed[k][k2] or v2 end
                else merged[k] = parsed[k] ~= nil and parsed[k] or v end
            end
            return merged
        end
    end
    return DefaultConfig
end

function Config.Create(configName, configTable)
    if not configName or not configTable or configName == "Default" then return end
    local filePath = GetConfigFilePath(configName)
    local json = HttpService:JSONEncode(configTable)
    pcall(function() writefile(filePath, json) end)
    local configList = GetConfigList()
    local found = false
    for _, name in ipairs(configList.configs) do if name == configName then found = true break end end
    if not found then table.insert(configList.configs, configName) end
    SaveConfigList(configList)
end

function Config.Delete(configName)
    if configName == "Default" then return end
    local filePath = GetConfigFilePath(configName)
    pcall(function() delfile(filePath) end)
    local configList = GetConfigList()
    local newConfigs = {}
    for _, name in ipairs(configList.configs) do
        if name ~= configName then table.insert(newConfigs, name) end
    end
    configList.configs = newConfigs
    if configList.activeConfig == configName then configList.activeConfig = "Default" end
    if #configList.configs == 0 then
        table.insert(configList.configs, "Default")
        configList.activeConfig = "Default"
    end
    SaveConfigList(configList)
end

function Config.SetActive(configName)
    local configList = GetConfigList()
    configList.activeConfig = configName
    SaveConfigList(configList)
end

function Config.GetAllConfigs()
    return GetConfigList().configs
end

function Config.GetActiveConfig()
    return GetConfigList().activeConfig
end

function Config.ApplySettings(settings)
    for k, v in pairs(settings) do getgenv()["WhiteTea_" .. k] = v end
end

function Config.CollectSettings()
    return {
        WeatherNotify = getgenv().WhiteTea_WeatherNotify,
        Anchor = getgenv().WhiteTea_Anchor,
        AutoCast = getgenv().WhiteTea_AutoCast,
        AutoSkill = getgenv().WhiteTea_AutoSkill,
        Skills = getgenv().WhiteTea_Skills,
        AutoSell = getgenv().WhiteTea_AutoSell,
        SellDelay = getgenv().WhiteTea_SellDelay,
        AutoBuyBait = getgenv().WhiteTea_AutoBuyBait,
        BaitDelay = getgenv().WhiteTea_BaitDelay,
        SelectedBaits = getgenv().WhiteTea_SelectedBaits,
        AutoQuest = getgenv().WhiteTea_AutoQuest,
        BossQTE = getgenv().WhiteTea_BossQTE,
        EnzoCam = getgenv().WhiteTea_EnzoCam,
    }
end

local configList = GetConfigList()
if #configList.configs == 0 then
    table.insert(configList.configs, "Default")
    configList.activeConfig = "Default"
    SaveConfigList(configList)
end
local activeConfigName = configList.activeConfig or "Default"
local configData = Config.Load(activeConfigName)
Config.ApplySettings(configData.Settings)

getgenv().WhiteTea_WeatherNotify = getgenv().WhiteTea_WeatherNotify
getgenv().WhiteTea_Anchor = getgenv().WhiteTea_Anchor
getgenv().WhiteTea_AutoCast = getgenv().WhiteTea_AutoCast
getgenv().WhiteTea_AutoSkill = getgenv().WhiteTea_AutoSkill
getgenv().WhiteTea_Skills = getgenv().WhiteTea_Skills
getgenv().WhiteTea_AutoSell = getgenv().WhiteTea_AutoSell
getgenv().WhiteTea_SellDelay = getgenv().WhiteTea_SellDelay
getgenv().WhiteTea_AutoBuyBait = getgenv().WhiteTea_AutoBuyBait
getgenv().WhiteTea_BaitDelay = getgenv().WhiteTea_BaitDelay
getgenv().WhiteTea_SelectedBaits = getgenv().WhiteTea_SelectedBaits
getgenv().WhiteTea_AutoQuest = getgenv().WhiteTea_AutoQuest
getgenv().WhiteTea_BossQTE = getgenv().WhiteTea_BossQTE
getgenv().WhiteTea_EnzoCam = getgenv().WhiteTea_EnzoCam

local currentBackgroundID = configData.BackgroundImageID or "17470093533"

local function showPopup(text, customColor)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("PopupGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PopupGui"
        screenGui.Parent = playerGui
    end

    local existingFrames = {}
    for _, child in ipairs(screenGui:GetChildren()) do
        if child:IsA("Frame") then table.insert(existingFrames, child) end
    end

    local function getTotalHeight()
        local total = 10
        for _, f in ipairs(existingFrames) do total = total + f.AbsoluteSize.Y + 10 end
        return total
    end

    local measureLabel = Instance.new("TextLabel")
    measureLabel.Text = text
    measureLabel.Font = Enum.Font.GothamBold
    measureLabel.TextSize = 17
    measureLabel.TextWrapped = false
    local textSize = TextService:GetTextSize(measureLabel.Text, measureLabel.TextSize, measureLabel.Font, Vector2.new(math.huge, math.huge))
    measureLabel:Destroy()

    local frameWidth = textSize.X + 34
    local frameHeight = textSize.Y + 18
    local startY = getTotalHeight()

    local frame = Instance.new("Frame")
    frame.Name = "PopupFrame"
    frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    frame.Position = UDim2.new(1, 0, 0, startY)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.05
    frame.Parent = screenGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", frame).Thickness = 1
    frame.UIStroke.Color = Color3.fromRGB(60, 60, 65)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 17
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -frameWidth - 12, 0, startY)
    }):Play()

    local rainbowConnection
    if customColor then
        textLabel.TextColor3 = customColor
    else
        local hue = 0
        rainbowConnection = RunService.RenderStepped:Connect(function(deltaTime)
            hue = (hue + deltaTime * 0.5) % 1
            textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end)
    end

    task.delay(5, function()
        if rainbowConnection then rainbowConnection:Disconnect() end
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, frame.Position.Y.Offset)
        }):Play()
        task.wait(0.25)
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do if child:IsA("Frame") then table.insert(remaining, child) end end
        table.sort(remaining, function(a, b) return a.Position.Y.Offset < b.Position.Y.Offset end)
        local newY = 10
        for _, f in ipairs(remaining) do
            TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            }):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end)
end

local function showTeleportPopup(islandName, teleportPos)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("PopupGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PopupGui"
        screenGui.Parent = playerGui
    end

    local existingFrames = {}
    for _, child in ipairs(screenGui:GetChildren()) do
        if child:IsA("Frame") then table.insert(existingFrames, child) end
    end

    local function getTotalHeight()
        local total = 10
        for _, f in ipairs(existingFrames) do total = total + f.AbsoluteSize.Y + 10 end
        return total
    end

    local text = "是否要传送到" .. islandName .. "?"
    local measureLabel = Instance.new("TextLabel")
    measureLabel.Text = text
    measureLabel.Font = Enum.Font.GothamBold
    measureLabel.TextSize = 17
    measureLabel.TextWrapped = false
    local textSize = TextService:GetTextSize(measureLabel.Text, measureLabel.TextSize, measureLabel.Font, Vector2.new(math.huge, math.huge))
    measureLabel:Destroy()

    local frameWidth = textSize.X + 90
    local frameHeight = math.max(textSize.Y + 18, 38)
    local startY = getTotalHeight()

    local frame = Instance.new("Frame")
    frame.Name = "TeleportPopupFrame"
    frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    frame.Position = UDim2.new(1, 0, 0, startY)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.05
    frame.Parent = screenGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", frame).Thickness = 1
    frame.UIStroke.Color = Color3.fromRGB(60, 60, 65)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, textSize.X, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 17
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame

    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0, 54, 0, frameHeight - 10)
    teleportBtn.Position = UDim2.new(1, -60, 0.5, -((frameHeight - 10) / 2))
    teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    teleportBtn.Text = "传送"
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.TextSize = 14
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.AutoButtonColor = false
    Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 8)
    teleportBtn.Parent = frame
    teleportBtn.MouseEnter:Connect(function() teleportBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
    teleportBtn.MouseLeave:Connect(function() teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)
    teleportBtn.MouseButton1Click:Connect(function()
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(teleportPos) end
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do if child:IsA("Frame") then table.insert(remaining, child) end end
        table.sort(remaining, function(a, b) return a.Position.Y.Offset < b.Position.Y.Offset end)
        local newY = 10
        for _, f in ipairs(remaining) do
            TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            }):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end)

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -frameWidth - 12, 0, startY)
    }):Play()

    local hue = 0
    local rainbowConnection = RunService.RenderStepped:Connect(function(deltaTime)
        hue = (hue + deltaTime * 0.5) % 1
        textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)

    task.delay(10, function()
        rainbowConnection:Disconnect()
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, frame.Position.Y.Offset)
        }):Play()
        task.wait(0.25)
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do if child:IsA("Frame") then table.insert(remaining, child) end end
        table.sort(remaining, function(a, b) return a.Position.Y.Offset < b.Position.Y.Offset end)
        local newY = 10
        for _, f in ipairs(remaining) do
            TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            }):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end)
end

local weatherColors = {
    ["Clear"] = Color3.fromRGB(255, 255, 150), ["Windy"] = Color3.fromRGB(100, 180, 255),
    ["Snowy"] = Color3.fromRGB(200, 230, 255), ["Thunderstorm"] = Color3.fromRGB(180, 180, 100),
    ["Foggy"] = Color3.fromRGB(200, 200, 200), ["Rainy"] = Color3.fromRGB(100, 150, 255),
    ["Blazing Sun"] = Color3.fromRGB(255, 180, 50)
}
local weatherIslands = {
    ["Windy"] = { name = "鲈鱼岛", pos = Vector3.new(-62, 9, -1321) },
    ["Snowy"] = { name = "冰霜岛", pos = Vector3.new(-1366, 9, -1495) },
    ["Thunderstorm"] = { name = "竹子岛", pos = Vector3.new(-1223, 7, -24) },
    ["Foggy"] = { name = "椰子岛", pos = Vector3.new(1494, 7, -1431) },
    ["Rainy"] = { name = "核弹岛", pos = Vector3.new(66, 7, 1181) },
    ["Blazing Sun"] = { name = "琥珀岛", pos = Vector3.new(1259, 7, 1401) }
}

local lastWeather = nil
task.spawn(function()
    local Event = replicatedStorage.Events.Notification
    if not Event then return end
    Event.OnClientEvent:Connect(function(message)
        if not getgenv().WhiteTea_WeatherNotify then return end
        if typeof(message) == "string" then
            local weather = string.match(message, "The weather has been changed to (.+)!")
            if weather and weather ~= lastWeather then
                lastWeather = weather
                showPopup("天气已变为 " .. weather, weatherColors[weather])
                local islandData = weatherIslands[weather]
                if islandData then task.wait(2) showTeleportPopup(islandData.name, islandData.pos) end
            end
        end
    end)
end)

task.spawn(function()
    task.wait(1) showPopup("欢迎使用") task.wait(0.5) showPopup("脚本作者为白茶")
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoQuestGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 310)
mainFrame.Position = UDim2.new(0.5, -175, 0.4, -155)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

if configData.Window and configData.Window.Position then
    pcall(function() mainFrame.Position = configData.Window.Position end)
end
if configData.Window and configData.Window.Size then
    pcall(function() mainFrame.Size = configData.Window.Size end)
end

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "BackgroundImage"
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://" .. currentBackgroundID
backgroundImage.ScaleType = Enum.ScaleType.Crop
backgroundImage.ZIndex = 0
backgroundImage.Parent = mainFrame

Instance.new("UICorner", backgroundImage).CornerRadius = UDim.new(0, 12)

local overlayFrame = Instance.new("Frame")
overlayFrame.Size = UDim2.new(1, 0, 1, 0)
overlayFrame.Position = UDim2.new(0, 0, 0, 0)
overlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlayFrame.BackgroundTransparency = 0.5
overlayFrame.BorderSizePixel = 0
overlayFrame.ZIndex = 1
overlayFrame.Parent = mainFrame

Instance.new("UICorner", overlayFrame).CornerRadius = UDim.new(0, 12)

local function HSVtoRGB(h, s, v)
    h = h % 1 local r, g, b
    local i = math.floor(h * 6) local f = h * 6 - i
    local p = v * (1 - s) local q = v * (1 - f * s) local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v elseif i == 5 then r, g, b = v, p, q end
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

local function makeDraggable(frame)
    local gui = frame
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
topBar.ZIndex = 2
topBar.Parent = mainFrame

Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)
local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 12)
topBarCover.Position = UDim2.new(0, 0, 1, -12)
topBarCover.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
topBarCover.BackgroundTransparency = 0.3
topBarCover.BorderSizePixel = 0
topBarCover.ZIndex = 2
topBarCover.Parent = topBar
makeDraggable(mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "钓鱼功能🎣"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = topBar

local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 56, 0, 22)
windowControls.Position = UDim2.new(1, -60, 0.5, -11)
windowControls.BackgroundTransparency = 1
windowControls.ZIndex = 3
windowControls.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(0, 34, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 11
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.ZIndex = 3
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 11)
closeButton.Parent = windowControls
closeButton.MouseEnter:Connect(function() closeButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90) end)
closeButton.MouseLeave:Connect(function() closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70) end)

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 22, 0, 22)
miniButton.Position = UDim2.new(0, 0, 0, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
miniButton.Text = "−"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 14
miniButton.Font = Enum.Font.GothamBold
miniButton.AutoButtonColor = false
miniButton.ZIndex = 3
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(0, 11)
miniButton.Parent = windowControls
miniButton.MouseEnter:Connect(function() miniButton.BackgroundColor3 = Color3.fromRGB(255, 190, 60) end)
miniButton.MouseLeave:Connect(function() miniButton.BackgroundColor3 = Color3.fromRGB(255, 170, 40) end)

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 56, 1, -36)
navBar.Position = UDim2.new(0, 0, 0, 36)
navBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
navBar.BackgroundTransparency = 0.3
navBar.BorderSizePixel = 0
navBar.ZIndex = 2
navBar.Parent = mainFrame

local navScroll = Instance.new("ScrollingFrame")
navScroll.Size = UDim2.new(1, 0, 1, 0)
navScroll.BackgroundTransparency = 1
navScroll.BorderSizePixel = 0
navScroll.ScrollBarThickness = 0
navScroll.CanvasSize = UDim2.new(0, 0, 0, 440)
navScroll.ZIndex = 2
navScroll.Parent = navBar

local function createNavButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 46)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.BackgroundTransparency = 0.3
    btn.Text = icon .. "\n" .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.Parent = navScroll
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 50, 58) btn.BackgroundTransparency = 0.2 end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48) btn.BackgroundTransparency = 0.3 end)
    return btn
end

local fishingNavBtn = createNavButton("钓鱼", "🎣", 8)
local bossNavBtn = createNavButton("Boss", "💀", 60)
local ticketNavBtn = createNavButton("刷票", "🎫", 112)
local teleportNavBtn = createNavButton("传送", "📍", 164)
local traitNavBtn = createNavButton("角色/特制", "🎲", 216)
local configNavBtn = createNavButton("配置", "⚙️", 268)

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -56, 1, -36)
pageContainer.Position = UDim2.new(0, 56, 0, 36)
pageContainer.BackgroundTransparency = 1
pageContainer.ZIndex = 1
pageContainer.Parent = mainFrame

local fishingPage = Instance.new("Frame")
fishingPage.Size = UDim2.new(1, 0, 1, 0)
fishingPage.BackgroundTransparency = 1
fishingPage.Visible = true
fishingPage.ZIndex = 1
fishingPage.Parent = pageContainer

local fishingScroll = Instance.new("ScrollingFrame")
fishingScroll.Size = UDim2.new(1, 0, 1, 0)
fishingScroll.BackgroundTransparency = 1
fishingScroll.BorderSizePixel = 0
fishingScroll.ScrollBarThickness = 3
fishingScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
fishingScroll.CanvasSize = UDim2.new(0, 0, 0, 260)
fishingScroll.ZIndex = 1
fishingScroll.Parent = fishingPage

local function createToggleRow(label, defaultState, yPos, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 276, 0, 32)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.ZIndex = 2
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 180, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(1, -54, 0.5, -11)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    btn.Text = defaultState and "开启" or "关闭"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = row
    return btn, lbl
end

local function createActionRow(label, btnText, yPos, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 276, 0, 32)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.ZIndex = 2
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 180, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 0, 22)
    btn.Position = UDim2.new(1, -62, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    btn.Text = btnText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = row
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)
    return btn
end

local weatherNotifyBtn, anchorBtn, autoCastBtn, skillToggleBtn, autoSellBtn
local bossQTEBtn, enzoCamBtn
local autoBuyBaitBtn, autoQuestBtn
local skillBtns = {}
local baitBtns = {}
local baitSpeedLabel, baitSliderFill, baitSliderBtn

weatherNotifyBtn, _ = createToggleRow("天气弹窗通知", getgenv().WhiteTea_WeatherNotify, 8, fishingScroll)
weatherNotifyBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_WeatherNotify = not getgenv().WhiteTea_WeatherNotify
    weatherNotifyBtn.BackgroundColor3 = getgenv().WhiteTea_WeatherNotify and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    weatherNotifyBtn.Text = getgenv().WhiteTea_WeatherNotify and "开启" or "关闭"
end)

anchorBtn, _ = createToggleRow("钓鱼条锚定", getgenv().WhiteTea_Anchor, 46, fishingScroll)
anchorBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_Anchor = not getgenv().WhiteTea_Anchor
    anchorBtn.BackgroundColor3 = getgenv().WhiteTea_Anchor and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    anchorBtn.Text = getgenv().WhiteTea_Anchor and "开启" or "关闭"
end)

autoCastBtn, _ = createToggleRow("自动抛竿(挂机请自备连点器)", getgenv().WhiteTea_AutoCast, 84, fishingScroll)
autoCastBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoCast = not getgenv().WhiteTea_AutoCast
    autoCastBtn.BackgroundColor3 = getgenv().WhiteTea_AutoCast and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoCastBtn.Text = getgenv().WhiteTea_AutoCast and "开启" or "关闭"
end)

skillToggleBtn, _ = createToggleRow("自动技能(开启后无法手动抛竿)", getgenv().WhiteTea_AutoSkill, 122, fishingScroll)
skillToggleBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoSkill = not getgenv().WhiteTea_AutoSkill
    skillToggleBtn.BackgroundColor3 = getgenv().WhiteTea_AutoSkill and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    skillToggleBtn.Text = getgenv().WhiteTea_AutoSkill and "开启" or "关闭"
end)

local skillKeys = {"Z", "X", "C", "V"}
local skillsRow = Instance.new("Frame")
skillsRow.Size = UDim2.new(0, 276, 0, 30)
skillsRow.Position = UDim2.new(0, 10, 0, 160)
skillsRow.BackgroundTransparency = 1
skillsRow.ZIndex = 1
skillsRow.Parent = fishingScroll

for i, key in ipairs(skillKeys) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 28)
    btn.Position = UDim2.new(0, (i-1)*72, 0, 0)
    btn.BackgroundColor3 = getgenv().WhiteTea_Skills[key] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    btn.Text = key
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = skillsRow
    btn.MouseButton1Click:Connect(function()
        getgenv().WhiteTea_Skills[key] = not getgenv().WhiteTea_Skills[key]
        btn.BackgroundColor3 = getgenv().WhiteTea_Skills[key] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    end)
    skillBtns[key] = btn
end

autoSellBtn, _ = createToggleRow("自动售卖(可能不完善)", getgenv().WhiteTea_AutoSell, 198, fishingScroll)
autoSellBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoSell = not getgenv().WhiteTea_AutoSell
    autoSellBtn.BackgroundColor3 = getgenv().WhiteTea_AutoSell and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoSellBtn.Text = getgenv().WhiteTea_AutoSell and "开启" or "关闭"
end)

local bossPage = Instance.new("Frame")
bossPage.Size = UDim2.new(1, 0, 1, 0)
bossPage.BackgroundTransparency = 1
bossPage.Visible = false
bossPage.ZIndex = 1
bossPage.Parent = pageContainer

local bossScroll = Instance.new("ScrollingFrame")
bossScroll.Size = UDim2.new(1, 0, 1, 0)
bossScroll.BackgroundTransparency = 1
bossScroll.BorderSizePixel = 0
bossScroll.ScrollBarThickness = 3
bossScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
bossScroll.CanvasSize = UDim2.new(0, 0, 0, 200)
bossScroll.ZIndex = 1
bossScroll.Parent = bossPage

local bossContent = Instance.new("Frame")
bossContent.Size = UDim2.new(1, 0, 1, 0)
bossContent.BackgroundTransparency = 1
bossContent.ZIndex = 1
bossContent.Parent = bossScroll

createActionRow("恩佐难度选择/开始", "打开", 8, bossContent).MouseButton1Click:Connect(function()
    task.spawn(function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local enzo = workspace:FindFirstChild("Enzo", true)
        if not enzo then return end
        local prompt = enzo:IsA("Model") and enzo:FindFirstChildWhichIsA("ProximityPrompt", true) or enzo:FindFirstChildOfClass("ProximityPrompt")
        if not prompt then return end
        local distance = (character.HumanoidRootPart.Position - enzo:GetPivot().Position).Magnitude
        if distance > prompt.MaxActivationDistance then
            firetouchinterest(character.HumanoidRootPart, prompt.Parent, 0)
            task.wait(0.1)
            firetouchinterest(character.HumanoidRootPart, prompt.Parent, 1)
        end
        firesignal(prompt.Triggered)
    end)
end)

enzoCamBtn = createActionRow("远程观看恩佐冷却/状态", "👀", 46, bossContent)
enzoCamBtn.BackgroundColor3 = getgenv().WhiteTea_EnzoCam and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 130, 255)
enzoCamBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_EnzoCam = not getgenv().WhiteTea_EnzoCam
    enzoCamBtn.BackgroundColor3 = getgenv().WhiteTea_EnzoCam and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 130, 255)
    if getgenv().WhiteTea_EnzoCam then
        task.spawn(function()
            local camera = workspace.CurrentCamera
            local enzo = workspace:FindFirstChild("Enzo", true)
            if not enzo then return end
            local targetPosition = (enzo:IsA("Model") and (enzo:FindFirstChild("HumanoidRootPart") or enzo.PrimaryPart) or enzo).Position
            if not targetPosition then return end
            local originalCameraType = camera.CameraType
            camera.CameraType = Enum.CameraType.Scriptable
            local camConnection = RunService.RenderStepped:Connect(function()
                if not getgenv().WhiteTea_EnzoCam then camera.CameraType = originalCameraType camConnection:Disconnect() return end
                camera.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 8), targetPosition + Vector3.new(0, 2, 0))
            end)
        end)
    end
end)

bossQTEBtn, _ = createToggleRow("自动噩梦恩佐二阶段QTE(挑战前开启)", getgenv().WhiteTea_BossQTE, 84, bossContent)
bossQTEBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_BossQTE = not getgenv().WhiteTea_BossQTE
    bossQTEBtn.BackgroundColor3 = getgenv().WhiteTea_BossQTE and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    bossQTEBtn.Text = getgenv().WhiteTea_BossQTE and "开启" or "关闭"
    if getgenv().WhiteTea_BossQTE then
        task.spawn(function()
            local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
            local mainGui = playerGui:WaitForChild("MainGui")
            local fishing = mainGui:WaitForChild("Fishing")
            local bossFightBar = fishing:WaitForChild("BossFightBar")
            local bar = bossFightBar:WaitForChild("Bar")
            local hitbox = bossFightBar:WaitForChild("Hitbox")
            local mobileFishing = mainGui:WaitForChild("Mobile"):WaitForChild("Fishing")
            local bossPhase2Action = replicatedStorage:WaitForChild("Events"):WaitForChild("BossPhase2Action")
            task.spawn(function()
                while getgenv().WhiteTea_BossQTE do
                    if bossFightBar.Visible then firesignal(mobileFishing.MouseButton1Down) end
                    task.wait(0.1)
                end
            end)
            RunService.RenderStepped:Connect(function()
                if not getgenv().WhiteTea_BossQTE then return end
                if bossFightBar.Visible and bar and hitbox then
                    bar.Position = UDim2.new(hitbox.Position.X.Scale, hitbox.Position.X.Offset, bar.Position.Y.Scale, bar.Position.Y.Offset)
                    bar.Size = UDim2.new(hitbox.Size.X.Scale, hitbox.Size.X.Offset, bar.Size.Y.Scale, bar.Size.Y.Offset)
                end
            end)
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = function(self, ...)
                local args = {...}
                if getnamecallmethod() == "FireServer" and self == bossPhase2Action then
                    if args[1] and type(args[1]) == "table" then args[1].Hit = true end
                end
                return oldNamecall(self, unpack(args))
            end
            setreadonly(mt, true)
        end)
    end
end)

local ticketPage = Instance.new("Frame")
ticketPage.Size = UDim2.new(1, 0, 1, 0)
ticketPage.BackgroundTransparency = 1
ticketPage.Visible = false
ticketPage.ZIndex = 1
ticketPage.Parent = pageContainer

local ticketScroll = Instance.new("ScrollingFrame")
ticketScroll.Size = UDim2.new(1, 0, 1, 0)
ticketScroll.BackgroundTransparency = 1
ticketScroll.BorderSizePixel = 0
ticketScroll.ScrollBarThickness = 3
ticketScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ticketScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ticketScroll.ZIndex = 1
ticketScroll.Parent = ticketPage

local ticketContent = Instance.new("Frame")
ticketContent.Size = UDim2.new(1, 0, 1, 0)
ticketContent.BackgroundTransparency = 1
ticketContent.ZIndex = 1
ticketContent.Parent = ticketScroll

createActionRow("数值修改器(客户端)", "打开", 8, ticketContent).MouseButton1Click:Connect(function() editorFrame.Visible = true end)

createActionRow("打开饵料商城", "打开", 46, ticketContent).MouseButton1Click:Connect(function()
    pcall(function() replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer("BuyBait", 1, "BaitShop") end)
end)

local autoBuyRow = Instance.new("Frame")
autoBuyRow.Size = UDim2.new(0, 276, 0, 32)
autoBuyRow.Position = UDim2.new(0, 10, 0, 84)
autoBuyRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
autoBuyRow.BackgroundTransparency = 0.3
autoBuyRow.BorderSizePixel = 0
autoBuyRow.ZIndex = 2
Instance.new("UICorner", autoBuyRow).CornerRadius = UDim.new(0, 8)
autoBuyRow.Parent = ticketContent

local autoBuyLabel = Instance.new("TextLabel")
autoBuyLabel.Size = UDim2.new(0, 160, 1, 0)
autoBuyLabel.Position = UDim2.new(0, 12, 0, 0)
autoBuyLabel.BackgroundTransparency = 1
autoBuyLabel.Text = "自动购买饵料(使用100个饵料)"
autoBuyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyLabel.TextSize = 12
autoBuyLabel.Font = Enum.Font.GothamMedium
autoBuyLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBuyLabel.ZIndex = 3
autoBuyLabel.Parent = autoBuyRow

local expandBaitBtn = Instance.new("TextButton")
expandBaitBtn.Size = UDim2.new(0, 22, 0, 22)
expandBaitBtn.Position = UDim2.new(1, -104, 0.5, -11)
expandBaitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
expandBaitBtn.BackgroundTransparency = 0.3
expandBaitBtn.Text = "+"
expandBaitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
expandBaitBtn.TextSize = 14
expandBaitBtn.Font = Enum.Font.GothamBold
expandBaitBtn.AutoButtonColor = false
expandBaitBtn.ZIndex = 3
Instance.new("UICorner", expandBaitBtn).CornerRadius = UDim.new(0, 5)
expandBaitBtn.Parent = autoBuyRow
expandBaitBtn.MouseEnter:Connect(function() expandBaitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 56) end)
expandBaitBtn.MouseLeave:Connect(function() expandBaitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46) end)

autoBuyBaitBtn = Instance.new("TextButton")
autoBuyBaitBtn.Size = UDim2.new(0, 44, 0, 22)
autoBuyBaitBtn.Position = UDim2.new(1, -54, 0.5, -11)
autoBuyBaitBtn.BackgroundColor3 = getgenv().WhiteTea_AutoBuyBait and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
autoBuyBaitBtn.Text = getgenv().WhiteTea_AutoBuyBait and "开启" or "关闭"
autoBuyBaitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyBaitBtn.TextSize = 10
autoBuyBaitBtn.Font = Enum.Font.GothamBold
autoBuyBaitBtn.AutoButtonColor = false
autoBuyBaitBtn.ZIndex = 3
Instance.new("UICorner", autoBuyBaitBtn).CornerRadius = UDim.new(0, 6)
autoBuyBaitBtn.Parent = autoBuyRow

local baitTypes = {"Basic Bait", "Crude Mash Bait", "Corrupted Essence Bait", "Elite Bait", "Ancestral Bait"}
local baitSelectFrame = Instance.new("Frame")
baitSelectFrame.Size = UDim2.new(0, 276, 0, 160)
baitSelectFrame.Position = UDim2.new(0, 10, 0, 122)
baitSelectFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
baitSelectFrame.BackgroundTransparency = 0.3
baitSelectFrame.BorderSizePixel = 0
baitSelectFrame.Visible = false
baitSelectFrame.ZIndex = 2
Instance.new("UICorner", baitSelectFrame).CornerRadius = UDim.new(0, 8)
baitSelectFrame.Parent = ticketContent

for i, baitName in ipairs(baitTypes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 256, 0, 24)
    btn.Position = UDim2.new(0, 10, 0, 8 + (i-1)*30)
    btn.BackgroundColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    btn.Text = baitName
    btn.TextColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 205)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.Parent = baitSelectFrame
    btn.MouseButton1Click:Connect(function()
        getgenv().WhiteTea_SelectedBaits[baitName] = not getgenv().WhiteTea_SelectedBaits[baitName]
        btn.BackgroundColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
        btn.TextColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 205)
    end)
    baitBtns[baitName] = btn
end

local dynamicContent = Instance.new("Frame")
dynamicContent.Size = UDim2.new(1, 0, 0, 100)
dynamicContent.Position = UDim2.new(0, 0, 0, 122)
dynamicContent.BackgroundTransparency = 1
dynamicContent.ZIndex = 1
dynamicContent.Parent = ticketContent

baitSpeedLabel = Instance.new("TextLabel")
baitSpeedLabel.Size = UDim2.new(1, -20, 0, 18)
baitSpeedLabel.Position = UDim2.new(0, 14, 0, 0)
baitSpeedLabel.BackgroundTransparency = 1
baitSpeedLabel.Text = "购买间隔: " .. getgenv().WhiteTea_BaitDelay .. "秒"
baitSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
baitSpeedLabel.TextSize = 11
baitSpeedLabel.Font = Enum.Font.GothamMedium
baitSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
baitSpeedLabel.ZIndex = 2
baitSpeedLabel.Parent = dynamicContent

local baitSliderBg = Instance.new("Frame")
baitSliderBg.Size = UDim2.new(0, 246, 0, 5)
baitSliderBg.Position = UDim2.new(0, 25, 0, 22)
baitSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
baitSliderBg.BackgroundTransparency = 0.3
baitSliderBg.BorderSizePixel = 0
baitSliderBg.ZIndex = 2
Instance.new("UICorner", baitSliderBg).CornerRadius = UDim.new(0, 3)
baitSliderBg.Parent = dynamicContent

baitSliderFill = Instance.new("Frame")
baitSliderFill.Size = UDim2.new((getgenv().WhiteTea_BaitDelay - 1) / 10, 0, 1, 0)
baitSliderFill.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
baitSliderFill.BorderSizePixel = 0
baitSliderFill.ZIndex = 3
Instance.new("UICorner", baitSliderFill).CornerRadius = UDim.new(0, 3)
baitSliderFill.Parent = baitSliderBg

baitSliderBtn = Instance.new("TextButton")
baitSliderBtn.Size = UDim2.new(0, 14, 0, 14)
baitSliderBtn.Position = UDim2.new((getgenv().WhiteTea_BaitDelay - 1) / 10, -7, 0.5, -7)
baitSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
baitSliderBtn.Text = ""
baitSliderBtn.BorderSizePixel = 0
baitSliderBtn.AutoButtonColor = false
baitSliderBtn.ZIndex = 4
Instance.new("UICorner", baitSliderBtn).CornerRadius = UDim.new(0, 7)
baitSliderBtn.Parent = baitSliderBg

local baitDragging = false
baitSliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then baitDragging = true end
end)
UserInputService.InputChanged:Connect(function(input)
    if baitDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local t = math.clamp((UserInputService:GetMouseLocation().X - baitSliderBg.AbsolutePosition.X) / baitSliderBg.AbsoluteSize.X, 0, 1)
        baitSliderFill.Size = UDim2.new(t, 0, 1, 0)
        baitSliderBtn.Position = UDim2.new(t, -7, 0.5, -7)
        getgenv().WhiteTea_BaitDelay = math.floor(1 + t * 10)
        baitSpeedLabel.Text = "购买间隔: " .. getgenv().WhiteTea_BaitDelay .. "秒"
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then baitDragging = false end
end)

local autoQuestRow = Instance.new("Frame")
autoQuestRow.Size = UDim2.new(0, 276, 0, 32)
autoQuestRow.Position = UDim2.new(0, 10, 0, 40)
autoQuestRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
autoQuestRow.BackgroundTransparency = 0.3
autoQuestRow.BorderSizePixel = 0
autoQuestRow.ZIndex = 2
Instance.new("UICorner", autoQuestRow).CornerRadius = UDim.new(0, 8)
autoQuestRow.Parent = dynamicContent

local autoQuestLabel = Instance.new("TextLabel")
autoQuestLabel.Size = UDim2.new(0, 210, 1, 0)
autoQuestLabel.Position = UDim2.new(0, 12, 0, 0)
autoQuestLabel.BackgroundTransparency = 1
autoQuestLabel.Text = "自动接取并提交刷票任务(挂机使用)"
autoQuestLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoQuestLabel.TextSize = 12
autoQuestLabel.Font = Enum.Font.GothamMedium
autoQuestLabel.TextXAlignment = Enum.TextXAlignment.Left
autoQuestLabel.ZIndex = 3
autoQuestLabel.Parent = autoQuestRow

autoQuestBtn = Instance.new("TextButton")
autoQuestBtn.Size = UDim2.new(0, 44, 0, 22)
autoQuestBtn.Position = UDim2.new(1, -54, 0.5, -11)
autoQuestBtn.BackgroundColor3 = getgenv().WhiteTea_AutoQuest and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
autoQuestBtn.Text = getgenv().WhiteTea_AutoQuest and "开启" or "关闭"
autoQuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoQuestBtn.TextSize = 10
autoQuestBtn.Font = Enum.Font.GothamBold
autoQuestBtn.AutoButtonColor = false
autoQuestBtn.ZIndex = 3
Instance.new("UICorner", autoQuestBtn).CornerRadius = UDim.new(0, 6)
autoQuestBtn.Parent = autoQuestRow

expandBaitBtn.MouseButton1Click:Connect(function()
    baitSelectFrame.Visible = not baitSelectFrame.Visible
    expandBaitBtn.Text = baitSelectFrame.Visible and "-" or "+"
    dynamicContent.Position = baitSelectFrame.Visible and UDim2.new(0, 0, 0, 288) or UDim2.new(0, 0, 0, 122)
    ticketScroll.CanvasSize = baitSelectFrame.Visible and UDim2.new(0, 0, 0, 566) or UDim2.new(0, 0, 0, 400)
end)

autoBuyBaitBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoBuyBait = not getgenv().WhiteTea_AutoBuyBait
    autoBuyBaitBtn.BackgroundColor3 = getgenv().WhiteTea_AutoBuyBait and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoBuyBaitBtn.Text = getgenv().WhiteTea_AutoBuyBait and "开启" or "关闭"
    if getgenv().WhiteTea_AutoBuyBait then
        task.spawn(function()
            while getgenv().WhiteTea_AutoBuyBait do
                for baitName, selected in pairs(getgenv().WhiteTea_SelectedBaits) do
                    if selected then pcall(function() replicatedStorage:WaitForChild("Events"):WaitForChild("BuyBait"):FireServer(baitName) end) end
                end
                task.wait(getgenv().WhiteTea_BaitDelay)
            end
        end)
    end
end)

autoQuestBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoQuest = not getgenv().WhiteTea_AutoQuest
    autoQuestBtn.BackgroundColor3 = getgenv().WhiteTea_AutoQuest and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoQuestBtn.Text = getgenv().WhiteTea_AutoQuest and "开启" or "关闭"
    if getgenv().WhiteTea_AutoQuest then
        task.spawn(function()
            local npc = workspace:WaitForChild("NPC", 5):WaitForChild("Function", 5):WaitForChild("Ticket Quest Giver", 5)
            local event = replicatedStorage:WaitForChild("Events", 5):WaitForChild("ChooseDialogueOption", 5)
            while getgenv().WhiteTea_AutoQuest do
                pcall(function() event:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {npc, "Ticket Quest"}) end)
                task.wait(0.5)
                pcall(function() event:FireServer("Ticket Quest Giver", 1, "Quest", {npc}) end)
                task.wait(5)
            end
        end)
    end
end)

local editorFrame = Instance.new("Frame")
editorFrame.Size = UDim2.new(0, 220, 0, 140)
editorFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
editorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
editorFrame.BorderSizePixel = 0
editorFrame.Active = true
editorFrame.Visible = false
editorFrame.ZIndex = 10
editorFrame.Parent = screenGui
Instance.new("UICorner", editorFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", editorFrame).Thickness = 1
editorFrame.UIStroke.Color = Color3.fromRGB(50, 50, 55)
makeDraggable(editorFrame)

local editorTopBar = Instance.new("Frame")
editorTopBar.Size = UDim2.new(1, 0, 0, 30)
editorTopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
editorTopBar.BorderSizePixel = 0
editorTopBar.ZIndex = 11
editorTopBar.Parent = editorFrame
Instance.new("UICorner", editorTopBar).CornerRadius = UDim.new(0, 12)
local editorTopCover = Instance.new("Frame")
editorTopCover.Size = UDim2.new(1, 0, 0, 12)
editorTopCover.Position = UDim2.new(0, 0, 1, -12)
editorTopCover.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
editorTopCover.BorderSizePixel = 0
editorTopCover.ZIndex = 11
editorTopCover.Parent = editorTopBar

local editorTitle = Instance.new("TextLabel")
editorTitle.Size = UDim2.new(1, -40, 1, 0)
editorTitle.Position = UDim2.new(0, 12, 0, 0)
editorTitle.BackgroundTransparency = 1
editorTitle.Text = "数值修改器"
editorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
editorTitle.TextSize = 13
editorTitle.Font = Enum.Font.GothamBold
editorTitle.TextXAlignment = Enum.TextXAlignment.Left
editorTitle.ZIndex = 12
editorTitle.Parent = editorTopBar

local editorClose = Instance.new("TextButton")
editorClose.Size = UDim2.new(0, 22, 0, 22)
editorClose.Position = UDim2.new(1, -26, 0, 4)
editorClose.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
editorClose.Text = "X"
editorClose.TextColor3 = Color3.fromRGB(255, 255, 255)
editorClose.TextSize = 11
editorClose.Font = Enum.Font.GothamBold
editorClose.AutoButtonColor = false
editorClose.ZIndex = 12
Instance.new("UICorner", editorClose).CornerRadius = UDim.new(0, 11)
editorClose.Parent = editorTopBar
editorClose.MouseButton1Click:Connect(function() editorFrame.Visible = false end)

local ticketLabel = Instance.new("TextLabel")
ticketLabel.Size = UDim2.new(0, 60, 0, 22)
ticketLabel.Position = UDim2.new(0, 18, 0, 42)
ticketLabel.BackgroundTransparency = 1
ticketLabel.Text = "票数:"
ticketLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ticketLabel.TextSize = 12
ticketLabel.Font = Enum.Font.GothamMedium
ticketLabel.ZIndex = 11
ticketLabel.Parent = editorFrame

local ticketBox = Instance.new("TextBox")
ticketBox.Size = UDim2.new(0, 140, 0, 24)
ticketBox.Position = UDim2.new(0, 65, 0, 41)
ticketBox.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
ticketBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ticketBox.TextSize = 12
ticketBox.Font = Enum.Font.Gotham
ticketBox.Text = "15"
ticketBox.PlaceholderText = "输入票数"
ticketBox.ZIndex = 11
Instance.new("UICorner", ticketBox).CornerRadius = UDim.new(0, 6)
ticketBox.Parent = editorFrame

local crystalLabel = Instance.new("TextLabel")
crystalLabel.Size = UDim2.new(0, 60, 0, 22)
crystalLabel.Position = UDim2.new(0, 18, 0, 72)
crystalLabel.BackgroundTransparency = 1
crystalLabel.Text = "水晶数:"
crystalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
crystalLabel.TextSize = 12
crystalLabel.Font = Enum.Font.GothamMedium
crystalLabel.ZIndex = 11
crystalLabel.Parent = editorFrame

local crystalBox = Instance.new("TextBox")
crystalBox.Size = UDim2.new(0, 140, 0, 24)
crystalBox.Position = UDim2.new(0, 65, 0, 71)
crystalBox.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
crystalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
crystalBox.TextSize = 12
crystalBox.Font = Enum.Font.Gotham
crystalBox.Text = "265"
crystalBox.PlaceholderText = "输入水晶数"
crystalBox.ZIndex = 11
Instance.new("UICorner", crystalBox).CornerRadius = UDim.new(0, 6)
crystalBox.Parent = editorFrame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 184, 0, 28)
applyBtn.Position = UDim2.new(0, 18, 0, 102)
applyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applyBtn.Text = "应用修改"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.TextSize = 12
applyBtn.Font = Enum.Font.GothamBold
applyBtn.ZIndex = 11
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)
applyBtn.Parent = editorFrame
applyBtn.MouseEnter:Connect(function() applyBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
applyBtn.MouseLeave:Connect(function() applyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)
applyBtn.MouseButton1Click:Connect(function()
    local player = Players.LocalPlayer
    local stats = player.PlayerGui:FindFirstChild("MainGui")
    if stats then stats = stats:FindFirstChild("Main") end
    if stats then stats = stats:FindFirstChild("Stats") end
    if stats then
        local ticket = stats:FindFirstChild("Ticket")
        if ticket then local val = ticket:FindFirstChild("Value") if val then val.Text = ticketBox.Text end end
        local crystal = stats:FindFirstChild("Crystal")
        if crystal then local val = crystal:FindFirstChild("Value") if val then val.Text = crystalBox.Text end end
    end
    editorFrame.Visible = false
end)

local teleportPage = Instance.new("Frame")
teleportPage.Size = UDim2.new(1, 0, 1, 0)
teleportPage.BackgroundTransparency = 1
teleportPage.Visible = false
teleportPage.ZIndex = 1
teleportPage.Parent = pageContainer

local teleportScroll = Instance.new("ScrollingFrame")
teleportScroll.Size = UDim2.new(1, 0, 1, 0)
teleportScroll.BackgroundTransparency = 1
teleportScroll.BorderSizePixel = 0
teleportScroll.ScrollBarThickness = 3
teleportScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 620)
teleportScroll.ZIndex = 1
teleportScroll.Parent = teleportPage

local teleportLocations = {
    {name = "初始岛", desc = "钓250条鱼,没有无我", pos = Vector3.new(-201, 7, 36), color = Color3.fromRGB(60, 200, 80)},
    {name = "竹子岛", desc = "暴风雨", pos = Vector3.new(-1223, 7, -24), color = Color3.fromRGB(100, 200, 100)},
    {name = "核弹岛", desc = "下雨", pos = Vector3.new(66, 7, 1181), color = Color3.fromRGB(255, 100, 100)},
    {name = "鲈鱼岛", desc = "有风", pos = Vector3.new(-62, 9, -1321), color = Color3.fromRGB(100, 180, 255)},
    {name = "冰霜岛", desc = "下雪", pos = Vector3.new(-1366, 9, -1495), color = Color3.fromRGB(150, 200, 255)},
    {name = "椰子岛", desc = "雾蒙蒙的", pos = Vector3.new(1494, 7, -1431), color = Color3.fromRGB(255, 220, 100)},
    {name = "琥珀岛", desc = "烈阳高照", pos = Vector3.new(1259, 7, 1401), color = Color3.fromRGB(255, 180, 50)},
    {name = "战场岛", desc = "钓5条1M以上boss", pos = Vector3.new(1393, 7, 170), color = Color3.fromRGB(255, 80, 80)},
    {name = "迷雾峰岛", desc = "未知区域", pos = Vector3.new(2660, 7, -87), color = Color3.fromRGB(180, 160, 220)}
}

for i, loc in ipairs(teleportLocations) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 276, 0, 54)
    card.Position = UDim2.new(0, 10, 0, 10 + (i-1)*60)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.ZIndex = 2
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    card.Parent = teleportScroll

    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 3, 1, -18)
    colorBar.Position = UDim2.new(0, 12, 0, 9)
    colorBar.BackgroundColor3 = loc.color
    colorBar.BorderSizePixel = 0
    colorBar.ZIndex = 3
    Instance.new("UICorner", colorBar).CornerRadius = UDim.new(0, 2)
    colorBar.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 120, 0, 18)
    nameLabel.Position = UDim2.new(0, 24, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = loc.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 3
    nameLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0, 120, 0, 14)
    descLabel.Position = UDim2.new(0, 24, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = loc.desc
    descLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.ZIndex = 3
    descLabel.Parent = card

    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Size = UDim2.new(0, 120, 0, 12)
    coordsLabel.Position = UDim2.new(0, 24, 0, 40)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.Text = string.format("%d, %d, %d", loc.pos.X, loc.pos.Y, loc.pos.Z)
    coordsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordsLabel.TextSize = 9
    coordsLabel.Font = Enum.Font.Gotham
    coordsLabel.ZIndex = 3
    coordsLabel.Parent = card

    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0, 52, 0, 28)
    teleportBtn.Position = UDim2.new(1, -62, 0.5, -14)
    teleportBtn.BackgroundColor3 = loc.color
    teleportBtn.Text = "传送"
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.TextSize = 11
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.AutoButtonColor = false
    teleportBtn.ZIndex = 3
    Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)
    teleportBtn.Parent = card
    teleportBtn.MouseButton1Click:Connect(function()
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(loc.pos) end
    end)
end

local traitPage = Instance.new("Frame")
traitPage.Size = UDim2.new(1, 0, 1, 0)
traitPage.BackgroundTransparency = 1
traitPage.Visible = false
traitPage.ZIndex = 1
traitPage.Parent = pageContainer

local traitScroll = Instance.new("ScrollingFrame")
traitScroll.Size = UDim2.new(1, 0, 1, 0)
traitScroll.BackgroundTransparency = 1
traitScroll.BorderSizePixel = 0
traitScroll.ScrollBarThickness = 3
traitScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
traitScroll.CanvasSize = UDim2.new(0, 0, 0, 240)
traitScroll.ZIndex = 1
traitScroll.Parent = traitPage

local traitContent = Instance.new("Frame")
traitContent.Size = UDim2.new(1, 0, 1, 0)
traitContent.BackgroundTransparency = 1
traitContent.ZIndex = 1
traitContent.Parent = traitScroll

createActionRow("打开特制抽取", "打开", 8, traitContent).MouseButton1Click:Connect(function()
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer("Nanjiang", 1, "OpenTrait", {
            workspace:WaitForChild("NPC"):WaitForChild("Function"):WaitForChild("Nanjiang")
        })
    end)
end)

createActionRow("特质石交换(1个或10个)", "打开", 46, traitContent).MouseButton1Click:Connect(function()
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer("Nanjiang", 2, "OpenTraitExchange", {
            workspace:WaitForChild("NPC"):WaitForChild("Function"):WaitForChild("Nanjiang")
        })
    end)
end)

local traitBulkBtn = createActionRow("兑换100个(500水晶)", "交换", 84, traitContent)
traitBulkBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 40)
traitBulkBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local event = replicatedStorage:WaitForChild("Events"):WaitForChild("ExchangeTrait")
        for i = 1, 10 do pcall(function() event:FireServer(10) end) task.wait() end
    end)
end)

createActionRow("远程打开角色升级(重生)", "打开", 122, traitContent).MouseButton1Click:Connect(function()
    pcall(function()
        local args = {"The Shadow", 1, "OpenUPGChar", {workspace:WaitForChild("NPC"):WaitForChild("Function"):WaitForChild("The Shadow")}}
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer(unpack(args))
    end)
end)

local configPage = Instance.new("Frame")
configPage.Size = UDim2.new(1, 0, 1, 0)
configPage.BackgroundTransparency = 1
configPage.Visible = false
configPage.ZIndex = 1
configPage.Parent = pageContainer

local configScroll = Instance.new("ScrollingFrame")
configScroll.Size = UDim2.new(1, 0, 1, 0)
configScroll.BackgroundTransparency = 1
configScroll.BorderSizePixel = 0
configScroll.ScrollBarThickness = 3
configScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
configScroll.CanvasSize = UDim2.new(0, 0, 0, 700)
configScroll.ZIndex = 1
configScroll.Parent = configPage

local configContent = Instance.new("Frame")
configContent.Size = UDim2.new(1, 0, 1, 0)
configContent.BackgroundTransparency = 1
configContent.ZIndex = 1
configContent.Parent = configScroll

local activeConfigLabel = Instance.new("TextLabel")
activeConfigLabel.Size = UDim2.new(1, -20, 0, 22)
activeConfigLabel.Position = UDim2.new(0, 14, 0, 8)
activeConfigLabel.BackgroundTransparency = 1
activeConfigLabel.Text = "当前配置: " .. activeConfigName
activeConfigLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
activeConfigLabel.TextSize = 12
activeConfigLabel.Font = Enum.Font.GothamMedium
activeConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
activeConfigLabel.ZIndex = 2
activeConfigLabel.Parent = configContent

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -20, 0, 16)
warningLabel.Position = UDim2.new(0, 14, 0, 30)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠️刷票中的购买饵料和接取并提交需重新启动"
warningLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
warningLabel.TextSize = 9
warningLabel.Font = Enum.Font.GothamMedium
warningLabel.TextXAlignment = Enum.TextXAlignment.Left
warningLabel.ZIndex = 2
warningLabel.Parent = configContent

local bgImageRow = Instance.new("Frame")
bgImageRow.Size = UDim2.new(0, 276, 0, 32)
bgImageRow.Position = UDim2.new(0, 10, 0, 52)
bgImageRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
bgImageRow.BackgroundTransparency = 0.3
bgImageRow.BorderSizePixel = 0
bgImageRow.ZIndex = 2
Instance.new("UICorner", bgImageRow).CornerRadius = UDim.new(0, 8)
bgImageRow.Parent = configContent

local bgImageLabel = Instance.new("TextLabel")
bgImageLabel.Size = UDim2.new(0, 120, 1, 0)
bgImageLabel.Position = UDim2.new(0, 12, 0, 0)
bgImageLabel.BackgroundTransparency = 1
bgImageLabel.Text = "背景图片ID:"
bgImageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bgImageLabel.TextSize = 11
bgImageLabel.Font = Enum.Font.GothamMedium
bgImageLabel.TextXAlignment = Enum.TextXAlignment.Left
bgImageLabel.ZIndex = 3
bgImageLabel.Parent = bgImageRow

local bgImageBox = Instance.new("TextBox")
bgImageBox.Size = UDim2.new(0, 80, 0, 22)
bgImageBox.Position = UDim2.new(0, 80, 0.5, -11)
bgImageBox.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
bgImageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
bgImageBox.TextSize = 11
bgImageBox.Font = Enum.Font.Gotham
bgImageBox.Text = currentBackgroundID
bgImageBox.PlaceholderText = "输入Decal ID"
bgImageBox.ZIndex = 3
Instance.new("UICorner", bgImageBox).CornerRadius = UDim.new(0, 5)
bgImageBox.Parent = bgImageRow

local applyBgBtn = Instance.new("TextButton")
applyBgBtn.Size = UDim2.new(0, 44, 0, 22)
applyBgBtn.Position = UDim2.new(1, -54, 0.5, -11)
applyBgBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applyBgBtn.Text = "应用"
applyBgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBgBtn.TextSize = 10
applyBgBtn.Font = Enum.Font.GothamBold
applyBgBtn.AutoButtonColor = false
applyBgBtn.ZIndex = 3
Instance.new("UICorner", applyBgBtn).CornerRadius = UDim.new(0, 6)
applyBgBtn.Parent = bgImageRow

applyBgBtn.MouseEnter:Connect(function() applyBgBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
applyBgBtn.MouseLeave:Connect(function() applyBgBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)

applyBgBtn.MouseButton1Click:Connect(function()
    local newID = bgImageBox.Text
    if newID ~= "" then
        currentBackgroundID = newID
        backgroundImage.Image = "rbxassetid://" .. newID
        configData.BackgroundImageID = newID
    end
end)

local createConfigRow = Instance.new("Frame")
createConfigRow.Size = UDim2.new(0, 276, 0, 32)
createConfigRow.Position = UDim2.new(0, 10, 0, 92)
createConfigRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
createConfigRow.BackgroundTransparency = 0.3
createConfigRow.BorderSizePixel = 0
createConfigRow.ZIndex = 2
Instance.new("UICorner", createConfigRow).CornerRadius = UDim.new(0, 8)
createConfigRow.Parent = configContent

local createConfigLabel = Instance.new("TextLabel")
createConfigLabel.Size = UDim2.new(0, 160, 1, 0)
createConfigLabel.Position = UDim2.new(0, 12, 0, 0)
createConfigLabel.BackgroundTransparency = 1
createConfigLabel.Text = "创建新配置"
createConfigLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
createConfigLabel.TextSize = 12
createConfigLabel.Font = Enum.Font.GothamMedium
createConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
createConfigLabel.ZIndex = 3
createConfigLabel.Parent = createConfigRow

local createConfigBtn = Instance.new("TextButton")
createConfigBtn.Size = UDim2.new(0, 52, 0, 22)
createConfigBtn.Position = UDim2.new(1, -62, 0.5, -11)
createConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
createConfigBtn.Text = "创建"
createConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createConfigBtn.TextSize = 10
createConfigBtn.Font = Enum.Font.GothamBold
createConfigBtn.AutoButtonColor = false
createConfigBtn.ZIndex = 3
Instance.new("UICorner", createConfigBtn).CornerRadius = UDim.new(0, 6)
createConfigBtn.Parent = createConfigRow
createConfigBtn.MouseEnter:Connect(function() createConfigBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
createConfigBtn.MouseLeave:Connect(function() createConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)

local configListFrame = Instance.new("Frame")
configListFrame.Size = UDim2.new(0, 276, 0, 400)
configListFrame.Position = UDim2.new(0, 10, 0, 132)
configListFrame.BackgroundTransparency = 1
configListFrame.ZIndex = 1
configListFrame.Parent = configContent

local function RefreshAllUI()
    weatherNotifyBtn.BackgroundColor3 = getgenv().WhiteTea_WeatherNotify and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    weatherNotifyBtn.Text = getgenv().WhiteTea_WeatherNotify and "开启" or "关闭"
    anchorBtn.BackgroundColor3 = getgenv().WhiteTea_Anchor and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    anchorBtn.Text = getgenv().WhiteTea_Anchor and "开启" or "关闭"
    autoCastBtn.BackgroundColor3 = getgenv().WhiteTea_AutoCast and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoCastBtn.Text = getgenv().WhiteTea_AutoCast and "开启" or "关闭"
    skillToggleBtn.BackgroundColor3 = getgenv().WhiteTea_AutoSkill and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    skillToggleBtn.Text = getgenv().WhiteTea_AutoSkill and "开启" or "关闭"
    for key, btn in pairs(skillBtns) do
        btn.BackgroundColor3 = getgenv().WhiteTea_Skills[key] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    end
    autoSellBtn.BackgroundColor3 = getgenv().WhiteTea_AutoSell and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoSellBtn.Text = getgenv().WhiteTea_AutoSell and "开启" or "关闭"
    bossQTEBtn.BackgroundColor3 = getgenv().WhiteTea_BossQTE and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    bossQTEBtn.Text = getgenv().WhiteTea_BossQTE and "开启" or "关闭"
    enzoCamBtn.BackgroundColor3 = getgenv().WhiteTea_EnzoCam and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 130, 255)
    autoBuyBaitBtn.BackgroundColor3 = getgenv().WhiteTea_AutoBuyBait and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoBuyBaitBtn.Text = getgenv().WhiteTea_AutoBuyBait and "开启" or "关闭"
    for baitName, btn in pairs(baitBtns) do
        btn.BackgroundColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
        btn.TextColor3 = getgenv().WhiteTea_SelectedBaits[baitName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 205)
    end
    baitSpeedLabel.Text = "购买间隔: " .. getgenv().WhiteTea_BaitDelay .. "秒"
    local t = (getgenv().WhiteTea_BaitDelay - 1) / 10
    baitSliderFill.Size = UDim2.new(t, 0, 1, 0)
    baitSliderBtn.Position = UDim2.new(t, -7, 0.5, -7)
    autoQuestBtn.BackgroundColor3 = getgenv().WhiteTea_AutoQuest and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(55, 55, 60)
    autoQuestBtn.Text = getgenv().WhiteTea_AutoQuest and "开启" or "关闭"
end

local function RefreshConfigList()
    for _, child in ipairs(configListFrame:GetChildren()) do child:Destroy() end
    local allConfigs = Config.GetAllConfigs()
    local currentActive = Config.GetActiveConfig()
    activeConfigLabel.Text = "当前配置: " .. activeConfigName

    for i, configName in ipairs(allConfigs) do
        local isCurrent = configName == activeConfigName
        local configRow = Instance.new("Frame")
        configRow.Size = UDim2.new(1, 0, 0, 32)
        configRow.Position = UDim2.new(0, 0, 0, (i-1)*38)
        configRow.BackgroundColor3 = isCurrent and Color3.fromRGB(40, 60, 80) or Color3.fromRGB(28, 28, 34)
        configRow.BackgroundTransparency = isCurrent and 0.2 or 0.3
        configRow.BorderSizePixel = 0
        configRow.ZIndex = 2
        Instance.new("UICorner", configRow).CornerRadius = UDim.new(0, 8)
        configRow.Parent = configListFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 100, 1, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = configName
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 11
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 3
        nameLabel.Parent = configRow

        if not isCurrent then
            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 36, 0, 20)
            loadBtn.Position = UDim2.new(1, -92, 0.5, -10)
            loadBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
            loadBtn.Text = "加载"
            loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            loadBtn.TextSize = 9
            loadBtn.Font = Enum.Font.GothamBold
            loadBtn.AutoButtonColor = false
            loadBtn.ZIndex = 3
            Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 5)
            loadBtn.Parent = configRow
            loadBtn.MouseEnter:Connect(function() loadBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
            loadBtn.MouseLeave:Connect(function() loadBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)
            loadBtn.MouseButton1Click:Connect(function()
                activeConfigName = configName
                Config.SetActive(configName)
                local newConfigData = Config.Load(configName)
                Config.ApplySettings(newConfigData.Settings)
                configData = newConfigData
                currentBackgroundID = newConfigData.BackgroundImageID or "17470093533"
                backgroundImage.Image = "rbxassetid://" .. currentBackgroundID
                bgImageBox.Text = currentBackgroundID
                getgenv().WhiteTea_WeatherNotify = newConfigData.Settings.WeatherNotify
                getgenv().WhiteTea_Anchor = newConfigData.Settings.Anchor
                getgenv().WhiteTea_AutoCast = newConfigData.Settings.AutoCast
                getgenv().WhiteTea_AutoSkill = newConfigData.Settings.AutoSkill
                getgenv().WhiteTea_Skills = newConfigData.Settings.Skills
                getgenv().WhiteTea_AutoSell = newConfigData.Settings.AutoSell
                getgenv().WhiteTea_SellDelay = newConfigData.Settings.SellDelay
                getgenv().WhiteTea_AutoBuyBait = newConfigData.Settings.AutoBuyBait
                getgenv().WhiteTea_BaitDelay = newConfigData.Settings.BaitDelay
                getgenv().WhiteTea_SelectedBaits = newConfigData.Settings.SelectedBaits
                getgenv().WhiteTea_AutoQuest = newConfigData.Settings.AutoQuest
                getgenv().WhiteTea_BossQTE = newConfigData.Settings.BossQTE
                getgenv().WhiteTea_EnzoCam = newConfigData.Settings.EnzoCam
                if newConfigData.Window and newConfigData.Window.Position then
                    pcall(function() mainFrame.Position = newConfigData.Window.Position end)
                end
                if newConfigData.Window and newConfigData.Window.Size then
                    pcall(function() mainFrame.Size = newConfigData.Window.Size end)
                end
                RefreshAllUI()
                RefreshConfigList()
            end)
        else
            local activeTag = Instance.new("TextLabel")
            activeTag.Size = UDim2.new(0, 44, 0, 20)
            activeTag.Position = UDim2.new(1, -54, 0.5, -10)
            activeTag.BackgroundTransparency = 1
            activeTag.Text = "使用中"
            activeTag.TextColor3 = Color3.fromRGB(60, 200, 80)
            activeTag.TextSize = 9
            activeTag.Font = Enum.Font.GothamBold
            activeTag.TextXAlignment = Enum.TextXAlignment.Center
            activeTag.ZIndex = 3
            activeTag.Parent = configRow
        end

        if configName ~= "Default" and configName ~= activeConfigName then
            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Size = UDim2.new(0, 36, 0, 20)
            deleteBtn.Position = UDim2.new(1, -44, 0.5, -10)
            deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            deleteBtn.Text = "删除"
            deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            deleteBtn.TextSize = 9
            deleteBtn.Font = Enum.Font.GothamBold
            deleteBtn.AutoButtonColor = false
            deleteBtn.ZIndex = 3
            Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(0, 5)
            deleteBtn.Parent = configRow
            deleteBtn.MouseEnter:Connect(function() deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90) end)
            deleteBtn.MouseLeave:Connect(function() deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70) end)
            deleteBtn.MouseButton1Click:Connect(function()
                Config.Delete(configName)
                RefreshConfigList()
            end)
        end
    end
    configScroll.CanvasSize = UDim2.new(0, 0, 0, 140 + math.max(#allConfigs * 38, 100))
end

createConfigBtn.MouseButton1Click:Connect(function()
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 220, 0, 90)
    inputFrame.Position = UDim2.new(0.5, -110, 0.5, -45)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    inputFrame.BorderSizePixel = 0
    inputFrame.Active = true
    inputFrame.ZIndex = 20
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 12)
    inputFrame.Parent = screenGui

    local inputTopBar = Instance.new("Frame")
    inputTopBar.Size = UDim2.new(1, 0, 0, 28)
    inputTopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    inputTopBar.BorderSizePixel = 0
    inputTopBar.ZIndex = 21
    Instance.new("UICorner", inputTopBar).CornerRadius = UDim.new(0, 12)
    inputTopBar.Parent = inputFrame
    local inputTopCover = Instance.new("Frame")
    inputTopCover.Size = UDim2.new(1, 0, 0, 12)
    inputTopCover.Position = UDim2.new(0, 0, 1, -12)
    inputTopCover.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    inputTopCover.BorderSizePixel = 0
    inputTopCover.ZIndex = 21
    inputTopCover.Parent = inputTopBar

    local inputTitle = Instance.new("TextLabel")
    inputTitle.Size = UDim2.new(1, -40, 1, 0)
    inputTitle.Position = UDim2.new(0, 12, 0, 0)
    inputTitle.BackgroundTransparency = 1
    inputTitle.Text = "创建新配置"
    inputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputTitle.TextSize = 12
    inputTitle.Font = Enum.Font.GothamBold
    inputTitle.TextXAlignment = Enum.TextXAlignment.Left
    inputTitle.ZIndex = 22
    inputTitle.Parent = inputTopBar

    local inputClose = Instance.new("TextButton")
    inputClose.Size = UDim2.new(0, 20, 0, 20)
    inputClose.Position = UDim2.new(1, -24, 0, 4)
    inputClose.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    inputClose.Text = "X"
    inputClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputClose.TextSize = 10
    inputClose.Font = Enum.Font.GothamBold
    inputClose.AutoButtonColor = false
    inputClose.ZIndex = 22
    Instance.new("UICorner", inputClose).CornerRadius = UDim.new(0, 10)
    inputClose.Parent = inputTopBar
    inputClose.MouseButton1Click:Connect(function() inputFrame:Destroy() end)

    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(0, 184, 0, 26)
    nameBox.Position = UDim2.new(0, 18, 0, 36)
    nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameBox.TextSize = 12
    nameBox.Font = Enum.Font.Gotham
    nameBox.Text = ""
    nameBox.PlaceholderText = "输入配置名称"
    nameBox.ZIndex = 21
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)
    nameBox.Parent = inputFrame

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0, 184, 0, 24)
    confirmBtn.Position = UDim2.new(0, 18, 0, 66)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    confirmBtn.Text = "确认创建"
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.TextSize = 11
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.AutoButtonColor = false
    confirmBtn.ZIndex = 21
    Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 6)
    confirmBtn.Parent = inputFrame
    confirmBtn.MouseEnter:Connect(function() confirmBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
    confirmBtn.MouseLeave:Connect(function() confirmBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)
    makeDraggable(inputFrame)

    confirmBtn.MouseButton1Click:Connect(function()
        local newName = nameBox.Text
        if newName ~= "" and newName ~= "Default" then
            local newConfig = {
                Window = { Position = mainFrame.Position, Size = mainFrame.Size },
                Settings = Config.CollectSettings(),
                BackgroundImageID = currentBackgroundID,
            }
            Config.Create(newName, newConfig)
            RefreshConfigList()
            inputFrame:Destroy()
        end
    end)
end)

RefreshConfigList()

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 170, 0, 42)
miniFrame.Position = UDim2.new(0.5, -85, 0.5, -21)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
miniFrame.BackgroundTransparency = 0.3
miniFrame.Text = "❤️打开UI · Made by 白茶❤️"
miniFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
miniFrame.TextSize = 13
miniFrame.Font = Enum.Font.GothamBold
miniFrame.BorderSizePixel = 0
miniFrame.AutoButtonColor = false
miniFrame.Visible = false
miniFrame.ZIndex = 10
miniFrame.Parent = screenGui
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", miniFrame).Thickness = 1
miniFrame.UIStroke.Color = Color3.fromRGB(50, 50, 55)

miniButton.MouseButton1Click:Connect(function() mainFrame.Visible = false miniFrame.Visible = true end)

closeButton.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_Anchor = false
    getgenv().WhiteTea_AutoCast = false
    getgenv().WhiteTea_AutoSkill = false
    getgenv().WhiteTea_AutoSell = false
    getgenv().WhiteTea_WeatherNotify = false
    getgenv().WhiteTea_BossQTE = false
    getgenv().WhiteTea_EnzoCam = false
    getgenv().WhiteTea_AutoBuyBait = false
    getgenv().WhiteTea_AutoQuest = false
    screenGui:Destroy()
end)

local miniDragging, miniDragStart, miniStartPos = false, nil, nil
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging, miniDragStart, miniStartPos = true, input.Position, miniFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if miniDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - miniDragStart
        miniFrame.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + d.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + d.Y)
    end
end)
miniFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if miniDragging and (input.Position - miniDragStart).Magnitude < 5 then
            miniFrame.Visible, mainFrame.Visible = false, true
        end
        miniDragging = false
    end
end)

local function switchPage(page)
    fishingPage.Visible = page == "fishing"
    bossPage.Visible = page == "boss"
    ticketPage.Visible = page == "ticket"
    teleportPage.Visible = page == "teleport"
    traitPage.Visible = page == "trait"
    configPage.Visible = page == "config"

    fishingNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    fishingNavBtn.BackgroundTransparency = 0.3
    fishingNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bossNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    bossNavBtn.BackgroundTransparency = 0.3
    bossNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ticketNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    ticketNavBtn.BackgroundTransparency = 0.3
    ticketNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    teleportNavBtn.BackgroundTransparency = 0.3
    teleportNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    traitNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    traitNavBtn.BackgroundTransparency = 0.3
    traitNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    configNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    configNavBtn.BackgroundTransparency = 0.3
    configNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local activeBtn = fishingNavBtn
    local pageTitle = "钓鱼功能🎣"
    if page == "boss" then activeBtn = bossNavBtn; pageTitle = "BOSS RAID💀"
    elseif page == "ticket" then activeBtn = ticketNavBtn; pageTitle = "刷票功能😱"
    elseif page == "teleport" then activeBtn = teleportNavBtn; pageTitle = "传送功能📍"
    elseif page == "trait" then activeBtn = traitNavBtn; pageTitle = "角色/特制功能🎲"
    elseif page == "config" then activeBtn = configNavBtn; pageTitle = "配置管理⚙️" end

    activeBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    activeBtn.BackgroundTransparency = 0
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = pageTitle
end

fishingNavBtn.MouseButton1Click:Connect(function() switchPage("fishing") end)
bossNavBtn.MouseButton1Click:Connect(function() switchPage("boss") end)
ticketNavBtn.MouseButton1Click:Connect(function() switchPage("ticket") end)
teleportNavBtn.MouseButton1Click:Connect(function() switchPage("teleport") end)
traitNavBtn.MouseButton1Click:Connect(function() switchPage("trait") end)
configNavBtn.MouseButton1Click:Connect(function() switchPage("config") end)

task.spawn(function()
    while task.wait(1) do
        if getgenv().WhiteTea_AutoCast then
            pcall(function()
                local Character = Players.LocalPlayer.Character
                local MainGui = Players.LocalPlayer.PlayerGui:FindFirstChild("MainGui")
                if MainGui then
                    local FishingGui = MainGui:FindFirstChild("Fishing")
                    if Character and not Character:GetAttribute("Fishing") and FishingGui and not FishingGui.Visible then
                        replicatedStorage.Events.Fishing:FireServer()
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    local KeyMap = { Z = Enum.KeyCode.Z, X = Enum.KeyCode.X, C = Enum.KeyCode.C, V = Enum.KeyCode.V }
    while task.wait(0.5) do
        if getgenv().WhiteTea_AutoSkill then
            for KeyName, KeyCode in pairs(KeyMap) do
                if getgenv().WhiteTea_Skills[KeyName] then
                    VirtualInputManager:SendKeyEvent(true, KeyCode, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, KeyCode, false, game)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(getgenv().WhiteTea_SellDelay)
        if getgenv().WhiteTea_AutoSell then
            pcall(function() replicatedStorage.Events.SellFish:FireServer("All") end)
        end
    end
end)

local hue = 0
local LocalPlayer = Players.LocalPlayer
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.3) % 1
    local c = HSVtoRGB(hue, 0.8, 1)
    title.TextColor3 = c
    if miniFrame.Visible then miniFrame.TextColor3 = c end
    if getgenv().WhiteTea_Anchor then
        pcall(function()
            local mg = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
            if mg then
                local fg = mg:FindFirstChild("Fishing")
                if fg and fg.Visible then
                    local bf = fg:FindFirstChild("BarFrame")
                    if bf then
                        local bar = bf:FindFirstChild("Bar")
                        if bar then
                            bar.Position = UDim2.new(0.5, 0, bar.Position.Y.Scale, 0)
                            replicatedStorage.Fishing:FireServer("1")
                        end
                    end
                end
            end
        end)
    end
end)
