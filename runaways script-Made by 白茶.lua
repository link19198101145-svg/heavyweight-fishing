local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientEvent = ReplicatedStorage.FlowClient.ClientRunner.Event
local ClientFunction = ReplicatedStorage.FlowClient.ClientRunner.Function

local SETTINGS = {
    KillRange = 200,
    KillDamage = 999999,
    KillInterval = 0.1,
    CollectRange = 200,
    CollectInterval = 0.05,
    BarrierRadius = 10,
    BarrierHeight = 15,
    PyramidHeight = 8,
    WallThickness = 1,
    BarrierTransparency = 0.3,
    ScanInterval = 0.5,
    SpeedLimit = 250,
}

local lastKill = 0
local lastCollect = 0
local killEnabled = false
local collectEnabled = false
local barrierEnabled = false
local antiFlyEnabled = false
local killConnection = nil
local collectConnection = nil
local antiFlyConnection = nil

local barrierParts = {}
local barrierActive = false
local lastScan = 0
local hue = 0

local function getNPCs()
    local npcList = {}

    pcall(function()
        local npcsFolder = Workspace:FindFirstChild("NPCs")
        if npcsFolder then
            for _, npc in ipairs(npcsFolder:GetChildren()) do
                local humanoid = npc:FindFirstChild("Humanoid")
                local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")

                if humanoid and root and humanoid.Health > 0 then
                    table.insert(npcList, {
                        Humanoid = humanoid,
                        Root = root,
                    })
                end
            end
        end
    end)

    return npcList
end

local function killNPCs()
    local character = LocalPlayer.Character
    if not character then return end

    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myPos = myRoot.Position
    local npcs = getNPCs()
    local count = 0

    for _, npc in ipairs(npcs) do
        local dist = (npc.Root.Position - myPos).Magnitude

        if dist <= SETTINGS.KillRange then
            pcall(function()
                ClientEvent:FireServer("NPCs", "Damage", npc.Humanoid, SETTINGS.KillDamage)
            end)
            count = count + 1
        end
    end
end

local function collectLoot()
    local character = LocalPlayer.Character
    if not character then return end

    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myPos = myRoot.Position
    local count = 0

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Handle") then
            local handle = obj:FindFirstChild("Handle")

            if handle:IsA("BasePart") then
                local dist = (handle.Position - myPos).Magnitude

                if dist <= SETTINGS.CollectRange then
                    pcall(function()
                        ClientFunction:InvokeServer("Loot", "LootEquip", handle)
                        count = count + 1
                    end)
                end
            end
        end
    end
end

local function startKillLoop()
    if killConnection then return end
    killConnection = RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        if currentTime - lastKill >= SETTINGS.KillInterval then
            lastKill = currentTime
            killNPCs()
        end
    end)
end

local function stopKillLoop()
    if killConnection then
        killConnection:Disconnect()
        killConnection = nil
    end
end

local function startCollectLoop()
    if collectConnection then return end
    collectConnection = RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        if currentTime - lastCollect >= SETTINGS.CollectInterval then
            lastCollect = currentTime
            collectLoot()
        end
    end)
end

local function stopCollectLoop()
    if collectConnection then
        collectConnection:Disconnect()
        collectConnection = nil
    end
end

local function startAntiFly()
    if antiFlyConnection then return end
    antiFlyConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end

        local root = character:FindFirstChild("HumanoidRootPart")
        if root and root.AssemblyLinearVelocity.Magnitude > SETTINGS.SpeedLimit then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopAntiFly()
    if antiFlyConnection then
        antiFlyConnection:Disconnect()
        antiFlyConnection = nil
    end
end

local function createPyramidRoof(myPos)
    local pyramidParts = {}
    local sides = 16

    for i = 0, sides - 1 do
        local angle1 = i * (math.pi * 2) / sides
        local angle2 = (i + 1) * (math.pi * 2) / sides

        local base1 = Vector3.new(math.cos(angle1) * SETTINGS.BarrierRadius, SETTINGS.BarrierHeight, math.sin(angle1) * SETTINGS.BarrierRadius)
        local base2 = Vector3.new(math.cos(angle2) * SETTINGS.BarrierRadius, SETTINGS.BarrierHeight, math.sin(angle2) * SETTINGS.BarrierRadius)
        local apex = Vector3.new(0, SETTINGS.BarrierHeight + SETTINGS.PyramidHeight, 0)

        local midPoint = (base1 + base2) / 2
        local center = myPos + midPoint

        local edgeLength = (base2 - base1).Magnitude
        local slantLength = (apex - base1).Magnitude

        local face = Instance.new("Part")
        face.Name = "PyramidFace"
        face.Size = Vector3.new(edgeLength, SETTINGS.WallThickness, slantLength)
        face.Anchored = true
        face.CanCollide = true
        face.Transparency = SETTINGS.BarrierTransparency
        face.Material = Enum.Material.ForceField
        face.BrickColor = BrickColor.new("Cyan")

        local direction = (myPos + apex) - center
        face.CFrame = CFrame.lookAt(center, myPos + apex)
        face.Position = (center + myPos + apex) / 2

        face.Parent = workspace
        table.insert(barrierParts, face)
        table.insert(pyramidParts, face)
    end

    return pyramidParts
