-- [[ XENONHUB V16: ULTRA ESP, HITBOX & SMART AUTO-HIT ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local Features = {
    AntiFling = true,
    AutoHit = false,
    ESP = true,
    HitboxSize = 6,
    ReachDistance = 14
}

-- UI Temizliği
pcall(function() if CoreGui:FindFirstChild("XenonUltra") then CoreGui.XenonUltra:Destroy() end end)

-- [[ MODERN MENU ]] --
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "XenonUltra"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 200, 0, 220)
Main.Position = UDim2.new(0.5, -100, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(170, 0, 255)

local function CreateToggle(text, pos, feat)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Features[feat] and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        Features[feat] = not Features[feat]
        btn.BackgroundColor3 = Features[feat] and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
end

CreateToggle("CELIK DUVAR (ANTI-FLING)", UDim2.new(0.075, 0, 0.15, 0), "AntiFling")
CreateToggle("SMART AUTO-HIT (YAKINDA)", UDim2.new(0.075, 0, 0.35, 0), "AutoHit")
CreateToggle("GHOST ESP (DUVAR ARKASI)", UDim2.new(0.075, 0, 0.55, 0), "ESP")

-- [[ ESP FONKSIYONU ]] --
local function CreateESP(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "XenonESP"
    Highlight.Parent = CoreGui
    Highlight.FillColor = Color3.fromRGB(170, 0, 255)
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    
    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and Features.ESP then
            Highlight.Adornee = plr.Character
            Highlight.Enabled = true
        else
            Highlight.Enabled = false
        end
    end)
end

-- Mevcut ve yeni oyunculara ESP ekle
for _, v in pairs(Players:GetPlayers()) do if v ~= LP then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- [[ ANA DÖNGÜ ]] --
RunService.RenderStepped:Connect(function()
    pcall(function()
        local myChar = LP.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myHrp = myChar.HumanoidRootPart

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                
                -- Hitbox Ayarı
                hrp.Size = Vector3.new(Features.HitboxSize, Features.HitboxSize, Features.HitboxSize)
                hrp.Transparency = 0.8
                hrp.Color = Color3.fromRGB(170, 0, 255)
                hrp.CanCollide = false

                -- Akıllı Vuruş
                if Features.AutoHit then
                    local dist = (myHrp.Position - hrp.Position).Magnitude
                    if dist <= Features.ReachDistance then
                        local tool = myChar:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end

        -- Anti-Fling
        if Features.AntiFling then
            if myHrp.Velocity.Magnitude > 35 then
                myHrp.Velocity = Vector3.new(0, myHrp.Velocity.Y, 0)
                myHrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)
