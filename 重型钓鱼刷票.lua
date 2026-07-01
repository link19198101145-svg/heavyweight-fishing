local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

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
title.Text = "钓鱼功能🎣"
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

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 60, 1, -40)
navBar.Position = UDim2.new(0, 0, 0, 40)
navBar.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

local fishingNavBtn = Instance.new("TextButton")
fishingNavBtn.Size = UDim2.new(0, 50, 0, 50)
fishingNavBtn.Position = UDim2.new(0, 5, 0, 10)
fishingNavBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
fishingNavBtn.Text = "钓鱼"
fishingNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fishingNavBtn.TextSize = 11
fishingNavBtn.Font = Enum.Font.GothamBold
fishingNavBtn.AutoButtonColor = false
local fishingNavCorner = Instance.new("UICorner")
fishingNavCorner.CornerRadius = UDim.new(0, 8)
fishingNavCorner.Parent = fishingNavBtn
fishingNavBtn.Parent = navBar

local ticketNavBtn = Instance.new("TextButton")
ticketNavBtn.Size = UDim2.new(0, 50, 0, 50)
ticketNavBtn.Position = UDim2.new(0, 5, 0, 70)
ticketNavBtn.BackgroundColor3 = Color3.fromRGB(58, 58, 60)
ticketNavBtn.Text = "刷票"
ticketNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ticketNavBtn.TextSize = 11
ticketNavBtn.Font = Enum.Font.GothamBold
ticketNavBtn.AutoButtonColor = false
local ticketNavCorner = Instance.new("UICorner")
ticketNavCorner.CornerRadius = UDim.new(0, 8)
ticketNavCorner.Parent = ticketNavBtn
ticketNavBtn.Parent = navBar

local fishingPage = Instance.new("Frame")
fishingPage.Size = UDim2.new(1, -60, 1, -40)
fishingPage.Position = UDim2.new(0, 60, 0, 40)
fishingPage.BackgroundTransparency = 1
fishingPage.Visible = true
fishingPage.Parent = mainFrame

local anchorFrame = Instance.new("Frame")
anchorFrame.Size = UDim2.new(0, 260, 0, 30)
anchorFrame.Position = UDim2.new(0, 10, 0, 10)
anchorFrame.BackgroundTransparency = 1
anchorFrame.Parent = fishingPage

local anchorLabel = Instance.new("TextLabel")
anchorLabel.Size = UDim2.new(0, 120, 1, 0)
anchorLabel.BackgroundTransparency = 1
anchorLabel.Text = "钓鱼条锚定"
anchorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
anchorLabel.TextSize = 13
anchorLabel.Font = Enum.Font.Gotham
anchorLabel.TextXAlignment = Enum.TextXAlignment.Left
anchorLabel.Parent = anchorFrame

local anchorBtn = Instance.new("TextButton")
anchorBtn.Size = UDim2.new(0, 50, 0, 24)
anchorBtn.Position = UDim2.new(1, -50, 0.5, -12)
anchorBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
anchorBtn.Text = "关闭"
anchorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
anchorBtn.TextSize = 11
anchorBtn.Font = Enum.Font.GothamBold
anchorBtn.AutoButtonColor = false
local anchorCorner = Instance.new("UICorner")
anchorCorner.CornerRadius = UDim.new(0, 6)
anchorCorner.Parent = anchorBtn
anchorBtn.Parent = anchorFrame

getgenv().Honey_Anchor = false

anchorBtn.MouseButton1Click:Connect(function()
    getgenv().Honey_Anchor = not getgenv().Honey_Anchor
    anchorBtn.Text = getgenv().Honey_Anchor and "开启" or "关闭"
    anchorBtn.BackgroundColor3 = getgenv().Honey_Anchor and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
end)

local autoCastFrame = Instance.new("Frame")
autoCastFrame.Size = UDim2.new(0, 260, 0, 30)
autoCastFrame.Position = UDim2.new(0, 10, 0, 50)
autoCastFrame.BackgroundTransparency = 1
autoCastFrame.Parent = fishingPage

