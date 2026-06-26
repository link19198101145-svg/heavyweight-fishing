local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoQuestGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 215)
mainFrame.Position = UDim2.new(0.5, -140, 0.4, -107)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 30, 0, 10)
title.BackgroundTransparency = 1
title.Text = "自动刷票任务"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
acceptModeBtn.Position = UDim2.new(0, 0, 0, 0)
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

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 98)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 已停止"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 121)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度: 0.50秒/次"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 210, 0, 6)
sliderBg.Position = UDim2.new(0, 35, 0, 153)
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

local function sliderToSpeed(sliderValue)
    local minLog = math.log(minSpeed)
    local maxLog = math.log(maxSpeed)
    local logSpeed = minLog + (maxLog - minLog) * sliderValue
    return math.exp(logSpeed)
end

local function updateSpeedDisplay(value)
    currentSpeed = value
    if currentSpeed < 0.1 then
        speedLabel.Text = string.format("速度: %.3f秒/次", currentSpeed)
    else
        speedLabel.Text = string.format("速度: %.2f秒/次", currentSpeed)
    end
end

local sliderDragging = false

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderAbsPos = sliderBg.AbsolutePosition
        local sliderAbsSize = sliderBg.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
        updateSpeedDisplay(sliderToSpeed(relativeX))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

local toggleButton2 = Instance.new("TextButton")
toggleButton2.Size = UDim2.new(0, 230, 0, 35)
toggleButton2.Position = UDim2.new(0, 25, 0, 170)
toggleButton2.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
toggleButton2.Text = "开始"
toggleButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton2.TextSize = 14
toggleButton2.Font = Enum.Font.GothamBold
local tb2Corner = Instance.new("UICorner")
tb2Corner.CornerRadius = UDim.new(0, 6)
tb2Corner.Parent = toggleButton2
toggleButton2.Parent = mainFrame

local running = false
local taskCount = 0
local lastTaskTime = 0

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 45)
toggleButton.Position = UDim2.new(0.5, -90, 0.5, -22)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.Text = "打开刷票脚本UI"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = false
toggleButton.Active = true
toggleButton.Visible = false
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleExitButton = Instance.new("TextButton")
toggleExitButton.Size = UDim2.new(0, 20, 0, 20)
toggleExitButton.Position = UDim2.new(0, 5, 0.5, -10)
toggleExitButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleExitButton.Text = "X"
toggleExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleExitButton.TextSize = 12
toggleExitButton.Font = Enum.Font.GothamBold
toggleExitButton.AutoButtonColor = false
local toggleExitCorner = Instance.new("UICorner")
toggleExitCorner.CornerRadius = UDim.new(0, 10)
toggleExitCorner.Parent = toggleExitButton
toggleExitButton.Parent = toggleButton

toggleExitButton.MouseEnter:Connect(function()
    toggleExitButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)
toggleExitButton.MouseLeave:Connect(function()
    toggleExitButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

toggleExitButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

toggleButton.MouseEnter:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)
toggleButton.MouseLeave:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

local toggleDragging = false
local dragStart = nil
local startPos = nil

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if toggleDragging and dragStart then
            if (input.Position - dragStart).Magnitude < 5 then
                toggleButton.Visible = false
                mainFrame.Visible = true
            end
        end
        toggleDragging = false
    end
end)

exitButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Visible = true
end)

local function setMode(mode)
    currentMode = mode
    if mode == "accept" then
        acceptModeBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        submitModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    elseif mode == "submit" then
        acceptModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        submitModeBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    end
end

acceptModeBtn.MouseButton1Click:Connect(function() setMode("accept") end)
submitModeBtn.MouseButton1Click:Connect(function() setMode("submit") end)

local npcCache = nil
local eventCache = nil

local function getNPC()
    if not npcCache or not npcCache.Parent then
        local success, result = pcall(function()
            return workspace:WaitForChild("NPC", 5):WaitForChild("Function", 5):WaitForChild("Ticket Quest Giver", 5)
        end)
        if success and result then
            npcCache = result
        end
    end
    return npcCache
end

local function getEvent()
    if not eventCache or not eventCache.Parent then
        local success, result = pcall(function()
            return replicatedStorage:WaitForChild("Events", 5):WaitForChild("ChooseDialogueOption", 5)
        end)
        if success and result then
            eventCache = result
        end
    end
    return eventCache
end

local function acceptQuest()
    local npc = getNPC()
    local event = getEvent()
    if not npc or not event then return false end
    local success, err = pcall(function()
        event:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {npc, "Ticket Quest"})
    end)
    return success
end

local function submitQuest()
    local npc = getNPC()
    local event = getEvent()
    if not npc or not event then return false end
    local success, err = pcall(function()
        event:FireServer("Ticket Quest Giver", 1, "Quest", {npc})
    end)
    return success
end

local function safeExecuteTask()
    local npc = getNPC()
    local event = getEvent()
    if not npc or not event then
        statusLabel.Text = "状态: 等待对象..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(1)
        return
    end
    local success = false
    if currentMode == "accept" then
        success = acceptQuest()
        if success then
            taskCount = taskCount + 1
            statusLabel.Text = string.format("状态: 接任务中 (已接%d次)", taskCount)
        end
    elseif currentMode == "submit" then
        success = submitQuest()
        if success then
            taskCount = taskCount + 1
            statusLabel.Text = string.format("状态: 交任务中 (已交%d次)", taskCount)
        end
    end
    if success then
        lastTaskTime = tick()
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "状态: 发送失败，重试中..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(1)
    end
end

toggleButton2.MouseButton1Click:Connect(function()
    if running then
        running = false
        toggleButton2.Text = "开始"
        toggleButton2.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        local modeText = currentMode == "accept" and "接" or "交"
        statusLabel.Text = string.format("状态: 已停止 (共%d%s)", taskCount, modeText)
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        running = true
        taskCount = 0
        toggleButton2.Text = "停止"
        toggleButton2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "状态: 运行中..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.spawn(function()
            while running do
                safeExecuteTask()
                local waitTime = currentSpeed
                if lastTaskTime > 0 then
                    local elapsed = tick() - lastTaskTime
                    if elapsed < waitTime then
                        waitTime = waitTime - elapsed
                    else
                        waitTime = 0.01
                    end
                end
                task.wait(math.max(0.01, waitTime))
            end
        end)
    end
end)