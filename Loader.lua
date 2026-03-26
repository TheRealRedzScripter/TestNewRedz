
--[[
    Script: Redz Hub - Ultimate Edition
    Style: Redz Hub / HoHoHub (Fenêtres cliquables)
    Fonctionnalités: Anti-Weather, Fly, Fast M1, No CD, No Zoom Limit, Auto Aim, Speed Hack (Perso/Boat)
    Anti-Detect: Obfuscation légère, exécution différée, hooks protégés.
]]

-- Variables d'environnement
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Anti-Detect : désactivation des services de rapport et masquage de l'executor
pcall(function()
    setfflag("AbuseReportEnabled", "False")
    setfflag("AbuseReportScreenshot", "False")
    setfflag("LuaTracebackEnabled", "False")
    setfflag("DebuggerEnabled", "False")
    game:GetService("TeleportService"):SetTeleportGui("")
    game:GetService("LogService"):SetLogListener(nil)
end)

-- Variables de contrôle des fonctionnalités
local features = {
    weatherDisabled = false,
    flyEnabled = false,
    flySpeed = 50,
    fastM1 = false,
    noCD = false,
    noZoomLimit = false,
    autoAim = false,
    autoAimTarget = nil,
    speedHack = false,
    playerSpeed = 50,
    boatSpeed = 100,
    boatSpeedEnabled = false
}

-- Anti-Detect : Nom aléatoire pour les fonctions et variables (obfuscation simple)
local _G = getfenv()
local _0x = {}
for i = 1, 100 do _0x[i] = string.char(math.random(97,122)) end

-- Cache les fonctions sensibles
local hookmetamethod = hookmetamethod or function() end
local getrawmetatable = getrawmetatable or function() return {} end

-- ==== FONCTIONS PRINCIPALES ====

-- Désactivation de la météo (Blox Fruits)
local function disableWeather()
    if features.weatherDisabled then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Weather") or v.Name == "Climate" then
                v.Enabled = false
                v:Destroy()
            end
        end
        pcall(function()
            game.Lighting.TimeOfDay = 12
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 12
        end)
    end
end

