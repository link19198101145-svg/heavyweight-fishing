local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local instantInteract = false
local graveMode = false
local candyAutoMode = false
local removeLoadingPopup = false
local remoteScriptRunning = false
local remoteScriptThread = nil
local initDone = false
local initRunning = false
local initIndex = 1
local lastInitTeleport = 0
local lastTeleport = 0
local lastPrompt = 0
local lastCandyTeleport = 0
local lastScreenClick = 0
local currentGrave = nil
local chestTeleportIndex = 1
local originalLighting = nil
local fullBrightEnabled = false
local npcPullEnabled = false
local npcPullRadius = math.huge
local npcPullFront = 5
local npcPullInterval = 0.1
local npcPullConnection = nil
local lastNpcPull = 0
local npcInitDone = false
local npcInitRunning = false
local npcInitIndex = 1
local lastNpcInitTeleport = 0

local autoSugarMode = false
local pickedThisLife = false
local lockedTarget, lockedPrompt = nil, nil
local lastSugarPrompt = nil
local HAUNTED_POS = Vector3.new(6920, 4618, -3267)
local PLACE_POS = Vector3.new(6816, 4618, -3611)
local sugarCandidates = {}

local autoLBMode = false
local lbInitDone = false
local lbInitRunning = false
local lbInitIndex = 1
local lastLbInitTeleport = 0
local lbCandidates = {}

local LB_INIT_POINTS = {
    Vector3.new(9805, 4616, -4567),
    Vector3.new(9905, 4618, -4733),
    Vector3.new(9930, 4618, -4616),
    Vector3.new(8857, 4626, -5611),
    Vector3.new(8906, 4627, -5432),
    Vector3.new(10623, 3823, -6037),
    Vector3.new(10662, 3823, -6046),
    Vector3.new(10666, 3823, -6000),
    Vector3.new(10763, 3823, -6232),
    Vector3.new(10283, 4137, -6389),
    Vector3.new(10096, 4618, -4758),
    Vector3.new(9988, 4618, -4834),
    Vector3.new(9631, 4629, -5499),
    Vector3.new(9541, 4622, -4976),
    Vector3.new(9187, 4625, -3874),
    Vector3.new(8942, 4621, -3948),
    Vector3.new(9181, 4619, -3912),
    Vector3.new(8828, 4625, -3826),
    Vector3.new(9292, 4627, -3640),
    Vector3.new(8552, 4622, -3589),
    Vector3.new(8222, 4625, -4629),
    Vector3.new(9030, 4621, -6096),
    Vector3.new(9352, 4615, -6515),
    Vector3.new(9670, 4633, -6625),
    Vector3.new(9936, 4618, -6316),
    Vector3.new(10048, 4557, -6481),
    Vector3.new(10698, 4632, -6385),
    Vector3.new(10651, 4633, -5523),
    Vector3.new(12186, 4634, -4648),
    Vector3.new(6023, 4234, -3012),
    Vector3.new(10469, 4616, -4359),
    Vector3.new(9478, 4628, -3604),
    Vector3.new(9700, 4636, -3881),
    Vector3.new(10048, 4139, -6558)
}

local NPC_INIT_POINTS = {
    Vector3.new(6121, 4237, -2985),
    Vector3.new(7293, 5660, -1939),
    Vector3.new(11175, 4636, -6352),
    Vector3.new(12044, 4631, -4397),
    Vector3.new(10007, 4621, -4750),
    Vector3.new(10765, 3826, -6070),
    Vector3.new(8504, 4625, -4897),
    Vector3.new(9274, 4629, -4996),
    Vector3.new(9055, 4631, -5744),
}

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

local function clickifyPrompt(p)
    pcall(function()
        p.HoldDuration = 0
        p.RequiresLineOfSight = false
    end)
end

local function firePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    clickifyPrompt(prompt)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin(LocalPlayer)
            prompt:InputHoldEnd(LocalPlayer)
        end
    end)
end

local function clickScreenCenter()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local centerX = viewport.X / 2
    local centerY = viewport.Y / 2
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
end

