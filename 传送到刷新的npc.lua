local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoQuestGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 300)
mainFrame.Position = UDim2.new(0.5, -170, 0.4, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 30, 0, 10)
title.BackgroundTransparency = 1
title.Text = "功能界面"
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 24, 0, 24)
exitButton.Position = UDim2.new(0, 6, 0, 8)
exitButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
exitButton.Text = "X"
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.TextSize = 14
exitButton.Font = Enum.Font.GothamBold
exitButton.AutoButtonColor = false
local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 12)
exitCorner.Parent = exitButton
exitButton.Parent = mainFrame

exitButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "-"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton
closeButton.Parent = mainFrame

local navBar = Instance.new("ScrollingFrame")
navBar.Size = UDim2.new(0, 60, 1, -40)
navBar.Position = UDim2.new(0, 0, 0, 40)
navBar.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
navBar.BorderSizePixel = 0
navBar.ScrollBarThickness = 0
navBar.CanvasSize = UDim2.new(0, 0, 0, 400)
navBar.Parent = mainFrame

local navButtons = {}

local function addNavButton(name, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, position)
    btn.BackgroundColor3 = Color3.fromRGB(58, 58, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.Parent = navBar
    table.insert(navButtons, btn)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

local pages = {}

local function addPage()
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -60, 1, -40)
    page.Position = UDim2.new(0, 60, 0, 40)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = mainFrame
    table.insert(pages, page)
    return page
end

local function addScrollPage()
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -60, 1, -40)
    page.Position = UDim2.new(0, 60, 0, 40)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = mainFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Position = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    scroll.Parent = page
    table.insert(pages, page)
    return scroll
end

local function addToggleRow(parent, label, position, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 260, 0, 30)
    row.Position = UDim2.new(0, 10, 0, position)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 170, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -50, 0.5, -12)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
    btn.Text = defaultValue and "开启" or "关闭"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    local state = defaultValue or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "开启" or "关闭"
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
        if callback then callback(state) end
    end)

    return row, state
end

local function addButtonRow(parent, label, btnText, position, color, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 260, 0, 30)
    row.Position = UDim2.new(0, 10, 0, position)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 170, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -50, 0.5, -12)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 122, 255)
    btn.Text = btnText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    if callback then
        btn.MouseButton1Click:Connect(callback)
    end

    return row
end

local function addTeleportCard(parent, name, pos, color, position)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 260, 0, 50)
    card.Position = UDim2.new(0, 10, 0, position)
    card.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    card.Parent = parent

    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 4, 1, -16)
    colorBar.Position = UDim2.new(0, 10, 0, 8)
    colorBar.BackgroundColor3 = color
    colorBar.BorderSizePixel = 0
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = colorBar
    colorBar.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 180, 1, 0)
    nameLabel.Position = UDim2.new(0, 22, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = card

    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Size = UDim2.new(0, 180, 0, 14)
    coordsLabel.Position = UDim2.new(0, 22, 0, 26)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.Text = string.format("X: %d  Y: %d  Z: %d", pos.X, pos.Y, pos.Z)
    coordsLabel.TextColor3 = Color3.fromRGB(120, 120, 125)
    coordsLabel.TextSize = 9
    coordsLabel.Font = Enum.Font.Gotham
    coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
    coordsLabel.Parent = card

    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0, 60, 0, 30)
    teleportBtn.Position = UDim2.new(1, -70, 0.5, -15)
    teleportBtn.BackgroundColor3 = color
    teleportBtn.Text = "传送"
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.TextSize = 12
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = teleportBtn
    teleportBtn.Parent = card

    teleportBtn.MouseButton1Click:Connect(function()
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)

    return card
end

local function teleportToNPC(npcName)
    local npc = workspace:FindFirstChild(npcName, true)
    
    if npc then
        local npcPosition = nil
        
        if npc:IsA("Model") and npc.PrimaryPart then
            npcPosition = npc.PrimaryPart.Position
        elseif npc:IsA("BasePart") then
            npcPosition = npc.Position
        elseif npc:FindFirstChild("HumanoidRootPart") then
            npcPosition = npc.HumanoidRootPart.Position
        elseif npc:FindFirstChild("Head") then
            npcPosition = npc.Head.Position
        end
        
        if npcPosition and Players.LocalPlayer.Character then
            local character = Players.LocalPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(npcPosition + Vector3.new(3, 0, 3))
                print("成功传送到 " .. npc.Name .. " 身边！")
            end
        end
    end
end

local function addNPCButton(parent, npcName, position, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 260, 0, 30)
    row.Position = UDim2.new(0, 10, 0, position)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 170, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "传送到 " .. npcName
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -50, 0.5, -12)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 122, 255)
    btn.Text = "传送"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        teleportToNPC(npcName)
    end)

    return row
end

local function switchPage(index)
    for i, page in ipairs(pages) do
        page.Visible = i == index
    end
    for i, btn in ipairs(navButtons) do
        btn.BackgroundColor3 = i == index and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(58, 58, 60)
    end
end

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 180, 0, 45)
miniFrame.Position = UDim2.new(0.5, -90, 0.5, -22)
miniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
miniFrame.Text = "打开UI"
miniFrame.TextSize = 16
miniFrame.Font = Enum.Font.GothamBold
miniFrame.BorderSizePixel = 0
miniFrame.AutoButtonColor = false
miniFrame.Visible = false
miniFrame.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniFrame

local miniExit = Instance.new("TextButton")
miniExit.Size = UDim2.new(0, 20, 0, 20)
miniExit.Position = UDim2.new(0, 5, 0.5, -10)
miniExit.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
miniExit.Text = "X"
miniExit.TextColor3 = Color3.fromRGB(255, 255, 255)
miniExit.TextSize = 12
miniExit.Font = Enum.Font.GothamBold
miniExit.AutoButtonColor = false
local miniExitCorner = Instance.new("UICorner")
miniExitCorner.CornerRadius = UDim.new(0, 10)
miniExitCorner.Parent = miniExit
miniExit.Parent = miniFrame

miniExit.MouseButton1Click:Connect(function() screenGui:Destroy() end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
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

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.3) % 1
    local c = HSVtoRGB(hue, 0.8, 1)
    title.TextColor3 = c
    if miniFrame.Visible then miniFrame.TextColor3 = c end
end)

local npcPage = addScrollPage()
npcPage.CanvasSize = UDim2.new(0, 0, 0, 280)

local npcTitle = Instance.new("TextLabel")
npcTitle.Size = UDim2.new(0, 260, 0, 25)
npcTitle.Position = UDim2.new(0, 10, 0, 5)
npcTitle.BackgroundTransparency = 1
npcTitle.Text = "NPC传送"
npcTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
npcTitle.TextSize = 16
npcTitle.Font = Enum.Font.GothamBold
npcTitle.TextXAlignment = Enum.TextXAlignment.Left
npcTitle.Parent = npcPage

addNPCButton(npcPage, "Taoist", 40, Color3.fromRGB(50, 180, 50))
addNPCButton(npcPage, "Maoshan", 80, Color3.fromRGB(255, 140, 0))
addNPCButton(npcPage, "红色灵魂", 120, Color3.fromRGB(255, 50, 50))
addNPCButton(npcPage, "黄色灵魂", 160, Color3.fromRGB(255, 220, 30))
addNPCButton(npcPage, "蓝色灵魂", 200, Color3.fromRGB(50, 120, 255))

addNavButton("NPC", 5, function() switchPage(1) end)

switchPage(1)