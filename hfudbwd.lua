local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

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
        if child:IsA("Frame") then
            table.insert(existingFrames, child)
        end
    end

    local function getTotalHeight()
        local total = 10
        for _, f in ipairs(existingFrames) do
            total = total + f.AbsoluteSize.Y + 10
        end
        return total
    end

    local measureLabel = Instance.new("TextLabel")
    measureLabel.Text = text
    measureLabel.Font = Enum.Font.GothamBold
    measureLabel.TextSize = 17
    measureLabel.TextWrapped = false

    local textSize = TextService:GetTextSize(
        measureLabel.Text,
        measureLabel.TextSize,
        measureLabel.Font,
        Vector2.new(math.huge, math.huge)
    )
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(60, 60, 65)
    stroke.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "MessageLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 17
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame

    local targetPosition = UDim2.new(1, -frameWidth - 12, 0, startY)
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(frame, tweenInfo, {Position = targetPosition}):Play()

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

    local function removeFrame()
        if rainbowConnection then rainbowConnection:Disconnect() end
        local tweenOut = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(frame, tweenOut, {Position = UDim2.new(1, 0, 0, frame.Position.Y.Offset)}):Play()
        task.wait(0.25)
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(remaining, child)
            end
        end
        table.sort(remaining, function(a, b)
            return a.Position.Y.Offset < b.Position.Y.Offset
        end)
        local newY = 10
        for _, f in ipairs(remaining) do
            local targetY = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            local tweenUp = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(f, tweenUp, {Position = targetY}):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end

    task.wait(5)
    removeFrame()
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
        if child:IsA("Frame") then
            table.insert(existingFrames, child)
        end
    end

    local function getTotalHeight()
        local total = 10
        for _, f in ipairs(existingFrames) do
            total = total + f.AbsoluteSize.Y + 10
        end
        return total
    end

    local text = "是否要传送到" .. islandName .. "?"
    local measureLabel = Instance.new("TextLabel")
    measureLabel.Text = text
    measureLabel.Font = Enum.Font.GothamBold
    measureLabel.TextSize = 17
    measureLabel.TextWrapped = false

    local textSize = TextService:GetTextSize(
        measureLabel.Text,
        measureLabel.TextSize,
        measureLabel.Font,
        Vector2.new(math.huge, math.huge)
    )
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(60, 60, 65)
    stroke.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "MessageLabel"
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
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = teleportBtn
    teleportBtn.Parent = frame

    teleportBtn.MouseEnter:Connect(function() teleportBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
    teleportBtn.MouseLeave:Connect(function() teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)

    teleportBtn.MouseButton1Click:Connect(function()
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(teleportPos)
        end
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(remaining, child)
            end
        end
        table.sort(remaining, function(a, b)
            return a.Position.Y.Offset < b.Position.Y.Offset
        end)
        local newY = 10
        for _, f in ipairs(remaining) do
            local targetY = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            local tweenUp = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(f, tweenUp, {Position = targetY}):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end)

    local targetPosition = UDim2.new(1, -frameWidth - 12, 0, startY)
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(frame, tweenInfo, {Position = targetPosition}):Play()

    local hue = 0
    local rainbowConnection
    rainbowConnection = RunService.RenderStepped:Connect(function(deltaTime)
        hue = (hue + deltaTime * 0.5) % 1
        textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)

    local function removeFrame()
        rainbowConnection:Disconnect()
        local tweenOut = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(frame, tweenOut, {Position = UDim2.new(1, 0, 0, frame.Position.Y.Offset)}):Play()
        task.wait(0.25)
        frame:Destroy()
        local remaining = {}
        for _, child in ipairs(screenGui:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(remaining, child)
            end
        end
        table.sort(remaining, function(a, b)
            return a.Position.Y.Offset < b.Position.Y.Offset
        end)
        local newY = 10
        for _, f in ipairs(remaining) do
            local targetY = UDim2.new(1, -f.AbsoluteSize.X - 12, 0, newY)
            local tweenUp = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(f, tweenUp, {Position = targetY}):Play()
            newY = newY + f.AbsoluteSize.Y + 10
        end
    end

    task.wait(10)
    removeFrame()
end

local weatherColors = {
    ["Clear"] = Color3.fromRGB(255, 255, 150),
    ["Windy"] = Color3.fromRGB(100, 180, 255),
    ["Snowy"] = Color3.fromRGB(200, 230, 255),
    ["Thunderstorm"] = Color3.fromRGB(180, 180, 100),
    ["Foggy"] = Color3.fromRGB(200, 200, 200),
    ["Rainy"] = Color3.fromRGB(100, 150, 255),
    ["Blazing Sun"] = Color3.fromRGB(255, 180, 50)
}

local weatherIslands = {
    ["Windy"] = {name = "鲈鱼岛", pos = Vector3.new(-62, 9, -1321)},
    ["Snowy"] = {name = "冰霜岛", pos = Vector3.new(-1366, 9, -1495)},
    ["Thunderstorm"] = {name = "竹子岛", pos = Vector3.new(-1223, 7, -24)},
    ["Foggy"] = {name = "椰子岛", pos = Vector3.new(1494, 7, -1431)},
    ["Rainy"] = {name = "核弹岛", pos = Vector3.new(66, 7, 1181)},
    ["Blazing Sun"] = {name = "琥珀岛", pos = Vector3.new(1259, 7, 1401)}
}

getgenv().WhiteTea_WeatherNotify = true

local lastWeather = nil
task.spawn(function()
    local Event = replicatedStorage.Events.Notification
    if not Event then return end
    
    local connection
    connection = Event.OnClientEvent:Connect(function(message)
        if not getgenv().WhiteTea_WeatherNotify then return end
        if typeof(message) == "string" then
            local weather = string.match(message, "The weather has been changed to (.+)!")
            if weather and weather ~= lastWeather then
                lastWeather = weather
                local weatherColor = weatherColors[weather]
                showPopup("天气已变为 " .. weather, weatherColor)
                
                local islandData = weatherIslands[weather]
                if islandData then
                    task.wait(2)
                    showTeleportPopup(islandData.name, islandData.pos)
                end
            end
        end
    end)
end)

task.spawn(function()
    task.wait(1)
    showPopup("欢迎使用")
    task.wait(0.5)
    showPopup("脚本作者为白茶")
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoQuestGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 310)
mainFrame.Position = UDim2.new(0.5, -175, 0.4, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local function HSVtoRGB(h, s, v)
    h = h % 1
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

local function makeDraggable(frame)
    local UserInputService = game:GetService("UserInputService")
    local gui = frame
    
    local dragging
    local dragInput
    local dragStart
    local startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 12)
topBarCover.Position = UDim2.new(0, 0, 1, -12)
topBarCover.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
topBarCover.BorderSizePixel = 0
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
title.Parent = topBar

local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 56, 0, 22)
windowControls.Position = UDim2.new(1, -60, 0.5, -11)
windowControls.BackgroundTransparency = 1
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
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 11)
closeCorner.Parent = closeButton
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
local miniCornerBtn = Instance.new("UICorner")
miniCornerBtn.CornerRadius = UDim.new(0, 11)
miniCornerBtn.Parent = miniButton
miniButton.Parent = windowControls

