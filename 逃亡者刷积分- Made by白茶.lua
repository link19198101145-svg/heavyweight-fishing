-- Made by 白茶
-- ❤️白茶出品 必属精品❤️
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local Event = ReplicatedStorage.FlowClient.ClientRunner.Event

local SCRIPT_URL = "https://raw.githubusercontent.com/link19198101145-svg/heavyweight-fishing/main/逃亡者刷积分-%20Made%20by白茶.lua"

local END_POS = CFrame.new(805, 1500, 83729)

local function teleportToEnd()
    local character = LocalPlayer.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = END_POS
    return true
end

local function replay()
    for i = 1, 5 do
        Event:FireServer("GameManager", "Replay")
        task.wait(0.5)
    end
end

local function main()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")
    character:WaitForChild("Humanoid")

    task.wait(2)

    for i = 1, 10 do
        if teleportToEnd() then break end
        task.wait(0.5)
    end

    task.wait(3)

    Event:FireServer("Passout", "Abandon")
    task.wait(1)
    replay()
end

main()

if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("' .. SCRIPT_URL .. '"))()')
end
