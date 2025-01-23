local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local noStunning = false
local noStunSpeed = 20

local function isNumber(value)
    return tonumber(value) ~= nil
end

local function noStunWalk(distance, speaker)
    noStunning = true
    local chr = speaker.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    while noStunning and chr and hum and hum.Parent do
        local delta = RunService.Heartbeat:Wait()
        if hum.MoveDirection.Magnitude > 0 then
            local speed = (distance or noStunSpeed)
            chr:TranslateBy(hum.MoveDirection * speed * delta)
        end
    end
end

local function stopNoStunWalk()
    noStunning = false
end

local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local uiCorner = Instance.new("UICorner")
local noStunButton = Instance.new("TextButton")
local stopNoStunButton = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local speedSlider = Instance.new("TextBox")

screenGui.Name = "ModernGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

noStunButton.Name = "NoStunButton"
noStunButton.Text = "No Stun"
noStunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noStunButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noStunButton.Size = UDim2.new(0, 200, 0, 50)
noStunButton.Position = UDim2.new(0.5, -100, 0.5, -150)
noStunButton.Parent = mainFrame

stopNoStunButton.Name = "StopNoStunButton"
stopNoStunButton.Text = "Stop No Stun"
stopNoStunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopNoStunButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
stopNoStunButton.Size = UDim2.new(0, 200, 0, 50)
stopNoStunButton.Position = UDim2.new(0.5, -100, 0.5, -80)
stopNoStunButton.Parent = mainFrame

speedLabel.Name = "SpeedLabel"
speedLabel.Text = "No Stun Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedLabel.Size = UDim2.new(0, 200, 0, 50)
speedLabel.Position = UDim2.new(0.5, -100, 0.5, 0)
speedLabel.Parent = mainFrame

speedSlider.Name = "SpeedSlider"
speedSlider.Text = tostring(noStunSpeed)
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.Size = UDim2.new(0, 200, 0, 50)
speedSlider.Position = UDim2.new(0.5, -100, 0.5, 50)
speedSlider.Parent = mainFrame

local function createHoverEffect(button)
    local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local hoverOn = TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    local hoverOff = TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})

    button.MouseEnter:Connect(function()
        hoverOn:Play()
    end)

    button.MouseLeave:Connect(function()
        hoverOff:Play()
    end)
end

createHoverEffect(noStunButton)
createHoverEffect(stopNoStunButton)
createHoverEffect(speedSlider)

noStunButton.MouseButton1Click:Connect(function()
    noStunWalk(nil, game.Players.LocalPlayer)
end)

stopNoStunButton.MouseButton1Click:Connect(function()
    stopNoStunWalk()
end)

speedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed > 0 then
        noStunSpeed = newSpeed
    else
        speedSlider.Text = tostring(noStunSpeed)
    end
end)


local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)