local autoCastLabel = Instance.new("TextLabel")
autoCastLabel.Size = UDim2.new(0, 120, 1, 0)
autoCastLabel.BackgroundTransparency = 1
autoCastLabel.Text = "自动抛竿"
autoCastLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
autoCastLabel.TextSize = 13
autoCastLabel.Font = Enum.Font.Gotham
autoCastLabel.TextXAlignment = Enum.TextXAlignment.Left
autoCastLabel.Parent = autoCastFrame

local autoCastBtn = Instance.new("TextButton")
autoCastBtn.Size = UDim2.new(0, 50, 0, 24)
autoCastBtn.Position = UDim2.new(1, -50, 0.5, -12)
autoCastBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoCastBtn.Text = "关闭"
autoCastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoCastBtn.TextSize = 11
autoCastBtn.Font = Enum.Font.GothamBold
autoCastBtn.AutoButtonColor = false
local autoCastCorner = Instance.new("UICorner")
autoCastCorner.CornerRadius = UDim.new(0, 6)
autoCastCorner.Parent = autoCastBtn
autoCastBtn.Parent = autoCastFrame

getgenv().Honey_AutoCast = false

autoCastBtn.MouseButton1Click:Connect(function()
    getgenv().Honey_AutoCast = not getgenv().Honey_AutoCast
    autoCastBtn.Text = getgenv().Honey_AutoCast and "开启" or "关闭"
    autoCastBtn.BackgroundColor3 = getgenv().Honey_AutoCast and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
end)

getgenv().Honey_AutoSkill = false
getgenv().Honey_Skills = {Z = true, X = true, C = true, V = true}

local skillToggleFrame = Instance.new("Frame")
skillToggleFrame.Size = UDim2.new(0, 260, 0, 30)
skillToggleFrame.Position = UDim2.new(0, 10, 0, 90)
skillToggleFrame.BackgroundTransparency = 1
skillToggleFrame.Parent = fishingPage

local skillToggleLabel = Instance.new("TextLabel")
skillToggleLabel.Size = UDim2.new(0, 120, 1, 0)
skillToggleLabel.BackgroundTransparency = 1
skillToggleLabel.Text = "自动技能(开启后无法手动抛竿)"
skillToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
skillToggleLabel.TextSize = 13
skillToggleLabel.Font = Enum.Font.Gotham
skillToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
skillToggleLabel.Parent = skillToggleFrame

local skillToggleBtn = Instance.new("TextButton")
skillToggleBtn.Size = UDim2.new(0, 50, 0, 24)
skillToggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
skillToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
skillToggleBtn.Text = "关闭"
skillToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
skillToggleBtn.TextSize = 11
skillToggleBtn.Font = Enum.Font.GothamBold
skillToggleBtn.AutoButtonColor = false
local skillToggleCorner = Instance.new("UICorner")
skillToggleCorner.CornerRadius = UDim.new(0, 6)
skillToggleCorner.Parent = skillToggleBtn
skillToggleBtn.Parent = skillToggleFrame

skillToggleBtn.MouseButton1Click:Connect(function()
    getgenv().Honey_AutoSkill = not getgenv().Honey_AutoSkill
    skillToggleBtn.Text = getgenv().Honey_AutoSkill and "开启" or "关闭"
    skillToggleBtn.BackgroundColor3 = getgenv().Honey_AutoSkill and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
end)

local skillKeys = {"Z", "X", "C", "V"}
local skillBtns = {}

local skillsRow = Instance.new("Frame")
skillsRow.Size = UDim2.new(0, 260, 0, 30)
skillsRow.Position = UDim2.new(0, 10, 0, 130)
skillsRow.BackgroundTransparency = 1
skillsRow.Parent = fishingPage

for i, key in ipairs(skillKeys) do
    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 56, 0, 28)
    skillBtn.Position = UDim2.new(0, (i-1)*68, 0, 0)
    skillBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
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
        getgenv().Honey_Skills[key] = not getgenv().Honey_Skills[key]
        skillBtn.BackgroundColor3 = getgenv().Honey_Skills[key] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
    end)

    skillBtns[key] = skillBtn
end

getgenv().Honey_AutoSell = false
getgenv().Honey_SellDelay = 5

local autoSellFrame = Instance.new("Frame")
autoSellFrame.Size = UDim2.new(0, 260, 0, 30)
autoSellFrame.Position = UDim2.new(0, 10, 0, 170)
autoSellFrame.BackgroundTransparency = 1
autoSellFrame.Parent = fishingPage

