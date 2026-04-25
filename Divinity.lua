-- // Divinity | Combat Initiation
-- // Fluent UI Edition | v15.12.0
-- // By Divine

-- ============================================================
-- // KEY SYSTEM (obfuscated)
-- ============================================================
local function _dk()
    local p = {"jUhCI","lHXXa","fjAtKg","gAQHku","dOLrsR","tBzO"}
    local s = ""
    for i = 1, #p do s = s .. p[i] end
    return s
end

-- User definitions
-- Format: [username_lower] = { key = "KEY", bypass = true/false }
local USER_CONFIG = {
    -- Owner accounts — instant bypass, no key needed
    ["divonz6"]        = { bypass = true  },
    ["youssef_marcos"] = { bypass = true  },
    ["divine012902"]   = { bypass = true  },
    -- Friend account — has own key
    ["noaukaj"]        = { bypass = false, key = "MEOWL" },
}

local VALID_KEY  = _dk()
local KEY_FILE   = "Divinity_Key.txt"
local OWNER_FILE = "Divinity_Owner.txt" -- lets owner force-show key screen

-- ============================================================
-- // SERVICES
-- ============================================================
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local Lighting           = game:GetService("Lighting")
local LocalPlayer        = Players.LocalPlayer

-- ============================================================
-- // FIGURE OUT WHO IS RUNNING THIS
-- ============================================================
local username     = LocalPlayer.Name:lower()
local userConfig   = USER_CONFIG[username]
local isOwner      = userConfig and userConfig.bypass == true
local isFriend     = userConfig and userConfig.bypass == false
local friendKey    = isFriend and userConfig.key or nil

-- Owner can force show key screen by having Divinity_Owner.txt = "showkey"
local ownerForcesKey = false
if isOwner and isfile and isfile(OWNER_FILE) then
    ownerForcesKey = readfile(OWNER_FILE) == "showkey"
end

-- ============================================================
-- // SUPPORTED GAMES
-- ============================================================
local SUPPORTED_IDS = {
    [6462529301]  = true,
    [13559635034] = true,
}
local currentGameName = "Unknown"
local isSupported     = false
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    currentGameName = info and info.Name or tostring(game.PlaceId)
    isSupported = SUPPORTED_IDS[game.PlaceId] == true
end)

