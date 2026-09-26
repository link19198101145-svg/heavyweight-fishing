local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Event = ReplicatedStorage.Stardust.Packages.Packet.RemoteEvent

local function sendPacket(bytes)
    local buf = buffer.create(#bytes)
    for i, byte in ipairs(bytes) do
        buffer.writeu8(buf, i - 1, byte)
    end
    Event:FireServer(buf)
end

task.spawn(function()
    while true do
        sendPacket({10, 6, 0})
        task.wait(0.01)
    end
end)

local DIRECTION_PACKETS = {
    Left = {14, 1, 65},
    Right = {14, 1, 68},
    Up = {14, 1, 87},
}

local lastSentDirection = nil
local lastSendTime = 0
local COOLDOWN = 0.05 

RunService.RenderStepped:Connect(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local reelGui = playerGui:FindFirstChild("ReelCounterGui")
    if not reelGui then return end

    local now = tick()

    for direction, packet in pairs(DIRECTION_PACKETS) do
        local button = reelGui:FindFirstChild(direction)
        if button and button:IsA("GuiObject") and button.Visible then
            if direction ~= lastSentDirection or now - lastSendTime >= COOLDOWN then
                lastSentDirection = direction
                lastSendTime = now
                sendPacket(packet)
            end
            break
        end
    end
end)