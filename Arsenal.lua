local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()


local exploit = {}

exploit.win = DiscordLib:Window("God Exploits")
exploit.serv = exploit.win:Server("Arsenal", "")
exploit.locql = exploit.serv:Channel("Local")


exploit.sldr = exploit.locql:Slider(
    "Speed",
    0,
    1000,
    400,
    function(value)
        getgenv().WalkSpeedValue = value
        local Player = game:GetService("Players").LocalPlayer
        local Humanoid = Player.Character.Humanoid
        
        -- Disconnect any previous connection
        if getgenv().WalkSpeedConnection then
            getgenv().WalkSpeedConnection:Disconnect()
        end

        getgenv().WalkSpeedConnection = Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
            Humanoid.WalkSpeed = getgenv().WalkSpeedValue
        end)
        Humanoid.WalkSpeed = getgenv().WalkSpeedValue
        print(value)
    end
)

exploit.Aim = exploit.serv:Channel("Aimbot")

exploit.sldr2 = exploit.Aim:Slider(
    "FOV",
    1,
    500,
    150,
    function(t)
        getgenv().AimbotFOV = t
        if getgenv().FOVring then
            getgenv().FOVring.Radius = t  -- Update the FOV ring radius
        end
        print(t)
    end
)

function exploit.startAimbot()
    local FOVring = Drawing.new("Circle")
    FOVring.Visible = true
    FOVring.Thickness = 1.5
    FOVring.Radius = getgenv().AimbotFOV or 150  -- Default value
    FOVring.Transparency = 1
    FOVring.Color = Color3.fromRGB(255, 128, 128)
    FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
    getgenv().FOVring = FOVring

    local teamCheck = true
    local fov = getgenv().AimbotFOV or 150
    local smoothing = 1

    local RunService = game:GetService("RunService")

    local function getClosest(cframe)
        local ray = Ray.new(cframe.Position, cframe.LookVector).Unit

        local target = nil
        local mag = math.huge

        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck)) then
                local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude

                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end

        return target
    end

    exploit.loop = RunService.RenderStepped:Connect(function()
        local UserInputService = game:GetService("UserInputService")
        local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        local localPlayer = game.Players.LocalPlayer
        local cam = workspace.CurrentCamera
        local zz = workspace.CurrentCamera.ViewportSize / 2

        if pressed then
            local curTar = getClosest(cam.CFrame)
            if curTar and curTar.Character and curTar.Character:FindFirstChild("Head") then
                local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
                ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
                if (ssHeadPoint - zz).Magnitude < fov then
                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), smoothing)
                end
            end
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
            exploit.loop:Disconnect()
            FOVring:Remove()
        end
    end)
end

exploit.Aim:Toggle(
    "Aimbot",
    false,
    function(bool)
        if bool then
            exploit.startAimbot()
        else
            if exploit.loop then
                exploit.loop:Disconnect()
            end
            if getgenv().FOVring then
                getgenv().FOVring:Remove()
            end
        end
    end
)

local Noclipping = nil
local Clip = true

local function NoclipLoop(character)
    for _, child in pairs(character:GetDescendants()) do
        if child:IsA("BasePart") and child.CanCollide == true then
            child.CanCollide = false
        end
    end
end

local function enableNoclip(speaker)
    Clip = false
    wait(0.1)
    Noclipping = game:GetService("RunService").Stepped:Connect(function()
        if not Clip and speaker.Character then
            NoclipLoop(speaker.Character)
        end
    end)
end

local function disableNoclip()
    if Noclipping then
        Noclipping:Disconnect()
    end
    Clip = true
    -- Reset collision for the character's parts
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, child in pairs(character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = true
            end
        end
    end
end

local function toggleNoclip(speaker)
    if Clip then
        enableNoclip(speaker)
        print("Noclip enabled")
    else
        disableNoclip()
        print("Noclip disabled")
    end
end



exploit.locql:Toggle(
    "No-Clip",
    false,
    function(bool)
        toggleNoclip(game.Players.LocalPlayer)
    end
)

_G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true
_G.ESPEnabled = false

local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false

local LoadCharacter = function(player)
    repeat wait() until player.Character ~= nil
    player.Character:WaitForChild("Humanoid")
    local vHolder = Holder:FindFirstChild(player.Name)
    vHolder:ClearAllChildren()
    local t = NameTag:Clone()
    t.Name = player.Name .. "NameTag"
    t.Enabled = true
    t.Parent = vHolder
    t.Adornee = player.Character:WaitForChild("Head", 5)
    if not t.Adornee then
        return UnloadCharacter(player)
    end
    t.Tag.Text = player.Name
    t.Tag.TextColor3 = Color3.new(player.TeamColor.r, player.TeamColor.g, player.TeamColor.b)
end

local UnloadCharacter = function(player)
    local vHolder = Holder:FindFirstChild(player.Name)
    if vHolder and vHolder:FindFirstChild(player.Name .. "NameTag") ~= nil then
        vHolder:ClearAllChildren()
    end
end

local LoadPlayer = function(player)
    local vHolder = Instance.new("Folder", Holder)
    vHolder.Name = player.Name
    player.CharacterAdded:Connect(function()
        pcall(LoadCharacter, player)
    end)
    player.CharacterRemoving:Connect(function()
        pcall(UnloadCharacter, player)
    end)
    player.Changed:Connect(function(prop)
        if prop == "TeamColor" then
            UnloadCharacter(player)
            wait()
            LoadCharacter(player)
        end
    end)
    if _G.ESPEnabled then
        LoadCharacter(player)
    end
end

local UnloadPlayer = function(player)
    UnloadCharacter(player)
    local vHolder = Holder:FindFirstChild(player.Name)
    if vHolder then
        vHolder:Destroy()
    end
end

local function Toggle(bool)
    _G.ESPEnabled = bool
    if bool then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            LoadPlayer(player)
        end
    else
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            UnloadPlayer(player)
        end
    end
end

local players = game:GetService("Players")
players.PlayerAdded:Connect(function(player)
    if _G.ESPEnabled then
        LoadPlayer(player)
    end
end)

players.PlayerRemoving:Connect(function(player)
    if _G.ESPEnabled then
        UnloadPlayer(player)
    end
end)

game:GetService("Players").LocalPlayer.NameDisplayDistance = 0

exploit.locql:Toggle(
    "Name ESP",
    false,
    function(bool)
        Toggle(bool)
    end
)

local plr = players.LocalPlayer

function esp(target, color)
    if target.Character then
        if not target.Character:FindFirstChild("GetReal") then
            local highlight = Instance.new("Highlight")
            highlight.RobloxLocked = true
            highlight.Name = "GetReal"
            highlight.Adornee = target.Character
            highlight.Transparency = 0.5
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Color3 = color
            highlight.Parent = target.Character
        else
            local highlight = target.Character:FindFirstChild("GetReal")
            highlight.Color3 = color
        end
    end
end

while true do
    for _, player in pairs(players:GetPlayers()) do
        if player ~= plr then
            esp(player, _G.UseTeamColor and player.TeamColor.Color or ((plr.TeamColor == player.TeamColor) and _G.FriendColor or _G.EnemyColor))
        end
    end
    wait(1)
end