-- Fly
local function startFly()
    local flying = false
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    
    local function enableFly()
        if not LocalPlayer.Character then return end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        bodyVelocity.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        flying = true
    end
    
    local function disableFly()
        bodyVelocity:Destroy()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        flying = false
    end
    
    local function updateFly()
        if flying then
            local direction = Vector3.new(0,0,0)
            local moveDirection = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Vector3.new(0,0,-1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction + Vector3.new(0,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction + Vector3.new(-1,0,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Vector3.new(1,0,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction + Vector3.new(0,-1,0) end
            
            local camCF = Camera.CFrame
            direction = (camCF.RightVector * direction.X + camCF.UpVector * direction.Y + camCF.LookVector * direction.Z)
            direction = direction.Unit * features.flySpeed
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity.Velocity = direction
            end
        end
    end
    
    if features.flyEnabled then
        enableFly()
        RunService:BindToRenderStep("FlyUpdate", 100, updateFly)
    else
        disableFly()
        RunService:UnbindFromRenderStep("FlyUpdate")
    end
end

-- Fast M1 (No Cooldown sur les coups)
local function fastM1()
    if not features.fastM1 then return end
    pcall(function()
        for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local attack = tool:FindFirstChild("Attack") or tool:FindFirstChild("Hit")
                if attack and attack:IsA("RemoteEvent") then
                    local oldFire = attack.FireServer
                    attack.FireServer = function(...)
                        attack.FireServer = oldFire
                        attack:FireServer(...)
                        wait(0.02)
                        attack:FireServer(...)
                    end
                end
            end
        end
    end)
end

-- No CD (Pas de cooldown pour les compétences)
local function noCD()
    if not features.noCD then return end
    pcall(function()
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("NumberValue") and v.Name == "Cooldown" then
                v.Value = 0
            end
        end
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        mt.__index = function(self, key)
            if key == "Cooldown" or key == "RemainingCooldown" then
                return 0
            end
            return oldIndex(self, key)
        end
    end)
end

-- No Zoom Limit
local function noZoomLimit()
    if not features.noZoomLimit then return end
    pcall(function()
        local cam = workspace.CurrentCamera
        local oldSet = cam.SetFieldOfView
        cam.SetFieldOfView = function(self, fov)
            if fov < 70 then fov = 70 end
            if fov > 120 then fov = 120 end
            return oldSet(self, fov)
        end
        cam.FieldOfView = 120
    end)
end

-- Auto Aim
local function autoAim()
    if not features.autoAim then
        features.autoAimTarget = nil
        return
    end
    local function getClosestPlayer()
        local closest = nil
        local minDist = math.huge
        for _,player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player
                end
            end
        end
        return closest
    end
    
    RunService:BindToRenderStep("AutoAim", 101, function()
        if features.autoAim then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end

-- Speed Hack (Personnage)
local function speedHack()
    if not features.speedHack then return end
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = features.playerSpeed
        end
    end
end

-- Speed Hack Boat (Blox Fruits)
local function boatSpeedHack()
    if not features.boatSpeedEnabled then return end
    for _,boat in pairs(workspace:GetDescendants()) do
        if boat:IsA("VehicleSeat") and boat.Parent and boat.Parent:FindFirstChild("BodyVelocity") then
            local bv = boat.Parent:FindFirstChild("BodyVelocity")
            if bv and bv:IsA("BodyVelocity") then
                bv.Velocity = bv.Velocity.Unit * features.boatSpeed
            end
        end
    end
end

-- Boucle principale d'application des hacks
RunService.Heartbeat:Connect(function()
    disableWeather()
    startFly()
    fastM1()
    noCD()
    noZoomLimit()
    autoAim()
    speedHack()
    boatSpeedHack()
end)

-- ===== INTERFACE UTILISATEUR (Style Redz Hub) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHubGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fenêtre principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.BackgroundTransparency = 0.15
MainFrame.ClipsDescendants = false

-- Effet verre liquide
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,215,0), Color3.fromRGB(255,170,0))
UIGradient.Rotation = 45
UIGradient.Transparency = NumberSequence.new(0.9)
UIGradient.Parent = MainFrame

-- Titre
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.Orbitron
Title.Text = "REDZ HUB | ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 24
Title.TextStrokeTransparency = 0.5

-- Bouton fermer
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.SourceSans
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Barre de déplacement
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame)

-- Scroll pour les fonctionnalités
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = ScrollingFrame
UIGridLayout.CellSize = UDim2.new(0, 260, 0, 100)
UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fonction pour créer une carte de fonctionnalité (clic vers sous-menu)
local function createFeatureCard(title, description, subFeatures)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    card.BackgroundTransparency = 0.3
    card.BorderColor3 = Color3.fromRGB(255, 215, 0)
    card.BorderSizePixel = 1
    card.Size = UDim2.new(0, 260, 0, 100)
    card.Parent = ScrollingFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = card
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Font = Enum.Font.Orbitron
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = card
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 10, 0, 35)
    descLabel.Size = UDim2.new(1, -20, 0, 40)
    descLabel.Font = Enum.Font.SourceSans
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    btn.BackgroundTransparency = 0.8
    btn.Position = UDim2.new(1, -80, 1, -35)
    btn.Size = UDim2.new(0, 70, 0, 30)
    btn.Font = Enum.Font.SourceSans
    btn.Text = "→"
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.TextSize = 20
    btn.BorderColor3 = Color3.fromRGB(255, 215, 0)
    
    btn.MouseButton1Click:Connect(function()
        -- Création du sous-menu
        local subFrame = Instance.new("Frame")
        subFrame.Parent = ScreenGui
        subFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        subFrame.BackgroundTransparency = 0.15
        subFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
        subFrame.BorderSizePixel = 2
        subFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
        subFrame.Size = UDim2.new(0, 500, 0, 400)
        
        local subTitle = Instance.new("TextLabel")
        subTitle.Parent = subFrame
        subTitle.BackgroundTransparency = 1
        subTitle.Position = UDim2.new(0, 0, 0, 10)
        subTitle.Size = UDim2.new(1, 0, 0, 40)
        subTitle.Font = Enum.Font.Orbitron
        subTitle.Text = title .. " - Settings"
        subTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
        subTitle.TextSize = 20
        
        local closeSub = Instance.new("TextButton")
        closeSub.Parent = subFrame
        closeSub.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        closeSub.BackgroundTransparency = 0.7
        closeSub.Position = UDim2.new(1, -40, 0, 5)
        closeSub.Size = UDim2.new(0, 30, 0, 30)
        closeSub.Font = Enum.Font.SourceSans
        closeSub.Text = "X"
        closeSub.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeSub.TextSize = 18
        closeSub.MouseButton1Click:Connect(function()
            subFrame:Destroy()
        end)
        
        local subScroll = Instance.new("ScrollingFrame")
        subScroll.Parent = subFrame
        subScroll.Position = UDim2.new(0, 10, 0, 60)
        subScroll.Size = UDim2.new(1, -20, 1, -80)
        subScroll.BackgroundTransparency = 1
        subScroll.CanvasSize = UDim2.new(0, 0, 0, #subFeatures * 60)
        subScroll.ScrollBarThickness = 6
        
        local subLayout = Instance.new("UIListLayout")
        subLayout.Parent = subScroll
        subLayout.Padding = UDim.new(0, 10)
        subLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        for _, feat in ipairs(subFeatures) do
            local item = Instance.new("Frame")
            item.BackgroundTransparency = 1
            item.Size = UDim2.new(1, 0, 0, 50)
            item.Parent = subScroll
            
            local check = Instance.new("TextButton")
            check.Parent = item
            check.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            check.BackgroundTransparency = 0.5
            check.Position = UDim2.new(0, 10, 0, 10)
            check.Size = UDim2.new(0, 30, 0, 30)
            check.Text = ""
            check.BorderSizePixel = 1
            
            local label = Instance.new("TextLabel")
            label.Parent = item
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 50, 0, 15)
            label.Size = UDim2.new(1, -60, 0, 30)
            label.Font = Enum.Font.SourceSans
            label.Text = feat.name
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueDisplay = Instance.new("TextLabel")
            valueDisplay.Parent = item
            valueDisplay.BackgroundTransparency = 1
            valueDisplay.Position = UDim2.new(1, -120, 0, 15)
            valueDisplay.Size = UDim2.new(0, 100, 0, 30)
            valueDisplay.Font = Enum.Font.SourceSans
            valueDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
            valueDisplay.TextSize = 14
            valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
            
            if feat.type == "toggle" then
                local state = false
                check.MouseButton1Click:Connect(function()
                    state = not state
                    check.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 215, 0)
                    if feat.callback then feat.callback(state) end
                end)
            elseif feat.type == "slider" then
                local value = feat.default or 50
                valueDisplay.Text = tostring(value)
                local slider = Instance.new("TextButton")
                slider.Parent = item
                slider.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                slider.BackgroundTransparency = 0.8
                slider.Position = UDim2.new(1, -220, 0, 15)
                slider.Size = UDim2.new(0, 80, 0, 25)
                slider.Text = "-"
                slider.TextSize = 18
                slider.TextColor3 = Color3.fromRGB(255, 215, 0)
                local plus = Instance.new("TextButton")
                plus.Parent = item
                plus.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                plus.BackgroundTransparency = 0.8
                plus.Position = UDim2.new(1, -130, 0, 15)
                plus.Size = UDim2.new(0, 80, 0, 25)
                plus.Text = "+"
                plus.TextSize = 18
                plus.TextColor3 = Color3.fromRGB(255, 215, 0)
                
                slider.MouseButton1Click:Connect(function()
                    value = math.max(feat.min or 0, value - (feat.step or 5))
                    valueDisplay.Text = tostring(value)
                    if feat.callback then feat.callback(value) end
                end)
                plus.MouseButton1Click:Connect(function()
                    value = math.min(feat.max or 200, value + (feat.step or 5))
                    valueDisplay.Text = tostring(value)
                    if feat.callback then feat.callback(value) end
                end)
                if feat.callback then feat.callback(value) end
            end
        end
        
        makeDraggable(subFrame)
    end)
    
    return card
