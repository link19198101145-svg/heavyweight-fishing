if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Theme = {
    Background     = Color3.fromRGB(20, 20, 24),
    TopBar         = Color3.fromRGB(16, 16, 20),
    NavBar         = Color3.fromRGB(16, 16, 20),
    Row            = Color3.fromRGB(28, 28, 34),
    Control        = Color3.fromRGB(55, 55, 60),
    Accent         = Color3.fromRGB(60, 130, 255),
    AccentHover    = Color3.fromRGB(80, 150, 255),
    Success        = Color3.fromRGB(60, 200, 80),
    Danger         = Color3.fromRGB(255, 70, 70),
    DangerHover    = Color3.fromRGB(255, 90, 90),
    Warning        = Color3.fromRGB(255, 170, 40),
    WarningHover   = Color3.fromRGB(255, 190, 60),
    Text           = Color3.fromRGB(255, 255, 255),
    TextDim        = Color3.fromRGB(200, 200, 205),
    Stroke         = Color3.fromRGB(50, 50, 55),
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function showPopup(text)
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 260, 0, 90)
    popup.Position = UDim2.new(0.5, -130, 0.5, -45)
    popup.BackgroundColor3 = Theme.Background
    popup.BorderSizePixel = 0
    popup.ZIndex = 100
    popup.Parent = screenGui

    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", popup)
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, -40)
    lbl.Position = UDim2.new(0, 10, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextWrapped = true
    lbl.ZIndex = 101
    lbl.Parent = popup

    local okBtn = Instance.new("TextButton")
    okBtn.Size = UDim2.new(0, 80, 0, 26)
    okBtn.Position = UDim2.new(0.5, -40, 1, -34)
    okBtn.BackgroundColor3 = Theme.Accent
    okBtn.Text = "知道了"
    okBtn.TextColor3 = Theme.Text
    okBtn.TextSize = 12
    okBtn.Font = Enum.Font.GothamBold
    okBtn.AutoButtonColor = false
    okBtn.ZIndex = 101
    Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 6)
    okBtn.Parent = popup

    okBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
    task.delay(3, function()
        if popup and popup.Parent then popup:Destroy() end
    end)
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 310)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -155)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Theme.Stroke
mainStroke.Thickness = 1

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://17470093533"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
bgImage.Parent = mainFrame
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 12)

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = mainFrame
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 12)

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
makeDraggable(mainFrame)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Theme.TopBar
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
topBar.ZIndex = 2
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 12)
topBarCover.Position = UDim2.new(0, 0, 1, -12)
topBarCover.BackgroundColor3 = Theme.TopBar
topBarCover.BackgroundTransparency = 0.3
topBarCover.BorderSizePixel = 0
topBarCover.ZIndex = 2
topBarCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "自动刷糖"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Theme.Text
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
closeButton.BackgroundColor3 = Theme.Danger
closeButton.Text = "X"
closeButton.TextColor3 = Theme.Text
closeButton.TextSize = 11
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.ZIndex = 3
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 11)
closeButton.Parent = windowControls
closeButton.MouseEnter:Connect(function() closeButton.BackgroundColor3 = Theme.DangerHover end)
closeButton.MouseLeave:Connect(function() closeButton.BackgroundColor3 = Theme.Danger end)

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 22, 0, 22)
miniButton.Position = UDim2.new(0, 0, 0, 0)
miniButton.BackgroundColor3 = Theme.Warning
miniButton.Text = "−"
miniButton.TextColor3 = Theme.Text
miniButton.TextSize = 14
miniButton.Font = Enum.Font.GothamBold
miniButton.AutoButtonColor = false
miniButton.ZIndex = 3
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(0, 11)
miniButton.Parent = windowControls
miniButton.MouseEnter:Connect(function() miniButton.BackgroundColor3 = Theme.WarningHover end)
miniButton.MouseLeave:Connect(function() miniButton.BackgroundColor3 = Theme.Warning end)

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 56, 1, -36)
navBar.Position = UDim2.new(0, 0, 0, 36)
navBar.BackgroundColor3 = Theme.NavBar
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
    btn.TextColor3 = Theme.Text
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.Parent = navScroll
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
        btn.BackgroundTransparency = 0.2
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        btn.BackgroundTransparency = 0.3
    end)
    return btn
end

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -56, 1, -36)
pageContainer.Position = UDim2.new(0, 56, 0, 36)
pageContainer.BackgroundTransparency = 1
pageContainer.ZIndex = 1
pageContainer.Parent = mainFrame

local pages = {}
local navButtons = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 1
    page.Parent = pageContainer

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Theme.Text
    scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
    scroll.ZIndex = 1
    scroll.Parent = page

    pages[name] = { frame = page, scroll = scroll }
    return scroll
end

local function createToggleRow(label, defaultState, yPos, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 276, 0, 32)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Theme.Row
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
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(1, -54, 0.5, -11)
    btn.BackgroundColor3 = defaultState and Theme.Success or Theme.Control
    btn.Text = defaultState and "开启" or "关闭"
    btn.TextColor3 = Theme.Text
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = row
    return btn, lbl
