local fenv = getfenv()
local Lighting = game:GetService('Lighting')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')

-- Safely remove existing GUI if present
local existingGui = game.CoreGui:FindFirstChild('ASAntiLagGUI')
if existingGui then
    existingGui:Destroy()
end

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'ASAntiLagGUI'
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService('Players').LocalPlayer.PlayerGui

local mainFrame = Instance.new('Frame')
mainFrame.Draggable = true
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.Active = true
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black interior
mainFrame.Size = UDim2.new(0, 220, 0, 125)
mainFrame.Parent = screenGui

local frameCorner = Instance.new('UICorner')
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- Animated red outline
local stroke = Instance.new('UIStroke')
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 0, 0) -- Red outline
stroke.Parent = mainFrame

-- Animation for the red outline
local float = 0
RunService.RenderStepped:Connect(function(dt)
    float = (float + dt * 2) % (math.pi * 2)
    
    -- Pulse effect - outline thickness varies
    local pulseThickness = 2 + math.sin(float * 4) * 1.5
    stroke.Thickness = pulseThickness
    
    -- Color intensity pulse
    local intensity = 0.5 + math.sin(float * 6) * 0.5
    stroke.Color = Color3.fromRGB(255, math.floor(100 * intensity), math.floor(50 * intensity))
end)

local titleLabel = Instance.new('TextLabel')
titleLabel.Font = Enum.Font.LuckiestGuy
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
titleLabel.Text = 'Meloska AntiLag'
titleLabel.TextSize = 16
titleLabel.Size = UDim2.new(1, 0, 0, 26)
titleLabel.Parent = mainFrame

local antiLagButton = Instance.new('TextButton')
antiLagButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black interior
antiLagButton.Font = Enum.Font.LuckiestGuy
antiLagButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
antiLagButton.Position = UDim2.new(0.05, 0, 0.33, 0)
antiLagButton.Text = 'ANTI LAG: OFF'
antiLagButton.TextSize = 14
antiLagButton.Size = UDim2.new(0.9, 0, 0, 34)
antiLagButton.Parent = mainFrame

local antiLagCorner = Instance.new('UICorner')
antiLagCorner.CornerRadius = UDim.new(0, 8)
antiLagCorner.Parent = antiLagButton

-- Add red outline to button
local antiLagStroke = Instance.new('UIStroke')
antiLagStroke.Thickness = 1.5
antiLagStroke.Color = Color3.fromRGB(255, 0, 0) -- Red outline
antiLagStroke.Parent = antiLagButton

local ultraButton = Instance.new('TextButton')
ultraButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black interior
ultraButton.Font = Enum.Font.LuckiestGuy
ultraButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
ultraButton.Position = UDim2.new(0.05, 0, 0.65, 0)
ultraButton.Text = 'ULTRA MODE: OFF'
ultraButton.TextSize = 13
ultraButton.Size = UDim2.new(0.9, 0, 0, 30)
ultraButton.Parent = mainFrame

local ultraCorner = Instance.new('UICorner')
ultraCorner.CornerRadius = UDim.new(0, 8)
ultraCorner.Parent = ultraButton

-- Add red outline to ultra button
local ultraStroke = Instance.new('UIStroke')
ultraStroke.Thickness = 1.5
ultraStroke.Color = Color3.fromRGB(255, 0, 0) -- Red outline
ultraStroke.Parent = ultraButton

-- Helper function to apply anti-lag settings to an instance
local function applyAntiLag(instance)
    if instance:IsA('ParticleEmitter') then
        instance.Enabled = false
    elseif instance:IsA('Decal') then
        instance.Transparency = 1
    elseif instance:IsA('BasePart') then
        instance.Material = Enum.Material.Plastic
        instance.Reflectance = 0
        instance.CastShadow = false
    end
end

local antiLagEnabled = false

antiLagButton.MouseButton1Click:Connect(function()
    antiLagEnabled = not antiLagEnabled
    antiLagButton.Text = antiLagEnabled and 'ANTI LAG: ON' or 'ANTI LAG: OFF'
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') then
            child.Enabled = false
        end
    end
    
    for _, descendant in pairs(Workspace:GetDescendants()) do
        applyAntiLag(descendant)
    end

    Workspace.DescendantAdded:Connect(function(descendant)
        applyAntiLag(descendant)
    end)
end)

ultraButton.MouseButton1Click:Connect(function()
    ultraButton.Text = 'ULTRA MODE: ON'
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') then
            child.Enabled = false
        end
    end
    
    for _, descendant in pairs(Workspace:GetDescendants()) do
        applyAntiLag(descendant)
        if descendant:IsA('Accessory') then
            descendant:Destroy()
        end
    end
end)

print('âœ… A&S ANTI LAG GUI LOADED')
