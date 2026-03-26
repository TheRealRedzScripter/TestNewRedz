--// Liquid Glass UI - Version ultra propre pour Delta Executor
-- Style Liquid Glass doré inspiré de ton CSS

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LiquidGlassUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.72, 0, 0.82, 0)
mainFrame.Position = UDim2.new(0.14, 0, 0.09, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
mainFrame.BackgroundTransparency = 0.28
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 24)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 2.8
stroke.Transparency = 0.35
stroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(26, 26, 46)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 33, 62))
}
gradient.Rotation = 135
gradient.Parent = mainFrame

-- Glow extérieur
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1.06, 0, 1.06, 0)
glow.Position = UDim2.new(-0.03, 0, -0.03, 0)
glow.BackgroundTransparency = 1
glow.ZIndex = mainFrame.ZIndex - 1
glow.Parent = mainFrame

local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(255, 215, 0)
glowStroke.Thickness = 12
glowStroke.Transparency = 0.78
glowStroke.Parent = glow

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 32)
glowCorner.Parent = glow

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.13, 0)
title.BackgroundTransparency = 1
title.Text = "LIQUID GLASS EXPLOIT"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = mainFrame

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 170, 0))
titleGrad.Parent = title

-- ScrollingFrame + Grid
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -50, 0.72, -30)
scroll.Position = UDim2.new(0, 25, 0.18, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scroll.Parent = mainFrame

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 260, 0, 82)
grid.CellPadding = UDim2.new(0, 20, 0, 20)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.Parent = scroll

-- Fonction bouton (style btn-fart)
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    btn.BackgroundTransparency = 0.22
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = scroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 20)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 215, 0)
    btnStroke.Thickness = 2.5
    btnStroke.Transparency = 0.3
    btnStroke.Parent = btn

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 136, 0))
    }
    btnGradient.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 12, 1, 12),
            Position = UDim2.new(0, -6, 0, -6)
        }):Play()
        btnStroke.Transparency = 0.1
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 0.22,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        btnStroke.Transparency = 0.3
    end)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(1, -10, 1, -10)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.12), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        if callback then
            callback()
        end
    end)
end

-- Boutons (faux pour l'instant - tu remplaceras plus tard)
createButton("Auto Farm", function() print("Auto Farm activé") end)
createButton("ESP & Tracers", function() print("ESP activé") end)
createButton("Speed + Fly", function() print("Speed/Fly activé") end)
createButton("God Mode", function() print("God Mode activé") end)
createButton("Kill Aura", function() print("Kill Aura activé") end)
createButton("Item Grabber", function() print("Grabber activé") end)
createButton("Teleport Menu", function() print("TP ouvert") end)
createButton("Settings", function() print("Settings ouvert") end)

-- Bouton fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 48, 0, 48)
closeBtn.Position = UDim2.new(1, -58, 0, 12)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Animation ouverture
mainFrame.Size = UDim2.new(0.35, 0, 0.35, 0)
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0.72, 0, 0.82, 0),
    BackgroundTransparency = 0.28
}):Play()

print("✅ UI Liquid Glass chargée dans Delta Executor !")
