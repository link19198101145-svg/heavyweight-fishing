local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local instantInteract = false
local graveMode = false
local candyAutoMode = false
local remoteScriptRunning = false
local remoteScriptThread = nil
local initDone = false
local initRunning = false
local initIndex = 1
local lastInitTeleport = 0
local lastTeleport = 0
local lastPrompt = 0
local lastCandyTeleport = 0
local currentGrave = nil
local chestTeleportIndex = 1
local originalLighting = nil
local fullBrightEnabled = false

local CHEST_POINTS = {
    Vector3.new(9312.5, 4624.0, -5172.4),
    Vector3.new(9380.7, 4624.0, -5193.5),
    Vector3.new(9844.5, 4616.6, -4602.4),
    Vector3.new(8870.4, 4626.9, -5597.0),
    Vector3.new(10621.9, 3824.3, -6042.3),
    Vector3.new(10653.5, 3825.4, -6017.2),
    Vector3.new(10640.2, 3824.3, -6023.4),
    Vector3.new(10661.6, 3824.3, -6042.0),
    Vector3.new(10666.1, 3824.3, -6005.6),
    Vector3.new(10640.7, 3825.2, -6012.0),
    Vector3.new(10324.1, 4619.1, -4401.1),
    Vector3.new(10170.6, 4618.7, -4632.0),
    Vector3.new(10157.4, 4618.7, -4651.3),
    Vector3.new(9533.3, 4628.3, -5567.6),
}

local CANDY_POINTS = {
    Vector3.new(8950.0, 4628.4, -5380.6),
    Vector3.new(9352.9, 4621.3, -4620.1),
    Vector3.new(9059.1, 4628.4, -5488.5),
    Vector3.new(9669.6, 4619.8, -4677.4),
    Vector3.new(9349.5, 4621.3, -4543.8),
    Vector3.new(9185.0, 4625.3, -3770.7),
    Vector3.new(9081.2, 4623.1, -3676.5),
    Vector3.new(8965.0, 4625.6, -3802.1),
    Vector3.new(8712.6, 4620.6, -3819.3),
    Vector3.new(8276.4, 4620.0, -4443.9),
    Vector3.new(8501.2, 4622.5, -5001.2),
    Vector3.new(8568.8, 4622.2, -5031.5),
    Vector3.new(8468.2, 4630.3, -5420.7),
    Vector3.new(8951.7, 4626.4, -5745.6),
    Vector3.new(8682.5, 4622.0, -5924.9),
    Vector3.new(8840.6, 4621.9, -6053.0),
    Vector3.new(9413.9, 4615.5, -6535.1),
    Vector3.new(9473.8, 4630.6, -6283.6),
    Vector3.new(9528.0, 4628.5, -5932.8),
    Vector3.new(9592.5, 4622.9, -6200.4),
    Vector3.new(9535.3, 4139.0, -6331.1),
    Vector3.new(10070.6, 4618.7, -6223.4),
    Vector3.new(10260.5, 4611.1, -6434.9),
    Vector3.new(10540.5, 3823.8, -6172.1),
    Vector3.new(10525.6, 3823.8, -6159.4),
    Vector3.new(10535.6, 3823.8, -6152.4),
    Vector3.new(10638.1, 3823.8, -6019.2),
    Vector3.new(10766.9, 3823.8, -6145.4),
    Vector3.new(10341.0, 4612.6, -6368.6),
    Vector3.new(10856.3, 4641.8, -6275.2),
    Vector3.new(10900.2, 4629.9, -5676.0),
    Vector3.new(11392.8, 4623.9, -5588.2),
    Vector3.new(10600.8, 4628.3, -4841.8),
    Vector3.new(12241.4, 4634.2, -4576.1),
    Vector3.new(12200.0, 4629.0, -4247.2),
    Vector3.new(12102.0, 4630.5, -4184.3),
    Vector3.new(11712.5, 4627.7, -4159.1),
    Vector3.new(10825.1, 4618.9, -4064.8),
    Vector3.new(10061.3, 4622.7, -5092.3),
    Vector3.new(9568.8, 4627.8, -5571.5),
    Vector3.new(8830.9, 4624.3, -4173.9),
    Vector3.new(10011.9, 4629.0, -5731.1),
}