miniButton.MouseEnter:Connect(function() miniButton.BackgroundColor3 = Color3.fromRGB(255, 190, 60) end)
miniButton.MouseLeave:Connect(function() miniButton.BackgroundColor3 = Color3.fromRGB(255, 170, 40) end)

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 56, 1, -36)
navBar.Position = UDim2.new(0, 0, 0, 36)
navBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

local navScroll = Instance.new("ScrollingFrame")
navScroll.Size = UDim2.new(1, 0, 1, 0)
navScroll.BackgroundTransparency = 1
navScroll.BorderSizePixel = 0
navScroll.ScrollBarThickness = 0
navScroll.CanvasSize = UDim2.new(0, 0, 0, 380)
navScroll.Parent = navBar

local function createNavButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 46)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.Text = icon .. "\n" .. text
    btn.TextColor3 = Color3.fromRGB(180, 180, 185)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    btn.Parent = navScroll
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    end)
    
    return btn
end

local fishingNavBtn = createNavButton("钓鱼", "🎣", 8)
local bossNavBtn = createNavButton("Boss", "💀", 60)
local ticketNavBtn = createNavButton("刷票", "🎫", 112)
local teleportNavBtn = createNavButton("传送", "📍", 164)
local traitNavBtn = createNavButton("特制/角色升级", "🎲", 216)

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -56, 1, -36)
pageContainer.Position = UDim2.new(0, 56, 0, 36)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = mainFrame

local fishingPage = Instance.new("Frame")
fishingPage.Size = UDim2.new(1, 0, 1, 0)
fishingPage.BackgroundTransparency = 1
fishingPage.Visible = true
fishingPage.Parent = pageContainer

local fishingScroll = Instance.new("ScrollingFrame")
fishingScroll.Size = UDim2.new(1, 0, 1, 0)
fishingScroll.BackgroundTransparency = 1
fishingScroll.BorderSizePixel = 0
fishingScroll.ScrollBarThickness = 3
fishingScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
fishingScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
fishingScroll.Parent = fishingPage

local function createToggleRow(label, defaultState, yPos, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 276, 0, 32)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 180, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 200, 205)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
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
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    return btn, lbl
end

local function createActionRow(label, btnText, yPos, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 276, 0, 32)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 180, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 200, 205)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
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
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)

    return btn
end

local weatherNotifyBtn, _ = createToggleRow("天气弹窗通知", true, 8, fishingScroll)
getgenv().WhiteTea_WeatherNotify = true

weatherNotifyBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_WeatherNotify = not getgenv().WhiteTea_WeatherNotify
    if getgenv().WhiteTea_WeatherNotify then
        weatherNotifyBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        weatherNotifyBtn.Text = "开启"
    else
        weatherNotifyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        weatherNotifyBtn.Text = "关闭"
    end
end)

local anchorBtn, _ = createToggleRow("钓鱼条锚定", true, 46, fishingScroll)
getgenv().WhiteTea_Anchor = true

anchorBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_Anchor = not getgenv().WhiteTea_Anchor
    if getgenv().WhiteTea_Anchor then
        anchorBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        anchorBtn.Text = "开启"
    else
        anchorBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        anchorBtn.Text = "关闭"
    end
end)

local autoCastBtn, _ = createToggleRow("自动抛竿(挂机请自备连点器)", false, 84, fishingScroll)
getgenv().WhiteTea_AutoCast = false

autoCastBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoCast = not getgenv().WhiteTea_AutoCast
    if getgenv().WhiteTea_AutoCast then
        autoCastBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        autoCastBtn.Text = "开启"
    else
        autoCastBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        autoCastBtn.Text = "关闭"
    end
end)

getgenv().WhiteTea_AutoSkill = false
getgenv().WhiteTea_Skills = {Z = true, X = true, C = true, V = true}

local skillToggleBtn, _ = createToggleRow("自动技能(开启后无法手动抛竿)", false, 122, fishingScroll)

skillToggleBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoSkill = not getgenv().WhiteTea_AutoSkill
    if getgenv().WhiteTea_AutoSkill then
        skillToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        skillToggleBtn.Text = "开启"
    else
        skillToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        skillToggleBtn.Text = "关闭"
    end
