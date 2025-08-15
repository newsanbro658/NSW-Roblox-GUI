-- NS-W Full GUI Script Fixed
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NSW_GUI"
screenGui.Parent = PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 60)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Note
local noteLabel = Instance.new("TextLabel")
noteLabel.Size = UDim2.new(0, 150, 0, 15)
noteLabel.Position = UDim2.new(0, 5, 0, 5)
noteLabel.BackgroundTransparency = 1
noteLabel.Text = "Note: It Only works on Private Server"
noteLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
noteLabel.Font = Enum.Font.Gotham
noteLabel.TextSize = 12
noteLabel.TextScaled = false
noteLabel.TextWrapped = true
noteLabel.Parent = mainFrame

-- UIListLayout for sections
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 3)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainFrame

-- Function to create sections
local function createSpawner(title, items, isPet, isExtra)
    local sectionButton = Instance.new("TextButton")
    sectionButton.Size = UDim2.new(0, 150, 0, 25)
    sectionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sectionButton.BorderSizePixel = 2
    sectionButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    sectionButton.Text = title
    sectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionButton.Font = Enum.Font.Gotham
    sectionButton.TextSize = 14
    sectionButton.TextScaled = false
    sectionButton.Parent = mainFrame

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = mainFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -6, 1, -6)
    scrollFrame.Position = UDim2.new(0, 3, 0, 3)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = frame

    local layoutInner = Instance.new("UIListLayout")
    layoutInner.FillDirection = Enum.FillDirection.Vertical
    layoutInner.Padding = UDim.new(0, 2)
    layoutInner.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layoutInner.SortOrder = Enum.SortOrder.LayoutOrder
    layoutInner.Parent = scrollFrame

    local function createButton(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 140, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextScaled = false
        btn.Parent = scrollFrame

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)

        btn.MouseButton1Click:Connect(function()
            if isPet then
                ReplicatedStorage:WaitForChild("GivePetRE"):FireServer({name, 1})
            elseif isExtra then
                if name == "Collect All" then
                    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CollectAllFree_RE"):FireServer()
                elseif name == "Clear Inventory" then
                    ReplicatedStorage:WaitForChild("ClearInventoryEvent"):FireServer()
                elseif name == "Reset Garden" then
                    ReplicatedStorage:WaitForChild("ResetGardenEvent"):FireServer()
                elseif name == "Give Sheckles (100m per click)" then
                    ReplicatedStorage:WaitForChild("GiveShecklesEvent"):FireServer()
                end
            else
                ReplicatedStorage:WaitForChild("Panel_Remotes"):WaitForChild("GiveSeedsOwner"):FireServer(name)
            end
        end)
    end

    for _, item in pairs(items) do
        createButton(item)
    end

    layoutInner:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0,0,0,layoutInner.AbsoluteContentSize.Y + 2)
    end)

    frame.Size = UDim2.new(0, 150, 0, math.min(#items*24, 120))

    local open = true
    local closedSize = UDim2.new(0, 150, 0, 0)
    local openSize = UDim2.new(0, 150, 0, math.min(#items*24, 120))

    sectionButton.MouseButton1Click:Connect(function()
        open = not open
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = open and openSize or closedSize}):Play()
    end)

    return frame
end

-- Seed Spawner
local seeds = {"Candy Blossom","Bone Blossom","Beanstalk","Ember lily","Sugar Apple"}
createSpawner("Seed Spawner", seeds, false, false)

-- Pet Spawner
local pets = {
    "Tarantula Hawk","Moth","Butterfly","Firefly","Disco Bee",
    "Red Dragon","Brown Mouse","Red Giant Ant","Red Fox","Blood Kiwi",
    "Chicken Zombie","Giant Ant","Raccoon","Dragonfly","Night Owl"
}
createSpawner("Pet Spawner", pets, true, false)

-- Extra Features in correct order
local extraFeatures = {
    "Clear Inventory",
    "Reset Garden",
    "Collect All",
    "Give Sheckles (100m per click)" -- last
}
local extraFrame = createSpawner("Extra Features", extraFeatures, false, true)

-- Auto Sheckles fast (separate button at bottom)
local autoSheckles = false
local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(0, 140, 0, 22)
autoButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoButton.BorderSizePixel = 2
autoButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
autoButton.Text = "Auto Sheckles: OFF"
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.Font = Enum.Font.Gotham
autoButton.TextSize = 14
autoButton.TextScaled = false
autoButton.Parent = extraFrame

autoButton.MouseButton1Click:Connect(function()
    autoSheckles = not autoSheckles
    autoButton.Text = "Auto Sheckles: " .. (autoSheckles and "ON" or "OFF")
end)

spawn(function()
    while true do
        if autoSheckles then
            ReplicatedStorage:WaitForChild("GiveShecklesEvent"):FireServer()
        end
        wait(0.05) -- very fast
    end
end)