local TELEPORT_LOCATIONS = {
    {Name = "传送水晶", Pos = Vector3.new(10500.671, 4638.676, -5488.309)},
    {Name = "角斗士", Pos = Vector3.new(8595.255, 4624.971, -4855.93)},
    {Name = "黑暗洞穴", Pos = Vector3.new(10501.594, 3826.314, -6266.758)},
    {Name = "岩石大陆", Pos = Vector3.new(10982.822, 4644.27, -6284.268)},
    {Name = "海滩(神圣岛水晶)", Pos = Vector3.new(8749.703, 4630.596, -3742.267)},
    {Name = "神秘岛", Pos = Vector3.new(5920, 4620.268, -3180.081)},
}

local function firePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()
        end
    end)
end

local function enableFullBright()
    if not originalLighting then
        originalLighting = {
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor,
            ClockTime = Lighting.ClockTime,
            GlobalShadows = Lighting.GlobalShadows,
        }
    end
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("Atmosphere") or effect:IsA("ColorCorrectionEffect") then
            pcall(function() effect:Destroy() end)
        end
    end
    pcall(function()
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end)
    fullBrightEnabled = true
end

local function disableFullBright()
    if not fullBrightEnabled then return end
    if originalLighting then
        pcall(function()
            Lighting.Brightness = originalLighting.Brightness
            Lighting.Ambient = originalLighting.Ambient
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.FogStart = originalLighting.FogStart
            Lighting.FogColor = originalLighting.FogColor
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.GlobalShadows = originalLighting.GlobalShadows
        end)
    end
    fullBrightEnabled = false
end

local function setPromptInstant()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            pcall(function()
                obj.HoldDuration = 0
            end)
        end
    end
end

local function getFirstGrave()
    local halloween = Workspace:FindFirstChild("HalloweenStuff")
    if not halloween then return nil end
    for _, obj in ipairs(halloween:GetDescendants()) do
        if obj.Name == "Grave" and obj:IsA("BasePart") then
            local prompt = obj:FindFirstChild("ProximityPrompt")
            if prompt then
                return {Part = obj, Prompt = prompt, Position = obj.Position}
            end
        end
    end
    return nil
end

local function getChestStatus()
    local result = {}
    local halloween = Workspace:FindFirstChild("HalloweenStuff")
    if not halloween then return result end
    for _, obj in ipairs(halloween:GetDescendants()) do
        if obj.Name == "ChestSpawn" and obj:IsA("BasePart") then
            local open = obj:FindFirstChild("Open")
            table.insert(result, {
                Position = obj.Position,
                IsOpen = open and open:IsA("BoolValue") and open.Value or false,
            })
        end
    end
    return result
end

local function findNearestCandy()
    local character = LocalPlayer.Character
    if not character then return nil end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local candySearch = Workspace:FindFirstChild("OthersSpecialEvents")
    if candySearch then
        candySearch = candySearch:FindFirstChild("CandySearch")
    end
    if not candySearch then return nil end

    local best = nil
    local bestDist = math.huge

    for _, spawn in ipairs(candySearch:GetChildren()) do
        if spawn.Name == "Spawn" then
            for _, child in ipairs(spawn:GetChildren()) do
                if child:IsA("BasePart") and child.Name ~= "Spawn" then
                    local prompt = child:FindFirstChild("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        local dist = (child.Position - myRoot.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            best = {Prompt = prompt, Part = child, Position = child.Position}
                        end
                    end
                end
            end
        end
    end

    return best
end

Workspace.DescendantAdded:Connect(function(obj)
    if instantInteract and obj:IsA("ProximityPrompt") then
        pcall(function()
            obj.HoldDuration = 0
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    local now = tick()

    local character = LocalPlayer.Character
    if not character then return end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    if initRunning then
        if now - lastInitTeleport >= 0.25 then
            lastInitTeleport = now

            local allPoints = {}
            for _, p in ipairs(CHEST_POINTS) do table.insert(allPoints, p) end
            for _, p in ipairs(CANDY_POINTS) do table.insert(allPoints, p) end

            if initIndex > #allPoints then
                initDone = true
                initRunning = false
                initIndex = 1
                if initBtn then
                    initBtn.Text = "✅ 已初始化"
                    initBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                end
                return
            end

            local target = allPoints[initIndex]
            myRoot.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
            initIndex = initIndex + 1
        end
        return
    end

    if candyAutoMode then
        if now - lastCandyTeleport >= 0.3 then
            lastCandyTeleport = now
            local candy = findNearestCandy()
            if candy then
                myRoot.CFrame = CFrame.new(candy.Position + Vector3.new(0, 5, 0))
                if now - lastPrompt >= 0.1 then
                    lastPrompt = now
                    firePrompt(candy.Prompt)
                end
                return
            end
        end
    end

    if graveMode then
        if not currentGrave then
            currentGrave = getFirstGrave()
        end
        if currentGrave then
            myRoot.CFrame = CFrame.new(currentGrave.Position + Vector3.new(0, 5, 0))
            firePrompt(currentGrave.Prompt)
        end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KsV4UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 280)
mainFrame.Position = UDim2.new(0.5, -190, 0.3, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 28)
title.Position = UDim2.new(0, 85, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🗡️KsV4 UI"
title.TextColor3 = Color3.fromRGB(255, 150, 50)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 20, 0, 20)
miniBtn.Position = UDim2.new(1, -48, 0, 7)
miniBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
miniBtn.Text = "−"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 14
miniBtn.Font = Enum.Font.GothamBold
miniBtn.AutoButtonColor = false
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 10)
miniCorner.Parent = miniBtn
miniBtn.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    disableFullBright()
    screenGui:Destroy()
end)

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 70, 1, -36)
navBar.Position = UDim2.new(0, 0, 0, 36)
navBar.BackgroundColor3 = Color3.fromRGB(22, 18, 28)
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 8)
navCorner.Parent = navBar