end

local function switchPage(name)
    for pName, p in pairs(pages) do
        p.frame.Visible = (pName == name)
    end
    for bName, btn in pairs(navButtons) do
        if bName == name then
            btn.BackgroundColor3 = Theme.Accent
            btn.BackgroundTransparency = 0
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            btn.BackgroundTransparency = 0.3
        end
    end
end

local mainPage = createPage("mainAccount")

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PLATFORM_POS = Vector3.new(10023, -42, 10023)
local PLATFORM_SIZE = Vector3.new(200, 4, 200)
local PLATFORM_TOP = PLATFORM_POS.Y + PLATFORM_SIZE.Y / 2
local STAND_POS = Vector3.new(10023, PLATFORM_TOP + 3, 10023)

local State = {
    MainAccount = false,
    SubAccount = false,
    SubTargetName = "",
    usedThisLife = false,
    characterConn = nil,
    mainClickThread = nil,
    subFollowThread = nil,
    freezeThread = nil,
}

local function ensurePlatform()
    local old = Workspace:FindFirstChild("InjectedPlatform")
    if old then return old end
    local ok, platform = pcall(function()
        local p = Instance.new("Part")
        p.Name = "InjectedPlatform"
        p.Size = PLATFORM_SIZE
        p.Position = PLATFORM_POS
        p.Anchored = true
        p.CanCollide = true
        p.CanTouch = true
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Material = Enum.Material.Slate
        p.Color = Color3.fromRGB(80, 80, 90)
        p.Parent = Workspace
        return p
    end)
    return ok and platform or nil
end

local function getSendPacket()
    local ok, packet = pcall(function()
        return ReplicatedStorage
            :WaitForChild("ReplicatedStorage Package", 5)
            :WaitForChild("Remote Events")
            :WaitForChild("SendPacket")
    end)
    return ok and packet or nil
end

local function enterArenaAndLand()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local SendPacket = getSendPacket()
    if not SendPacket then return end

    ensurePlatform()

    local ARENA_CFRAME = CFrame.new(78, 6.9535388946533203, -55, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    local startPos = hrp.Position

    pcall(function()
        SendPacket:FireServer("Enter Arena", ARENA_CFRAME)
    end)

    local t0 = os.clock()
    local conn
    local done = false
    conn = RunService.Heartbeat:Connect(function()
        if done then return end
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then
            done = true
            if conn then conn:Disconnect() end
            return
        end
        if (h.Position - startPos).Magnitude > 5 then
            h.CFrame = CFrame.new(STAND_POS)
            done = true
            if conn then conn:Disconnect() end
            return
        end
        if os.clock() - t0 > 3 then
            h.CFrame = CFrame.new(STAND_POS)
            done = true
            if conn then conn:Disconnect() end
        end
    end)
end

local function freezeLocalPlayer()
    local conn
    local done = false
    conn = RunService.Heartbeat:Connect(function()
        if done or not State.MainAccount then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.CFrame = CFrame.new(STAND_POS)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
    return function()
        done = true
        if conn then conn:Disconnect() end
    end
end

local function findPunchButton()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, d in ipairs(pg:GetDescendants()) do
        if d.Name == "Punch Button"
           and (d:IsA("TextButton") or d:IsA("ImageButton") or d:IsA("GuiButton")) then
            return d
        end
    end
    return nil
end

local function clickAtLeft()
    local vp = Workspace.CurrentCamera.ViewportSize
    local pos = Vector2.new(vp.X * 0.12, vp.Y * 0.5)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.03)
        vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    end)
end

local function startMainClickLoop()
    if State.mainClickThread then
        pcall(function() task.cancel(State.mainClickThread) end)
        State.mainClickThread = nil
    end
    State.mainClickThread = task.spawn(function()
        while State.MainAccount do
            local btn = findPunchButton()
            if btn and btn.Enabled then
                pcall(function() btn:Activate() end)
            else
                clickAtLeft()
            end
            task.wait(0.1)
        end
    end)
end

local function stopMainClickLoop()
    if State.mainClickThread then
        pcall(function() task.cancel(State.mainClickThread) end)
        State.mainClickThread = nil
    end
end

local function findPlayerByName(name)
    name = (name or ""):lower()
    if name == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower() == name then
            return p
        end
    end
    return nil
end

local function getTargetRightArmCFrame(targetChar)
    if not targetChar then return nil end
    local rightHand = targetChar:FindFirstChild("RightHand")
    if rightHand and rightHand:IsA("BasePart") then
        return rightHand.CFrame
    end
    local rightLowerArm = targetChar:FindFirstChild("RightLowerArm")
    if rightLowerArm and rightLowerArm:IsA("BasePart") then
        return rightLowerArm.CFrame
    end
    local rightArm = targetChar:FindFirstChild("Right Arm")
    if rightArm and rightArm:IsA("BasePart") then
        return rightArm.CFrame
    end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.CFrame * CFrame.new(1.5, 0, 0)
    end
    return nil
end

