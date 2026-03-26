--// Liquid Glass UI - Blox Fruits Style (Redz/HoHo inspired + ton CSS exact)
-- Anti-detect version légère - Delta Executor

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LiquidGlassBF"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Main Frame (Liquid Glass exact comme ton CSS)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.78, 0, 0.85, 0)
mainFrame.Position = UDim2.new(0.11, 0, 0.075, 0)
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
glow.Size = UDim2.new(1.05, 0, 1.05, 0)
glow.Position = UDim2.new(-0.025, 0, -0.025, 0)
glow.BackgroundTransparency = 1
glow.ZIndex = mainFrame.ZIndex - 1
glow.Parent = mainFrame

local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(255, 215, 0)
glowStroke.Thickness = 14
glowStroke.Transparency = 0.75
glowStroke.Parent = glow

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 32)
glowCorner.Parent = glow

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "LIQUID GLASS | BLOX FRUITS"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = mainFrame

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 170, 0))
titleGrad.Parent = title

-- Container pour les pages (comme HoHo/Redz)
local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -40, 0.82, -20)
pages.Position = UDim2.new(0, 20, 0.15, 0)
pages.BackgroundTransparency = 1
pages.Parent = mainFrame

local currentPage = nil

local function showPage(pageName)
    if currentPage then currentPage.Visible = false end
    for _, child in pairs(pages:GetChildren()) do
        if child.Name == pageName then
            child.Visible = true
            currentPage = child
            break
        end
    end
end

-- Page Home (cards principales)
local homePage = Instance.new("ScrollingFrame")
homePage.Name = "Home"
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.ScrollBarThickness = 6
homePage.Visible = true
homePage.Parent = pages

local homeGrid = Instance.new("UIGridLayout")
homeGrid.CellSize = UDim2.new(0, 280, 0, 110)
homeGrid.CellPadding = UDim2.new(0, 25, 0, 25)
homeGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
homeGrid.Parent = homePage

local function createCard(text, targetPage)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    card.BackgroundTransparency = 0.22
    card.Text = text
    card.TextColor3 = Color3.fromRGB(255, 215, 0)
    card.TextScaled = true
    card.Font = Enum.Font.GothamBold
    card.AutoButtonColor = false
    card.Parent = homePage

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 20)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(255, 215, 0)
    cStroke.Thickness = 2.5
    cStroke.Parent = card

    local cGrad = Instance.new("UIGradient")
    cGrad.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 136, 0))
    cGrad.Parent = card

    card.MouseButton1Click:Connect(function()
        showPage(targetPage)
    end)
end

createCard("Combat Features", "Combat")
createCard("Movement & Misc", "Movement")
createCard("Visuals & Tweaks", "Visuals")

-- === PAGE COMBAT ===
local combatPage = Instance.new("ScrollingFrame")
combatPage.Name = "Combat"
combatPage.Size = UDim2.new(1, 0, 1, 0)
combatPage.BackgroundTransparency = 1
combatPage.Visible = false
combatPage.Parent = pages

local combatLayout = Instance.new("UIListLayout")
combatLayout.Padding = UDim.new(0, 15)
combatLayout.Parent = combatPage

-- Fast M1 No CD
local fastM1 = Instance.new("TextButton")
fastM1.Text = "Fast M1 (No Cooldown)"
fastM1.Size = UDim2.new(1, 0, 0, 60)
fastM1.BackgroundTransparency = 0.3
fastM1.Parent = combatPage
-- (ajoute UICorner + Stroke comme avant)

fastM1.MouseButton1Click:Connect(function()
    -- Simple no cooldown melee (exemple basique, à adapter)
    print("Fast M1 activé (simulé)")
end)

-- Auto Aim
local autoAimToggle = Instance.new("TextButton")
autoAimToggle.Text = "Auto Aim : OFF"
autoAimToggle.Size = UDim2.new(1, 0, 0, 60)
autoAimToggle.Parent = combatPage
-- ... style glass

-- === PAGE MOVEMENT ===
local movePage = Instance.new("ScrollingFrame")
movePage.Name = "Movement"
movePage.Size = UDim2.new(1, 0, 1, 0)
movePage.BackgroundTransparency = 1
movePage.Visible = false
movePage.Parent = pages

-- Fly + Slider vitesse
-- Speed Personnage + Boat (sliders)
-- Disable Weather (blox fruits specific)

-- === PAGE VISUALS ===
local visualPage = Instance.new("ScrollingFrame")
visualPage.Name = "Visuals"
visualPage.Size = UDim2.new(1, 0, 1, 0)
visualPage.BackgroundTransparency = 1
visualPage.Visible = false
visualPage.Parent = pages

-- No Zoom Limit, etc.

-- Bouton fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -65, 0, 15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Animation ouverture
mainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0.78, 0, 0.85, 0),
    BackgroundTransparency = 0.28
}):Play()

print("✅ Liquid Glass UI Blox Fruits chargée (style CSS + Redz/HoHo structure)")

-- Anti-detect basique (exemple)
RunService.Heartbeat:Connect(function()
    -- Ajoute ici des checks légers si besoin (ex: vérifier si anti-cheat détecte des changements trop rapides)
end)