local pages = {}
local navButtons = {}

local function switchPage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
    end
    for i, btn in ipairs(navButtons) do
        btn.BackgroundColor3 = (i == index) and Color3.fromRGB(60, 130, 255) or Color3.fromRGB(45, 45, 55)
    end
end

local function createNavButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 58, 0, 40)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = navBar
    table.insert(navButtons, btn)
    btn.MouseButton1Click:Connect(callback)
end

local function createPage(contentHeight)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -70, 1, -36)
    page.Position = UDim2.new(0, 70, 0, 36)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ClipsDescendants = true
    page.Parent = mainFrame
    table.insert(pages, page)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight or 300)
    scroll.ScrollBarImageTransparency = 0.3
    scroll.Parent = page

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, contentHeight or 300)
    content.BackgroundTransparency = 1
    content.Parent = scroll

    return content, page
end

local function createToggle(parent, label, yPos, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 290, 0, 34)
    row.Position = UDim2.new(0, 5, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    row.BorderSizePixel = 0
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 220, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
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
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "关闭"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
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

local function createSubLabel(parent, text, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 290, 0, 16)
    lbl.Position = UDim2.new(0, 8, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local page1, _ = createPage(220)

local initBtn = Instance.new("TextButton")
initBtn.Size = UDim2.new(0, 290, 0, 30)
initBtn.Position = UDim2.new(0, 5, 0, 5)
initBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
initBtn.Text = "🔄 初始化地图 (糖果+宝箱)"
initBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
initBtn.TextSize = 11
initBtn.Font = Enum.Font.GothamBold
initBtn.AutoButtonColor = false
local initBtnCorner = Instance.new("UICorner")
initBtnCorner.CornerRadius = UDim.new(0, 6)
initBtnCorner.Parent = initBtn
initBtn.Parent = page1

initBtn.MouseButton1Click:Connect(function()
    if initDone then
        initBtn.Text = "✅ 已初始化"
        return
    end
    initRunning = true
    initIndex = 1
    lastInitTeleport = 0
    initBtn.Text = "⏳ 初始化中..."
    initBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

createSubLabel(page1, "🍭 糖果", 40)

createToggle(page1, "自动捡糖", 58, function(state)
    candyAutoMode = state
end)

createSubLabel(page1, "🔑钥匙和宝箱📦", 102)

createToggle(page1, "自动挖钥匙", 120, function(state)
    graveMode = state
    if not state then currentGrave = nil end
end)

local chestTeleportBtn = Instance.new("TextButton")
chestTeleportBtn.Size = UDim2.new(0, 290, 0, 30)
chestTeleportBtn.Position = UDim2.new(0, 5, 0, 160)
chestTeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
chestTeleportBtn.Text = "传送到宝箱 1 / 14"
chestTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chestTeleportBtn.TextSize = 11
chestTeleportBtn.Font = Enum.Font.GothamBold
chestTeleportBtn.AutoButtonColor = false
local chestBtnCorner = Instance.new("UICorner")
chestBtnCorner.CornerRadius = UDim.new(0, 6)
chestBtnCorner.Parent = chestTeleportBtn
chestTeleportBtn.Parent = page1

chestTeleportBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local chests = getChestStatus()
    if #chests == 0 then return end
    if chestTeleportIndex > #chests then chestTeleportIndex = 1 end
    local chest = chests[chestTeleportIndex]
    if chest then
        myRoot.CFrame = CFrame.new(chest.Position + Vector3.new(0, 3, 0))
        chestTeleportBtn.Text = string.format("传送到宝箱 %d / %d", chestTeleportIndex, #chests)
        chestTeleportIndex = chestTeleportIndex + 1
    end
end)

local page2, _ = createPage(200)

createToggle(page2, "全亮 + 除雾", 8, function(state)
    if state then enableFullBright() else disableFullBright() end
end)

createToggle(page2, "快速交互", 50, function(state)
    instantInteract = state
    if state then setPromptInstant() end
end)

createSubLabel(page2, "🏃 移动设置", 94)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 90, 0, 24)
speedLabel.Position = UDim2.new(0, 5, 0, 112)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "移速:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = page2

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 0, 24)
speedBox.Position = UDim2.new(0, 60, 0, 112)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
speedBox.BorderSizePixel = 0
speedBox.Text = "16"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 11
speedBox.Font = Enum.Font.Gotham
speedBox.ClearTextOnFocus = false
local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 5)
speedBoxCorner.Parent = speedBox
speedBox.Parent = page2

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0, 60, 0, 24)
applySpeedBtn.Position = UDim2.new(0, 150, 0, 112)
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applySpeedBtn.Text = "应用"
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.TextSize = 10
applySpeedBtn.Font = Enum.Font.GothamBold
applySpeedBtn.AutoButtonColor = false
local applySpeedCorner = Instance.new("UICorner")
applySpeedCorner.CornerRadius = UDim.new(0, 5)
applySpeedCorner.Parent = applySpeedBtn
applySpeedBtn.Parent = page2

applySpeedBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local speed = tonumber(speedBox.Text) or 16
    humanoid.WalkSpeed = speed
end)

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 90, 0, 24)
jumpLabel.Position = UDim2.new(0, 5, 0, 144)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "跳跃力:"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
jumpLabel.TextSize = 11
jumpLabel.Font = Enum.Font.GothamMedium
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = page2

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 80, 0, 24)
jumpBox.Position = UDim2.new(0, 60, 0, 144)
jumpBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
jumpBox.BorderSizePixel = 0
jumpBox.Text = "50"
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.TextSize = 11
jumpBox.Font = Enum.Font.Gotham
jumpBox.ClearTextOnFocus = false
local jumpBoxCorner = Instance.new("UICorner")
jumpBoxCorner.CornerRadius = UDim.new(0, 5)
jumpBoxCorner.Parent = jumpBox
jumpBox.Parent = page2

local applyJumpBtn = Instance.new("TextButton")
applyJumpBtn.Size = UDim2.new(0, 60, 0, 24)
applyJumpBtn.Position = UDim2.new(0, 150, 0, 144)
applyJumpBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applyJumpBtn.Text = "应用"
applyJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyJumpBtn.TextSize = 10
applyJumpBtn.Font = Enum.Font.GothamBold
applyJumpBtn.AutoButtonColor = false
local applyJumpCorner = Instance.new("UICorner")
applyJumpCorner.CornerRadius = UDim.new(0, 5)
applyJumpCorner.Parent = applyJumpBtn
applyJumpBtn.Parent = page2

applyJumpBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local jump = tonumber(jumpBox.Text) or 50
    humanoid.JumpPower = jump
end)

local page3, _ = createPage(280)