local autoSellLabel = Instance.new("TextLabel")
autoSellLabel.Size = UDim2.new(0, 120, 1, 0)
autoSellLabel.BackgroundTransparency = 1
autoSellLabel.Text = "自动售卖(可能不完善)"
autoSellLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
autoSellLabel.TextSize = 13
autoSellLabel.Font = Enum.Font.Gotham
autoSellLabel.TextXAlignment = Enum.TextXAlignment.Left
autoSellLabel.Parent = autoSellFrame

local autoSellBtn = Instance.new("TextButton")
autoSellBtn.Size = UDim2.new(0, 50, 0, 24)
autoSellBtn.Position = UDim2.new(1, -50, 0.5, -12)
autoSellBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoSellBtn.Text = "关闭"
autoSellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSellBtn.TextSize = 11
autoSellBtn.Font = Enum.Font.GothamBold
autoSellBtn.AutoButtonColor = false
local autoSellCorner = Instance.new("UICorner")
autoSellCorner.CornerRadius = UDim.new(0, 6)
autoSellCorner.Parent = autoSellBtn
autoSellBtn.Parent = autoSellFrame

autoSellBtn.MouseButton1Click:Connect(function()
    getgenv().Honey_AutoSell = not getgenv().Honey_AutoSell
    autoSellBtn.Text = getgenv().Honey_AutoSell and "开启" or "关闭"
    autoSellBtn.BackgroundColor3 = getgenv().Honey_AutoSell and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(60, 60, 60)
end)

local ticketPage = Instance.new("Frame")
ticketPage.Size = UDim2.new(1, -60, 1, -40)
ticketPage.Position = UDim2.new(0, 60, 0, 40)
ticketPage.BackgroundTransparency = 1
ticketPage.Visible = false
ticketPage.Parent = mainFrame

local editorRow = Instance.new("Frame")
editorRow.Size = UDim2.new(0, 260, 0, 30)
editorRow.Position = UDim2.new(0, 10, 0, 10)
editorRow.BackgroundTransparency = 1
editorRow.Parent = ticketPage

local editorLabel = Instance.new("TextLabel")
editorLabel.Size = UDim2.new(0, 120, 1, 0)
editorLabel.BackgroundTransparency = 1
editorLabel.Text = "数值修改器(客户端,防止刷太多录视频被封)"
editorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
editorLabel.TextSize = 13
editorLabel.Font = Enum.Font.Gotham
editorLabel.TextXAlignment = Enum.TextXAlignment.Left
editorLabel.Parent = editorRow

local editorOpenBtn = Instance.new("TextButton")
editorOpenBtn.Size = UDim2.new(0, 50, 0, 24)
editorOpenBtn.Position = UDim2.new(1, -50, 0.5, -12)
editorOpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
editorOpenBtn.Text = "打开"
editorOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
editorOpenBtn.TextSize = 11
editorOpenBtn.Font = Enum.Font.GothamBold
editorOpenBtn.AutoButtonColor = false
local editorOpenCorner = Instance.new("UICorner")
editorOpenCorner.CornerRadius = UDim.new(0, 6)
editorOpenCorner.Parent = editorOpenBtn
editorOpenBtn.Parent = editorRow

local editorFrame = Instance.new("Frame")
editorFrame.Size = UDim2.new(0, 200, 0, 130)
editorFrame.Position = UDim2.new(0.5, -100, 0.5, -65)
editorFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
editorFrame.BorderSizePixel = 0
editorFrame.Active = true
editorFrame.Draggable = true
editorFrame.Visible = false
editorFrame.Parent = screenGui

local editorCorner = Instance.new("UICorner")
editorCorner.CornerRadius = UDim.new(0, 8)
editorCorner.Parent = editorFrame

local editorTitle = Instance.new("TextLabel")
editorTitle.Size = UDim2.new(1, -40, 0, 25)
editorTitle.Position = UDim2.new(0, 10, 0, 8)
editorTitle.BackgroundTransparency = 1
editorTitle.Text = "数值修改器"
editorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
editorTitle.TextSize = 14
editorTitle.Font = Enum.Font.GothamBold
editorTitle.Parent = editorFrame

