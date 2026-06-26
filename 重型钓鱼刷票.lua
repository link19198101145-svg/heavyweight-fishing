local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoQuestGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 240)
mainFrame.Position = UDim2.new(0.5, -140, 0.4, -120)
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
title.Text = "自动刷票任务"
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

exitButton.MouseEnter:Connect(function()
    exitButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)
exitButton.MouseLeave:Connect(function()
    exitButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

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

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)
closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -20, 0, 20)
modeLabel.Position = UDim2.new(0, 10, 0, 42)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "模式选择:"
modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
modeLabel.TextSize = 13
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = mainFrame

local modeContainer = Instance.new("Frame")
modeContainer.Size = UDim2.new(0, 260, 0, 30)
modeContainer.Position = UDim2.new(0, 10, 0, 63)
modeContainer.BackgroundTransparency = 1
modeContainer.Parent = mainFrame

local acceptModeBtn = Instance.new("TextButton")
acceptModeBtn.Size = UDim2.new(0, 125, 0, 28)
acceptModeBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
acceptModeBtn.Text = "接任务"
acceptModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
acceptModeBtn.TextSize = 12
acceptModeBtn.Font = Enum.Font.GothamBold
acceptModeBtn.AutoButtonColor = false
local acceptCorner = Instance.new("UICorner")
acceptCorner.CornerRadius = UDim.new(0, 6)
acceptCorner.Parent = acceptModeBtn
acceptModeBtn.Parent = modeContainer

local submitModeBtn = Instance.new("TextButton")
submitModeBtn.Size = UDim2.new(0, 125, 0, 28)
submitModeBtn.Position = UDim2.new(0, 135, 0, 0)
submitModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
submitModeBtn.Text = "交任务"
submitModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitModeBtn.TextSize = 12
submitModeBtn.Font = Enum.Font.GothamBold
submitModeBtn.AutoButtonColor = false
local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitModeBtn
submitModeBtn.Parent = modeContainer

local currentMode = "accept"

local historyLabel = Instance.new("TextLabel")
historyLabel.Size = UDim2.new(1, -20, 0, 20)
historyLabel.Position = UDim2.new(0, 10, 0, 95)
historyLabel.BackgroundTransparency = 1
historyLabel.Text = "本次: 接0 交0 | 历史: 接0 交0"
historyLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
historyLabel.TextSize = 11
historyLabel.Font = Enum.Font.GothamMedium
historyLabel.TextXAlignment = Enum.TextXAlignment.Left
historyLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 115)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 已停止"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 138)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度: 0.50秒/次"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 210, 0, 6)
sliderBg.Position = UDim2.new(0, 35, 0, 170)
sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBg.BorderSizePixel = 0
local sliderBgCorner = Instance.new("UICorner")
sliderBgCorner.CornerRadius = UDim.new(0, 3)
sliderBgCorner.Parent = sliderBg
sliderBg.Parent = mainFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
sliderFill.BorderSizePixel = 0
local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0, 3)
sliderFillCorner.Parent = sliderFill
sliderFill.Parent = sliderBg

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 16, 0, 16)
sliderButton.Position = UDim2.new(0.5, -8, 0.5, -8)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.AutoButtonColor = false
local sliderBtnCorner = Instance.new("UICorner")
sliderBtnCorner.CornerRadius = UDim.new(0, 8)
sliderBtnCorner.Parent = sliderButton
sliderButton.Parent = sliderBg

local currentSpeed = 0.5
local minSpeed = 0.01
local maxSpeed = 2.0

local function sliderToSpeed(v)
    return math.exp(math.log(minSpeed) + (math.log(maxSpeed) - math.log(minSpeed)) * v)
end

local function updateSpeedDisplay(v)
    currentSpeed = v
    speedLabel.Text = v < 0.1 and string.format("速度: %.3f秒/次", v) or string.format("速度: %.2f秒/次", v)
end

