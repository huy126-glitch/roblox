
-- GREEDY GROWS - GUI + FPS OPTIMIZER
-- Local client interface

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI
local old = PlayerGui:FindFirstChild("GreedyGrowsGUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GreedyGrowsGUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(310, 390)
main.Position = UDim2.new(0.5, -155, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(24, 27, 35)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 45)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "GREEDY GROWS"
title.TextColor3 = Color3.fromRGB(90, 255, 150)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -40, 0, 7)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
close.Parent = main

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local y = 55

local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 35)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = Color3.fromRGB(43, 49, 62)
    button.TextColor3 = Color3.new(1,1,1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamMedium
    button.Text = name
    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.MouseButton1Click:Connect(callback)
    y = y + 42
    return button
end

-- Rarity interface
local rarities = {
    "Common", "Uncommon", "Rare",
    "Epic", "Legendary", "Mythic", "All Rarities"
}

for _, rarity in ipairs(rarities) do
    createButton("AUTO BUY: " .. rarity, function()
        print("Selected rarity: " .. rarity)
        -- Add authorized game purchase logic here
    end)
end

-- FPS Optimizer
local optimized = false

local fpsButton = createButton("FIX LAG: OFF", function()
    optimized = not optimized

    if optimized then
        fpsButton.Text = "FIX LAG: ON"
        fpsButton.BackgroundColor3 = Color3.fromRGB(35, 135, 80)

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam") then
                obj.Enabled = false
            end
        end
    else
        fpsButton.Text = "FIX LAG: OFF"
        fpsButton.BackgroundColor3 = Color3.fromRGB(43, 49, 62)
    end
end)

-- Draggable GUI
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("Greedy Grows GUI loaded!")