-- ============================================================
-- // KEY SYSTEM UI BUILDER
-- ============================================================
local function buildKeyUI(keyToCheck, keyFile, titleText, subtitleText)
    -- Check saved key first
    if isfile and isfile(keyFile) then
        local saved = readfile(keyFile)
        if saved == keyToCheck then return true end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DivKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then ScreenGui.Parent = gethui()
        else ScreenGui.Parent = game:GetService("CoreGui") end
    end)

    local Backdrop = Instance.new("Frame", ScreenGui)
    Backdrop.Size = UDim2.new(1,0,1,0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Backdrop.BackgroundTransparency = 0.5
    Backdrop.BorderSizePixel = 0
    Backdrop.ZIndex = 1

    -- Unsupported game warning
    if not isSupported then
        local WCard = Instance.new("Frame", ScreenGui)
        WCard.Size = UDim2.fromOffset(500,200)
        WCard.Position = UDim2.new(0.5,-250,0.5,-100)
        WCard.BackgroundColor3 = Color3.fromRGB(20,20,20)
        WCard.BorderSizePixel = 0
        WCard.ZIndex = 3
        Instance.new("UICorner", WCard).CornerRadius = UDim.new(0,10)
        local WS = Instance.new("UIStroke", WCard)
        WS.Color = Color3.fromRGB(200,70,50)
        WS.Thickness = 1.5
        local WAccent = Instance.new("Frame", WCard)
        WAccent.Size = UDim2.new(1,0,0,3)
        WAccent.BackgroundColor3 = Color3.fromRGB(220,70,50)
        WAccent.BorderSizePixel = 0
        WAccent.ZIndex = 4
        Instance.new("UICorner", WAccent).CornerRadius = UDim.new(0,10)
        local WTitle = Instance.new("TextLabel", WCard)
        WTitle.Size = UDim2.new(1,0,0,36)
        WTitle.Position = UDim2.fromOffset(0,12)
        WTitle.BackgroundTransparency = 1
        WTitle.Text = "Unsupported Game Detected"
        WTitle.TextColor3 = Color3.fromRGB(255,90,60)
        WTitle.Font = Enum.Font.GothamBold
        WTitle.TextSize = 19
        WTitle.ZIndex = 4
        local WBody = Instance.new("TextLabel", WCard)
        WBody.Size = UDim2.new(1,-40,0,72)
        WBody.Position = UDim2.fromOffset(20,52)
        WBody.BackgroundTransparency = 1
        WBody.Text = "You are playing an unsupported game right now.\nThe supported games are: Combat Initiation\nBut you are playing: " .. currentGameName
        WBody.TextColor3 = Color3.fromRGB(190,190,190)
        WBody.Font = Enum.Font.Gotham
        WBody.TextSize = 14
        WBody.TextWrapped = true
        WBody.TextXAlignment = Enum.TextXAlignment.Left
        WBody.ZIndex = 4
        local WBtn = Instance.new("TextButton", WCard)
        WBtn.Size = UDim2.new(1,-40,0,36)
        WBtn.Position = UDim2.fromOffset(20,148)
        WBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        WBtn.TextColor3 = Color3.fromRGB(190,190,190)
        WBtn.Text = "I don't care."
        WBtn.Font = Enum.Font.Gotham
        WBtn.TextSize = 14
        WBtn.BorderSizePixel = 0
        WBtn.ZIndex = 4
        Instance.new("UICorner", WBtn).CornerRadius = UDim.new(0,7)
        local dismissed = false
        WBtn.MouseButton1Click:Connect(function()
            dismissed = true
            TweenService:Create(WCard, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
            task.wait(0.25) WCard:Destroy()
        end)
        while not dismissed do task.wait(0.05) end
    end

    -- Key card
    local Card = Instance.new("Frame", ScreenGui)
    Card.Size = UDim2.fromOffset(460,290)
    Card.Position = UDim2.new(0.5,-230,0.5,-145)
    Card.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Card.BorderSizePixel = 0
    Card.ZIndex = 2
    Card.BackgroundTransparency = 1
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,10)
    local CS = Instance.new("UIStroke", Card)
    CS.Color = Color3.fromRGB(50,50,50)
    CS.Thickness = 1

    local SideBar = Instance.new("Frame", Card)
    SideBar.Size = UDim2.new(0,3,1,0)
    SideBar.BackgroundColor3 = Color3.fromRGB(50,120,255)
    SideBar.BorderSizePixel = 0
    SideBar.ZIndex = 3
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,10)

    local Header = Instance.new("Frame", Card)
    Header.Size = UDim2.new(1,0,0,52)
    Header.BackgroundColor3 = Color3.fromRGB(24,24,24)
    Header.BorderSizePixel = 0
    Header.ZIndex = 3
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

    local HTitle = Instance.new("TextLabel", Header)
    HTitle.Size = UDim2.new(1,-20,0,28)
    HTitle.Position = UDim2.fromOffset(14,6)
    HTitle.BackgroundTransparency = 1
    HTitle.Text = titleText or "Divinity"
    HTitle.TextColor3 = Color3.fromRGB(255,255,255)
    HTitle.Font = Enum.Font.GothamBold
    HTitle.TextSize = 16
    HTitle.TextXAlignment = Enum.TextXAlignment.Left
    HTitle.ZIndex = 4

    local HSub = Instance.new("TextLabel", Header)
    HSub.Size = UDim2.new(1,-20,0,18)
    HSub.Position = UDim2.fromOffset(14,28)
    HSub.BackgroundTransparency = 1
    HSub.Text = subtitleText or "Key System  —  discord.gg/wAAHbUg46x"
    HSub.TextColor3 = Color3.fromRGB(110,110,110)
    HSub.Font = Enum.Font.Gotham
    HSub.TextSize = 12
    HSub.TextXAlignment = Enum.TextXAlignment.Left
    HSub.ZIndex = 4

    local IL = Instance.new("TextLabel", Card)
    IL.Size = UDim2.new(1,-40,0,16)
    IL.Position = UDim2.fromOffset(20,62)
    IL.BackgroundTransparency = 1
    IL.Text = "LICENSE KEY"
    IL.TextColor3 = Color3.fromRGB(90,90,90)
    IL.TextXAlignment = Enum.TextXAlignment.Left
    IL.Font = Enum.Font.GothamBold
    IL.TextSize = 11
    IL.ZIndex = 3

    local IBG = Instance.new("Frame", Card)
    IBG.Size = UDim2.new(1,-40,0,42)
    IBG.Position = UDim2.fromOffset(20,82)
    IBG.BackgroundColor3 = Color3.fromRGB(28,28,28)
    IBG.BorderSizePixel = 0
    IBG.ZIndex = 3
    Instance.new("UICorner", IBG).CornerRadius = UDim.new(0,7)
    local IS = Instance.new("UIStroke", IBG)
    IS.Color = Color3.fromRGB(48,48,48)
    IS.Thickness = 1

    local IBox = Instance.new("TextBox", IBG)
    IBox.Size = UDim2.new(1,-18,1,0)
    IBox.Position = UDim2.fromOffset(9,0)
    IBox.BackgroundTransparency = 1
    IBox.TextColor3 = Color3.fromRGB(220,220,220)
    IBox.PlaceholderText = "Paste your key here..."
    IBox.PlaceholderColor3 = Color3.fromRGB(60,60,60)
    IBox.Font = Enum.Font.Code
    IBox.TextSize = 13
    IBox.ClearTextOnFocus = false
    IBox.ZIndex = 4

    local Divider = Instance.new("Frame", Card)
    Divider.Size = UDim2.new(1,-40,0,1)
    Divider.Position = UDim2.fromOffset(20,134)
    Divider.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 3

    local SL = Instance.new("TextLabel", Card)
    SL.Size = UDim2.new(1,-40,0,18)
    SL.Position = UDim2.fromOffset(20,140)
    SL.BackgroundTransparency = 1
    SL.Text = ""
    SL.TextXAlignment = Enum.TextXAlignment.Left
    SL.TextColor3 = Color3.fromRGB(255,80,80)
    SL.Font = Enum.Font.Gotham
    SL.TextSize = 12
    SL.ZIndex = 3

    local SBtn = Instance.new("TextButton", Card)
    SBtn.Size = UDim2.new(1,-40,0,40)
    SBtn.Position = UDim2.fromOffset(20,162)
    SBtn.BackgroundColor3 = Color3.fromRGB(50,120,255)
    SBtn.TextColor3 = Color3.fromRGB(255,255,255)
    SBtn.Text = "Unlock Divinity"
    SBtn.Font = Enum.Font.GothamBold
    SBtn.TextSize = 14
    SBtn.BorderSizePixel = 0
    SBtn.AutoButtonColor = false
    SBtn.ZIndex = 3
    Instance.new("UICorner", SBtn).CornerRadius = UDim.new(0,7)

    local DiscordBtn = Instance.new("TextButton", Card)
    DiscordBtn.Size = UDim2.new(1,-40,0,26)
    DiscordBtn.Position = UDim2.fromOffset(20,212)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    DiscordBtn.TextColor3 = Color3.fromRGB(90,90,90)
    DiscordBtn.Text = "Get key at discord.gg/wAAHbUg46x"
    DiscordBtn.Font = Enum.Font.Gotham
    DiscordBtn.TextSize = 12
    DiscordBtn.BorderSizePixel = 0
    DiscordBtn.ZIndex = 3
    Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0,7)
    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("discord.gg/wAAHbUg46x") end
    end)

    -- Owner only: button to disable force-key next time
    if isOwner and ownerForcesKey then
        local ResetBtn = Instance.new("TextButton", Card)
        ResetBtn.Size = UDim2.new(1,-40,0,26)
        ResetBtn.Position = UDim2.fromOffset(20,244)
        ResetBtn.BackgroundColor3 = Color3.fromRGB(40,20,20)
        ResetBtn.TextColor3 = Color3.fromRGB(200,100,100)
        ResetBtn.Text = "Turn off force-show key screen"
        ResetBtn.Font = Enum.Font.Gotham
        ResetBtn.TextSize = 12
        ResetBtn.BorderSizePixel = 0
        ResetBtn.ZIndex = 3
        Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0,7)
        ResetBtn.MouseButton1Click:Connect(function()
            if writefile then writefile(OWNER_FILE, "") end
            ResetBtn.Text = "Done! Restart script to take effect."
        end)
    end

    SBtn.MouseEnter:Connect(function()
        TweenService:Create(SBtn, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(70,140,255)}):Play()
    end)
    SBtn.MouseLeave:Connect(function()
        TweenService:Create(SBtn, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(50,120,255)}):Play()
    end)
    IBox.Focused:Connect(function()
        TweenService:Create(IS, TweenInfo.new(0.15), {Color=Color3.fromRGB(50,120,255)}):Play()
    end)
    IBox.FocusLost:Connect(function()
        TweenService:Create(IS, TweenInfo.new(0.15), {Color=Color3.fromRGB(48,48,48)}):Play()
    end)
    TweenService:Create(Card, TweenInfo.new(0.25), {BackgroundTransparency=0}):Play()

    local validated = false
    SBtn.MouseButton1Click:Connect(function()
        if IBox.Text == keyToCheck then
            if writefile then writefile(keyFile, keyToCheck) end
            validated = true
            SL.TextColor3 = Color3.fromRGB(80,255,120)
            SL.Text = "Key accepted! Loading Divinity..."
            TweenService:Create(SBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(40,180,80)}):Play()
            SBtn.Text = "Unlocked!"
            task.wait(1.1)
            TweenService:Create(Card, TweenInfo.new(0.22), {BackgroundTransparency=1}):Play()
            task.wait(0.25)
            ScreenGui:Destroy()
        else
            SL.TextColor3 = Color3.fromRGB(255,80,80)
            SL.Text = "Invalid key. Get it from the Discord."
            TweenService:Create(IBG, TweenInfo.new(0.08), {BackgroundColor3=Color3.fromRGB(50,20,20)}):Play()
            task.wait(0.5)
            TweenService:Create(IBG, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(28,28,28)}):Play()
        end
    end)

    while not validated and ScreenGui.Parent do task.wait(0.08) end
    if not validated then error("[Divinity] Key not validated.") end
    return true
