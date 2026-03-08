-- [[ XENONHUB: STEAL A BRAINROT - FULL MENU SOURCE ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
    MainColor = Color3.fromRGB(20, 5, 35),
    AccentColor = Color3.fromRGB(150, 0, 255),
    TextColor = Color3.fromRGB(255, 255, 255)
}

local Features = { AntiRagdoll = false, GhostWalk = false }

-- Eski menüyü sil
pcall(function() if CoreGui:FindFirstChild("XenonHub") then CoreGui.XenonHub:Destroy() end end)

-- MENÜYÜ OLUŞTUR
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "XenonHub"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 200, 0, 200)
Main.Position = UDim2.new(0.5, -100, 0.4, -100)
Main.BackgroundColor3 = Theme.MainColor
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Theme.AccentColor

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Theme.AccentColor
Title.Text = "XenonHub"
Title.TextColor3 = Theme.TextColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local function CreateToggle(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Theme.TextColor
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = active and Theme.AccentColor or Color3.fromRGB(40, 15, 60)
        callback(active)
    end)
end

-- Butonları Menüye Ekle
CreateToggle("Anti-Ragdoll", UDim2.new(0.075, 0, 0.3, 0), function(val) Features.AntiRagdoll = val end)
CreateToggle("Ghost Movement", UDim2.new(0.075, 0, 0.55, 0), function(val) Features.GhostWalk = val end)

-- ARKA PLAN ÇALIŞAN HİLE KODU
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            if Features.AntiRagdoll then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                if hum.Sit then hum.Sit = false end
            end
            if Features.GhostWalk then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    task.wait()
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                hum.PlatformStand = false
                if char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end)