end)

local skillKeys = {"Z", "X", "C", "V"}

local skillsRow = Instance.new("Frame")
skillsRow.Size = UDim2.new(0, 276, 0, 30)
skillsRow.Position = UDim2.new(0, 10, 0, 160)
skillsRow.BackgroundTransparency = 1
skillsRow.Parent = fishingScroll

for i, key in ipairs(skillKeys) do
    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 60, 0, 28)
    skillBtn.Position = UDim2.new(0, (i-1)*72, 0, 0)
    skillBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
    skillBtn.Text = key
    skillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    skillBtn.TextSize = 14
    skillBtn.Font = Enum.Font.GothamBold
    skillBtn.AutoButtonColor = false
    local skillCorner = Instance.new("UICorner")
    skillCorner.CornerRadius = UDim.new(0, 6)
    skillCorner.Parent = skillBtn
    skillBtn.Parent = skillsRow

    skillBtn.MouseButton1Click:Connect(function()
        getgenv().WhiteTea_Skills[key] = not getgenv().WhiteTea_Skills[key]
        if getgenv().WhiteTea_Skills[key] then
            skillBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        else
            skillBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        end
    end)
end

getgenv().WhiteTea_AutoSell = false
getgenv().WhiteTea_SellDelay = 5

local autoSellBtn, _ = createToggleRow("自动售卖(可能不完善)", false, 198, fishingScroll)

autoSellBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoSell = not getgenv().WhiteTea_AutoSell
    if getgenv().WhiteTea_AutoSell then
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        autoSellBtn.Text = "开启"
    else
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        autoSellBtn.Text = "关闭"
    end
end)

getgenv().WhiteTea_AutoFavorite = false

local autoFavoriteBtn, _ = createToggleRow("自动收藏诱饵材料", false, 236, fishingScroll)

autoFavoriteBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoFavorite = not getgenv().WhiteTea_AutoFavorite
    if getgenv().WhiteTea_AutoFavorite then
        autoFavoriteBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        autoFavoriteBtn.Text = "开启"
        task.spawn(function()
            local favoriteEvent = replicatedStorage.Events.FavoriteItem
            local targetFish = {
                "Colossal Tigerfish",
                "Heavenpiercer Turtle",
                "Golden Guardian Fish",
                "Crimson Electric Eel",
                "Frost Kingfish",
                "Ascended Perch",
                "Primordial Kunfish Overlord",
                "Warbringer Shark"
            }
            while getgenv().WhiteTea_AutoFavorite do
                pcall(function()
                    local scroll = Players.LocalPlayer.PlayerGui.MainGui.Main.Inventory.Main.List.ScrollingFrame
                    for _, child in ipairs(scroll:GetChildren()) do
                        if child:IsA("GuiObject") then
                            local fishText = ""
                            for _, label in ipairs(child:GetDescendants()) do
                                if label:IsA("TextLabel") then
                                    for _, name in ipairs(targetFish) do
                                        if string.find(label.Text, name) then
                                            fishText = label.Text
                                            break
                                        end
                                    end
                                end
                                if fishText ~= "" then break end
                            end
                            if fishText ~= "" then
                                local weight = fishText:match("%(([%d.]+) KG%)")
                                local name = ""
                                for _, n in ipairs(targetFish) do
                                    if string.find(fishText, n) then
                                        name = n
                                        break
                                    end
                                end
                                if name ~= "" and weight then
                                    favoriteEvent:FireServer(name .. " | " .. weight)
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        autoFavoriteBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        autoFavoriteBtn.Text = "关闭"
    end
end)

local bossPage = Instance.new("Frame")
bossPage.Size = UDim2.new(1, 0, 1, 0)
bossPage.BackgroundTransparency = 1
bossPage.Visible = false
bossPage.Parent = pageContainer

local bossScroll = Instance.new("ScrollingFrame")
bossScroll.Size = UDim2.new(1, 0, 1, 0)
bossScroll.BackgroundTransparency = 1
bossScroll.BorderSizePixel = 0
bossScroll.ScrollBarThickness = 3
bossScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
bossScroll.CanvasSize = UDim2.new(0, 0, 0, 200)
bossScroll.Parent = bossPage

local bossContent = Instance.new("Frame")
bossContent.Size = UDim2.new(1, 0, 1, 0)
bossContent.BackgroundTransparency = 1
bossContent.Parent = bossScroll

local enzoStartBtn = createActionRow("恩佐难度选择/开始", "打开", 8, bossContent)
enzoStartBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local enzo = workspace:FindFirstChild("Enzo", true)

        if not enzo then
            return
        end

        local prompt
        if enzo:IsA("Model") then
            prompt = enzo:FindFirstChildWhichIsA("ProximityPrompt", true)
        end

        if not prompt then
            prompt = enzo:FindFirstChildOfClass("ProximityPrompt")
        end

        if not prompt then
            return
        end

        local distance = (character.HumanoidRootPart.Position - enzo:GetPivot().Position).Magnitude
        if distance > prompt.MaxActivationDistance then
            firetouchinterest(character.HumanoidRootPart, prompt.Parent, 0)
            task.wait(0.1)
            firetouchinterest(character.HumanoidRootPart, prompt.Parent, 1)
        end

        firesignal(prompt.Triggered)
    end)
end)

getgenv().WhiteTea_EnzoCam = false

local enzoCamBtn = createActionRow("远程观看恩佐冷却/状态", "👀", 46, bossContent)
enzoCamBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)

enzoCamBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_EnzoCam = not getgenv().WhiteTea_EnzoCam
    if getgenv().WhiteTea_EnzoCam then
        enzoCamBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        enzoCamBtn.Text = "👀"
        task.spawn(function()
            local player = Players.LocalPlayer
            local camera = workspace.CurrentCamera
            local enzo = workspace:FindFirstChild("Enzo", true)

            if not enzo then return end

            local targetPosition
            if enzo:IsA("Model") then
                local humanoidRootPart = enzo:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    targetPosition = humanoidRootPart.Position
                elseif enzo.PrimaryPart then
                    targetPosition = enzo.PrimaryPart.Position
                end
            elseif enzo:IsA("BasePart") then
                targetPosition = enzo.Position
            end

            if not targetPosition then return end

            local originalCameraType = camera.CameraType
            camera.CameraType = Enum.CameraType.Scriptable

            local camConnection
            camConnection = RunService.RenderStepped:Connect(function()
                if not getgenv().WhiteTea_EnzoCam then
                    camera.CameraType = originalCameraType
                    camConnection:Disconnect()
                    return
                end
                camera.CFrame = CFrame.new(
                    targetPosition + Vector3.new(0, 3, 8),
                    targetPosition + Vector3.new(0, 2, 0)
                )
            end)
        end)
    else
        enzoCamBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
        enzoCamBtn.Text = "👀"
    end
end)

getgenv().WhiteTea_BossQTE = false

local bossQTEBtn, bossQTELabel = createToggleRow("自动噩梦恩佐二阶段QTE(挑战前开启)", false, 84, bossContent)
bossQTELabel.Size = UDim2.new(0, 240, 1, 0)

bossQTEBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_BossQTE = not getgenv().WhiteTea_BossQTE
    if getgenv().WhiteTea_BossQTE then
        bossQTEBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        bossQTEBtn.Text = "开启"
        task.spawn(function()
            local player = Players.LocalPlayer
            local playerGui = player:WaitForChild("PlayerGui")
            local mainGui = playerGui:WaitForChild("MainGui")
            local fishing = mainGui:WaitForChild("Fishing")
            local bossFightBar = fishing:WaitForChild("BossFightBar")
            local bar = bossFightBar:WaitForChild("Bar")
            local hitbox = bossFightBar:WaitForChild("Hitbox")
            local mobileFishing = mainGui:WaitForChild("Mobile"):WaitForChild("Fishing")
            local events = replicatedStorage:WaitForChild("Events")
            local bossPhase2Action = events:WaitForChild("BossPhase2Action")

            task.spawn(function()
                while getgenv().WhiteTea_BossQTE do
                    if bossFightBar.Visible then
                        firesignal(mobileFishing.MouseButton1Down)
                    end
                    task.wait(0.1)
                end
            end)

            local renderConnection
            renderConnection = RunService.RenderStepped:Connect(function()
                if not getgenv().WhiteTea_BossQTE then
                    renderConnection:Disconnect()
                    return
                end
                if bossFightBar.Visible and bar and hitbox then
                    bar.Position = UDim2.new(
                        hitbox.Position.X.Scale, 
                        hitbox.Position.X.Offset,
                        bar.Position.Y.Scale, 
                        bar.Position.Y.Offset
                    )
                    bar.Size = UDim2.new(
                        hitbox.Size.X.Scale, 
                        hitbox.Size.X.Offset,
                        bar.Size.Y.Scale, 
                        bar.Size.Y.Offset
                    )
                end
            end)

            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)

            mt.__namecall = function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" and self == bossPhase2Action then
                    if args[1] and type(args[1]) == "table" then
                        args[1].Hit = true
                    end
                end
                
                return oldNamecall(self, unpack(args))
            end
            setreadonly(mt, true)
        end)
    else
        bossQTEBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        bossQTEBtn.Text = "关闭"
    end
end)

local ticketPage = Instance.new("Frame")
ticketPage.Size = UDim2.new(1, 0, 1, 0)
ticketPage.BackgroundTransparency = 1
ticketPage.Visible = false
ticketPage.Parent = pageContainer

local ticketScroll = Instance.new("ScrollingFrame")
ticketScroll.Size = UDim2.new(1, 0, 1, 0)
ticketScroll.Position = UDim2.new(0, 0, 0, 0)
ticketScroll.BackgroundTransparency = 1
ticketScroll.BorderSizePixel = 0
ticketScroll.ScrollBarThickness = 3
ticketScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
ticketScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ticketScroll.Parent = ticketPage

local ticketContent = Instance.new("Frame")
ticketContent.Size = UDim2.new(1, 0, 1, 0)
ticketContent.BackgroundTransparency = 1
ticketContent.Parent = ticketScroll

local editorOpenBtn = createActionRow("数值修改器(客户端)", "打开", 8, ticketContent)

local baitShopBtn = createActionRow("打开饵料商城", "打开", 46, ticketContent)
baitShopBtn.MouseButton1Click:Connect(function()
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer("BuyBait", 1, "BaitShop")
    end)
end)

getgenv().WhiteTea_AutoBuyBait = false
getgenv().WhiteTea_BaitDelay = 3
getgenv().WhiteTea_SelectedBaits = {
    ["Basic Bait"] = false,
    ["Crude Mash Bait"] = false,
    ["Corrupted Essence Bait"] = false,
    ["Elite Bait"] = false,
    ["Ancestral Bait"] = false
}

local baitTypes = {"Basic Bait", "Crude Mash Bait", "Corrupted Essence Bait", "Elite Bait", "Ancestral Bait"}

local autoBuyRow = Instance.new("Frame")
autoBuyRow.Size = UDim2.new(0, 276, 0, 32)
autoBuyRow.Position = UDim2.new(0, 10, 0, 84)
autoBuyRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
autoBuyRow.BorderSizePixel = 0
local autoBuyRowCorner = Instance.new("UICorner")
autoBuyRowCorner.CornerRadius = UDim.new(0, 8)
autoBuyRowCorner.Parent = autoBuyRow
autoBuyRow.Parent = ticketContent