end

-- ============================================================
-- // RUN KEY CHECK BASED ON USER
-- ============================================================
if isOwner and not ownerForcesKey then
    -- Owner with no force flag = instant bypass, no UI shown
    -- do nothing
elseif isOwner and ownerForcesKey then
    -- Owner chose to see the key screen
    if not buildKeyUI(VALID_KEY, KEY_FILE, "Divinity — Owner Mode", "You chose to see this screen.") then return end
elseif isFriend then
    -- Friend has their own key
    if not buildKeyUI(friendKey, "Divinity_Friend_" .. username .. ".txt", "Divinity — Key System", "Key System  —  discord.gg/wAAHbUg46x") then return end
else
    -- Anyone else uses the default key
    if not buildKeyUI(VALID_KEY, KEY_FILE, "Divinity", "Key System  —  discord.gg/wAAHbUg46x") then return end
end

-- ============================================================
-- // LIBRARIES
-- ============================================================
local Fluent           = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager      = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Workspace folders
if isfolder and not isfolder("Divinity") then makefolder("Divinity") end
if isfolder and not isfolder("Divinity/Music") then makefolder("Divinity/Music") end
if isfolder and not isfolder("Divinity/configs") then makefolder("Divinity/configs") end

local UIBlur = Instance.new("BlurEffect")
UIBlur.Size = 0
UIBlur.Parent = Lighting

local executor = "Unknown"
pcall(function()
    if identifyexecutor then executor = identifyexecutor()
    elseif getexecutorname then executor = getexecutorname() end
end)

local FontMap = {
    ["GothamBold"] = Enum.Font.GothamBold,
    ["Gotham"]     = Enum.Font.Gotham,
    ["Arial"]      = Enum.Font.Arial,
    ["ArialBold"]  = Enum.Font.ArialBold,
    ["Code"]       = Enum.Font.Code,
    ["Bangers"]    = Enum.Font.Bangers,
    ["SourceSans"] = Enum.Font.SourceSans,
    ["Fantasy"]    = Enum.Font.Fantasy,
}

local Toggles = {
    GodMode         = false,
    BringNPCs       = false,
    InfiniteJump    = false,
    Speed           = false,
    FOV             = false,
    CamDist         = false,
    NPC_ESP         = false,
    ESPBar          = false,
    ESPHighlight    = false,
    KillAura        = false,
    MuteAll         = false,
    DestroyOnExec   = false,
    Crosshair       = false,
    CrosshairSpin   = false,
    CrosshairCursor = false,
}

local SpeedValue      = 16
local FOVValue        = 90
local CamDistValue    = 500
local ESPNameColor    = Color3.fromRGB(255, 80, 80)
local ESPHPColor      = Color3.fromRGB(80, 255, 80)
local ESPHLFill       = Color3.fromRGB(255, 80, 80)
local ESPHLOutline    = Color3.fromRGB(255, 255, 255)
local ESPHLFillTrans  = 0.6
local ESPFont         = Enum.Font.GothamBold
local ESPBarSide      = "Left"
local KillAuraDist    = 15
local scriptInput     = ""
local lastBring       = 0
local lastKillAura    = 0
local crosshairAngle  = 0
local crosshairSize   = 20
local crosshairThick  = 2
local crosshairGap    = 5
local crosshairColor  = Color3.fromRGB(255, 255, 255)
local spinSpeed       = 2

