local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")

local musicBar = playerGui:FindFirstChild("Music Bar", true)
if not musicBar then
    warn("找不到 Music Bar")
    return
end

local mainContainer = musicBar:WaitForChild("Main")
local notesContainer = mainContainer:WaitForChild("Notes")
local mobileButton = musicBar:WaitForChild("Mobile Button"):WaitForChild("TextButton")
local noteMiddleX = 0.475
local perfectThreshold = 0.02
local lastPressedNote = nil
local cooldown = 0.05
local lastPressTime = 0

runService.RenderStepped:Connect(function()
    local now = os.clock()
    local closestNote = nil
    local closestDistance = math.huge

    for _, note in ipairs(notesContainer:GetChildren()) do
        if note.Name == "Small Note" and note.Visible and note ~= lastPressedNote then
            local distance = math.abs(note.Position.X.Scale - noteMiddleX)
            if distance < closestDistance then
                closestNote = note
                closestDistance = distance
            end
        end
    end

    if closestNote and closestDistance <= perfectThreshold and now - lastPressTime >= cooldown then
        firesignal(mobileButton.MouseButton1Down)
        lastPressedNote = closestNote
        lastPressTime = now
    end
end)