local autoBuyLabel = Instance.new("TextLabel")
autoBuyLabel.Size = UDim2.new(0, 160, 1, 0)
autoBuyLabel.Position = UDim2.new(0, 12, 0, 0)
autoBuyLabel.BackgroundTransparency = 1
autoBuyLabel.Text = "自动购买饵料(使用100个饵料)"
autoBuyLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
autoBuyLabel.TextSize = 12
autoBuyLabel.Font = Enum.Font.GothamMedium
autoBuyLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBuyLabel.Parent = autoBuyRow

local expandBaitBtn = Instance.new("TextButton")
expandBaitBtn.Size = UDim2.new(0, 22, 0, 22)
expandBaitBtn.Position = UDim2.new(1, -104, 0.5, -11)
expandBaitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
expandBaitBtn.Text = "+"
expandBaitBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
expandBaitBtn.TextSize = 14
expandBaitBtn.Font = Enum.Font.GothamBold
expandBaitBtn.AutoButtonColor = false
local expandBtnCorner = Instance.new("UICorner")
expandBtnCorner.CornerRadius = UDim.new(0, 5)
expandBtnCorner.Parent = expandBaitBtn
expandBaitBtn.Parent = autoBuyRow

expandBaitBtn.MouseEnter:Connect(function() expandBaitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 56) end)
expandBaitBtn.MouseLeave:Connect(function() expandBaitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46) end)

local autoBuyBaitBtn = Instance.new("TextButton")
autoBuyBaitBtn.Size = UDim2.new(0, 44, 0, 22)
autoBuyBaitBtn.Position = UDim2.new(1, -54, 0.5, -11)
autoBuyBaitBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
autoBuyBaitBtn.Text = "关闭"
autoBuyBaitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyBaitBtn.TextSize = 10
autoBuyBaitBtn.Font = Enum.Font.GothamBold
autoBuyBaitBtn.AutoButtonColor = false
local autoBuyBtnCorner = Instance.new("UICorner")
autoBuyBtnCorner.CornerRadius = UDim.new(0, 6)
autoBuyBtnCorner.Parent = autoBuyBaitBtn
autoBuyBaitBtn.Parent = autoBuyRow

local baitSelectFrame = Instance.new("Frame")
baitSelectFrame.Size = UDim2.new(0, 276, 0, 160)
baitSelectFrame.Position = UDim2.new(0, 10, 0, 122)
baitSelectFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
baitSelectFrame.BorderSizePixel = 0
baitSelectFrame.Visible = false
local baitSelectCorner = Instance.new("UICorner")
baitSelectCorner.CornerRadius = UDim.new(0, 8)
baitSelectCorner.Parent = baitSelectFrame
baitSelectFrame.Parent = ticketContent

local baitBtns = {}
for i, baitName in ipairs(baitTypes) do
    local baitBtn = Instance.new("TextButton")
    baitBtn.Size = UDim2.new(0, 256, 0, 24)
    baitBtn.Position = UDim2.new(0, 10, 0, 8 + (i-1)*30)
    baitBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    baitBtn.Text = baitName
    baitBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
    baitBtn.TextSize = 11
    baitBtn.Font = Enum.Font.GothamBold
    baitBtn.AutoButtonColor = false
    local baitBtnCorner = Instance.new("UICorner")
    baitBtnCorner.CornerRadius = UDim.new(0, 5)
    baitBtnCorner.Parent = baitBtn
    baitBtn.Parent = baitSelectFrame

    baitBtn.MouseButton1Click:Connect(function()
        getgenv().WhiteTea_SelectedBaits[baitName] = not getgenv().WhiteTea_SelectedBaits[baitName]
        if getgenv().WhiteTea_SelectedBaits[baitName] then
            baitBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
            baitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            baitBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
            baitBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
        end
    end)

    baitBtns[baitName] = baitBtn
end

local dynamicContent = Instance.new("Frame")
dynamicContent.Size = UDim2.new(1, 0, 0, 100)
dynamicContent.Position = UDim2.new(0, 0, 0, 122)
dynamicContent.BackgroundTransparency = 1
dynamicContent.Parent = ticketContent

local baitSpeedLabel = Instance.new("TextLabel")
baitSpeedLabel.Size = UDim2.new(1, -20, 0, 18)
baitSpeedLabel.Position = UDim2.new(0, 14, 0, 0)
baitSpeedLabel.BackgroundTransparency = 1
baitSpeedLabel.Text = "购买间隔: 3秒"
baitSpeedLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
baitSpeedLabel.TextSize = 11
baitSpeedLabel.Font = Enum.Font.GothamMedium
baitSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
baitSpeedLabel.Parent = dynamicContent

local baitSliderBg = Instance.new("Frame")
baitSliderBg.Size = UDim2.new(0, 246, 0, 5)
baitSliderBg.Position = UDim2.new(0, 25, 0, 22)
baitSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
baitSliderBg.BorderSizePixel = 0
local baitSliderBgCorner = Instance.new("UICorner")
baitSliderBgCorner.CornerRadius = UDim.new(0, 3)
baitSliderBgCorner.Parent = baitSliderBg
baitSliderBg.Parent = dynamicContent

local baitSliderFill = Instance.new("Frame")
baitSliderFill.Size = UDim2.new(0.4, 0, 1, 0)
baitSliderFill.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
baitSliderFill.BorderSizePixel = 0
local baitSliderFillCorner = Instance.new("UICorner")
baitSliderFillCorner.CornerRadius = UDim.new(0, 3)
baitSliderFillCorner.Parent = baitSliderFill
baitSliderFill.Parent = baitSliderBg

