
--==================================================
-- GREEDY GROWS V5
-- GUI + AUTO BUY CONTROLS + FPS OPTIMIZER
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xoa GUI cu
local Old = PlayerGui:FindFirstChild("GreedyGrows")
if Old then Old:Destroy() end

--==================================================
-- GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "GreedyGrows"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999
GUI.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(290, 355)
Main.Position = UDim2.new(0.5, -145, 0.5, -177)
Main.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
Main.BorderSizePixel = 0
Main.Parent = GUI

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(60, 190, 120)
Stroke.Thickness = 1.5
Stroke.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 0, 45)
Title.Position = UDim2.fromOffset(12, 0)
Title.BackgroundTransparency = 1
Title.Text = "GREEDY GROWS V5"
Title.TextColor3 = Color3.fromRGB(80, 255, 150)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local function button(name, position, size, color)
    local B = Instance.new("TextButton")
    B.Size = size
    B.Position = position
    B.BackgroundColor3 = color
    B.Text = name
    B.TextColor3 = Color3.new(1, 1, 1)
    B.TextSize = 12
    B.Font = Enum.Font.GothamBold
    B.BorderSizePixel = 0
    B.Parent = Main

    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

    return B
end

--==================================================
-- HIDE / MINIMIZE
--==================================================

local Hide = button(
    "HIDE",
    UDim2.new(1, -103, 0, 9),
    UDim2.fromOffset(43, 27),
    Color3.fromRGB(170, 65, 65)
)

local Min = button(
    "-",
    UDim2.new(1, -52, 0, 9),
    UDim2.fromOffset(35, 27),
    Color3.fromRGB(55, 65, 85)
)

local Floating = Instance.new("TextButton")
Floating.Name = "OpenMenu"
Floating.Size = UDim2.fromOffset(48, 48)
Floating.Position = UDim2.new(0, 20, 0.5, 0)
Floating.BackgroundColor3 = Color3.fromRGB(35, 180, 105)
Floating.Text = "GG"
Floating.TextColor3 = Color3.new(1, 1, 1)
Floating.TextSize = 17
Floating.Font = Enum.Font.GothamBold
Floating.Visible = false
Floating.Parent = GUI

Instance.new("UICorner", Floating).CornerRadius = UDim.new(1, 0)

Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Floating.MouseButton1Click:Connect(function()
    Main.Visible = true
    Floating.Visible = false
end)

local Minimized = false

Min.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    for _, obj in ipairs(Main:GetChildren()) do
        if obj ~= Title and obj ~= Hide
            and obj ~= Min and obj ~= Stroke then
            obj.Visible = not Minimized
        end
    end

    Main.Size = Minimized
        and UDim2.fromOffset(290, 45)
        or UDim2.fromOffset(290, 355)

    Min.Text = Minimized and "+" or "-"
end)

--==================================================
-- DRAG MENU
--==================================================

local function makeDraggable(target)
    local dragging = false
    local startPosition
    local startInput

    target.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            startInput = input.Position
            startPosition = target.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - startInput

            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(Title)
makeDraggable(Floating)

--==================================================
-- AUTO BUY INTERFACE
--==================================================

local States = {
    Celestial = false,
    Secret = false,
    Divine = false
}

local TierButtons = {}

local function updateTier(name, value)
    States[name] = value

    local B = TierButtons[name]
    B.Text = name .. " : " .. (value and "ON" or "OFF")

    B.BackgroundColor3 = value
        and Color3.fromRGB(35, 145, 85)
        or Color3.fromRGB(45, 50, 65)
end

