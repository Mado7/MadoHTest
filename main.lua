-- MadoHub | Slap Tower ✨ Created by Mado

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
end)

local Window = Rayfield:CreateWindow({
    Name = "MadoHub | Slap Tower",
    LoadingTitle = "MadoHub",
    LoadingSubtitle = "by Mado",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MadoHub",
        FileName = "SlapTower"
    },
    Theme = "Default"
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        humanoid.WalkSpeed = value
    end
})

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(value)
        humanoid.JumpPower = value
    end
})

local infJump = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(value)
        infJump = value
    end
})

UIS.JumpRequest:Connect(function()
    if infJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Mobile-Friendly Fly
local flyConn, bodyGyro, bodyVel
MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(state)
        if state then
            bodyGyro = Instance.new("BodyGyro", root)
            bodyGyro.P = 9e4
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = root.CFrame

            bodyVel = Instance.new("BodyVelocity", root)
            bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVel.Velocity = Vector3.zero

            flyConn = runService.RenderStepped:Connect(function()
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                bodyVel.Velocity = humanoid.MoveDirection * 100
            end)
        else
            if flyConn then flyConn:Disconnect() end
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVel then bodyVel:Destroy() end
        end
    end
})

-- NoClip
local noclipConn
MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(value)
        if value then
            noclipConn = runService.Stepped:Connect(function()
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end
})

-- God Mode Toggleable
local godConn
MainTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(state)
        if state then
            godConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                humanoid.Health = math.huge
            end)
            humanoid.Health = math.huge
        elseif godConn then
            godConn:Disconnect()
        end
    end
})

-- Teleport to Player (Live Refresh)
local playerDropdown
local function refreshPlayers()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(names, p.Name)
        end
    end
    if playerDropdown then
        playerDropdown:SetOptions(names)
    end
end

playerDropdown = MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = nil,
    Callback = function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
})

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
task.defer(refreshPlayers)

-- Teleport Tab
local TeleTab = Window:CreateTab("Teleport", 4483362458)
TeleTab:CreateButton({
    Name = "Win the Game",
    Callback = function()
        root.CFrame = CFrame.new(
            -177.241547, 769.303284, 54.1927948,
            0.0165336356, -4.86685963e-08, 0.999863327,
            -3.10548164e-14, 1, 4.86752505e-08,
            -0.999863327, -8.04809885e-10, 0.0165336356
        )
    end
})

-- Fun Tab (All 4 slaps)
local FunTab = Window:CreateTab("Fun", 4483362458)
FunTab:CreateButton({
    Name = "Get All Free Slaps",
    Callback = function()
        local cframes = {
            CFrame.new(-22.268858, -10.6966152, 106.038391, -0.998899937, 0, 0.0468926057, 0, 1, 0, -0.0468926057, 0, -0.998899937),
            CFrame.new(-21.0327148, -8.57869434, 19.7716141, 0, 0, 1, 0, 1, 0, -1, 0, 0),
            CFrame.new(-186.058868, 771.421936, 68.3176346, 0, 0, 1, 0, 1, 0, -1, 0, 0),
            CFrame.new(185.226074, -8.57869244, 90.5352173, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        }
        local old = root.CFrame
        for _, cf in ipairs(cframes) do
            root.CFrame = cf
            task.wait(0.5)
        end
        root.CFrame = old
    end
})

-- Info Tab
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateParagraph({
    Title = "MadoHub | Slap Tower",
    Content = "This script was made by Mado.\nJoin our Discord to stay updated on supported games or patches."
})
InfoTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/yourserver")
        Rayfield:Notify({ Title = "Discord", Content = "Link copied to clipboard.", Duration = 4 })
    end
})

-- Load Config
Rayfield:LoadConfiguration()