-- ============================================================
-- // CROSSHAIR
-- ============================================================
local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Color = crosshairColor
    l.Thickness = crosshairThick
    l.Transparency = 1
    l.Visible = false
    chLines[i] = l
end
local chDot = Drawing.new("Circle")
chDot.Color = crosshairColor
chDot.Thickness = 1
chDot.Filled = true
chDot.Radius = 2
chDot.Transparency = 1
chDot.Visible = false

local function updateCrosshair()
    local cx, cy
    if Toggles.CrosshairCursor then
        local mp = UserInputService:GetMouseLocation()
        cx, cy = mp.X, mp.Y
    else
        cx = workspace.CurrentCamera.ViewportSize.X / 2
        cy = workspace.CurrentCamera.ViewportSize.Y / 2
    end
    local angle = math.rad(crosshairAngle)
    local dirs = {
        Vector2.new(math.cos(angle), math.sin(angle)),
        Vector2.new(-math.cos(angle), -math.sin(angle)),
        Vector2.new(-math.sin(angle), math.cos(angle)),
        Vector2.new(math.sin(angle), -math.cos(angle)),
    }
    local center = Vector2.new(cx, cy)
    for i, dir in ipairs(dirs) do
        chLines[i].From = center + dir * crosshairGap
        chLines[i].To   = center + dir * (crosshairGap + crosshairSize)
        chLines[i].Color = crosshairColor
        chLines[i].Thickness = crosshairThick
        chLines[i].Visible = Toggles.Crosshair
    end
    chDot.Position = center
    chDot.Color = crosshairColor
    chDot.Visible = Toggles.Crosshair
end

-- ============================================================
-- // ESP HELPERS
-- ============================================================
local function applyBarFill(fill, hp, maxHp)
    local pct = math.clamp(hp / math.max(maxHp, 1), 0, 1)
    fill.Size = UDim2.new(1, 0, pct, 0)
    local r = math.floor((1 - pct) * 255)
    local g = math.floor(pct * 255)
    fill.BackgroundColor3 = Color3.fromRGB(r, g, 30)
end

local function isNPC(model)
    -- Returns true only if this is NOT a player character
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character == model then return false end
    end
    return true
end

local function addESP(npcModel, humanoid)
    if not npcModel then return end
    if npcModel:FindFirstChild("_DivinityESP") then return end
    if npcModel == LocalPlayer.Character then return end
    -- Skip player characters
    if not isNPC(npcModel) then return end

    local anchor = npcModel:FindFirstChild("HumanoidRootPart")
                or npcModel:FindFirstChildOfClass("BasePart")
    if not anchor then return end

    local hl = Instance.new("Highlight")
    hl.Name = "_DivinityHL"
    hl.FillColor = ESPHLFill
    hl.OutlineColor = ESPHLOutline
    hl.FillTransparency = ESPHLFillTrans
    hl.OutlineTransparency = 0
    hl.Enabled = Toggles.ESPHighlight
    hl.Adornee = npcModel
    hl.Parent = npcModel

    local bb = Instance.new("BillboardGui")
    bb.Name = "_DivinityESP"
    bb.Size = UDim2.new(0, 130, 0, 36)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.Parent = anchor

    local nameLabel = Instance.new("TextLabel", bb)
    nameLabel.Name = "_ESPName"
    nameLabel.Size = UDim2.new(1,0,0.55,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = ESPNameColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = ESPFont
    nameLabel.TextScaled = true
    nameLabel.Text = npcModel.Name

    local hpLabel = Instance.new("TextLabel", bb)
    hpLabel.Name = "_ESPHp"
    hpLabel.Size = UDim2.new(1,0,0.45,0)
    hpLabel.Position = UDim2.new(0,0,0.55,0)
    hpLabel.BackgroundTransparency = 1
    hpLabel.TextColor3 = ESPHPColor
    hpLabel.TextStrokeTransparency = 0
    hpLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    hpLabel.Font = ESPFont
    hpLabel.TextScaled = true
    hpLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)

    local sideOffset = ESPBarSide == "Left" and -1.3 or 1.3
    local barBB = Instance.new("BillboardGui")
    barBB.Name = "_DivinityESPBar"
    barBB.Size = UDim2.new(0, 6, 0, 52)
    barBB.StudsOffset = Vector3.new(sideOffset, 0, 0)
    barBB.AlwaysOnTop = true
    barBB.Enabled = Toggles.ESPBar
    barBB.Parent = anchor

    local barBG = Instance.new("Frame", barBB)
    barBG.Size = UDim2.new(1,0,1,0)
    barBG.BackgroundColor3 = Color3.fromRGB(15,15,15)
    barBG.BorderSizePixel = 0
    barBG.ClipsDescendants = true
    Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)
    local barStroke = Instance.new("UIStroke", barBG)
    barStroke.Color = Color3.fromRGB(0,0,0)
    barStroke.Thickness = 1
    barStroke.Transparency = 0.5

    local barFill = Instance.new("Frame", barBG)
    barFill.Name = "_ESPBarFill"
    barFill.AnchorPoint = Vector2.new(0,1)
    barFill.Position = UDim2.new(0,0,1,0)
    barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)
    local shine = Instance.new("Frame", barFill)
    shine.Size = UDim2.new(0.5,0,1,0)
    shine.BackgroundColor3 = Color3.fromRGB(255,255,255)
    shine.BackgroundTransparency = 0.85
    shine.BorderSizePixel = 0
    Instance.new("UICorner", shine).CornerRadius = UDim.new(1,0)
    applyBarFill(barFill, humanoid.Health, humanoid.MaxHealth)

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not bb.Parent then return end
        if not Toggles.NPC_ESP then
            pcall(function() bb:Destroy() barBB:Destroy() hl:Destroy() end)
            return
        end
        hpLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        applyBarFill(barFill, humanoid.Health, humanoid.MaxHealth)
    end)
    humanoid.Died:Connect(function()
        task.wait(0.1)
        pcall(function() bb:Destroy() barBB:Destroy() hl:Destroy() end)
    end)