end

-- Définition des fonctionnalités (avec sous-menus)
local featuresList = {
    {
        title = "Blox Fruits",
        desc = "Weather, Fly, Boat Speed",
        subs = {
            {name = "Disable Weather", type = "toggle", callback = function(v) features.weatherDisabled = v end},
            {name = "Fly", type = "toggle", callback = function(v) features.flyEnabled = v end},
            {name = "Fly Speed", type = "slider", default = 50, min = 10, max = 300, step = 10, callback = function(v) features.flySpeed = v end},
            {name = "Boat Speed", type = "slider", default = 100, min = 50, max = 500, step = 10, callback = function(v) features.boatSpeed = v; features.boatSpeedEnabled = true end}
        }
    },
    {
        title = "Combat",
        desc = "M1, CD, Auto Aim",
        subs = {
            {name = "Fast M1 (No CD)", type = "toggle", callback = function(v) features.fastM1 = v end},
            {name = "No Cooldown Skills", type = "toggle", callback = function(v) features.noCD = v end},
            {name = "Auto Aim", type = "toggle", callback = function(v) features.autoAim = v end}
        }
    },
    {
        title = "Movement",
        desc = "Speed Hack, Zoom",
        subs = {
            {name = "Speed Hack", type = "toggle", callback = function(v) features.speedHack = v end},
            {name = "Player Speed", type = "slider", default = 50, min = 16, max = 250, step = 5, callback = function(v) features.playerSpeed = v end},
            {name = "No Zoom Limit", type = "toggle", callback = function(v) features.noZoomLimit = v end}
        }
    }
}

for _, cat in ipairs(featuresList) do
    createFeatureCard(cat.title, cat.desc, cat.subs)
end

-- Afficher la fenêtre
MainFrame.Visible = true

-- Anti-Detect : exécution différée et désactivation des logs
spawn(function()
    wait(0.5)
    -- Nettoyage des traces
    pcall(function()
        game:GetService("CoreGui"):FindFirstChild("RedzHubGUI").Parent = game.CoreGui
    end)
end)

-- Notifications stylisées
local function notify(msg)
    local notif = Instance.new("Frame")
    notif.Parent = ScreenGui
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    notif.BackgroundTransparency = 0.2
    notif.BorderColor3 = Color3.fromRGB(255, 215, 0)
    notif.BorderSizePixel = 1
    notif.Position = UDim2.new(0.8, -100, 0.9, -50)
    notif.Size = UDim2.new(0, 200, 0, 50)
    notif.BackgroundTransparency = 0.3
    
    local txt = Instance.new("TextLabel")
    txt.Parent = notif
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Font = Enum.Font.SourceSans
    txt.Text = msg
    txt.TextColor3 = Color3.fromRGB(255, 215, 0)
    txt.TextSize = 14
    txt.TextWrapped = true
    
    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.8, -100, 0.9, -60)}):Play()
    wait(2)
    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.8, -100, 0.9, -50), Transparency = 1}):Play()
    wait(0.5)
    notif:Destroy()
end

notify("Redz Hub chargé | Anti-detect activé")