for i, loc in ipairs(TELEPORT_LOCATIONS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 290, 0, 36)
    btn.Position = UDim2.new(0, 5, 0, 8 + (i - 1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    btn.Text = "📍 " .. loc.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.Parent = page3

    btn.MouseButton1Click:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end
        local myRoot = character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        myRoot.CFrame = CFrame.new(loc.Pos + Vector3.new(0, 3, 0))
    end)
end

local page4, _ = createPage(280)

local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(0, 290, 0, 140)
scriptBox.Position = UDim2.new(0, 5, 0, 8)
scriptBox.BackgroundColor3 = Color3.fromRGB(20, 18, 25)
scriptBox.BorderSizePixel = 0
scriptBox.Text = ""
scriptBox.PlaceholderText = "粘贴要一直运行的脚本..."
scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
scriptBox.TextSize = 11
scriptBox.Font = Enum.Font.Code
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
local scriptBoxCorner = Instance.new("UICorner")
scriptBoxCorner.CornerRadius = UDim.new(0, 6)
scriptBoxCorner.Parent = scriptBox
scriptBox.Parent = page4

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(0, 140, 0, 20)
intervalLabel.Position = UDim2.new(0, 5, 0, 156)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "间隔 (秒):"
intervalLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
intervalLabel.TextSize = 11
intervalLabel.Font = Enum.Font.GothamMedium
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = page4

local intervalBox = Instance.new("TextBox")
intervalBox.Size = UDim2.new(0, 100, 0, 24)
intervalBox.Position = UDim2.new(0, 140, 0, 154)
intervalBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
intervalBox.BorderSizePixel = 0
intervalBox.Text = "0.1"
intervalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalBox.TextSize = 11
intervalBox.Font = Enum.Font.Gotham
intervalBox.ClearTextOnFocus = false
local intervalBoxCorner = Instance.new("UICorner")
intervalBoxCorner.CornerRadius = UDim.new(0, 5)
intervalBoxCorner.Parent = intervalBox
intervalBox.Parent = page4

local runScriptBtn = Instance.new("TextButton")
runScriptBtn.Size = UDim2.new(0, 145, 0, 32)
runScriptBtn.Position = UDim2.new(0, 5, 0, 188)
runScriptBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
runScriptBtn.Text = "▶ 滥用"
runScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runScriptBtn.TextSize = 12
runScriptBtn.Font = Enum.Font.GothamBold
runScriptBtn.AutoButtonColor = false
local runScriptCorner = Instance.new("UICorner")
runScriptCorner.CornerRadius = UDim.new(0, 6)
runScriptCorner.Parent = runScriptBtn
runScriptBtn.Parent = page4

local stopScriptBtn = Instance.new("TextButton")
stopScriptBtn.Size = UDim2.new(0, 140, 0, 32)
stopScriptBtn.Position = UDim2.new(0, 155, 0, 188)
stopScriptBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
stopScriptBtn.Text = "⏹ 停止"
stopScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopScriptBtn.TextSize = 12
stopScriptBtn.Font = Enum.Font.GothamBold
stopScriptBtn.AutoButtonColor = false
local stopScriptCorner = Instance.new("UICorner")
stopScriptCorner.CornerRadius = UDim.new(0, 6)
stopScriptCorner.Parent = stopScriptBtn
stopScriptBtn.Parent = page4

local scriptStatus = Instance.new("TextLabel")
scriptStatus.Size = UDim2.new(1, -10, 0, 18)
scriptStatus.Position = UDim2.new(0, 5, 0, 224)
scriptStatus.BackgroundTransparency = 1
scriptStatus.Text = "未运行"
scriptStatus.TextColor3 = Color3.fromRGB(150, 150, 155)
scriptStatus.TextSize = 10
scriptStatus.Font = Enum.Font.Gotham
scriptStatus.TextXAlignment = Enum.TextXAlignment.Left
scriptStatus.Parent = page4

runScriptBtn.MouseButton1Click:Connect(function()
    if remoteScriptRunning then return end
    local code = scriptBox.Text
    if code == "" then
        scriptStatus.Text = "❌ 请输入脚本"
        scriptStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    local interval = tonumber(intervalBox.Text) or 0.1
    interval = math.clamp(interval, 0.01, 60)

    remoteScriptRunning = true
    scriptStatus.Text = string.format("✅ 运行中 (间隔 %.2fs)", interval)
    scriptStatus.TextColor3 = Color3.fromRGB(100, 255, 100)

    remoteScriptThread = task.spawn(function()
        local fn, err = loadstring(code)
        if not fn then
            scriptStatus.Text = "❌ 语法错误: " .. tostring(err)
            scriptStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            remoteScriptRunning = false
            return
        end

        while remoteScriptRunning do
            local success, execErr = pcall(fn)
            if not success then
                scriptStatus.Text = "❌ 运行出错: " .. tostring(execErr)
                scriptStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                remoteScriptRunning = false
                return
            end
            task.wait(interval)
        end
    end)
end)

stopScriptBtn.MouseButton1Click:Connect(function()
    remoteScriptRunning = false
    if remoteScriptThread then
        pcall(function() task.cancel(remoteScriptThread) end)
        remoteScriptThread = nil
    end
    scriptStatus.Text = "已停止"
    scriptStatus.TextColor3 = Color3.fromRGB(150, 150, 155)
end)

createNavButton("万圣\n节", 8, function() switchPage(1) end)
createNavButton("通用", 56, function() switchPage(2) end)
createNavButton("传送", 104, function() switchPage(3) end)
createNavButton("Remote\n滥用", 152, function() switchPage(4) end)

switchPage(1)

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 140, 0, 36)
miniFrame.Position = UDim2.new(0.5, -70, 0.5, -18)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
miniFrame.Text = "🗡️KsV4 UI"
miniFrame.TextColor3 = Color3.fromRGB(255, 150, 50)
miniFrame.TextSize = 12
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