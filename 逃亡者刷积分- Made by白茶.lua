-- Made by 白茶
-- ❤️白茶出品 必属精品❤️
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local Event = ReplicatedStorage.FlowClient.ClientRunner.Event

-- 保存自己的源代码（需要注入器支持 getscriptsource）
local SCRIPT_URL = "https://你的服务器/autofarm.lua"  -- 或本地路径

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

    -- 脚本结束后重新加入服务器（触发自动重跑）
    task.wait(5)
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

main()