local baitSliderBtn = Instance.new("TextButton")
baitSliderBtn.Size = UDim2.new(0, 14, 0, 14)
baitSliderBtn.Position = UDim2.new(0.4, -7, 0.5, -7)
baitSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
baitSliderBtn.Text = ""
baitSliderBtn.BorderSizePixel = 0
baitSliderBtn.AutoButtonColor = false
local baitSliderBtnCorner = Instance.new("UICorner")
baitSliderBtnCorner.CornerRadius = UDim.new(0, 7)
baitSliderBtnCorner.Parent = baitSliderBtn
baitSliderBtn.Parent = baitSliderBg

local baitDragging = false
baitSliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        baitDragging = true
    end
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        baitDragging = false
    end
end)

getgenv().WhiteTea_AutoQuest = false

local autoQuestRow = Instance.new("Frame")
autoQuestRow.Size = UDim2.new(0, 276, 0, 32)
autoQuestRow.Position = UDim2.new(0, 10, 0, 40)
autoQuestRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
autoQuestRow.BorderSizePixel = 0
local autoQuestRowCorner = Instance.new("UICorner")
autoQuestRowCorner.CornerRadius = UDim.new(0, 8)
autoQuestRowCorner.Parent = autoQuestRow
autoQuestRow.Parent = dynamicContent

local autoQuestLabel = Instance.new("TextLabel")
autoQuestLabel.Size = UDim2.new(0, 210, 1, 0)
autoQuestLabel.Position = UDim2.new(0, 12, 0, 0)
autoQuestLabel.BackgroundTransparency = 1
autoQuestLabel.Text = "自动接取并提交刷票任务(挂机使用)"
autoQuestLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
autoQuestLabel.TextSize = 12
autoQuestLabel.Font = Enum.Font.GothamMedium
autoQuestLabel.TextXAlignment = Enum.TextXAlignment.Left
autoQuestLabel.Parent = autoQuestRow

local autoQuestBtn = Instance.new("TextButton")
autoQuestBtn.Size = UDim2.new(0, 44, 0, 22)
autoQuestBtn.Position = UDim2.new(1, -54, 0.5, -11)
autoQuestBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
autoQuestBtn.Text = "关闭"
autoQuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoQuestBtn.TextSize = 10
autoQuestBtn.Font = Enum.Font.GothamBold
autoQuestBtn.AutoButtonColor = false
local autoQuestBtnCorner = Instance.new("UICorner")
autoQuestBtnCorner.CornerRadius = UDim.new(0, 6)
autoQuestBtnCorner.Parent = autoQuestBtn
autoQuestBtn.Parent = autoQuestRow

expandBaitBtn.MouseButton1Click:Connect(function()
    baitSelectFrame.Visible = not baitSelectFrame.Visible
    expandBaitBtn.Text = baitSelectFrame.Visible and "-" or "+"
    
    if baitSelectFrame.Visible then
        dynamicContent.Position = UDim2.new(0, 0, 0, 122 + 166)
        ticketScroll.CanvasSize = UDim2.new(0, 0, 0, 400 + 166)
    else
        dynamicContent.Position = UDim2.new(0, 0, 0, 122)
        ticketScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
    end
end)

autoBuyBaitBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoBuyBait = not getgenv().WhiteTea_AutoBuyBait
    if getgenv().WhiteTea_AutoBuyBait then
        autoBuyBaitBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        autoBuyBaitBtn.Text = "开启"
        task.spawn(function()
            while getgenv().WhiteTea_AutoBuyBait do
                for baitName, selected in pairs(getgenv().WhiteTea_SelectedBaits) do
                    if selected and getgenv().WhiteTea_AutoBuyBait then
                        pcall(function()
                            replicatedStorage:WaitForChild("Events"):WaitForChild("BuyBait"):FireServer(baitName)
                        end)
                    end
                end
                task.wait(getgenv().WhiteTea_BaitDelay)
            end
        end)
    else
        autoBuyBaitBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        autoBuyBaitBtn.Text = "关闭"
    end
end)

autoQuestBtn.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_AutoQuest = not getgenv().WhiteTea_AutoQuest
    if getgenv().WhiteTea_AutoQuest then
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        autoQuestBtn.Text = "开启"
        task.spawn(function()
            local npc = workspace:WaitForChild("NPC", 5):WaitForChild("Function", 5):WaitForChild("Ticket Quest Giver", 5)
            local event = replicatedStorage:WaitForChild("Events", 5):WaitForChild("ChooseDialogueOption", 5)
            while getgenv().WhiteTea_AutoQuest do
                pcall(function()
                    event:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {npc, "Ticket Quest"})
                end)
                task.wait(0.5)
                pcall(function()
                    event:FireServer("Ticket Quest Giver", 1, "Quest", {npc})
                end)
                task.wait(5)
            end
        end)
    else
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        autoQuestBtn.Text = "关闭"
    end
end)

local editorFrame = Instance.new("Frame")
editorFrame.Size = UDim2.new(0, 220, 0, 140)
editorFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
editorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
editorFrame.BorderSizePixel = 0
editorFrame.Active = true
editorFrame.Visible = false
editorFrame.Parent = screenGui

local editorCorner = Instance.new("UICorner")
editorCorner.CornerRadius = UDim.new(0, 12)
editorCorner.Parent = editorFrame

local editorStroke = Instance.new("UIStroke")
editorStroke.Thickness = 1
editorStroke.Color = Color3.fromRGB(50, 50, 55)
editorStroke.Parent = editorFrame