end

local function createBarrier()
    if barrierActive then return end
    barrierActive = true

    local character = LocalPlayer.Character
    if not character then
        barrierActive = false
        return
    end

    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        barrierActive = false
        return
    end

    local myPos = myRoot.Position
    local wallCount = 16
    local angleStep = (math.pi * 2) / wallCount

    for i = 0, wallCount - 1 do
        local angle = i * angleStep
        local wall = Instance.new("Part")
        wall.Name = "Barrier"
        wall.Size = Vector3.new(SETTINGS.BarrierRadius * math.pi / wallCount + SETTINGS.WallThickness * 2, SETTINGS.BarrierHeight, SETTINGS.WallThickness)
        wall.Anchored = true
        wall.CanCollide = true
        wall.Transparency = SETTINGS.BarrierTransparency
        wall.Material = Enum.Material.ForceField
        wall.BrickColor = BrickColor.new("Cyan")

        local x = math.cos(angle) * SETTINGS.BarrierRadius
        local z = math.sin(angle) * SETTINGS.BarrierRadius
        wall.Position = myPos + Vector3.new(x, SETTINGS.BarrierHeight / 2, z)

        local lookDir = Vector3.new(-x, 0, -z)
        if lookDir.Magnitude > 0 then
            wall.CFrame = CFrame.lookAt(wall.Position, wall.Position + lookDir)
        end

        wall.Parent = workspace
        table.insert(barrierParts, wall)

        local glow = Instance.new("PointLight")
        glow.Color = Color3.fromRGB(0, 200, 255)
        glow.Brightness = 2
        glow.Range = 8
        glow.Parent = wall

        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxassetid://243098098"
        emitter.Lifetime = NumberRange.new(1, 2)
        emitter.Rate = 50
        emitter.Speed = NumberRange.new(0)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
        emitter.LightEmission = 1
        emitter.Transparency = NumberSequence.new(0, 1)
        emitter.Size = NumberSequence.new(0.2)
        emitter.Parent = wall
    end

    createPyramidRoof(myPos)
end

local function destroyBarrier()
    for _, part in ipairs(barrierParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    barrierParts = {}
    barrierActive = false
end

local function updateBarrier()
    local character = LocalPlayer.Character
    if not character then return end

    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myPos = myRoot.Position
    local wallCount = 16
    local angleStep = (math.pi * 2) / wallCount

    for i = 0, wallCount - 1 do
        local wall = barrierParts[i + 1]
        if wall and wall.Parent then
            local angle = i * angleStep
            local x = math.cos(angle) * SETTINGS.BarrierRadius
            local z = math.sin(angle) * SETTINGS.BarrierRadius

            wall.Position = myPos + Vector3.new(x, SETTINGS.BarrierHeight / 2, z)

            local lookDir = Vector3.new(-x, 0, -z)
            if lookDir.Magnitude > 0 then
                wall.CFrame = CFrame.lookAt(wall.Position, wall.Position + lookDir)
            end

            wall.BrickColor = BrickColor.new(Color3.fromHSV(hue, 1, 1))
        end
    end

    local pyramidStart = wallCount + 1
    local sides = 16

    for i = 0, sides - 1 do
        local face = barrierParts[pyramidStart + i]
        if face and face.Parent then
            local angle1 = i * (math.pi * 2) / sides
            local angle2 = (i + 1) * (math.pi * 2) / sides

            local base1 = Vector3.new(math.cos(angle1) * SETTINGS.BarrierRadius, SETTINGS.BarrierHeight, math.sin(angle1) * SETTINGS.BarrierRadius)
            local base2 = Vector3.new(math.cos(angle2) * SETTINGS.BarrierRadius, SETTINGS.BarrierHeight, math.sin(angle2) * SETTINGS.BarrierRadius)
            local apex = Vector3.new(0, SETTINGS.BarrierHeight + SETTINGS.PyramidHeight, 0)

            local midPoint = (base1 + base2) / 2
            local center = myPos + midPoint
            local worldApex = myPos + apex

            face.CFrame = CFrame.lookAt(center, worldApex)
            face.Position = (center + worldApex) / 2

            face.BrickColor = BrickColor.new(Color3.fromHSV(hue, 1, 1))
        end
    end
end

local function detectHeli()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if string.find(name, "heli") or string.find(name, "police") then
                return true
            end
        end
    end
    return false
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 230)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
title.Text = "功能面板"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 52, 0, 22)
windowControls.Position = UDim2.new(1, -58, 0, 12)
windowControls.BackgroundTransparency = 1
windowControls.Parent = mainFrame

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 22, 0, 22)
miniBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 14
miniBtn.Font = Enum.Font.GothamBold
miniBtn.AutoButtonColor = false
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 11)
miniCorner.Parent = miniBtn
miniBtn.Parent = windowControls

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(0, 30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 11)
closeCorner.Parent = closeBtn
closeBtn.Parent = windowControls

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -45)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 310)
scrollFrame.Parent = mainFrame