local function clickScreenRight()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local rightX = viewport.X * 0.85
    local centerY = viewport.Y / 2
    VirtualInputManager:SendMouseButtonEvent(rightX, centerY, 0, true, game, 0)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(rightX, centerY, 0, false, game, 0)
end

local function EquipAllItems()
    local character = LocalPlayer.Character
    if not character then return end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            pcall(function()
                item.Parent = character
            end)
        end
    end
end

local function useAllCandies()
    local character = LocalPlayer.Character
    if not character then return end

    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Candy" then
            pcall(function()
                item:Activate()
            end)
        end
    end
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
            clickifyPrompt(obj)
        end
    end
end

local function disableLoadingPopup()
    pcall(function()
        if GuiService.SetGameplayPausedNotificationEnabled then
            GuiService:SetGameplayPausedNotificationEnabled(false)
        end
    end)
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

local function findNearestLB()
    local character = LocalPlayer.Character
    if not character then return nil end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local best = nil
    local bestDist = math.huge

    for part, prompt in pairs(lbCandidates) do
        if part and part.Parent then
            local dist = (part.Position - myRoot.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                best = {Prompt = prompt, Part = part, Position = part.Position}
            end
        end
    end
    return best
end

local function pullNearbyNpcs()
    local character = LocalPlayer.Character
    if not character then return end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local npcFolder = Workspace:FindFirstChild("NPC")
    if not npcFolder then return end

    local myPos = myRoot.Position
    local forward = myRoot.CFrame.LookVector
    local targetPos = myPos + forward * npcPullFront

    for _, group in ipairs(npcFolder:GetChildren()) do
        if group:IsA("Folder") or group:IsA("Model") then
            for _, npc in ipairs(group:GetChildren()) do
                if npc:IsA("Model") then
                    local humanoid = npc:FindFirstChild("Humanoid")
                    local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc:FindFirstChildWhichIsA("BasePart")
                    if npcRoot and humanoid and humanoid.Health > 0 then
                        local dist = (npcRoot.Position - myPos).Magnitude
                        if dist <= npcPullRadius then
                            pcall(function()
                                if npc.PrimaryPart then
                                    npc:PivotTo(CFrame.new(targetPos))
                                else
                                    npcRoot.CFrame = CFrame.new(targetPos)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end

local function cleanRagdolls()
    local npcFolder = Workspace:FindFirstChild("NPC")
    if not npcFolder then return end

    for _, group in ipairs(npcFolder:GetChildren()) do
        if group:IsA("Folder") or group:IsA("Model") then
            for _, npc in ipairs(group:GetChildren()) do
                if npc:IsA("Model") then
                    local humanoid = npc:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        pcall(function()
                            npc:Destroy()
                        end)
                    end
                end
            end
        end
    end
end

local function startNpcPullLoop()
    if npcPullConnection then return end
    npcPullConnection = RunService.RenderStepped:Connect(function()
        if not npcPullEnabled then return end
        local now = tick()
        if now - lastNpcPull < npcPullInterval then return end
        lastNpcPull = now
        pullNearbyNpcs()
        cleanRagdolls()
    end)
end

local function stopNpcPullLoop()
    if npcPullConnection then
        npcPullConnection:Disconnect()
        npcPullConnection = nil
    end
end

local function registerIfBewitched(d)
    if d:IsA("BasePart") and d.Name:lower():find("bewitchedenergy", 1, true) then
        local prompt = d:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            clickifyPrompt(prompt)
            sugarCandidates[d] = prompt
        end
    end
end

local function watchMeteorRoot(root)
    for _, d in ipairs(root:GetDescendants()) do
        registerIfBewitched(d)
    end
    root.DescendantAdded:Connect(registerIfBewitched)
end

local meteorRoot = Workspace:FindFirstChild("MeteorResidue")
if meteorRoot then watchMeteorRoot(meteorRoot) end
Workspace.ChildAdded:Connect(function(c)
    if c.Name == "MeteorResidue" then
        watchMeteorRoot(c)
    end
end)

local function registerLB(d)
    if d:IsA("BasePart") and (d.Name:lower():find("lbbottle", 1, true) or d.Name:lower():find("lbchest", 1, true)) then
        local prompt = d:FindFirstChildOfClass("ProximityPrompt")
        if not prompt and d:FindFirstChild("hitbox") then
            prompt = d.hitbox:FindFirstChild("Proximity")
        end
        if prompt then
            clickifyPrompt(prompt)
            lbCandidates[d] = prompt
        end
    end
end

local function watchLBRoot(root)
    for _, d in ipairs(root:GetDescendants()) do
        registerLB(d)
    end
    root.DescendantAdded:Connect(registerLB)
end

local lbRoot = Workspace:FindFirstChild("OthersSpecialEvents") and Workspace.OthersSpecialEvents:FindFirstChild("LBSearch")
if lbRoot then watchLBRoot(lbRoot) end
Workspace.ChildAdded:Connect(function(c)
    if c.Name == "OthersSpecialEvents" then
        local lb = c:FindFirstChild("LBSearch")
        if lb then watchLBRoot(lb) end
    end
end)

local function cleanCandidates()
    for part in pairs(sugarCandidates) do
        if not part:IsDescendantOf(Workspace) then
            sugarCandidates[part] = nil
        end
    end
    for part in pairs(lbCandidates) do
        if not part:IsDescendantOf(Workspace) then
            lbCandidates[part] = nil
        end
    end
end

local function fireShopEvents()
    local ok, shop = pcall(function()
        return ReplicatedStorage:WaitForChild("HalloweenShopEvents", 5):WaitForChild("ShopEvents")
    end)
    if not ok or not shop then return end
    local lamp = shop:FindFirstChild("Lamp")
    if lamp then pcall(function() lamp:FireServer() end) end
    local cauldron = shop:FindFirstChild("Cauldron")
    if cauldron then pcall(function() cauldron:FireServer() end) end
end

local function equipToolByKeywords(keywords)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not hum or not backpack then return false end

    local function match(name)
        name = name:lower()
        for _, kw in ipairs(keywords) do
            if name:find(kw:lower(), 1, true) then return true end
        end
        return false
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and match(tool.Name) then
            pcall(function() hum:EquipTool(tool) end)
            return tool
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and match(tool.Name) then
            return tool
        end
    end
    return false
end

local function triggerPromptByAttachmentName(attName)
    local cauldron = workspace:FindFirstChild("PlaceWorkTables") and workspace.PlaceWorkTables:FindFirstChild("Cauldron")
    if not cauldron then return false end
    local mainPart = cauldron:FindFirstChild("Main")
    if not mainPart then return false end
    local att = mainPart:FindFirstChild(attName)
    if not att then return false end
    local prompt = att:FindFirstChildOfClass("ProximityPrompt")
    if not prompt or not prompt.Enabled then return false end
    firePrompt(prompt)
    return true
end

local function claimCauldron()
    task.wait(0.8)
    local tool = equipToolByKeywords({"cauldron"})
    if not tool then return false end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(PLACE_POS) end
    task.wait(5)
    clickScreenCenter()
    task.wait(0.5)
    pcall(function() tool:Activate() end)
    task.wait(1.5)
    local cauldron = workspace:FindFirstChild("PlaceWorkTables") and workspace.PlaceWorkTables:FindFirstChild("Cauldron")
    if cauldron then
        for _, d in ipairs(cauldron:GetDescendants()) do
            if d.Name == "ClaimProximity" and d:IsA("ProximityPrompt") and d.Enabled then
                firePrompt(d)
                break
            end
        end
    end
    task.wait(1)
    return true
end

local function postClaimActions()
    task.wait(1)
    for _ = 1, 5 do
        if equipToolByKeywords({"lamp"}) then break end
        task.wait(0.3)
    end
    task.wait(0.5)
    triggerPromptByAttachmentName("Throw")
    task.wait(0.5)

    for _ = 1, 5 do
        if equipToolByKeywords({"bewitched", "energy"}) then break end
        task.wait(0.3)
    end
    task.wait(0.5)
    triggerPromptByAttachmentName("Throw")
    task.wait(0.5)
    triggerPromptByAttachmentName("Get")
end

local function isCandyName(n)
    n = n:lower()
    return n:find("candy", 1, true) or n:find("chocolate", 1, true) or n:find("lollipop", 1, true) or n:find("sweet", 1, true) or n:find("treat", 1, true)
end

local function eatAllCandies()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not hum then return end
    
    local candiesToEat = {}
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and isCandyName(tool.Name) then
            table.insert(candiesToEat, tool)
        end
    end
    
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and isCandyName(tool.Name) then
                table.insert(candiesToEat, tool)
            end
        end
    end
    
    if #candiesToEat == 0 then return end
    
    task.spawn(function()
        for _, candy in ipairs(candiesToEat) do
            if candy and candy.Parent then
                pcall(function() 
                    candy.Parent = char 
                end)
                task.wait(0.4)
                clickScreenRight()
                task.wait(0.2)
                pcall(function() candy:Activate() end)
                task.wait(0.3)
            end
        end
        
        if autoSugarMode then
            task.wait(0.2)
            equipToolByKeywords({"haunted"})
        end
    end)
end

local function watchCandyTools()
    local function checkAdded(parent)
        if not parent then return end
        -- 【关键修改】：只有开启了提灯刷糖模式，才自动吃并点击屏幕
        if autoSugarMode and parent:IsA("Tool") and isCandyName(parent.Name) then
            eatAllCandies()
        end
    end
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if char then
        char.ChildAdded:Connect(checkAdded)
    end
    if backpack then
        backpack.ChildAdded:Connect(checkAdded)
    end
    LocalPlayer.CharacterAdded:Connect(function(c)
        c.ChildAdded:Connect(checkAdded)
    end)
end
watchCandyTools()

local function hauntedLampPhase()
    task.wait(0.5)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(HAUNTED_POS) end
    task.wait(1)
    for _ = 1, 10 do
        if equipToolByKeywords({"haunted"}) then break end
        task.wait(0.3)
    end
    task.wait(1)

    task.spawn(function()
        while autoSugarMode do
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h then
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then
                        local parent = d.Parent
                        if parent and parent:IsA("BasePart") then
                            if (parent.Position - h.Position).Magnitude <= 30 then
                                firePrompt(d)
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

Workspace.DescendantAdded:Connect(function(obj)
    if instantInteract and obj:IsA("ProximityPrompt") then
        clickifyPrompt(obj)
    end
end)

local function resetLife()
    pickedThisLife = false
    lockedTarget, lockedPrompt = nil, nil
    lastSugarPrompt = nil
end
LocalPlayer.CharacterAdded:Connect(resetLife)
if LocalPlayer.Character then resetLife() end

RunService.RenderStepped:Connect(function()
    local now = tick()

    if autoSugarMode then
        if not pickedThisLife then
            if not lockedTarget or not lockedTarget:IsDescendantOf(Workspace) then
                cleanCandidates()
                lockedTarget, lockedPrompt = nil, nil
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bestDist = math.huge
                    for part, prompt in pairs(sugarCandidates) do
                        local d = (part.Position - hrp.Position).Magnitude
                        if d < bestDist then
                            bestDist = d
                            lockedTarget, lockedPrompt = part, prompt
                        end
                    end
                else
                    for part, prompt in pairs(sugarCandidates) do
                        lockedTarget, lockedPrompt = part, prompt
                        break
                    end
                end
            end

            local target, prompt = lockedTarget, lockedPrompt
            if target and prompt then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
                    if prompt ~= lastSugarPrompt then
                        lastSugarPrompt = prompt
                        clickifyPrompt(prompt)
                    end
                    
                    pickedThisLife = true
                    sugarCandidates[target] = nil
                    
                    task.spawn(function()
                        task.wait(3)
                        firePrompt(prompt)
                        
                        task.wait(1)
                        fireShopEvents()
                        task.wait(1)
                        if claimCauldron() then
                            postClaimActions()
                            if autoSugarMode then hauntedLampPhase() end
                        end
                    end)
                end
            end
        end
        return
    end

    if autoLBMode then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lb = findNearestLB()
            if lb then
                if now - lastTeleport >= 0.3 then
                    lastTeleport = now
                    hrp.CFrame = CFrame.new(lb.Position + Vector3.new(0, 3, 0))
                    if now - lastPrompt >= 0.1 then
                        lastPrompt = now
                        firePrompt(lb.Prompt)
                    end
                    return
                end
            end
        end
    end

    local character = LocalPlayer.Character
    if not character then return end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    if npcInitRunning then
        if now - lastNpcInitTeleport >= 0.25 then
            lastNpcInitTeleport = now
            if npcInitIndex > #NPC_INIT_POINTS then
                npcInitDone = true
                npcInitRunning = false
                npcInitIndex = 1
                if npcInitBtn then
                    npcInitBtn.Text = "✅ NPC已加载"
                    npcInitBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                end
                return
            end
            local target = NPC_INIT_POINTS[npcInitIndex]
            myRoot.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
            npcInitIndex = npcInitIndex + 1
        end
        return
    end

    if lbInitRunning then
        if now - lastLbInitTeleport >= 0.25 then
            lastLbInitTeleport = now
            if lbInitIndex > #LB_INIT_POINTS then
                lbInitDone = true
                lbInitRunning = false
                lbInitIndex = 1
                if lbInitBtn then
                    lbInitBtn.Text = "✅ LB已初始化"
                    lbInitBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                end
                return
            end
            local target = LB_INIT_POINTS[lbInitIndex]
            myRoot.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
            lbInitIndex = lbInitIndex + 1
        end
        return
    end

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
        EquipAllItems()
        useAllCandies()
        if now - lastScreenClick >= 0.1 then
            lastScreenClick = now
            task.spawn(clickScreenCenter)
        end
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
        EquipAllItems()
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
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
    stopNpcPullLoop()
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
    return row
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

local page1, _ = createPage(260)

local initBtn = Instance.new("TextButton")
initBtn.Size = UDim2.new(0, 290, 0, 30)
initBtn.Position = UDim2.new(0, 5, 0, 5)
initBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
initBtn.Text = "🔄 初始化糖果和宝箱"
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

createSubLabel(page1, "🍭 糖果(先初始化)(底下两个选项只能开一个)", 40)

local rowCandyAuto = createToggle(page1, "自动捡糖", 58, function(state)
    candyAutoMode = state
    if state then
        rowSugarAuto.Visible = false
    else
        rowSugarAuto.Visible = false
    end
end)

local rowSugarAuto = createToggle(page1, "提灯刷糖(开启后等待陨石降落)", 96, function(state)
    autoSugarMode = state
    if state then
        rowCandyAuto.Visible = false
    else
        rowCandyAuto.Visible = false
    end
end)

createSubLabel(page1, "🔑钥匙和宝箱📦", 130)

createToggle(page1, "自动挖钥匙", 148, function(state)
    graveMode = state
    if not state then currentGrave = nil end
end)

local chestTeleportBtn = Instance.new("TextButton")
chestTeleportBtn.Size = UDim2.new(0, 290, 0, 30)
chestTeleportBtn.Position = UDim2.new(0, 5, 0, 188)
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

local page2, _ = createPage(450)

createToggle(page2, "全亮 + 除雾", 8, function(state)
    if state then enableFullBright() else disableFullBright() end
end)

createToggle(page2, "快速交互", 50, function(state)
    instantInteract = state
    if state then setPromptInstant() end
end)

createToggle(page2, "移除加载弹窗", 92, function(state)
    removeLoadingPopup = state
    if state then
        disableLoadingPopup()
    end
end)

createSubLabel(page2, "LB相关", 130)

local lbInitBtn = Instance.new("TextButton")
lbInitBtn.Size = UDim2.new(0, 290, 0, 30)
lbInitBtn.Position = UDim2.new(0, 5, 0, 148)
lbInitBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
lbInitBtn.Text = "🔄 初始化LB药水"
lbInitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lbInitBtn.TextSize = 11
lbInitBtn.Font = Enum.Font.GothamBold
lbInitBtn.AutoButtonColor = false
local lbInitBtnCorner = Instance.new("UICorner")
lbInitBtnCorner.CornerRadius = UDim.new(0, 6)
lbInitBtnCorner.Parent = lbInitBtn
lbInitBtn.Parent = page2

lbInitBtn.MouseButton1Click:Connect(function()
    if lbInitDone then
        lbInitBtn.Text = "✅LB药水已初始化"
        return
    end
    lbInitRunning = true
    lbInitIndex = 1
    lastLbInitTeleport = 0
    lbInitBtn.Text = "⏳ LB药水初始化中..."
    lbInitBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

createToggle(page2, "自动捡LB药水", 186, function(state)
    autoLBMode = state
end)

createSubLabel(page2, "🏃 移动设置", 230)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 90, 0, 24)
speedLabel.Position = UDim2.new(0, 5, 0, 248)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "移速:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = page2

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 0, 24)
speedBox.Position = UDim2.new(0, 60, 0, 248)
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
applySpeedBtn.Position = UDim2.new(0, 150, 0, 248)
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
jumpLabel.Position = UDim2.new(0, 5, 0, 280)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "跳跃力:"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
jumpLabel.TextSize = 11
jumpLabel.Font = Enum.Font.GothamMedium
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = page2

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 80, 0, 24)
jumpBox.Position = UDim2.new(0, 60, 0, 280)
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
applyJumpBtn.Position = UDim2.new(0, 150, 0, 280)
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

createSubLabel(page2, "👊 NPC 抓取", 316)

local npcInitBtn = Instance.new("TextButton")
npcInitBtn.Size = UDim2.new(0, 290, 0, 28)
npcInitBtn.Position = UDim2.new(0, 5, 0, 334)
npcInitBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 40)
npcInitBtn.Text = "🔄 初始化NPC"
npcInitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
npcInitBtn.TextSize = 11
npcInitBtn.Font = Enum.Font.GothamBold
npcInitBtn.AutoButtonColor = false
local npcInitBtnCorner = Instance.new("UICorner")
npcInitBtnCorner.CornerRadius = UDim.new(0, 6)
npcInitBtnCorner.Parent = npcInitBtn
npcInitBtn.Parent = page2

npcInitBtn.MouseButton1Click:Connect(function()
    if npcInitDone then
        npcInitBtn.Text = "✅ NPC已加载"
        return
    end
    npcInitRunning = true
    npcInitIndex = 1
    lastNpcInitTeleport = 0
    npcInitBtn.Text = "⏳ NPC加载中..."
    npcInitBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

createToggle(page2, "抓取附近NPC", 370, function(state)
    npcPullEnabled = state
    if state then
        startNpcPullLoop()
    else
        stopNpcPullLoop()
    end
end)

local pullRadiusLabel = Instance.new("TextLabel")
pullRadiusLabel.Size = UDim2.new(0, 90, 0, 24)
pullRadiusLabel.Position = UDim2.new(0, 5, 0, 406)
pullRadiusLabel.BackgroundTransparency = 1
pullRadiusLabel.Text = "抓取半径:"
pullRadiusLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
pullRadiusLabel.TextSize = 11
pullRadiusLabel.Font = Enum.Font.GothamMedium
pullRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
pullRadiusLabel.Parent = page2

local pullRadiusBox = Instance.new("TextBox")
pullRadiusBox.Size = UDim2.new(0, 70, 0, 24)
pullRadiusBox.Position = UDim2.new(0, 80, 0, 406)
pullRadiusBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
pullRadiusBox.BorderSizePixel = 0
pullRadiusBox.Text = "∞"
pullRadiusBox.TextColor3 = Color3.fromRGB(255, 255, 255)
pullRadiusBox.TextSize = 11
pullRadiusBox.Font = Enum.Font.Gotham
pullRadiusBox.ClearTextOnFocus = false
local pullRadiusCorner = Instance.new("UICorner")
pullRadiusCorner.CornerRadius = UDim.new(0, 5)
pullRadiusCorner.Parent = pullRadiusBox
pullRadiusBox.Parent = page2

local frontLabel = Instance.new("TextLabel")
frontLabel.Size = UDim2.new(0, 70, 0, 24)
frontLabel.Position = UDim2.new(0, 155, 0, 406)
frontLabel.BackgroundTransparency = 1
frontLabel.Text = "前方:"
frontLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
frontLabel.TextSize = 11
frontLabel.Font = Enum.Font.GothamMedium
frontLabel.TextXAlignment = Enum.TextXAlignment.Left
frontLabel.Parent = page2

local frontBox = Instance.new("TextBox")
frontBox.Size = UDim2.new(0, 50, 0, 24)
frontBox.Position = UDim2.new(0, 200, 0, 406)
frontBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
frontBox.BorderSizePixel = 0
frontBox.Text = "5"
frontBox.TextColor3 = Color3.fromRGB(255, 255, 255)
frontBox.TextSize = 11
frontBox.Font = Enum.Font.Gotham
frontBox.ClearTextOnFocus = false
local frontBoxCorner = Instance.new("UICorner")
frontBoxCorner.CornerRadius = UDim.new(0, 5)
frontBoxCorner.Parent = frontBox
frontBox.Parent = page2

local intervalLabel2 = Instance.new("TextLabel")
intervalLabel2.Size = UDim2.new(0, 90, 0, 24)
intervalLabel2.Position = UDim2.new(0, 5, 0, 436)
intervalLabel2.BackgroundTransparency = 1
intervalLabel2.Text = "抓取间隔:"
intervalLabel2.TextColor3 = Color3.fromRGB(200, 200, 205)
intervalLabel2.TextSize = 11
intervalLabel2.Font = Enum.Font.GothamMedium
intervalLabel2.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel2.Parent = page2

local intervalBox2 = Instance.new("TextBox")
intervalBox2.Size = UDim2.new(0, 70, 0, 24)
intervalBox2.Position = UDim2.new(0, 80, 0, 436)
intervalBox2.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
intervalBox2.BorderSizePixel = 0
intervalBox2.Text = "0.1"
intervalBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalBox2.TextSize = 11
intervalBox2.Font = Enum.Font.Gotham
intervalBox2.ClearTextOnFocus = false
local intervalBox2Corner = Instance.new("UICorner")
intervalBox2Corner.CornerRadius = UDim.new(0, 5)
intervalBox2Corner.Parent = intervalBox2
intervalBox2.Parent = page2

local applyPullBtn = Instance.new("TextButton")
applyPullBtn.Size = UDim2.new(0, 60, 0, 24)
applyPullBtn.Position = UDim2.new(0, 235, 0, 436)
applyPullBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
applyPullBtn.Text = "应用"
applyPullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyPullBtn.TextSize = 10
applyPullBtn.Font = Enum.Font.GothamBold
applyPullBtn.AutoButtonColor = false
local applyPullCorner = Instance.new("UICorner")
applyPullCorner.CornerRadius = UDim.new(0, 5)
applyPullCorner.Parent = applyPullBtn
applyPullBtn.Parent = page2

applyPullBtn.MouseButton1Click:Connect(function()
    local r = tonumber(pullRadiusBox.Text)
    if r and r > 0 then
        npcPullRadius = r
    else
        npcPullRadius = math.huge
    end
    npcPullFront = math.clamp(tonumber(frontBox.Text) or 5, 1, 100)
    npcPullInterval = math.clamp(tonumber(intervalBox2.Text) or 0.1, 0.01, 10)
    pullRadiusBox.Text = npcPullRadius == math.huge and "∞" or tostring(npcPullRadius)
    frontBox.Text = tostring(npcPullFront)
    intervalBox2.Text = tostring(npcPullInterval)
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