local function createTier(name, y)
    local B = button(
        name .. " : OFF",
        UDim2.fromOffset(12, y),
        UDim2.new(1, -24, 0, 35),
        Color3.fromRGB(45, 50, 65)
    )

    TierButtons[name] = B

    B.MouseButton1Click:Connect(function()
        updateTier(name, not States[name])

        local allEnabled = true

        for _, state in pairs(States) do
            if not state then
                allEnabled = false
            end
        end

        AllState = allEnabled
        AllButton.Text = allEnabled
            and "AUTO BUY ALL : ON"
            or "AUTO BUY ALL : OFF"

        AllButton.BackgroundColor3 = allEnabled
            and Color3.fromRGB(35, 145, 85)
            or Color3.fromRGB(45, 50, 65)
    end)
end

local AllState = false
local AllButton

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -24, 0, 25)
Header.Position = UDim2.fromOffset(12, 48)
Header.BackgroundTransparency = 1
Header.Text = "AUTO BUY - SEED RARITY"
Header.TextColor3 = Color3.fromRGB(200, 205, 220)
Header.TextSize = 12
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Main

createTier("Celestial", 78)
createTier("Secret", 120)
createTier("Divine", 162)

AllButton = button(
    "AUTO BUY ALL : OFF",
    UDim2.fromOffset(12, 204),
    UDim2.new(1, -24, 0, 35),
    Color3.fromRGB(45, 50, 65)
)

AllButton.MouseButton1Click:Connect(function()
    AllState = not AllState

    for name in pairs(States) do
        updateTier(name, AllState)
    end

    AllButton.Text = AllState
        and "AUTO BUY ALL : ON"
        or "AUTO BUY ALL : OFF"

    AllButton.BackgroundColor3 = AllState
        and Color3.fromRGB(35, 145, 85)
        or Color3.fromRGB(45, 50, 65)
end)

--==================================================
-- FPS OPTIMIZER
--==================================================

local FPS = false
local Saved = {}
local OriginalShadows = Lighting.GlobalShadows

local function saveAndSet(object, property, value)
    if Saved[object] == nil then
        Saved[object] = {}
    end

    if Saved[object][property] == nil then
        Saved[object][property] = object[property]
    end

    object[property] = value
end

local function optimizeObject(obj)
    if obj:IsA("BasePart") then
        saveAndSet(obj, "CastShadow", false)

    elseif obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam") then

        saveAndSet(obj, "Enabled", false)

    elseif obj:IsA("PostEffect") then
        saveAndSet(obj, "Enabled", false)
    end
end

local function enableFPS()
    OriginalShadows = Lighting.GlobalShadows
    Lighting.GlobalShadows = false

    for _, obj in ipairs(Workspace:GetDescendants()) do
        optimizeObject(obj)
    end

    for _, obj in ipairs(Lighting:GetDescendants()) do
        optimizeObject(obj)
    end
end

local function disableFPS()
    Lighting.GlobalShadows = OriginalShadows

    for obj, properties in pairs(Saved) do
        if obj.Parent then
            for property, oldValue in pairs(properties) do
                pcall(function()
                    obj[property] = oldValue
                end)
            end
        end
    end

    table.clear(Saved)
end

-- FPS button
local FPSButton = button(
    "FIX LAG : OFF",
    UDim2.fromOffset(12, 252),
    UDim2.new(1, -24, 0, 36),
    Color3.fromRGB(45, 50, 65)
)

FPSButton.MouseButton1Click:Connect(function()
    FPS = not FPS

    if FPS then
        enableFPS()
    else
        disableFPS()
    end

    FPSButton.Text = FPS and "FIX LAG : ON" or "FIX LAG : OFF"

    FPSButton.BackgroundColor3 = FPS
        and Color3.fromRGB(35, 145, 85)
        or Color3.fromRGB(45, 50, 65)
end)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 30)
Status.Position = UDim2.fromOffset(12, 300)
Status.BackgroundTransparency = 1
Status.Text = "GREEDY GROWS V5 - READY"
Status.TextColor3 = Color3.fromRGB(150, 160, 175)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = Main

-- Cleanup when GUI is removed
GUI.Destroying:Connect(function()
    if FPS then
        disableFPS()
    end
end)

print("GREEDY GROWS V5 LOADED")
