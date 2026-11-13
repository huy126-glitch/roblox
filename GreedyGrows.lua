
--========================================
-- HIDE / SHOW MENU
--========================================

local ToggleMenu = Instance.new("TextButton")
ToggleMenu.Name = "ToggleMenu"
ToggleMenu.Size = UDim2.fromOffset(48, 48)
ToggleMenu.Position = UDim2.new(0, 20, 0.5, 0)
ToggleMenu.BackgroundColor3 = Color3.fromRGB(35, 180, 100)
ToggleMenu.Text = "GG"
ToggleMenu.TextColor3 = Color3.new(1, 1, 1)
ToggleMenu.TextSize = 17
ToggleMenu.Font = Enum.Font.GothamBold
ToggleMenu.Visible = false
ToggleMenu.Parent = GUI

Instance.new("UICorner", ToggleMenu).CornerRadius =
    UDim.new(1, 0)

-- Hide button
local Hide = Instance.new("TextButton")
Hide.Name = "HideMenu"
Hide.Size = UDim2.fromOffset(45, 28)
Hide.Position = UDim2.new(1, -95, 0, 8)
Hide.BackgroundColor3 = Color3.fromRGB(180, 65, 65)
Hide.Text = "HIDE"
Hide.TextColor3 = Color3.new(1, 1, 1)
Hide.TextSize = 11
Hide.Font = Enum.Font.GothamBold
Hide.Parent = Main

Instance.new("UICorner", Hide).CornerRadius =
    UDim.new(0, 6)

Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    ToggleMenu.Visible = true
end)

ToggleMenu.MouseButton1Click:Connect(function()
    Main.Visible = true
    ToggleMenu.Visible = false
end)