local editorTopBar = Instance.new("Frame")
editorTopBar.Size = UDim2.new(1, 0, 0, 30)
editorTopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
editorTopBar.BorderSizePixel = 0
editorTopBar.Parent = editorFrame

local editorTopCorner = Instance.new("UICorner")
editorTopCorner.CornerRadius = UDim.new(0, 12)
editorTopCorner.Parent = editorTopBar

local editorTopCover = Instance.new("Frame")
editorTopCover.Size = UDim2.new(1, 0, 0, 12)
editorTopCover.Position = UDim2.new(0, 0, 1, -12)
editorTopCover.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
editorTopCover.BorderSizePixel = 0
editorTopCover.Parent = editorTopBar

makeDraggable(editorFrame)

local editorTitle = Instance.new("TextLabel")
editorTitle.Size = UDim2.new(1, -40, 1, 0)
editorTitle.Position = UDim2.new(0, 12, 0, 0)
editorTitle.BackgroundTransparency = 1
editorTitle.Text = "数值修改器"
editorTitle.TextColor3 = Color3.fromRGB(220, 220, 225)
editorTitle.TextSize = 13
editorTitle.Font = Enum.Font.GothamBold
editorTitle.TextXAlignment = Enum.TextXAlignment.Left
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
local editorCloseCorner = Instance.new("UICorner")
editorCloseCorner.CornerRadius = UDim.new(0, 11)
editorCloseCorner.Parent = editorClose
editorClose.Parent = editorTopBar

editorClose.MouseButton1Click:Connect(function() editorFrame.Visible = false end)

local ticketLabel = Instance.new("TextLabel")
ticketLabel.Size = UDim2.new(0, 60, 0, 22)
ticketLabel.Position = UDim2.new(0, 18, 0, 42)
ticketLabel.BackgroundTransparency = 1
ticketLabel.Text = "票数:"
ticketLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
ticketLabel.TextSize = 12
ticketLabel.Font = Enum.Font.GothamMedium
ticketLabel.TextXAlignment = Enum.TextXAlignment.Left
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
local ticketBoxCorner = Instance.new("UICorner")
ticketBoxCorner.CornerRadius = UDim.new(0, 6)
ticketBoxCorner.Parent = ticketBox
ticketBox.Parent = editorFrame

local crystalLabel = Instance.new("TextLabel")
crystalLabel.Size = UDim2.new(0, 60, 0, 22)
crystalLabel.Position = UDim2.new(0, 18, 0, 72)
crystalLabel.BackgroundTransparency = 1
crystalLabel.Text = "水晶数:"
crystalLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
crystalLabel.TextSize = 12
crystalLabel.Font = Enum.Font.GothamMedium
crystalLabel.TextXAlignment = Enum.TextXAlignment.Left
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
local crystalBoxCorner = Instance.new("UICorner")
crystalBoxCorner.CornerRadius = UDim.new(0, 6)
crystalBoxCorner.Parent = crystalBox
crystalBox.Parent = editorFrame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 184, 0, 28)
applyBtn.Position = UDim2.new(0, 18, 0, 102)
applyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applyBtn.Text = "应用修改"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.TextSize = 12
applyBtn.Font = Enum.Font.GothamBold
local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 6)
applyCorner.Parent = applyBtn
applyBtn.Parent = editorFrame

applyBtn.MouseEnter:Connect(function() applyBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255) end)
applyBtn.MouseLeave:Connect(function() applyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255) end)

editorOpenBtn.MouseButton1Click:Connect(function() editorFrame.Visible = true end)

applyBtn.MouseButton1Click:Connect(function()
    local player = Players.LocalPlayer
    local stats = player.PlayerGui:FindFirstChild("MainGui")
    if stats then stats = stats:FindFirstChild("Main") end
    if stats then stats = stats:FindFirstChild("Stats") end
    if stats then
        local ticket = stats:FindFirstChild("Ticket")
        if ticket then
            local val = ticket:FindFirstChild("Value")
            if val then val.Text = ticketBox.Text end
        end
        local crystal = stats:FindFirstChild("Crystal")
        if crystal then
            local val = crystal:FindFirstChild("Value")
            if val then val.Text = crystalBox.Text end
        end
    end
    editorFrame.Visible = false
end)

local teleportPage = Instance.new("Frame")
teleportPage.Size = UDim2.new(1, 0, 1, 0)
teleportPage.BackgroundTransparency = 1
teleportPage.Visible = false
teleportPage.Parent = pageContainer