end

local function removeAllESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_DivinityESP" or obj.Name == "_DivinityHL" or obj.Name == "_DivinityESPBar" then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function refreshESP(fn)
    for _, obj in ipairs(workspace:GetDescendants()) do pcall(fn, obj) end
end

-- ============================================================
-- // WINDOW
-- ============================================================
local Window = Fluent:CreateWindow({
    Title       = "Divinity  v15.12.0",
    SubTitle    = "By Divine",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(680, 580),
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

pcall(function()
    Window.Gui:GetPropertyChangedSignal("Enabled"):Connect(function()
        TweenService:Create(UIBlur, TweenInfo.new(0.3), {
            Size = Window.Gui.Enabled and 20 or 0
        }):Play()
    end)
end)

local Tabs = {
    Home     = Window:AddTab({ Title = "Home",            Icon = "home"      }),
    Combat   = Window:AddTab({ Title = "Combat",          Icon = "sword"     }),
    Visuals  = Window:AddTab({ Title = "Visuals",         Icon = "eye"       }),
    Scripts  = Window:AddTab({ Title = "Script Executor", Icon = "terminal"  }),
    Music    = Window:AddTab({ Title = "Music",           Icon = "music"     }),
    Patches  = Window:AddTab({ Title = "Patch Notes",     Icon = "file-text" }),
    Settings = Window:AddTab({ Title = "Settings",        Icon = "settings"  }),
}

-- ============================================================
-- // HOME
-- ============================================================
Tabs.Home:AddParagraph({
    Title   = "Welcome",
    Content = "Hello dear owner, I'm sorry that no one wants to use your script,\nits okay though cause you have yourself BAAAAAHAHAHAHAHAH-",
})
Tabs.Home:AddParagraph({
    Title   = "Supported Executors",
    Content = "Ronix, Solara, Wave, Zorara, Celery, Fluxus",
})
Tabs.Home:AddButton({
    Title       = "Copy Hangout Discord",
    Description = "Copies the Discord invite to clipboard",
    Callback    = function()
        if setclipboard then
            setclipboard("discord.gg/wAAHbUg46x")
            Fluent:Notify({ Title = "Copied!", Content = "Discord link copied.", Duration = 3 })
        else
            Fluent:Notify({ Title = "Error", Content = "Executor does not support clipboard.", Duration = 3 })
        end
    end,
})

-- Owner-only: toggle force key screen
if isOwner then
    Tabs.Home:AddSection("Owner Options")
    Tabs.Home:AddButton({
        Title       = "Toggle Force Key Screen",
        Description = "Next launch will show the key system screen for you",
        Callback    = function()
            if writefile then
                local current = (isfile and isfile(OWNER_FILE)) and readfile(OWNER_FILE) or ""
                if current == "showkey" then
                    writefile(OWNER_FILE, "")
                    Fluent:Notify({ Title = "Owner", Content = "Force key screen OFF. Restart to apply.", Duration = 4 })
                else
                    writefile(OWNER_FILE, "showkey")
                    Fluent:Notify({ Title = "Owner", Content = "Force key screen ON. Restart to apply.", Duration = 4 })
                end
            end
        end,
    })
end

-- ============================================================
-- // COMBAT
-- ============================================================
Tabs.Combat:AddSection("Player Hacks")

local GodToggle = Tabs.Combat:AddToggle("GodMode", {
    Title = "God Mode", Description = "Refreshes HP to max every frame", Default = false,
})
GodToggle:OnChanged(function(v) Toggles.GodMode = v end)

local BringToggle = Tabs.Combat:AddToggle("BringNPCs", {
    Title = "Bring All NPCs", Description = "Pulls all NPCs 4 studs in front of you (players excluded)", Default = false,
})
BringToggle:OnChanged(function(v) Toggles.BringNPCs = v end)

local KillAuraToggle = Tabs.Combat:AddToggle("KillAura", {
    Title = "Kill Aura", Description = "Automatically attacks NPCs within range", Default = false,
})
KillAuraToggle:OnChanged(function(v) Toggles.KillAura = v end)

local KillAuraSlider = Tabs.Combat:AddSlider("KillAuraDist", {
    Title = "Kill Aura Distance", Description = "Stud radius",
    Default = 15, Min = 5, Max = 100, Rounding = 0,
})
KillAuraSlider:OnChanged(function(v) KillAuraDist = v end)

Tabs.Combat:AddSection("Modded Weapons")
Tabs.Combat:AddButton({
    Title = "Mod All Weapons", Description = "Sets all weapon cooldowns to 0 (pick up weapons first)",
    Callback = function()
        local applied = 0
        local function findTool(name)
            local p = LocalPlayer
            return p.Backpack:FindFirstChild(name)
                or (p.Character and p.Character:FindFirstChild(name))
                or workspace:FindFirstChild(name, true)
        end
        local function modTool(name, attrs)
            pcall(function()
                local tool = findTool(name)
                if tool then
                    for k, v in pairs(attrs) do tool:SetAttribute(k, v) end
                    applied = applied + 1
                end
            end)
        end
        modTool("Sword",             { LungeRate=0, Swingrate=0, OffhandSwingRate=0 })
        modTool("Firebrand",         { LungeRate=0, Swingrate=0, OffhandSwingRate=0, Windup=0 })
        modTool("Katana",            { LungeRate=0, Swingrate=0, OffhandSwingRate=0 })
        modTool("Slingshot",         { Capacity=10000, ChargeRate=0, Firerate=0, Spread=0, ProjectileSpeed=2250 })
        modTool("Flamethrower",      { Cooldown=0 })
        modTool("Paintball Gun",     { Firerate=0, ProjectileSpeed=2250 })
        modTool("BB Gun",            { Firerate=0, MinShots=2, MaxShots=99999 })
        modTool("Freeze Ray",        { Firerate=0, ProjectileSpeed=2250, ChargeTime=0 })
        modTool("Ninja Stars",       { ThrowRate=0, Capacity=10000000, ChargeRate=0 })
        modTool("Bazooka",           { ReloadTick=0, Capacity=100, PassiveReloadTick=0 })
        modTool("Subspace Tripmine", { Cooldown=0 })
        modTool("Explosive Pinata",  { Cooldown=0 })
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                char:SetAttribute("DashRegenTime", 0.05)
                char:SetAttribute("DashRegenFury", 0.05)
            end
        end)
        if applied > 0 then
            Fluent:Notify({ Title = "Modded Weapons", Content = applied .. " weapons modded!", Duration = 4 })
        else
            Fluent:Notify({ Title = "Modded Weapons", Content = "Pick up weapons first then try again.", Duration = 5 })
        end
    end,
})

Tabs.Combat:AddSection("Movement and Camera")

local IJToggle = Tabs.Combat:AddToggle("InfJump", {
    Title = "Infinite Jump", Description = "Jump unlimited times mid-air", Default = false,
})
IJToggle:OnChanged(function(v) Toggles.InfiniteJump = v end)

local SpeedToggle = Tabs.Combat:AddToggle("SpeedToggle", {
    Title = "Speed Multiplier", Description = "Toggle custom walk speed", Default = false,
})
SpeedToggle:OnChanged(function(v)
    Toggles.Speed = v
    if not v then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)
local SpeedSlider = Tabs.Combat:AddSlider("SpeedSlider", {
    Title = "Speed Value", Description = "16 to 700 studs per second",
    Default = 16, Min = 16, Max = 700, Rounding = 0,
})
SpeedSlider:OnChanged(function(v) SpeedValue = v end)

local FOVToggle2 = Tabs.Combat:AddToggle("FOVToggle", {
    Title = "FOV Extender", Description = "Toggle custom Field of View", Default = false,
})
FOVToggle2:OnChanged(function(v)
    Toggles.FOV = v
    if not v then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end
end)
local FOVSlider = Tabs.Combat:AddSlider("FOVSlider", {
    Title = "Camera FOV", Description = "90 to 170",
    Default = 90, Min = 90, Max = 170, Rounding = 0,
})
FOVSlider:OnChanged(function(v) FOVValue = v end)

local CamToggle = Tabs.Combat:AddToggle("CamDist", {
    Title = "Camera Distance Bypass", Description = "Zoom camera much further out", Default = false,
})
CamToggle:OnChanged(function(v)
    Toggles.CamDist = v
    LocalPlayer.CameraMaxZoomDistance = v and CamDistValue or 400
end)
local CamSlider = Tabs.Combat:AddSlider("CamDistSlider", {
    Title = "Max Zoom Distance", Default = 500, Min = 50, Max = 3000, Rounding = 0,
})
CamSlider:OnChanged(function(v)
    CamDistValue = v
    if Toggles.CamDist then LocalPlayer.CameraMaxZoomDistance = v end
end)

-- ============================================================
-- // VISUALS
-- ============================================================
Tabs.Visuals:AddSection("NPC ESP")

local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable NPC ESP", Description = "Name and HP labels above all NPCs (players excluded)", Default = false,
})
ESPToggle:OnChanged(function(v)
    Toggles.NPC_ESP = v
    if not v then removeAllESP()
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent ~= LocalPlayer.Character and obj.Health > 0 and isNPC(obj.Parent) then
                pcall(addESP, obj.Parent, obj)
            end
        end
    end
end)

