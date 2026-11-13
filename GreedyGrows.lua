
--========================================
-- GREEDY GROWS V4
-- GUI + FPS OPTIMIZER
--========================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Remove old GUI
if PlayerGui:FindFirstChild("GreedyGrows") then
    PlayerGui.GreedyGrows:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "GreedyGrows"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(280, 350)
Main.Position = UDim2.new(0.5, -140, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
Main.BorderSizePixel = 0
Main.Parent = GUI

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 0, 45)
Title.Position = UDim2.fromOffset(12, 0)
Title.BackgroundTransparency = 1
Title.Text = "GREEDY GROWS V4"
Title.TextColor3 = Color3.fromRGB(80, 255, 140)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Minimize button
local Min = Instance.new("TextButton")
Min.Size = UDim2.fromOffset(32, 30)
Min.Position = UDim2.new(1, -40, 0, 7)
Min.Text = "-"
Min.TextSize = 22
Min.Parent = Main

local function makeButton(name, y)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -24, 0, 36)
    B.Position = UDim2.fromOffset(12, y)
    B.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    B.TextColor3 = Color3.new(1, 1, 1)
    B.TextSize = 14
    B.Font = Enum.Font.GothamMedium
    B.Parent = Main
    B.Text = name
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 7)
    return B
end

local function makeToggle(name, y, callback)
    local enabled = false
    local B = makeButton(name .. ": OFF", y)

    B.MouseButton1Click:Connect(function()
        enabled = not enabled
        B.Text = name .. (enabled and ": ON" or ": OFF")
        B.BackgroundColor3 = enabled
            and Color3.fromRGB(35, 135, 80)
            or Color3.fromRGB(45, 50, 65)

        callback(enabled)
    end)

    return function(value)
        enabled = value
        B.Text = name .. (enabled and ": ON" or ": OFF")
        B.BackgroundColor3 = enabled
            and Color3.fromRGB(35, 135, 80)
            or Color3.fromRGB(45, 50, 65)
    end
end

-- Auto Buy controls
local autoStates = {
    Celestial = false,
    Secret = false,
    Divine = false
}

local setCelestial = makeToggle("Celestial", 55, function(v)
    autoStates.Celestial = v
end)

local setSecret = makeToggle("Secret", 99, function(v)
    autoStates.Secret = v
end)

local setDivine = makeToggle("Divine", 143, function(v)
    autoStates.Divine = v
end)

local setAll = makeToggle("AUTO BUY ALL", 187, function(v)
    autoStates.Celestial = v
    autoStates.Secret = v
    autoStates.Divine = v

    setCelestial(v)
    setSecret(v)
    setDivine(v)
end)

-- FPS Optimizer
local oldSettings = {}
local optimized = false

local function fixLag()
    oldSettings.GlobalShadows = Lighting.GlobalShadows
    Lighting.GlobalShadows = false

    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then
            oldSettings[obj] = obj.Enabled
            obj.Enabled = false
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            oldSettings[obj] = {
                CastShadow = obj.CastShadow
            }
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam") then

            oldSettings[obj] = obj.Enabled
            obj.Enabled = false
        end
    end
end

local function restoreLag()
    Lighting.GlobalShadows = oldSettings.GlobalShadows

    for obj, value in pairs(oldSettings) do
        if typeof(obj) == "Instance" and obj.Parent then
            if typeof(value) == "table" then
                obj.CastShadow = value.CastShadow
            else
                obj.Enabled = value
            end
        end
    end

    table.clear(oldSettings)
end

makeToggle("FIX LAG", 231, function(v)
    optimized = v

    if optimized then
        fixLag()
    else
        restoreLag()
    end
end)

-- Minimize / Restore
local minimized = false

Min.MouseButton1Click:Connect(function()
    minimized = not minimized

    for _, obj in ipairs(Main:GetChildren()) do
        if obj ~= Title and obj ~= Min then
            obj.Visible = not minimized
        end
    end

    Main.Size = minimized
        and UDim2.fromOffset(280, 45)
        or UDim2.fromOffset(280, 350)

    Min.Text = minimized and "+" or "-"
end)

-- Drag GUI
local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("GREEDY GROWS V4 LOADED")