local teleportScroll = Instance.new("ScrollingFrame")
teleportScroll.Size = UDim2.new(1, 0, 1, 0)
teleportScroll.Position = UDim2.new(0, 0, 0, 0)
teleportScroll.BackgroundTransparency = 1
teleportScroll.BorderSizePixel = 0
teleportScroll.ScrollBarThickness = 3
teleportScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 620)
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
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    card.Parent = teleportScroll

    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 3, 1, -18)
    colorBar.Position = UDim2.new(0, 12, 0, 9)
    colorBar.BackgroundColor3 = loc.color
    colorBar.BorderSizePixel = 0
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = colorBar
    colorBar.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 120, 0, 18)
    nameLabel.Position = UDim2.new(0, 24, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = loc.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0, 120, 0, 14)
    descLabel.Position = UDim2.new(0, 24, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = loc.desc
    descLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Size = UDim2.new(0, 120, 0, 12)
    coordsLabel.Position = UDim2.new(0, 24, 0, 40)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.Text = string.format("%d, %d, %d", loc.pos.X, loc.pos.Y, loc.pos.Z)
    coordsLabel.TextColor3 = Color3.fromRGB(100, 100, 105)
    coordsLabel.TextSize = 9
    coordsLabel.Font = Enum.Font.Gotham
    coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
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
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = teleportBtn
    teleportBtn.Parent = card

    teleportBtn.MouseButton1Click:Connect(function()
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(loc.pos)
        end
    end)
end

local traitPage = Instance.new("Frame")
traitPage.Size = UDim2.new(1, 0, 1, 0)
traitPage.BackgroundTransparency = 1
traitPage.Visible = false
traitPage.Parent = pageContainer

local traitScroll = Instance.new("ScrollingFrame")
traitScroll.Size = UDim2.new(1, 0, 1, 0)
traitScroll.BackgroundTransparency = 1
traitScroll.BorderSizePixel = 0
traitScroll.ScrollBarThickness = 3
traitScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
traitScroll.CanvasSize = UDim2.new(0, 0, 0, 240)
traitScroll.Parent = traitPage

local traitContent = Instance.new("Frame")
traitContent.Size = UDim2.new(1, 0, 1, 0)
traitContent.BackgroundTransparency = 1
traitContent.Parent = traitScroll

local traitOpenBtn = createActionRow("打开特制抽取", "打开", 8, traitContent)
traitOpenBtn.MouseButton1Click:Connect(function()
    pcall(function()
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer("Nanjiang", 1, "OpenTrait", {
            workspace:WaitForChild("NPC"):WaitForChild("Function"):WaitForChild("Nanjiang")
        })
    end)
end)

local traitExchangeBtn = createActionRow("特质石交换(1个或10个)", "打开", 46, traitContent)
traitExchangeBtn.MouseButton1Click:Connect(function()
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
        for i = 1, 10 do
            pcall(function()
                event:FireServer(10)
            end)
            task.wait()
        end
    end)
end)

local rebirthBtn = createActionRow("远程打开角色升级(重生)", "打开", 122, traitContent)
rebirthBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local args = {
            "The Shadow",
            1,
            "OpenUPGChar",
            {
                workspace:WaitForChild("NPC"):WaitForChild("Function"):WaitForChild("The Shadow")
            }
        }
        replicatedStorage:WaitForChild("Events"):WaitForChild("ChooseDialogueOption"):FireServer(unpack(args))
    end)
end)

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 170, 0, 42)
miniFrame.Position = UDim2.new(0.5, -85, 0.5, -21)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
miniFrame.Text = "❤️打开UI · Made by 白茶❤️"
miniFrame.TextColor3 = Color3.fromRGB(200, 200, 205)
miniFrame.TextSize = 13
miniFrame.Font = Enum.Font.GothamBold
miniFrame.BorderSizePixel = 0
miniFrame.AutoButtonColor = false
miniFrame.Visible = false
miniFrame.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniFrame

local miniStroke = Instance.new("UIStroke")
miniStroke.Thickness = 1
miniStroke.Color = Color3.fromRGB(50, 50, 55)
miniStroke.Parent = miniFrame

miniButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    getgenv().WhiteTea_Anchor = false
    getgenv().WhiteTea_AutoCast = false
    getgenv().WhiteTea_AutoSkill = false
    getgenv().WhiteTea_AutoSell = false
    getgenv().WhiteTea_WeatherNotify = false
    getgenv().WhiteTea_BossQTE = false
    getgenv().WhiteTea_EnzoCam = false
    getgenv().WhiteTea_AutoFavorite = false
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
    
    fishingNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    fishingNavBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
    bossNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    bossNavBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
    ticketNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    ticketNavBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
    teleportNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    teleportNavBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
    traitNavBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    traitNavBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
    
    local activeBtn = fishingNavBtn
    local pageTitle = "钓鱼功能🎣"
    if page == "boss" then activeBtn = bossNavBtn; pageTitle = "BOSS RAID💀"
    elseif page == "ticket" then activeBtn = ticketNavBtn; pageTitle = "刷票功能😱"
    elseif page == "teleport" then activeBtn = teleportNavBtn; pageTitle = "传送功能📍"
    elseif page == "trait" then activeBtn = traitNavBtn; pageTitle = "特制功能🎲"
    end
    
    activeBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = pageTitle
end

fishingNavBtn.MouseButton1Click:Connect(function() switchPage("fishing") end)
bossNavBtn.MouseButton1Click:Connect(function() switchPage("boss") end)
ticketNavBtn.MouseButton1Click:Connect(function() switchPage("ticket") end)
teleportNavBtn.MouseButton1Click:Connect(function() switchPage("teleport") end)
traitNavBtn.MouseButton1Click:Connect(function() switchPage("trait") end)

local npcCache, eventCache = nil, nil

local function getNPC()
    if not npcCache or not npcCache.Parent then
        pcall(function() npcCache = workspace:WaitForChild("NPC", 5):WaitForChild("Function", 5):WaitForChild("Ticket Quest Giver", 5) end)
    end
    return npcCache
end

local function getEvent()
    if not eventCache or not eventCache.Parent then
        pcall(function() eventCache = replicatedStorage:WaitForChild("Events", 5):WaitForChild("ChooseDialogueOption", 5) end)
    end
    return eventCache
end

local function acceptQuest()
    local n, e = getNPC(), getEvent()
    return n and e and pcall(function() e:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {n, "Ticket Quest"}) end)
end

local function submitQuest()
    local n, e = getNPC(), getEvent()
    return n and e and pcall(function() e:FireServer("Ticket Quest Giver", 1, "Quest", {n}) end)
end

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
    local KeyMap = {
        Z = Enum.KeyCode.Z,
        X = Enum.KeyCode.X,
        C = Enum.KeyCode.C,
        V = Enum.KeyCode.V
    }
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
            pcall(function()
                replicatedStorage.Events.SellFish:FireServer("All")
            end)
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