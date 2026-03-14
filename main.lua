-- [[ XENONHUB V17: NEXT-GEN UI & KEY SYSTEM ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local CorrectKey = "XenonHub"
local Features = { AntiFling = true, AutoHit = false, ESP = true, HitboxSize = 6, ReachDistance = 14 }

-- UI Temizleme
pcall(function() if CoreGui:FindFirstChild("XenonSystem") then CoreGui.XenonSystem:Destroy() end end)

local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "XenonSystem"

-- [[ KEY GIRIŞ EKRANI ]] --
local KeyMain = Instance.new("Frame", SG)
KeyMain.Size = UDim2.new(0, 300, 0, 150)
KeyMain.Position = UDim2.new(0.5, -150, 0.4, -75)
KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyMain.BorderSizePixel = 0
Instance.new("UICorner", KeyMain).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", KeyMain).Color = Color3.fromRGB(170, 0, 255)

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "XENON HUB | ANAHTAR SISTEMI"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Anahtari Buraya Yaz..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local KeyBtn = Instance.new("TextButton", KeyMain)
KeyBtn.Size = UDim2.new(0.8, 0, 0, 35)
KeyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
KeyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
KeyBtn.Text = "GIRIS YAP"
KeyBtn.TextColor3 = Color3.new(1, 1, 1)
KeyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)

-- [[ ANA HUB EKRANI ]] --
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.5, -110, 0.4, -140)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(170, 0, 255)

local Banner = Instance.new("TextLabel", Main)
Banner.Size = UDim2.new(1, 0, 0, 50)
Banner.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
Banner.Text = "XENON HUB"
Banner.TextColor3 = Color3.new(1, 1, 1)
Banner.Font = Enum.Font.GothamBlack
Banner.TextSize = 22
Instance.new("UICorner", Banner).CornerRadius = UDim.new(0, 15)

local function CreateToggle(text, pos, feat)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Features[feat] and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        Features[feat] = not Features[feat]
        btn.BackgroundColor3 = Features[feat] and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
end

CreateToggle("CELIK DUVAR (FLY-FIX)", UDim2.new(0.075, 0, 0.25, 0), "AntiFling")
CreateToggle("SMART AUTO-HIT", UDim2.new(0.075, 0, 0.42, 0), "AutoHit")
CreateToggle("XENON ESP", UDim2.new(0.075, 0, 0.59, 0), "ESP")

-- Key Kontrol
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyMain:Destroy()
        Main.Visible = true
        Main.Draggable = true
        Main.Active = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "HATALI ANAHTAR!"
    end
end)

-- Ana Script Döngüsü
RunService.RenderStepped:Connect(function()
    if not Main.Visible then return end
    pcall(function()
        local myHrp = LP.Character.HumanoidRootPart
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = Vector3.new(Features.HitboxSize, Features.HitboxSize, Features.HitboxSize)
                hrp.Transparency = 0.8
                hrp.Color = Color3.fromRGB(170, 0, 255)
                
                if Features.AutoHit and (myHrp.Position - hrp.Position).Magnitude <= Features.ReachDistance then
                    local tool = LP.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
                
                local high = v.Character:FindFirstChild("XenonHigh") or Instance.new("Highlight", v.Character)
                high.Name = "XenonHigh"
                high.Enabled = Features.ESP
                high.FillColor = Color3.fromRGB(170, 0, 255)
            end
        end
        if Features.AntiFling and myHrp.Velocity.Magnitude > 35 then
            myHrp.Velocity = Vector3.new(0, myHrp.Velocity.Y, 0)
            myHrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end)
end)