local sliderDragging = false

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local x = UserInputService:GetMouseLocation().X
        local t = math.clamp((x - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(t, 0, 1, 0)
        sliderButton.Position = UDim2.new(t, -8, 0.5, -8)
        updateSpeedDisplay(sliderToSpeed(t))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0, 230, 0, 35)
actionBtn.Position = UDim2.new(0, 25, 0, 187)
actionBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
actionBtn.Text = "开始"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.TextSize = 14
actionBtn.Font = Enum.Font.GothamBold
local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionBtn
actionBtn.Parent = mainFrame

local running = false
local taskCount = 0
local lastTaskTime = 0
local sessionAccept = 0
local sessionSubmit = 0
local totalAccept = 0
local totalSubmit = 0

local function updateHistory()
    historyLabel.Text = string.format("本次: 接%d 交%d | 历史: 接%d 交%d", sessionAccept, sessionSubmit, totalAccept, totalSubmit)
end

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 180, 0, 45)
miniFrame.Position = UDim2.new(0.5, -90, 0.5, -22)
miniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
miniFrame.Text = "打开刷票脚本UI"
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

miniExit.MouseEnter:Connect(function() miniExit.BackgroundColor3 = Color3.fromRGB(255, 80, 80) end)
miniExit.MouseLeave:Connect(function() miniExit.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end)
miniExit.MouseButton1Click:Connect(function() screenGui:Destroy() end)

miniFrame.MouseEnter:Connect(function() miniFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end)
miniFrame.MouseLeave:Connect(function() miniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end)

local miniDragging = false
local miniDragStart = nil
local miniStartPos = nil

miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniDragStart = input.Position
        miniStartPos = miniFrame.Position
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
            miniFrame.Visible = false
            mainFrame.Visible = true
        end
        miniDragging = false
    end
end)

exitButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

local function setMode(m)
    currentMode = m
    acceptModeBtn.BackgroundColor3 = m == "accept" and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
    submitModeBtn.BackgroundColor3 = m == "submit" and Color3.fromRGB(200, 150, 50) or Color3.fromRGB(60, 60, 60)
end

acceptModeBtn.MouseButton1Click:Connect(function() setMode("accept") end)
submitModeBtn.MouseButton1Click:Connect(function() setMode("submit") end)

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
    if not n or not e then return false end
    return pcall(function() e:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {n, "Ticket Quest"}) end)
end

local function submitQuest()
    local n, e = getNPC(), getEvent()
    if not n or not e then return false end
    return pcall(function() e:FireServer("Ticket Quest Giver", 1, "Quest", {n}) end)
end

local function doTask()
    if not getNPC() or not getEvent() then
        statusLabel.Text = "状态: 等待对象..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(1)
        return
    end
    local ok = currentMode == "accept" and acceptQuest() or submitQuest()
    if ok then
        taskCount = taskCount + 1
        if currentMode == "accept" then sessionAccept = sessionAccept + 1; totalAccept = totalAccept + 1
        else sessionSubmit = sessionSubmit + 1; totalSubmit = totalSubmit + 1 end
        updateHistory()
        statusLabel.Text = currentMode == "accept" and string.format("状态: 接任务中 (已接%d次)", taskCount) or string.format("状态: 交任务中 (已交%d次)", taskCount)
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        lastTaskTime = tick()
    else
        statusLabel.Text = "状态: 发送失败，重试中..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(1)
    end
end

actionBtn.MouseButton1Click:Connect(function()
    if running then
        running = false
        actionBtn.Text = "开始"
        actionBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = string.format("状态: 已停止 (共%d%s)", taskCount, currentMode == "accept" and "接" or "交")
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        running = true
        taskCount, sessionAccept, sessionSubmit = 0, 0, 0
        updateHistory()
        actionBtn.Text = "停止"
        actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "状态: 运行中..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.spawn(function()
            while running do
                doTask()
                local waitTime = currentSpeed
                if lastTaskTime > 0 then
                    local elapsed = tick() - lastTaskTime
                    waitTime = elapsed < currentSpeed and currentSpeed - elapsed or 0.01
                end
                task.wait(math.max(0.01, waitTime))
            end
        end)
    end
end)

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.3) % 1
    local c = HSVtoRGB(hue, 0.8, 1)
    title.TextColor3 = c
    miniFrame.TextColor3 = c
end)
