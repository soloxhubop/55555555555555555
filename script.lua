local Lighting = game:GetService('Lighting')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')

local existingGui = game.CoreGui:FindFirstChild('MelAntiLagGUI')
if existingGui then existingGui:Destroy() end

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'MelAntiLagGUI'
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new('Frame')
mainFrame.Draggable = true
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.Active = true
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Size = UDim2.new(0, 210, 0, 115)
mainFrame.Parent = screenGui
Instance.new('UICorner', mainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new('UIStroke')
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.6
stroke.Parent = mainFrame

local titleLabel = Instance.new('TextLabel')
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = 'Meloska AntiLag'
titleLabel.TextSize = 13
titleLabel.Size = UDim2.new(1, 0, 0, 28)
titleLabel.Position = UDim2.new(0, 0, 0, 2)
titleLabel.Parent = mainFrame

local function makeBtn(text, yPos)
    local btn = Instance.new('TextButton')
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.BackgroundTransparency = 0.2
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.Text = text
    btn.TextSize = 12
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Parent = mainFrame
    Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 7)
    local s = Instance.new('UIStroke', btn)
    s.Thickness = 1.2
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Transparency = 0.7
    return btn, s
end

local antiLagButton, antiLagStroke = makeBtn('ANTI LAG: OFF', 32)
local ultraButton, ultraStroke = makeBtn('ULTRA MODE: OFF', 72)

local function applyAntiLag(instance)
    if instance:IsA('ParticleEmitter') then
        instance.Enabled = false
    elseif instance:IsA('Decal') then
        instance.Transparency = 1
    elseif instance:IsA('BasePart') then
        instance.Material = Enum.Material.Plastic
        instance.Reflectance = 0
        instance.CastShadow = false
    elseif instance:IsA('SpecialMesh') then
        -- keep
    end
end

local function disableAnimations()
    -- ferma tutte le animazioni di tutti i player
    for _, p in pairs(Players:GetPlayers()) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass('Humanoid')
            if hum then
                local animator = hum:FindFirstChildOfClass('Animator')
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0)
                    end
                    -- blocca future animazioni
                    animator.AnimationPlayed:Connect(function(track)
                        track:Stop(0)
                    end)
                end
            end
        end
    end
end

local function setNightSky()
    -- cielo scuro tipo notte
    Lighting.ClockTime = 0
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.fromRGB(10, 10, 10)
    Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 10)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA('Sky') then child:Destroy() end
        if child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') or child:IsA('ColorCorrectionEffect') then
            child.Enabled = false
        end
    end
end

local antiLagEnabled = false

antiLagButton.MouseButton1Click:Connect(function()
    antiLagEnabled = not antiLagEnabled
    if antiLagEnabled then
        antiLagButton.Text = 'ANTI LAG: ON'
        antiLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        antiLagStroke.Transparency = 0.2
        setNightSky()
        disableAnimations()
        for _, d in pairs(Workspace:GetDescendants()) do applyAntiLag(d) end
        Workspace.DescendantAdded:Connect(function(d) applyAntiLag(d) end)
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() disableAnimations() end)
        end)
    else
        antiLagButton.Text = 'ANTI LAG: OFF'
        antiLagButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        antiLagStroke.Transparency = 0.7
    end
end)

ultraButton.MouseButton1Click:Connect(function()
    ultraButton.Text = 'ULTRA MODE: ON'
    ultraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ultraStroke.Transparency = 0.2
    setNightSky()
    disableAnimations()
    for _, d in pairs(Workspace:GetDescendants()) do
        applyAntiLag(d)
        if d:IsA('Accessory') then d:Destroy() end
        if d:IsA('ParticleEmitter') or d:IsA('Trail') or d:IsA('Beam') then
            d.Enabled = false
        end
    end
end)

print('Meloska AntiLag loaded')