local editorClose = Instance.new("TextButton")
editorClose.Size = UDim2.new(0, 22, 0, 22)
editorClose.Position = UDim2.new(1, -26, 0, 6)
editorClose.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
editorClose.Text = "X"
editorClose.TextColor3 = Color3.fromRGB(255, 255, 255)
editorClose.TextSize = 12
editorClose.Font = Enum.Font.GothamBold
editorClose.AutoButtonColor = false
local editorCloseCorner = Instance.new("UICorner")
editorCloseCorner.CornerRadius = UDim.new(0, 11)
editorCloseCorner.Parent = editorClose
editorClose.Parent = editorFrame

editorClose.MouseButton1Click:Connect(function() editorFrame.Visible = false end)

local ticketLabel = Instance.new("TextLabel")
ticketLabel.Size = UDim2.new(0, 50, 0, 20)
ticketLabel.Position = UDim2.new(0, 15, 0, 40)
ticketLabel.BackgroundTransparency = 1
ticketLabel.Text = "票数:"
ticketLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ticketLabel.TextSize = 12
ticketLabel.Font = Enum.Font.Gotham
ticketLabel.TextXAlignment = Enum.TextXAlignment.Left
ticketLabel.Parent = editorFrame

local ticketBox = Instance.new("TextBox")
ticketBox.Size = UDim2.new(0, 120, 0, 22)
ticketBox.Position = UDim2.new(0, 65, 0, 39)
ticketBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ticketBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ticketBox.TextSize = 12
ticketBox.Font = Enum.Font.Gotham
ticketBox.Text = "15"
ticketBox.Parent = editorFrame

local crystalLabel = Instance.new("TextLabel")
crystalLabel.Size = UDim2.new(0, 50, 0, 20)
crystalLabel.Position = UDim2.new(0, 15, 0, 68)
crystalLabel.BackgroundTransparency = 1
crystalLabel.Text = "水晶数:"
crystalLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
crystalLabel.TextSize = 12
crystalLabel.Font = Enum.Font.Gotham
crystalLabel.TextXAlignment = Enum.TextXAlignment.Left
crystalLabel.Parent = editorFrame

local crystalBox = Instance.new("TextBox")
crystalBox.Size = UDim2.new(0, 120, 0, 22)
crystalBox.Position = UDim2.new(0, 65, 0, 67)
crystalBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
crystalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
crystalBox.TextSize = 12
crystalBox.Font = Enum.Font.Gotham
crystalBox.Text = "265"
crystalBox.Parent = editorFrame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 170, 0, 28)
applyBtn.Position = UDim2.new(0, 15, 0, 94)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
applyBtn.Text = "修改"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.TextSize = 12
applyBtn.Font = Enum.Font.GothamBold
local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 6)
applyCorner.Parent = applyBtn
applyBtn.Parent = editorFrame

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
end)

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -20, 0, 20)
modeLabel.Position = UDim2.new(0, 10, 0, 50)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "模式选择:"
modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
modeLabel.TextSize = 13
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = ticketPage

