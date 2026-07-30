local args = {
	999999999999999999999,
	10
}
game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("PullFishEvent"):FireServer(unpack(args))