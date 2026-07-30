local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PullFishEvent = ReplicatedStorage:WaitForChild("Event"):WaitForChild("PullFishEvent")
local lastTick = 0

RunService.RenderStepped:Connect(function()
    local currentTick = tick()
    if currentTick - lastTick < 0.3 then return end
    lastTick = currentTick

    local args = {
        999999999999999999999,
        10
    }
    PullFishEvent:FireServer(unpack(args))
end)
