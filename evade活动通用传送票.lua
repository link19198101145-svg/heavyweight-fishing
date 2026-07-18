local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreUI"
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
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
title.Text = "票收集"
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

local navButtons = {}
local pages = {}

function createNavButton(name, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 46)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.Text = icon .. "\n" .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 185)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    btn.Parent = navScroll
    table.insert(navButtons, btn)
    return btn
end

function createPage()
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

    table.insert(pages, page)
    return page, content
end

function createToggle(label, defaultState, yPos, parent)
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
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(60, 200, 80)
    btn.Text = defaultState and "关闭" or "开启"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(60, 200, 80)
        btn.Text = state and "关闭" or "开启"
    end)

    return btn, lbl, function() return state end, function(v) state = v; btn.BackgroundColor3 = state and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(60, 200, 80); btn.Text = state and "关闭" or "开启" end
end

function switchPage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
    end
    for i, btn in ipairs(navButtons) do
        btn.BackgroundColor3 = (i == index) and Color3.fromRGB(60, 130, 255) or Color3.fromRGB(40, 40, 48)
        btn.TextColor3 = (i == index) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 185)
    end
end

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 170, 0, 42)
miniFrame.Position = UDim2.new(0.5, -85, 0.5, -21)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
miniFrame.Text = "打开UI"
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

miniButton.MouseButton1Click:Connect(function() mainFrame.Visible = false; miniFrame.Visible = true end)

local md, mds, msp = false, nil, nil
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        md, mds, msp = true, input.Position, miniFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if md and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - mds
        miniFrame.Position = UDim2.new(msp.X.Scale, msp.X.Offset + d.X, msp.Y.Scale, msp.Y.Offset + d.Y)
    end
end)
miniFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if md and (input.Position - mds).Magnitude < 5 then
            miniFrame.Visible, mainFrame.Visible = false, true
        end
        md = false
    end
end)

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.3) % 1
    local c = HSVtoRGB(hue, 0.8, 1)
    title.TextColor3 = c
    if miniFrame.Visible then miniFrame.TextColor3 = c end
end)

-- ==================== 票收集功能 ====================

local btnTicket = createNavButton("票收集", "🎫", 10)
local pageTicket, contentTicket = createPage()
btnTicket.MouseButton1Click:Connect(function() switchPage(1) end)
switchPage(1)

local isEnabled = false
local ticketConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local ticketsFolder = workspace:WaitForChild("Effects"):WaitForChild("Tickets")
local collectedTickets = {}
local idlePosition = Vector3.new(0, 9999, 0)
local isIdle = false
local currentTarget = nil
local arriveTime = 0
local waitTime = 1
local currentRootPart = nil
local currentHumanoid = nil

local function clearPhysics()
    if ticketConnection then
        ticketConnection:Disconnect()
        ticketConnection = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if currentHumanoid then
        currentHumanoid.PlatformStand = false
    end
    isIdle = false
    currentTarget = nil
    collectedTickets = {}
    arriveTime = 0
end

local function runTicketLoop(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    currentRootPart = rootPart
    currentHumanoid = humanoid

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    ticketConnection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent then return end
        local now = os.clock()
        local hasTicket = false

        for _, ticket in ipairs(ticketsFolder:GetChildren()) do
            if not collectedTickets[ticket] then
                hasTicket = true
                break
            end
        end

        if not hasTicket then
            if not isIdle then
                humanoid.PlatformStand = true
                rootPart.CFrame = CFrame.new(idlePosition)
                bodyVelocity.Velocity = Vector3.zero
                bodyGyro.CFrame = rootPart.CFrame
                isIdle = true
                currentTarget = nil
            end
            for _, ticket in ipairs(ticketsFolder:GetChildren()) do
                collectedTickets[ticket] = nil
            end
            return
        end

        isIdle = false
        humanoid.PlatformStand = false

        local nearestTicket = nil
        local nearestDistance = math.huge

        for _, ticket in ipairs(ticketsFolder:GetChildren()) do
            if not collectedTickets[ticket] then
                local primaryPart = ticket:FindFirstChild("HumanoidRootPart") or ticket.PrimaryPart
                if primaryPart then
                    local distance = (rootPart.Position - primaryPart.Position).Magnitude
                    if distance < nearestDistance then
                        nearestTicket = ticket
                        nearestDistance = distance
                    end
                end
            end
        end

        if nearestTicket then
            local primaryPart = nearestTicket:FindFirstChild("HumanoidRootPart") or nearestTicket.PrimaryPart
            if primaryPart then
                if currentTarget ~= nearestTicket then
                    currentTarget = nearestTicket
                    arriveTime = 0
                end

                local targetPos = primaryPart.Position + Vector3.new(0, 5, 0)
                rootPart.CFrame = CFrame.new(targetPos)
                bodyVelocity.Velocity = Vector3.zero
                bodyGyro.CFrame = rootPart.CFrame

                if arriveTime == 0 then
                    arriveTime = now
                elseif now - arriveTime >= waitTime then
                    collectedTickets[nearestTicket] = true
                    currentTarget = nil
                    arriveTime = 0
                end
            end
        end
    end)
end

local function startTicketCollect()
    if isEnabled then return end
    isEnabled = true
    clearPhysics()
    if player.Character then
        runTicketLoop(player.Character)
    end
end

local function stopTicketCollect()
    isEnabled = false
    clearPhysics()
end

player.CharacterAdded:Connect(function(character)
    if isEnabled then
        clearPhysics()
        runTicketLoop(character)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    stopTicketCollect()
    screenGui:Destroy()
end)

local ticketToggleBtn, ticketToggleLbl, getTicketState, setTicketState = createToggle("自动收集票(如果没用请再次开启关闭)", false, 10, contentTicket)
ticketToggleBtn.MouseButton1Click:Connect(function()
    if getTicketState() then
        startTicketCollect()
    else
        stopTicketCollect()
    end
end)