local function startSubFollowLoop()
    if State.subFollowThread then
        pcall(function() task.cancel(State.subFollowThread) end)
        State.subFollowThread = nil
    end
    State.subFollowThread = task.spawn(function()
        while State.SubAccount do
            local target = findPlayerByName(State.SubTargetName)
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local tChar = target and target.Character

            if myHrp and tChar then
                local armCF = getTargetRightArmCFrame(tChar)
                if armCF then
                    pcall(function()
                        myHrp.CFrame = armCF
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function stopSubFollowLoop()
    if State.subFollowThread then
        pcall(function() task.cancel(State.subFollowThread) end)
        State.subFollowThread = nil
    end
end

local function bindCharacterAuto()
    if State.characterConn then
        State.characterConn:Disconnect()
        State.characterConn = nil
    end
    State.characterConn = LocalPlayer.CharacterAdded:Connect(function(char)
        State.usedThisLife = false
        if State.MainAccount or State.SubAccount then
            task.wait(0.5)
            pcall(enterArenaAndLand)
        end
    end)
end
bindCharacterAuto()

local btnMain, _ = createToggleRow("主账号开启", false, 8, mainPage)
local btnSub, _  = createToggleRow("子账号开启", false, 46, mainPage)

local inputRow = Instance.new("Frame")
inputRow.Size = UDim2.new(0, 276, 0, 32)
inputRow.Position = UDim2.new(0, 10, 0, 84)
inputRow.BackgroundColor3 = Theme.Row
inputRow.BackgroundTransparency = 0.3
inputRow.BorderSizePixel = 0
inputRow.ZIndex = 2
Instance.new("UICorner", inputRow).CornerRadius = UDim.new(0, 8)
inputRow.Parent = mainPage

local inputLbl = Instance.new("TextLabel")
inputLbl.Size = UDim2.new(0, 90, 1, 0)
inputLbl.Position = UDim2.new(0, 12, 0, 0)
inputLbl.BackgroundTransparency = 1
inputLbl.Text = "主账号名称"
inputLbl.TextColor3 = Theme.Text
inputLbl.TextSize = 11
inputLbl.Font = Enum.Font.GothamMedium
inputLbl.TextXAlignment = Enum.TextXAlignment.Left
inputLbl.ZIndex = 3
inputLbl.Parent = inputRow

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 160, 0, 22)
inputBox.Position = UDim2.new(1, -170, 0.5, -11)
inputBox.BackgroundColor3 = Theme.Control
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "输入主账号名称"
inputBox.PlaceholderColor3 = Theme.TextDim
inputBox.TextColor3 = Theme.Text
inputBox.TextSize = 11
inputBox.Font = Enum.Font.GothamMedium
inputBox.ClearTextOnFocus = false
inputBox.ZIndex = 3
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)
inputBox.Parent = inputRow

inputBox.FocusLost:Connect(function()
    State.SubTargetName = inputBox.Text
end)

local function refreshToggle(btn, on)
    btn.BackgroundColor3 = on and Theme.Success or Theme.Control
    btn.Text = on and "开启" or "关闭"
end

btnMain.MouseButton1Click:Connect(function()
    State.MainAccount = not State.MainAccount
    refreshToggle(btnMain, State.MainAccount)
    if State.MainAccount then
        State.usedThisLife = false
        pcall(enterArenaAndLand)
        startMainClickLoop()
        if State.freezeThread then
            pcall(State.freezeThread)
            State.freezeThread = nil
        end
        State.freezeThread = freezeLocalPlayer()
    else
        stopMainClickLoop()
        if State.freezeThread then
            pcall(State.freezeThread)
            State.freezeThread = nil
        end
    end
end)

btnSub.MouseButton1Click:Connect(function()
    if not State.SubAccount then
        local name = inputBox.Text
        if not name or name:gsub("%s", "") == "" then
            showPopup("请输入主账号名称")
            return
        end
        State.SubTargetName = name
    end

    State.SubAccount = not State.SubAccount
    refreshToggle(btnSub, State.SubAccount)
    if State.SubAccount then
        State.usedThisLife = false
        pcall(enterArenaAndLand)
        startSubFollowLoop()
    else
        stopSubFollowLoop()
    end
end)

navButtons["mainAccount"] = createNavButton("自动刷糖", "🍬", 8)
navButtons["mainAccount"].MouseButton1Click:Connect(function() switchPage("mainAccount") end)

switchPage("mainAccount")

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 170, 0, 42)
miniFrame.Position = UDim2.new(0.5, -85, 0.5, -21)
miniFrame.BackgroundColor3 = Theme.Background
miniFrame.BackgroundTransparency = 0.3
miniFrame.Text = "❤️打开UI❤️"
miniFrame.TextColor3 = Theme.Text
miniFrame.TextSize = 13
miniFrame.Font = Enum.Font.GothamBold
miniFrame.BorderSizePixel = 0
miniFrame.AutoButtonColor = false
miniFrame.Visible = false
miniFrame.ZIndex = 10
miniFrame.Parent = screenGui
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke", miniFrame)
miniStroke.Thickness = 1
miniStroke.Color = Theme.Stroke

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

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)