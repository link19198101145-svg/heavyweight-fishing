local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local function safeTeleport(cframe)
    local char = player.Character or player.CharacterAdded:Wait()
    if char then
        pcall(function()
            char:PivotTo(cframe)
        end)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cframe
        end
    end
end

local function firePrompt(promptObj)
    if not promptObj or not promptObj:IsA("ProximityPrompt") then return end
    
    local success = pcall(function()
        if fireproximityprompt then
            fireproximityprompt(promptObj)
        elseif typeof(fireproximityprompt) == "function" then
            fireproximityprompt(promptObj)
        else
            error("没有可用的 fireproximityprompt")
        end
    end)
    
    if not success then
        pcall(function()
            promptObj:InputHoldBegin()
            task.wait(promptObj.HoldDuration or 0.5)
            promptObj:InputHoldEnd()
        end)
    end
end

-- 运行脚本30秒后自动重进服务器
task.delay(30, function()
    print("[*] 已满30秒！正在自动重进服务器...")
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, player)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end
    end)
end)

local elevatorNames = {"Solo1", "Solo2", "Solo3", "Solo4", "Solo5"}
local foundEmptyElevator = false

for _, name in ipairs(elevatorNames) do
    local elevatorObj = nil
    pcall(function()
        elevatorObj = Workspace.Elevators:FindFirstChild(name)
    end)

    if elevatorObj then
        local isOccupied = false
        pcall(function()
            local playersFolder = elevatorObj:FindFirstChild("Players")
            if playersFolder and #playersFolder:GetChildren() > 0 then
                isOccupied = true
            end
        end)

        if not isOccupied then
            local touchPart = elevatorObj:FindFirstChild("TouchPart")
            if touchPart then
                print("[+] 找到空闲电梯 " .. name .. "，正在传送到 TouchPart...")
                
                safeTeleport(touchPart.CFrame)
                task.wait(0.2)

                local startTime = tick()
                while tick() - startTime < 2 do
                    pcall(function()
                        local args = {
                            [1] = {
                                ["method"] = "create",
                                ["data"] = {
                                    ["maxMember"] = 1,
                                    ["friendsOnly"] = false
                                }
                            }
                        }
                        ReplicatedStorage.remotes.requestActiveElevator:FireServer(unpack(args))
                    end)
                    task.wait(0.1)
                end

                foundEmptyElevator = true
                break
            end
        else
            print("[!] " .. name .. " 已有玩家，跳过...")
        end
    end
end

if not foundEmptyElevator then
    warn("[-] 所有电梯都已被占用或找不到 TouchPart！")
end

task.wait(0.5)

pcall(function()
    ReplicatedStorage.Systems.Intro.VoteSkip:FireServer()
    print("[+] 已投票跳过开场")
end)

safeTeleport(CFrame.new(-170, 27, 44, 0, 0, -1, 0, 1, 0, 1, 0, 0))
task.wait(1)

local prompt = nil
pcall(function()
    prompt = Workspace["Escape Route"]["Prompt Escape"]:FindFirstChildOfClass("ProximityPrompt")
end)

if prompt then
    firePrompt(prompt)
    print("[+] 已触发交互提示")
else
    warn("[-] 在逃生路线找不到 ProximityPrompt")
end

task.wait(0.5)
pcall(function()
    ReplicatedStorage.Systems.PhoneCall.SkipVote:FireServer()
    print("[+] 已投票跳过电话")
end)

print("[*] 正在等待25秒...")
task.wait(25)

pcall(function()
    ReplicatedStorage.Systems.Sleeping.Remotes.LeaveToLobby:FireServer()
    print("[+] 已发送返回大厅请求")
end)