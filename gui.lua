
-- NINJA DEMON - MTN
-- Roblox Studio : StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NinjaDemonMTN"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local WHITE = Color3.fromRGB(255,255,255)
local BLACK = Color3.fromRGB(0,0,0)
local GREY = Color3.fromRGB(145,145,145)

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = object
end

local function outline(object, thickness)
    local s = Instance.new("UIStroke")
    s.Color = WHITE
    s.Thickness = thickness or 2
    s.Parent = object
end

-- MENU PRINCIPAL
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(330,350)
menu.Position = UDim2.new(0.5,-165,0.5,-175)
menu.BackgroundColor3 = BLACK
menu.BorderSizePixel = 0
menu.Visible = true
menu.Parent = gui
corner(menu,16)
outline(menu,2)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.fromOffset(10,5)
title.BackgroundTransparency = 1
title.Text = "NINJA DEMON"
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBlack
title.TextSize = 25
title.Parent = menu

local function makeLabel(text,y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.38,0,0,35)
    l.Position = UDim2.fromOffset(12,y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = WHITE
    l.Font = Enum.Font.GothamBold
    l.TextSize = 15
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = menu
end

local function makeBox(placeholder,y)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(0.56,0,0,35)
    b.Position = UDim2.new(0.41,0,0,y)
    b.BackgroundColor3 = BLACK
    b.TextColor3 = WHITE
    b.PlaceholderColor3 = GREY
    b.PlaceholderText = placeholder
    b.Text = ""
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.ClearTextOnFocus = false
    b.Parent = menu
    corner(b,9)
    outline(b,1.5)
    return b
end

-- WALK SPEED
makeLabel("WalkSpeed:",55)
local speedBox = makeBox("SET: number",55)

-- POWER JUMP
makeLabel("PowerJump:",105)
local jumpBox = makeBox("SET: number",105)

-- TP PLAYER
makeLabel("TP Player:",155)
local playerBox = makeBox("pseudo:",155)

local function makeButton(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-24,0,38)
    b.Position = UDim2.fromOffset(12,y)
    b.BackgroundColor3 = BLACK
    b.TextColor3 = WHITE
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.Parent = menu
    corner(b,9)
    outline(b,1.5)
    return b
end

local tpButton = makeButton("TP SET PLAYER",200)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,30)
status.Position = UDim2.fromOffset(10,244)
status.BackgroundTransparency = 1
status.Text = "NINJA DEMON READY"
status.TextColor3 = GREY
status.Font = Enum.Font.GothamBold
status.TextSize = 12
status.Parent = menu

local closeButton = makeButton("FERMER",280)
closeButton.Size = UDim2.new(1,-24,0,35)

-- WALK SPEED
speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if value and humanoid then
        humanoid.WalkSpeed = math.clamp(value,0,100)
        status.Text = "WALKSPEED : "..value
    else
        status.Text = "NOMBRE INVALIDE"
    end
end)

-- POWER JUMP
jumpBox.FocusLost:Connect(function()
    local value = tonumber(jumpBox.Text)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if value and humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = math.clamp(value,0,200)
        status.Text = "POWER JUMP : "..value
    else
        status.Text = "NOMBRE INVALIDE"
    end
end)

-- RECHERCHE DU JOUEUR
local function findPlayer(text)
    local search = string.lower(text)
    local matches = {}

    for _, target in ipairs(Players:GetPlayers()) do
        if string.lower(target.Name) == search then
            return target, false
        end

        if string.sub(string.lower(target.Name),1,#search) == search then
            table.insert(matches,target)
        end
    end

    if #matches == 1 then
        return matches[1], false
    end

    return nil, #matches > 1
end

tpButton.MouseButton1Click:Connect(function()
    local search = playerBox.Text

    if search == "" then
        status.Text = "ENTRE UN PSEUDO"
        return
    end

    local target, ambiguous = findPlayer(search)

    if ambiguous then
        status.Text = "PLUSIEURS JOUEURS TROUVES"
        return
    end

    if not target then
        status.Text = "JOUEUR INTROUVABLE"
        return
    end

    local targetCharacter = target.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if targetRoot and root then
        root.CFrame = targetRoot.CFrame * CFrame.new(0,0,3)
        status.Text = "TELEPORTATION EFFECTUEE"
    else
        status.Text = "PERSONNAGE NON DISPONIBLE"
    end
end)

-- PETIT BOUTON FLOTTANT
local floating = Instance.new("TextButton")
floating.Name = "NinjaButton"
floating.Size = UDim2.fromOffset(55,55)
floating.Position = UDim2.new(0,15,0.65,0)
floating.BackgroundColor3 = BLACK
floating.Text = "ND"
floating.TextColor3 = WHITE
floating.Font = Enum.Font.GothamBlack
floating.TextSize = 21
floating.Parent = gui
corner(floating,50)
outline(floating,2)

-- Déplacement au doigt ou à la souris
local dragging = false
local moved = false
local dragStart
local startPosition
local activeInput

floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPosition = floating.Position
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        if delta.Magnitude > 6 then
            moved = true
        end

        floating.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == activeInput
    or input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

floating.Activated:Connect(function()
    if not moved then
        menu.Visible = not menu.Visible
    end
end)

closeButton.Activated:Connect(function()
    menu.Visible = false
end)

print("NINJA DEMON MTN loaded")