local modeContainer = Instance.new("Frame")
modeContainer.Size = UDim2.new(0, 260, 0, 30)
modeContainer.Position = UDim2.new(0, 10, 0, 71)
modeContainer.BackgroundTransparency = 1
modeContainer.Parent = ticketPage

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
historyLabel.Position = UDim2.new(0, 10, 0, 105)
historyLabel.BackgroundTransparency = 1
historyLabel.Text = "本次: 接0 交0 | 历史: 接0 交0"
historyLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
historyLabel.TextSize = 11
historyLabel.Font = Enum.Font.GothamMedium
historyLabel.TextXAlignment = Enum.TextXAlignment.Left
historyLabel.Parent = ticketPage

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 125)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 已停止"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = ticketPage

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 148)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度: 0.50秒/次"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = ticketPage

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 210, 0, 6)
sliderBg.Position = UDim2.new(0, 35, 0, 180)
sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBg.BorderSizePixel = 0
local sliderBgCorner = Instance.new("UICorner")
sliderBgCorner.CornerRadius = UDim.new(0, 3)
sliderBgCorner.Parent = sliderBg
sliderBg.Parent = ticketPage

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
        local t = math.clamp((UserInputService:GetMouseLocation().X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
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
actionBtn.Position = UDim2.new(0, 25, 0, 195)
actionBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
actionBtn.Text = "开始"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.TextSize = 14
actionBtn.Font = Enum.Font.GothamBold
local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionBtn
actionBtn.Parent = ticketPage

local running = false
local taskCount, lastTaskTime = 0, 0
local sessionAccept, sessionSubmit = 0, 0
local totalAccept, totalSubmit = 0, 0

local function updateHistory()
    historyLabel.Text = string.format("本次: 接%d 交%d | 历史: 接%d 交%d", sessionAccept, sessionSubmit, totalAccept, totalSubmit)
end

local miniFrame = Instance.new("TextButton")
miniFrame.Size = UDim2.new(0, 180, 0, 45)
miniFrame.Position = UDim2.new(0.5, -90, 0.5, -22)
miniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
miniFrame.Text = "打开UI--Made by 茶茶"
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

local function switchPage(page)
    fishingPage.Visible = page == "fishing"
    ticketPage.Visible = page == "ticket"
    fishingNavBtn.BackgroundColor3 = page == "fishing" and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(58, 58, 60)
    ticketNavBtn.BackgroundColor3 = page == "ticket" and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(58, 58, 60)
    title.Text = page == "fishing" and "钓鱼功能🎣" or "刷票功能😱"
end

fishingNavBtn.MouseButton1Click:Connect(function() switchPage("fishing") end)
ticketNavBtn.MouseButton1Click:Connect(function() switchPage("ticket") end)

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
    return n and e and pcall(function() e:FireServer("Ticket Quest Giver", 2, "HardAcceptQuest", {n, "Ticket Quest"}) end)
end

local function submitQuest()
    local n, e = getNPC(), getEvent()
    return n and e and pcall(function() e:FireServer("Ticket Quest Giver", 1, "Quest", {n}) end)
end

local function doTask()
    if not getNPC() or not getEvent() then
        statusLabel.Text, statusLabel.TextColor3 = "状态: 等待对象...", Color3.fromRGB(255, 200, 50)
        task.wait(1)
        return
    end
    local ok = currentMode == "accept" and acceptQuest() or submitQuest()
    if ok then
        taskCount = taskCount + 1
        if currentMode == "accept" then sessionAccept, totalAccept = sessionAccept + 1, totalAccept + 1
        else sessionSubmit, totalSubmit = sessionSubmit + 1, totalSubmit + 1 end
        updateHistory()
        statusLabel.Text = currentMode == "accept" and string.format("状态: 接任务中 (已接%d次)", taskCount) or string.format("状态: 交任务中 (已交%d次)", taskCount)
        statusLabel.TextColor3, lastTaskTime = Color3.fromRGB(100, 255, 100), tick()
    else
        statusLabel.Text, statusLabel.TextColor3 = "状态: 发送失败，重试中...", Color3.fromRGB(255, 200, 50)
        task.wait(1)
    end
end

actionBtn.MouseButton1Click:Connect(function()
    if running then
        running = false
        actionBtn.Text, actionBtn.BackgroundColor3 = "开始", Color3.fromRGB(50, 200, 50)
        statusLabel.Text = string.format("状态: 已停止 (共%d%s)", taskCount, currentMode == "accept" and "接" or "交")
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        running = true
        taskCount, sessionAccept, sessionSubmit = 0, 0, 0
        updateHistory()
        actionBtn.Text, actionBtn.BackgroundColor3 = "停止", Color3.fromRGB(200, 50, 50)
        statusLabel.Text, statusLabel.TextColor3 = "状态: 运行中...", Color3.fromRGB(100, 255, 100)
        task.spawn(function()
            while running do
                doTask()
                local w = currentSpeed
                if lastTaskTime > 0 then w = math.max(0.01, tick() - lastTaskTime < currentSpeed and currentSpeed - (tick() - lastTaskTime) or 0.01) end
                task.wait(w)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if getgenv().Honey_AutoCast then
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
        if getgenv().Honey_AutoSkill then
            for KeyName, KeyCode in pairs(KeyMap) do
                if getgenv().Honey_Skills[KeyName] then
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
        task.wait(getgenv().Honey_SellDelay)
        if getgenv().Honey_AutoSell then
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
    if getgenv().Honey_Anchor then
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