local ESPFontDrop = Tabs.Visuals:AddDropdown("ESPFontDrop", {
    Title = "ESP Font",
    Values = {"GothamBold","Gotham","Arial","ArialBold","Code","Bangers","SourceSans","Fantasy"},
    Default = "GothamBold",
})
ESPFontDrop:OnChanged(function(v)
    ESPFont = FontMap[v] or Enum.Font.GothamBold
    refreshESP(function(obj)
        if obj.Name == "_ESPName" or obj.Name == "_ESPHp" then obj.Font = ESPFont end
    end)
end)

local NameCP = Tabs.Visuals:AddColorpicker("NameCP", { Title = "Name Color", Default = Color3.fromRGB(255,80,80) })
NameCP:OnChanged(function(v)
    ESPNameColor = v
    refreshESP(function(obj) if obj.Name == "_ESPName" then obj.TextColor3 = v end end)
end)

local HPCP = Tabs.Visuals:AddColorpicker("HPCP", { Title = "HP Text Color", Default = Color3.fromRGB(80,255,80) })
HPCP:OnChanged(function(v)
    ESPHPColor = v
    refreshESP(function(obj) if obj.Name == "_ESPHp" then obj.TextColor3 = v end end)
end)

Tabs.Visuals:AddSection("Side Health Bar")

local BarToggle = Tabs.Visuals:AddToggle("ESPBar", {
    Title = "Show Side Health Bar", Description = "Vertical HP bar next to the character body", Default = false,
})
BarToggle:OnChanged(function(v)
    Toggles.ESPBar = v
    refreshESP(function(obj) if obj.Name == "_DivinityESPBar" then obj.Enabled = v end end)
end)

local BarSideDrop = Tabs.Visuals:AddDropdown("BarSideDrop", {
    Title = "Bar Side", Values = {"Left","Right"}, Default = "Left",
})
BarSideDrop:OnChanged(function(v)
    ESPBarSide = v
    local offset = v == "Left" and -1.3 or 1.3
    refreshESP(function(obj)
        if obj.Name == "_DivinityESPBar" then obj.StudsOffset = Vector3.new(offset,0,0) end
    end)
end)

Tabs.Visuals:AddSection("Highlight Chams")

local HLToggle = Tabs.Visuals:AddToggle("HLToggle", {
    Title = "Enable Highlight Chams", Description = "Body highlight visible through walls", Default = false,
})
HLToggle:OnChanged(function(v)
    Toggles.ESPHighlight = v
    refreshESP(function(obj) if obj.Name == "_DivinityHL" then obj.Enabled = v end end)
end)