local scrollContent = Instance.new("Frame")
scrollContent.Size = UDim2.new(1, 0, 1, 0)
scrollContent.BackgroundTransparency = 1
scrollContent.Parent = scrollFrame

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 150, 0, 35)
miniFrame.Position = UDim2.new(0.5, -75, 0.5, -17)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
miniFrame.Text = "功能面板"
miniFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
miniFrame.TextSize = 13
miniFrame.Font = Enum.Font.GothamBold
miniFrame.BorderSizePixel = 0
miniFrame.AutoButtonColor = false
miniFrame.Visible = false
miniFrame.Parent = screenGui

local miniFrameCorner = Instance.new("UICorner")
miniFrameCorner.CornerRadius = UDim.new(1, 0)
miniFrameCorner.Parent = miniFrame

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    stopKillLoop()
    stopCollectLoop()
    stopAntiFly()
    destroyBarrier()
    screenGui:Destroy()
end)

local dragging = false
local dragStart = nil
local startPos = nil

miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = miniFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        miniFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

miniFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging and (input.Position - dragStart).Magnitude < 5 then
            miniFrame.Visible = false
            mainFrame.Visible = true
        end
        dragging = false
    end
end)

local function createToggle(label, yPos, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 230, 0, 40)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    row.Parent = scrollContent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 150, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 200, 205)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 26)
    btn.Position = UDim2.new(1, -60, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "关闭"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = row

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "开启" or "关闭"
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
        if callback then callback(state) end
    end)
end

local function createSliderRow(label, yPos, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 230, 0, 50)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    row.Parent = scrollContent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 220, 0, 18)
    lbl.Position = UDim2.new(0, 5, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. defaultVal
    lbl.TextColor3 = Color3.fromRGB(200, 200, 205)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 28, 0, 22)
    minusBtn.Position = UDim2.new(0, 5, 0, 24)
    minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.TextSize = 14
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.AutoButtonColor = false
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 5)
    minusCorner.Parent = minusBtn
    minusBtn.Parent = row

    local valueInput = Instance.new("TextBox")
    valueInput.Size = UDim2.new(0, 80, 0, 22)
    valueInput.Position = UDim2.new(0, 75, 0, 24)
    valueInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    valueInput.Text = tostring(defaultVal)
    valueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueInput.TextSize = 11
    valueInput.Font = Enum.Font.Gotham
    valueInput.ClearTextOnFocus = false
    valueInput.Parent = row

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 28, 0, 22)
    plusBtn.Position = UDim2.new(0, 197, 0, 24)
    plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.TextSize = 14
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.AutoButtonColor = false
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 5)
    plusCorner.Parent = plusBtn
    plusBtn.Parent = row

    local currentValue = defaultVal

    local function updateValue(newVal)
        currentValue = math.clamp(tonumber(newVal) or minVal, minVal, maxVal)
        valueInput.Text = tostring(currentValue)
        lbl.Text = label .. ": " .. currentValue
        if callback then callback(currentValue) end
    end

    minusBtn.MouseButton1Click:Connect(function()
        updateValue(currentValue - 100)
    end)

    plusBtn.MouseButton1Click:Connect(function()
        updateValue(currentValue + 100)
    end)

    valueInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            updateValue(tonumber(valueInput.Text))
        end
    end)
end

createSliderRow("杀戮范围", 0, 100, 10000, SETTINGS.KillRange, function(val)
    SETTINGS.KillRange = val
end)

createToggle("杀戮光环", 60, function(state)
    killEnabled = state
    if state then
        startKillLoop()
    else
        stopKillLoop()
    end
end)

createToggle("物品收集", 110, function(state)
    collectEnabled = state
    if state then
        startCollectLoop()
    else
        stopCollectLoop()
    end
end)

createToggle("直升机屏障", 160, function(state)
    barrierEnabled = state
    if state then
        if not barrierActive and detectHeli() then
            createBarrier()
        end
    else
        destroyBarrier()
    end
end)

createToggle("绕过反飞行", 210, function(state)
    antiFlyEnabled = state
    if state then
        startAntiFly()
    else
        stopAntiFly()
    end
end)

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1

    if barrierEnabled then
        local currentTime = tick()
        if currentTime - lastScan >= SETTINGS.ScanInterval then
            lastScan = currentTime

            local heliExists = detectHeli()

            if heliExists and not barrierActive then
                createBarrier()
            elseif not heliExists and barrierActive then
                destroyBarrier()
            end
        end

        if barrierActive then
            updateBarrier()
        end
    end
end)
