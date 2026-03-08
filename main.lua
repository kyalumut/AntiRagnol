-- [[ XENONHUB V12: STEAL A BRAINROT ULTIMATE ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Tasarım Ayarları
local Theme = {
    Main = Color3.fromRGB(15, 15, 25),
    Accent = Color3.fromRGB(170, 0, 255),
    Outline = Color3.fromRGB(60, 60, 80),
    Text = Color3.fromRGB(255, 255, 255)
}

local Features = { AntiFling = false, GhostMovement = false }

-- Eski UI'yı temizle
pcall(function() if CoreGui:FindFirstChild("XenonUltra") then CoreGui.XenonUltra:Destroy() end end)

-- [[ MODERN UI TASARIMI ]] --
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "XenonUltra"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.5, -110, 0.4, -90)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Cam Efekti (Outline)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Theme.Accent
Stroke.Thickness = 1.5
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Başlık
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "XENON HUB"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Buton Yapıcı
local function AddButton(text, pos, feat)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        Features[feat] = not Features[feat]
        btn.BackgroundColor3 = Features[feat] and Theme.Accent or Color3.fromRGB(30, 30, 45)
        btn.TextColor3 = Features[feat] and Color3.new(1,1,1) or Theme.Text
    end)
end

AddButton("Çelik Duvar (Anti-Uçma)", UDim2.new(0.075, 0, 0.3, 0), "AntiFling")
AddButton("Ghost Walk (Yerde Yürü)", UDim2.new(0.075, 0, 0.55, 0), "GhostMovement")

-- [[ ANA FİZİK MOTORU ]] --
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local hum = char.Humanoid

            -- 1. ÇELİK DUVAR SİSTEMİ (Vurulduğunda uçmamak için)
            if Features.AntiFling then
                -- Dışarıdan gelen devasa hızları (Fling) her saniye sıfırlar
                if root.Velocity.Magnitude > 40 then
                    root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                end
                root.RotVelocity = Vector3.new(0, 0, 0) -- Takla atmayı engeller
                
                -- Karakterin devrilmesini (Ragdoll) engelleme
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                if hum.Sit then hum.Sit = false end
            end

            -- 2. GHOST MOVEMENT (Yerdeyken akıcı hareket)
            if Features.GhostMovement then
                local state = hum:GetState()
                -- Eğer karakter yerde sürünüyorsa veya physics modundaysa
                if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum.PlatformStand = false
                    
                    -- Hareket yönüne doğru zorla hız verir (Yerde yürümeyi sağlayan ana kısım)
                    if hum.MoveDirection.Magnitude > 0 then
                        root.Velocity = hum.MoveDirection * 20 -- Yerdeki yürüme hızı
                    end
                end
            end
        end
    end)
end)