local HLFillCP = Tabs.Visuals:AddColorpicker("HLFillCP", { Title = "Fill Color", Default = Color3.fromRGB(255,80,80) })
HLFillCP:OnChanged(function(v)
    ESPHLFill = v
    refreshESP(function(obj) if obj.Name == "_DivinityHL" then obj.FillColor = v end end)
end)

local HLOutlineCP = Tabs.Visuals:AddColorpicker("HLOutlineCP", { Title = "Outline Color", Default = Color3.fromRGB(255,255,255) })
HLOutlineCP:OnChanged(function(v)
    ESPHLOutline = v
    refreshESP(function(obj) if obj.Name == "_DivinityHL" then obj.OutlineColor = v end end)
end)

local HLTransSlider = Tabs.Visuals:AddSlider("HLTransSlider", {
    Title = "Fill Transparency", Description = "0 = solid, 100 = invisible",
    Default = 60, Min = 0, Max = 100, Rounding = 0,
})
HLTransSlider:OnChanged(function(v)
    ESPHLFillTrans = v / 100
    refreshESP(function(obj) if obj.Name == "_DivinityHL" then obj.FillTransparency = ESPHLFillTrans end end)
end)

Tabs.Visuals:AddSection("Custom Crosshair")

local CHToggle = Tabs.Visuals:AddToggle("CHToggle", {
    Title = "Enable Crosshair", Description = "Draws a custom crosshair on screen", Default = false,
})
CHToggle:OnChanged(function(v) Toggles.Crosshair = v end)

local CHCursorToggle = Tabs.Visuals:AddToggle("CHCursor", {
    Title = "Follow Cursor", Description = "Crosshair follows your mouse", Default = false,
})
CHCursorToggle:OnChanged(function(v) Toggles.CrosshairCursor = v end)

local CHSpinToggle = Tabs.Visuals:AddToggle("CHSpin", {
    Title = "Spin Crosshair", Description = "Makes the crosshair rotate continuously", Default = false,
})
CHSpinToggle:OnChanged(function(v) Toggles.CrosshairSpin = v end)

local CHSpinSlider = Tabs.Visuals:AddSlider("CHSpinSpeed", {
    Title = "Spin Speed", Default = 2, Min = 1, Max = 20, Rounding = 0,
})
CHSpinSlider:OnChanged(function(v) spinSpeed = v end)

local CHSizeSlider = Tabs.Visuals:AddSlider("CHSize", {
    Title = "Crosshair Size", Default = 20, Min = 5, Max = 60, Rounding = 0,
})
CHSizeSlider:OnChanged(function(v) crosshairSize = v end)

local CHGapSlider = Tabs.Visuals:AddSlider("CHGap", {
    Title = "Crosshair Gap", Default = 5, Min = 0, Max = 30, Rounding = 0,
})
CHGapSlider:OnChanged(function(v) crosshairGap = v end)

local CHThickSlider = Tabs.Visuals:AddSlider("CHThick", {
    Title = "Line Thickness", Default = 2, Min = 1, Max = 8, Rounding = 0,
})
CHThickSlider:OnChanged(function(v) crosshairThick = v end)

local CHCP = Tabs.Visuals:AddColorpicker("CHCP", { Title = "Crosshair Color", Default = Color3.fromRGB(255,255,255) })
CHCP:OnChanged(function(v) crosshairColor = v end)

-- ============================================================
-- // SCRIPT EXECUTOR
-- ============================================================
Tabs.Scripts:AddSection("Options")
local DestToggle = Tabs.Scripts:AddToggle("DestroyUI", {
    Title = "Destroy UI on Execute", Default = false,
})
DestToggle:OnChanged(function(v) Toggles.DestroyOnExec = v end)

Tabs.Scripts:AddSection("Custom Script")
Tabs.Scripts:AddInput("ScriptBox", {
    Title = "Script", Default = "", Placeholder = "loadstring(game:HttpGet(''))()  or  print('hello')",
    Numeric = false, Finished = false,
    Callback = function(v) scriptInput = v end,
})
Tabs.Scripts:AddButton({
    Title = "Execute Script",
    Callback = function()
        if scriptInput == "" then
            Fluent:Notify({ Title = "Executor", Content = "Paste a script first.", Duration = 3 })
            return
        end
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        local fn, err = loadstring(scriptInput)
        if fn then pcall(fn)
            Fluent:Notify({ Title = "Executor", Content = "Script executed.", Duration = 3 })
        else
            Fluent:Notify({ Title = "Executor Error", Content = tostring(err), Duration = 6 })
        end
    end,
})

Tabs.Scripts:AddSection("Presets")
Tabs.Scripts:AddButton({
    Title = "Execute CI Marik Script",
    Callback = function()
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/marik611377/scripts/main/combatinitation.lua"))()
        end)
        Fluent:Notify({ Title = "CI Marik Script", Content = "Script executed!", Duration = 4 })
    end,
})
Tabs.Scripts:AddButton({
    Title = "Execute Infinite Yield",
    Callback = function()
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        Fluent:Notify({ Title = "Infinite Yield", Content = "IY loaded!", Duration = 4 })
    end,
})

-- ============================================================
-- // MUSIC
-- ============================================================
Tabs.Music:AddParagraph({
    Title   = "How to use Music",
    Content = "Place sound IDs in the box below and hit Play.\nPut files in your Divinity/Music folder for local use.",
})

local currentSound = nil
local musicIDInput = ""

