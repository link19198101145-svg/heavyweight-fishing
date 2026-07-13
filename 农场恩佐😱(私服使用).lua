local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreUIGUI"
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
    local gui = frame
    local dragging, dragInput, dragStart, startPos

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
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
title.Text = "farm enzo (搭配主脚本使用)"
title.TextSize = 14
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
navScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
navScroll.Parent = navBar

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -56, 1, -36)
pageContainer.Position = UDim2.new(0, 56, 0, 36)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = mainFrame

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
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 50, 58) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48) end)
    return btn
end

local function createPage()
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pageContainer

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    scroll.Parent = page

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Parent = scroll

    return page, content
end

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

local mainPage, mainContent = createPage()
mainPage.Visible = true

local normalEnzoToggle, normalEnzoLabel = createToggleRow("每隔5秒尝试开启普通恩佐", false, 10, mainContent)

local hardEnzoToggle, hardEnzoLabel = createToggleRow("每隔5秒尝试开启困难恩佐", false, 50, mainContent)

local nightmareEnzoToggle, nightmareEnzoLabel = createToggleRow("每隔5秒尝试开启噩梦恩佐", false, 90, mainContent)

local activeDifficulty = nil
local farmingActive = false
local farmingCoroutine = nil

local function updateAllToggles()
    if activeDifficulty == "Normal" then
        normalEnzoToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        normalEnzoToggle.Text = "开启"
        hardEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        hardEnzoToggle.Text = "关闭"
        nightmareEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        nightmareEnzoToggle.Text = "关闭"
    elseif activeDifficulty == "Hard" then
        normalEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        normalEnzoToggle.Text = "关闭"
        hardEnzoToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        hardEnzoToggle.Text = "开启"
        nightmareEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        nightmareEnzoToggle.Text = "关闭"
    elseif activeDifficulty == "Nightmare" then
        normalEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        normalEnzoToggle.Text = "关闭"
        hardEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        hardEnzoToggle.Text = "关闭"
        nightmareEnzoToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        nightmareEnzoToggle.Text = "开启"
    else
        normalEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        normalEnzoToggle.Text = "关闭"
        hardEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        hardEnzoToggle.Text = "关闭"
        nightmareEnzoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        nightmareEnzoToggle.Text = "关闭"
    end
end

local function startFarming(difficulty)
    if farmingActive then
        farmingActive = false
        farmingCoroutine = nil
        task.wait(0.1)
    end
    
    activeDifficulty = difficulty
    farmingActive = true
    
    farmingCoroutine = coroutine.create(function()
        while farmingActive and activeDifficulty == difficulty do
            local success, err = pcall(function()
                local args = {
                    "Enzo",
                    difficulty
                }
                ReplicatedStorage:WaitForChild("Events"):WaitForChild("StartBossFight"):FireServer(unpack(args))
            end)
            if not success then
                warn("农场脚本错误 (" .. difficulty .. "): " .. tostring(err))
            end
            if farmingActive and activeDifficulty == difficulty then
                task.wait(5)
            end
        end
    end)
    coroutine.resume(farmingCoroutine)
    updateAllToggles()
end

local function stopFarming()
    farmingActive = false
    activeDifficulty = nil
    farmingCoroutine = nil
    updateAllToggles()
end

normalEnzoToggle.MouseButton1Click:Connect(function()
    if activeDifficulty == "Normal" then
        stopFarming()
    else
        startFarming("Normal")
    end
end)

hardEnzoToggle.MouseButton1Click:Connect(function()
    if activeDifficulty == "Hard" then
        stopFarming()
    else
        startFarming("Hard")
    end
end)

nightmareEnzoToggle.MouseButton1Click:Connect(function()
    if activeDifficulty == "Nightmare" then
        stopFarming()
    else
        startFarming("Nightmare")
    end
end)

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 170, 0, 42)
miniFrame.Position = UDim2.new(0.5, -85, 0.5, -21)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
miniFrame.Text = "farm enzo"
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

closeButton.MouseButton1Click:Connect(function()
    stopFarming()
    screenGui:Destroy()
end)

miniButton.MouseButton1Click:Connect(function()
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