Tabs.Music:AddInput("MusicID", {
    Title = "Roblox Sound ID", Default = "",
    Placeholder = "rbxassetid://1234567890",
    Numeric = false, Finished = false,
    Callback = function(v) musicIDInput = v end,
})
Tabs.Music:AddButton({
    Title = "Play",
    Callback = function()
        if musicIDInput == "" then
            Fluent:Notify({ Title = "Music", Content = "Enter a sound ID first.", Duration = 3 })
            return
        end
        if currentSound then currentSound:Stop() currentSound:Destroy() currentSound = nil end
        local s = Instance.new("Sound")
        s.SoundId = musicIDInput
        s.Volume = 0.5
        s.Looped = true
        s.Parent = game:GetService("SoundService")
        s:Play()
        currentSound = s
        Fluent:Notify({ Title = "Music", Content = "Now playing!", Duration = 3 })
    end,
})
Tabs.Music:AddButton({
    Title = "Stop",
    Callback = function()
        if currentSound then
            currentSound:Stop() currentSound:Destroy() currentSound = nil
            Fluent:Notify({ Title = "Music", Content = "Stopped.", Duration = 2 })
        else
            Fluent:Notify({ Title = "Music", Content = "Nothing is playing.", Duration = 2 })
        end
    end,
})
local VolSlider = Tabs.Music:AddSlider("MusicVol", {
    Title = "Volume", Default = 50, Min = 0, Max = 100, Rounding = 0,
})
VolSlider:OnChanged(function(v)
    if currentSound then currentSound.Volume = v / 100 end
end)

-- ============================================================
-- // PATCH NOTES
-- ============================================================
Tabs.Patches:AddParagraph({ Title = "v1.0.0 — v14.90.90", Content = "From v1.0.0 to v14.90.90 there is no patch notes." })
Tabs.Patches:AddParagraph({ Title = "v15.0.0", Content = "Divinity rewritten with Fluent UI.\nAdded: God Mode, Bring NPCs, Speed, FOV, Infinite Jump." })
Tabs.Patches:AddParagraph({ Title = "v15.1.0", Content = "Added: NPC ESP with name and HP labels.\nAdded: Highlight Chams." })
Tabs.Patches:AddParagraph({ Title = "v15.2.0", Content = "Added: Side health bar (vertical).\nAdded: ESP font selector." })
Tabs.Patches:AddParagraph({ Title = "v15.3.0", Content = "Added: Camera Distance Bypass.\nAdded: Script Executor tab." })
Tabs.Patches:AddParagraph({ Title = "v15.4.0", Content = "Added: Key System with game check warning." })
Tabs.Patches:AddParagraph({ Title = "v15.5.0", Content = "Added: CI Marik and Infinite Yield presets." })
Tabs.Patches:AddParagraph({ Title = "v15.6.0", Content = "Fixed: Bring NPCs throttled to prevent lobby lag." })
Tabs.Patches:AddParagraph({ Title = "v15.7.0", Content = "Added: Destroy UI on Execute toggle." })
Tabs.Patches:AddParagraph({ Title = "v15.8.0", Content = "Added: Ronix to supported executors." })
Tabs.Patches:AddParagraph({ Title = "v15.9.0", Content = "Added: UI blur effect." })
Tabs.Patches:AddParagraph({ Title = "v15.10.0", Content = "Added: Game ID whitelist." })
Tabs.Patches:AddParagraph({ Title = "v15.11.0", Content = "Added: GDEV SMELLING SALTS notification." })
Tabs.Patches:AddParagraph({ Title = "v15.12.0  (Current)", Content = "Added: Kill Aura with distance slider.\nAdded: Modded Weapons button.\nAdded: Custom Crosshair with spin and cursor follow.\nAdded: Music tab.\nAdded: Patch Notes tab.\nAdded: Multi-user key system (owner bypass, friend keys).\nFixed: Bring NPCs and ESP now ignore player characters.\nFixed: Disable All Sounds lag loop removed." })

-- ============================================================
-- // SETTINGS
-- ============================================================
local MuteToggle = Tabs.Settings:AddToggle("MuteAll", {
    Title = "Disable All Sounds", Description = "Mutes every SFX and Music track", Default = false,
})
MuteToggle:OnChanged(function(v)
    Toggles.MuteAll = v
    for _, s in ipairs(game:GetDescendants()) do
        if s:IsA("Sound") then s.Volume = v and 0 or 0.5 end
    end
end)
game.DescendantAdded:Connect(function(obj)
    if Toggles.MuteAll and obj:IsA("Sound") then task.wait() obj.Volume = 0 end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("Divinity")
SaveManager:SetFolder("Divinity/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ============================================================
-- // INFINITE JUMP
-- ============================================================
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ============================================================
-- // NEW NPC LISTENER
-- ============================================================
workspace.DescendantAdded:Connect(function(obj)
    if Toggles.NPC_ESP and obj:IsA("Humanoid") then
        task.wait()
        if obj.Parent and obj.Parent ~= LocalPlayer.Character and isNPC(obj.Parent) then
            pcall(addESP, obj.Parent, obj)
        end
    end
end)

-- ============================================================
-- // MAIN LOOP
-- ============================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local now  = tick()

    if Toggles.GodMode and hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
    if Toggles.Speed and hum then hum.WalkSpeed = SpeedValue end
    if Toggles.FOV then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = FOVValue end
    end

    -- Bring NPCs (players excluded)
    if Toggles.BringNPCs and root and (now - lastBring) >= 0.2 then
        lastBring = now
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 and isNPC(obj.Parent) then
                local npcRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    npcRoot.CFrame = root.CFrame * CFrame.new(0, 0, -4.5)
                end
            end
        end
    end

    -- Kill Aura (NPCs only)
    if Toggles.KillAura and root and (now - lastKillAura) >= 0.1 then
        lastKillAura = now
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 and isNPC(obj.Parent) then
                local npcRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    local dist = (root.Position - npcRoot.Position).Magnitude
                    if dist <= KillAuraDist then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        pcall(function() obj:TakeDamage(10) end)
                    end
                end
            end
        end
    end

    -- Crosshair
    if Toggles.Crosshair then
        if Toggles.CrosshairSpin then
            crosshairAngle = (crosshairAngle + spinSpeed) % 360
        end
        updateCrosshair()
    else
        for _, l in ipairs(chLines) do l.Visible = false end
        chDot.Visible = false
    end
end)

-- ============================================================
-- // INIT
-- ============================================================
Window:SelectTab(1)

Fluent:Notify({
    Title    = "GDEV SMELLING SALTS",
    Content  = "Divinity v15.12.0 loaded. Welcome back.",
    Duration = 5,
})
