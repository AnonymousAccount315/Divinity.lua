-- // Divinity | Combat Initiation
-- // Fluent UI Edition | v15.13.0
-- // By Divine | Experimental (FOR NOW)

-- ============================================================
-- // KEY (obfuscated)
-- ============================================================
local function _dk()
    local p = {"jUhCI","lHXXa","fjAtKg","gAQHku","dOLrsR","tBzO"}
    local s = ""
    for i = 1, #p do s = s .. p[i] end
    return s
end

local USER_CONFIG = {
    ["divonz6"]        = { bypass = true  },
    ["youssef_marcos"] = { bypass = true  },
    ["divine012902"]   = { bypass = true  },
    ["noaukaj"]        = { bypass = false, key = "MEOWL" },
}

local VALID_KEY  = _dk()
local KEY_FILE   = "Divinity_Key.txt"
local OWNER_FILE = "Divinity_Owner.txt"

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
-- // USER DETECTION
-- ============================================================
local username   = LocalPlayer.Name:lower()
local userCfg    = USER_CONFIG[username]
local isOwner    = userCfg and userCfg.bypass == true
local isFriend   = userCfg and userCfg.bypass == false
local friendKey  = isFriend and userCfg.key or nil

local ownerForcesKey = false
if isOwner and isfile and isfile(OWNER_FILE) then
    ownerForcesKey = readfile(OWNER_FILE) == "showkey"
end

-- ============================================================
-- // SUPPORTED GAMES
-- ============================================================
local SUPPORTED_IDS = { [6462529301]=true, [13559635034]=true }
local currentGameName = "Unknown"
local isSupported = false
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    currentGameName = info and info.Name or tostring(game.PlaceId)
    isSupported = SUPPORTED_IDS[game.PlaceId] == true
end)

-- ============================================================
-- // NPC RENAME TABLE
-- ============================================================
local LOBBY_NPC_NAMES = {
    "Dummy","Training Dummy","Target Dummy","Practice Dummy",
    "Lobby Dummy","NPCDummy","LobbyNPC","Lobby_NPC",
}
local BOSS_NAMES = {
    ["Doombringer"]           = "100% not an annoying bih",
    ["Juggernaut"]            = "tier 3 armor crim user",
    ["Juggernaught"]          = "tier 3 armor crim user",
    ["Slasher"]               = "swagified",
    ["Jason"]                 = "my annoying little brother",
    ["Vagabond"]              = "normal crim mod",
    ["Captain"]               = "the attention seeker",
    ["King"]                  = "tony stark",
    ["Drakobloxer"]           = "the big lizard (super scawy)",
    ["Revolutionary Trooper"] = "dark souls + elden ring boss",
    ["Rev Trooper"]           = "dark souls + elden ring boss",
}

local function getDisplayName(modelName)
    for _, n in ipairs(LOBBY_NPC_NAMES) do
        if modelName == n or modelName:lower():find(n:lower(), 1, true) then
            return "Lobby NPC"
        end
    end
    if BOSS_NAMES[modelName] then return BOSS_NAMES[modelName] end
    if modelName:lower():find("test") and modelName:lower():find("exe") then
        return "dark souls + elden ring boss"
    end
    if modelName:lower():find("slasher") then return "swagified" end
    return "tier 1 skid"
end

-- ============================================================
-- // KEY SYSTEM BUILDER
-- ============================================================
local function buildKeyUI(keyToCheck, keyFile, titleTxt, subTxt, previewMode)
    if not previewMode then
        if isfile and isfile(keyFile) then
            local saved = readfile(keyFile)
            if saved == keyToCheck then return true end
        end
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

    local warnCard
    local function buildWarnCard()
        if warnCard then warnCard:Destroy() end
        warnCard = Instance.new("Frame", ScreenGui)
        warnCard.Size = UDim2.fromOffset(500,200)
        warnCard.Position = UDim2.new(0.5,-250,0.5,-100)
        warnCard.BackgroundColor3 = Color3.fromRGB(20,20,20)
        warnCard.BorderSizePixel = 0 warnCard.ZIndex = 5
        Instance.new("UICorner", warnCard).CornerRadius = UDim.new(0,10)
        local WS = Instance.new("UIStroke", warnCard)
        WS.Color = Color3.fromRGB(200,70,50) WS.Thickness = 1.5
        local WAccent = Instance.new("Frame", warnCard)
        WAccent.Size = UDim2.new(1,0,0,3)
        WAccent.BackgroundColor3 = Color3.fromRGB(220,70,50)
        WAccent.BorderSizePixel = 0 WAccent.ZIndex = 6
        Instance.new("UICorner", WAccent).CornerRadius = UDim.new(0,10)
        local WTitle = Instance.new("TextLabel", warnCard)
        WTitle.Size = UDim2.new(1,0,0,36) WTitle.Position = UDim2.fromOffset(0,12)
        WTitle.BackgroundTransparency = 1 WTitle.Text = "Unsupported Game Detected"
        WTitle.TextColor3 = Color3.fromRGB(255,90,60) WTitle.Font = Enum.Font.GothamBold
        WTitle.TextSize = 19 WTitle.ZIndex = 6
        local WBody = Instance.new("TextLabel", warnCard)
        WBody.Size = UDim2.new(1,-40,0,72) WBody.Position = UDim2.fromOffset(20,52)
        WBody.BackgroundTransparency = 1
        WBody.Text = "You are playing an unsupported game right now.\nThe supported games are: Combat Initiation\nBut you are playing: " .. currentGameName
        WBody.TextColor3 = Color3.fromRGB(190,190,190) WBody.Font = Enum.Font.Gotham
        WBody.TextSize = 14 WBody.TextWrapped = true
        WBody.TextXAlignment = Enum.TextXAlignment.Left WBody.ZIndex = 6
        local WBtn = Instance.new("TextButton", warnCard)
        WBtn.Size = UDim2.new(1,-40,0,36) WBtn.Position = UDim2.fromOffset(20,148)
        WBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        WBtn.TextColor3 = Color3.fromRGB(190,190,190) WBtn.Text = "I don't care."
        WBtn.Font = Enum.Font.Gotham WBtn.TextSize = 14 WBtn.BorderSizePixel = 0
        WBtn.ZIndex = 6
        Instance.new("UICorner", WBtn).CornerRadius = UDim.new(0,7)
        WBtn.MouseButton1Click:Connect(function()
            TweenService:Create(warnCard, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
            task.wait(0.25) warnCard:Destroy() warnCard = nil
        end)
    end

    if not isSupported and not previewMode then
        buildWarnCard()
        repeat task.wait(0.05) until warnCard == nil or not warnCard.Parent
    end

    local Card = Instance.new("Frame", ScreenGui)
    Card.Size = UDim2.fromOffset(460, previewMode and 310 or 280)
    Card.Position = UDim2.new(0.5,-230,0.5,-155)
    Card.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Card.BorderSizePixel = 0 Card.ZIndex = 2 Card.BackgroundTransparency = 1
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,10)
    local CS = Instance.new("UIStroke", Card)
    CS.Color = Color3.fromRGB(50,50,50) CS.Thickness = 1

    local SideBar = Instance.new("Frame", Card)
    SideBar.Size = UDim2.new(0,3,1,0)
    SideBar.BackgroundColor3 = Color3.fromRGB(50,120,255)
    SideBar.BorderSizePixel = 0 SideBar.ZIndex = 3
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,10)

    local Header = Instance.new("Frame", Card)
    Header.Size = UDim2.new(1,0,0,52)
    Header.BackgroundColor3 = Color3.fromRGB(24,24,24)
    Header.BorderSizePixel = 0 Header.ZIndex = 3
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

    local HTitle = Instance.new("TextLabel", Header)
    HTitle.Size = UDim2.new(1,-20,0,28) HTitle.Position = UDim2.fromOffset(14,6)
    HTitle.BackgroundTransparency = 1 HTitle.Text = titleTxt or "Divinity"
    HTitle.TextColor3 = Color3.fromRGB(255,255,255) HTitle.Font = Enum.Font.GothamBold
    HTitle.TextSize = 16 HTitle.TextXAlignment = Enum.TextXAlignment.Left HTitle.ZIndex = 4

    local HSub = Instance.new("TextLabel", Header)
    HSub.Size = UDim2.new(1,-20,0,18) HSub.Position = UDim2.fromOffset(14,28)
    HSub.BackgroundTransparency = 1 HSub.Text = subTxt or "Key System"
    HSub.TextColor3 = Color3.fromRGB(110,110,110) HSub.Font = Enum.Font.Gotham
    HSub.TextSize = 12 HSub.TextXAlignment = Enum.TextXAlignment.Left HSub.ZIndex = 4

    local IL = Instance.new("TextLabel", Card)
    IL.Size = UDim2.new(1,-40,0,16) IL.Position = UDim2.fromOffset(20,62)
    IL.BackgroundTransparency = 1 IL.Text = "LICENSE KEY"
    IL.TextColor3 = Color3.fromRGB(90,90,90) IL.TextXAlignment = Enum.TextXAlignment.Left
    IL.Font = Enum.Font.GothamBold IL.TextSize = 11 IL.ZIndex = 3

    local IBG = Instance.new("Frame", Card)
    IBG.Size = UDim2.new(1,-40,0,42) IBG.Position = UDim2.fromOffset(20,82)
    IBG.BackgroundColor3 = Color3.fromRGB(28,28,28)
    IBG.BorderSizePixel = 0 IBG.ZIndex = 3
    Instance.new("UICorner", IBG).CornerRadius = UDim.new(0,7)
    local IS = Instance.new("UIStroke", IBG)
    IS.Color = Color3.fromRGB(48,48,48) IS.Thickness = 1

    local IBox = Instance.new("TextBox", IBG)
    IBox.Size = UDim2.new(1,-18,1,0) IBox.Position = UDim2.fromOffset(9,0)
    IBox.BackgroundTransparency = 1 IBox.TextColor3 = Color3.fromRGB(220,220,220)
    IBox.PlaceholderText = previewMode and "(Preview Mode)" or "Paste your key here..."
    IBox.PlaceholderColor3 = Color3.fromRGB(60,60,60) IBox.Font = Enum.Font.Code
    IBox.TextSize = 13 IBox.ClearTextOnFocus = false IBox.ZIndex = 4
    IBox.Editable = not previewMode

    local Divider = Instance.new("Frame", Card)
    Divider.Size = UDim2.new(1,-40,0,1) Divider.Position = UDim2.fromOffset(20,134)
    Divider.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Divider.BorderSizePixel = 0 Divider.ZIndex = 3

    local SL = Instance.new("TextLabel", Card)
    SL.Size = UDim2.new(1,-40,0,18) SL.Position = UDim2.fromOffset(20,140)
    SL.BackgroundTransparency = 1
    SL.Text = previewMode and "(Preview Mode)" or ""
    SL.TextXAlignment = Enum.TextXAlignment.Left
    SL.TextColor3 = Color3.fromRGB(100,100,255) SL.Font = Enum.Font.Gotham
    SL.TextSize = 12 SL.ZIndex = 3

    local SBtn = Instance.new("TextButton", Card)
    SBtn.Size = UDim2.new(1,-40,0,40) SBtn.Position = UDim2.fromOffset(20,162)
    SBtn.BackgroundColor3 = previewMode and Color3.fromRGB(60,60,60) or Color3.fromRGB(50,120,255)
    SBtn.TextColor3 = Color3.fromRGB(255,255,255)
    SBtn.Text = previewMode and "Close" or "Unlock Divinity"
    SBtn.Font = Enum.Font.GothamBold SBtn.TextSize = 14
    SBtn.BorderSizePixel = 0 SBtn.AutoButtonColor = false SBtn.ZIndex = 3
    Instance.new("UICorner", SBtn).CornerRadius = UDim.new(0,7)

    if previewMode then
        local PrevBtn = Instance.new("TextButton", Card)
        PrevBtn.Size = UDim2.new(1,-40,0,36) PrevBtn.Position = UDim2.fromOffset(20,212)
        PrevBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        PrevBtn.TextColor3 = Color3.fromRGB(200,200,200)
        PrevBtn.Text = "Preview I Don't Care Screen"
        PrevBtn.Font = Enum.Font.Gotham PrevBtn.TextSize = 13
        PrevBtn.BorderSizePixel = 0 PrevBtn.ZIndex = 3
        Instance.new("UICorner", PrevBtn).CornerRadius = UDim.new(0,7)
        PrevBtn.MouseButton1Click:Connect(function() buildWarnCard() end)

        local InfoLbl = Instance.new("TextLabel", Card)
        InfoLbl.Size = UDim2.new(1,-40,0,28) InfoLbl.Position = UDim2.fromOffset(20,255)
        InfoLbl.BackgroundTransparency = 1
        InfoLbl.Text = "This is a preview. Key validation is disabled."
        InfoLbl.TextColor3 = Color3.fromRGB(80,80,80) InfoLbl.Font = Enum.Font.Gotham
        InfoLbl.TextSize = 11 InfoLbl.TextWrapped = true InfoLbl.ZIndex = 3
    end

    if isOwner and ownerForcesKey and not previewMode then
        local ResetBtn = Instance.new("TextButton", Card)
        ResetBtn.Size = UDim2.new(1,-40,0,26) ResetBtn.Position = UDim2.fromOffset(20,212)
        ResetBtn.BackgroundColor3 = Color3.fromRGB(40,20,20)
        ResetBtn.TextColor3 = Color3.fromRGB(200,100,100)
        ResetBtn.Text = "Turn off force-show key screen"
        ResetBtn.Font = Enum.Font.Gotham ResetBtn.TextSize = 12
        ResetBtn.BorderSizePixel = 0 ResetBtn.ZIndex = 3
        Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0,7)
        ResetBtn.MouseButton1Click:Connect(function()
            if writefile then writefile(OWNER_FILE, "") end
            ResetBtn.Text = "Done! Restart to apply."
        end)
    end

    SBtn.MouseEnter:Connect(function()
        TweenService:Create(SBtn, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(70,140,255)}):Play()
    end)
    SBtn.MouseLeave:Connect(function()
        local c = previewMode and Color3.fromRGB(60,60,60) or Color3.fromRGB(50,120,255)
        TweenService:Create(SBtn, TweenInfo.new(0.12), {BackgroundColor3=c}):Play()
    end)
    IBox.Focused:Connect(function()
        TweenService:Create(IS, TweenInfo.new(0.15), {Color=Color3.fromRGB(50,120,255)}):Play()
    end)
    IBox.FocusLost:Connect(function()
        TweenService:Create(IS, TweenInfo.new(0.15), {Color=Color3.fromRGB(48,48,48)}):Play()
    end)
    TweenService:Create(Card, TweenInfo.new(0.25), {BackgroundTransparency=0}):Play()

    if previewMode then
        SBtn.MouseButton1Click:Connect(function()
            TweenService:Create(Card, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
            task.wait(0.25) ScreenGui:Destroy()
        end)
        return true
    end

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
            task.wait(0.25) ScreenGui:Destroy()
        else
            SL.TextColor3 = Color3.fromRGB(255,80,80)
            SL.Text = "Invalid key."
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
-- // RUN KEY CHECK
-- ============================================================
if isOwner and not ownerForcesKey then
    -- instant bypass
elseif isOwner and ownerForcesKey then
    if not buildKeyUI(VALID_KEY, KEY_FILE, "Divinity — Owner Mode", "You chose to see this.") then return end
elseif isFriend then
    if not buildKeyUI(friendKey, "Divinity_Friend_"..username..".txt", "Divinity", "Key System") then return end
else
    if not buildKeyUI(VALID_KEY, KEY_FILE, "Divinity", "Key System") then return end
end

-- ============================================================
-- // LIBRARIES
-- ============================================================
local Fluent           = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager      = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

if isfolder then
    if not isfolder("Divinity") then makefolder("Divinity") end
    if not isfolder("Divinity/Music") then makefolder("Divinity/Music") end
    if not isfolder("Divinity/configs") then makefolder("Divinity/configs") end
    if not isfolder("Divinity/Crosshairs") then makefolder("Divinity/Crosshairs") end
end

local UIBlur = Instance.new("BlurEffect")
UIBlur.Size = 0
UIBlur.Parent = Lighting

local executor = "Unknown"
pcall(function()
    if identifyexecutor then executor = identifyexecutor()
    elseif getexecutorname then executor = getexecutorname() end
end)

-- ============================================================
-- // STATE
-- ============================================================
local Toggles = {
    GodMode         = false,
    BringNPCs       = false,
    InfiniteJump    = false,
    Speed           = false,
    FOV             = false,
    CamDist         = false,
    NPC_ESP         = false,
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
local KillAuraDist    = 15
local scriptInput     = ""
local lastBring       = 0
local lastKillAura    = 0
local cachedNPCs      = {}
local lastNPCCache    = 0

local crosshairAngle  = 0
local crosshairSize   = 12
local crosshairThick  = 2
local crosshairGap    = 4
local crosshairColor  = Color3.fromRGB(255, 50, 50)
local spinSpeed       = 2
local crosshairType   = "Cross"

local meleeRangeVal   = "5"
local pogoRangeVal    = "5"
local utilityVal      = "2"
local musicIDInput    = ""
local selectedFolderTrack = ""
local currentSound    = nil

-- ============================================================
-- // CROSSHAIR
-- ============================================================
local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Color = crosshairColor
    l.Thickness = crosshairThick
    l.Visible = false
    chLines[i] = l
end
local chDot = Drawing.new("Circle")
chDot.Color = crosshairColor
chDot.Thickness = crosshairThick
chDot.Filled = true
chDot.Radius = 3
chDot.Visible = false
local chCircle = Drawing.new("Circle")
chCircle.Color = crosshairColor
chCircle.Thickness = crosshairThick
chCircle.Filled = false
chCircle.Radius = crosshairSize
chCircle.Visible = false

local function hideAllCH()
    for _, l in ipairs(chLines) do l.Visible = false end
    chDot.Visible = false
    chCircle.Visible = false
end

local function updateCrosshair()
    hideAllCH()
    if not Toggles.Crosshair then return end
    local cx, cy
    if Toggles.CrosshairCursor then
        local mp = UserInputService:GetMouseLocation()
        cx, cy = mp.X, mp.Y
    else
        cx = workspace.CurrentCamera.ViewportSize.X / 2
        cy = workspace.CurrentCamera.ViewportSize.Y / 2
    end
    local center = Vector2.new(cx, cy)

    if crosshairType == "Dot" then
        chDot.Position = center
        chDot.Color = crosshairColor
        chDot.Radius = crosshairSize / 3
        chDot.Visible = true
    elseif crosshairType == "Circle" then
        chCircle.Position = center
        chCircle.Color = crosshairColor
        chCircle.Radius = crosshairSize
        chCircle.Thickness = crosshairThick
        chCircle.Visible = true
    elseif crosshairType == "Cross" or crosshairType == "X" then
        local baseAngle = crosshairType == "X" and 45 or 0
        local angle = math.rad(baseAngle + crosshairAngle)
        local dirs = {
            Vector2.new(math.cos(angle), math.sin(angle)),
            Vector2.new(-math.cos(angle), -math.sin(angle)),
            Vector2.new(-math.sin(angle), math.cos(angle)),
            Vector2.new(math.sin(angle), -math.cos(angle)),
        }
        for i, dir in ipairs(dirs) do
            chLines[i].From = center + dir * crosshairGap
            chLines[i].To   = center + dir * (crosshairGap + crosshairSize)
            chLines[i].Color = crosshairColor
            chLines[i].Thickness = crosshairThick
            chLines[i].Visible = true
        end
        chDot.Position = center
        chDot.Color = crosshairColor
        chDot.Radius = math.max(1, crosshairThick - 1)
        chDot.Visible = true
    elseif crosshairType == "Square" then
        local half = crosshairSize
        local corners = {
            Vector2.new(cx-half, cy-half), Vector2.new(cx+half, cy-half),
            Vector2.new(cx+half, cy+half), Vector2.new(cx-half, cy+half),
        }
        local nexts = {2,3,4,1}
        for i = 1, 4 do
            chLines[i].From = corners[i]
            chLines[i].To   = corners[nexts[i]]
            chLines[i].Color = crosshairColor
            chLines[i].Thickness = crosshairThick
            chLines[i].Visible = true
        end
    end
end

-- ============================================================
-- // ESP HELPERS
-- ============================================================
local function isNPC(model)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character == model then return false end
    end
    return true
end

local function addESP(npcModel, humanoid)
    if not npcModel then return end
    if npcModel:FindFirstChild("_DivinityESP") then return end
    if npcModel == LocalPlayer.Character then return end
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

    local displayName = getDisplayName(npcModel.Name)

    local bb = Instance.new("BillboardGui")
    bb.Name = "_DivinityESP"
    bb.Size = UDim2.new(0, 140, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
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
    nameLabel.Text = displayName

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

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not bb.Parent then return end
        if not Toggles.NPC_ESP then
            pcall(function() bb:Destroy() hl:Destroy() end)
            return
        end
        hpLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    end)
    humanoid.Died:Connect(function()
        task.wait(0.1)
        pcall(function() bb:Destroy() hl:Destroy() end)
    end)
end

local function removeAllESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_DivinityESP" or obj.Name == "_DivinityHL" then
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
    Title       = "Divinity  v15.13.0",
    SubTitle    = "Experimental (FOR NOW)",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(700, 580),
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

-- ============================================================
-- // TABS
-- ============================================================
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
    Content = "Everything BUT level 2/3 executors",
})

if isOwner then
    Tabs.Home:AddSection("Owner Options")
    Tabs.Home:AddButton({
        Title       = "Toggle Force Key Screen",
        Description = "Next launch will show the key system for you",
        Callback    = function()
            if writefile then
                local cur = (isfile and isfile(OWNER_FILE)) and readfile(OWNER_FILE) or ""
                if cur == "showkey" then
                    writefile(OWNER_FILE, "")
                    Fluent:Notify({ Title = "Owner", Content = "Force key screen OFF.", Duration = 4 })
                else
                    writefile(OWNER_FILE, "showkey")
                    Fluent:Notify({ Title = "Owner", Content = "Force key screen ON.", Duration = 4 })
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
    Title = "Bring All NPCs", Description = "Pulls NPCs in front of you (players excluded)", Default = false,
})
BringToggle:OnChanged(function(v) Toggles.BringNPCs = v end)

local KAToggle = Tabs.Combat:AddToggle("KillAura", {
    Title = "Kill Aura", Description = "Auto attacks nearby NPCs (keep distance low)", Default = false,
})
KAToggle:OnChanged(function(v) Toggles.KillAura = v end)

local KASlider = Tabs.Combat:AddSlider("KADist", {
    Title = "Kill Aura Distance", Description = "Stud radius",
    Default = 15, Min = 5, Max = 60, Rounding = 0,
})
KASlider:OnChanged(function(v) KillAuraDist = v end)

-- SWORD
Tabs.Combat:AddSection("Sword")
Tabs.Combat:AddButton({ Title = "Modded Sword", Description = "Parry go BRRR",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Sword") or (p.Character and p.Character:FindFirstChild("Sword"))
        if t then t:SetAttribute("LungeRate",0) t:SetAttribute("Swingrate",0) t:SetAttribute("OffhandSwingRate",0)
            Fluent:Notify({Title="Sword",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Sword",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Firebrand",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Firebrand") or (p.Character and p.Character:FindFirstChild("Firebrand"))
        if t then t:SetAttribute("LungeRate",0) t:SetAttribute("Swingrate",0) t:SetAttribute("OffhandSwingRate",0) t:SetAttribute("Windup",0)
            Fluent:Notify({Title="Firebrand",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Firebrand",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Katana",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Katana") or (p.Character and p.Character:FindFirstChild("Katana"))
        if t then t:SetAttribute("LungeRate",0) t:SetAttribute("Swingrate",0) t:SetAttribute("OffhandSwingRate",0)
            Fluent:Notify({Title="Katana",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Katana",Content="Not found.",Duration=3}) end
    end,
})

-- SLINGSHOT
Tabs.Combat:AddSection("Slingshot")
Tabs.Combat:AddButton({ Title = "Modded Slingshot", Description = "Spammy!",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Slingshot") or (p.Character and p.Character:FindFirstChild("Slingshot"))
        if t then t:SetAttribute("Capacity",10000) t:SetAttribute("ChargeRate",0) t:SetAttribute("Firerate",0) t:SetAttribute("Spread",0) t:SetAttribute("ProjectileSpeed",2250)
            Fluent:Notify({Title="Slingshot",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Slingshot",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Flamethrower",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Flamethrower") or (p.Character and p.Character:FindFirstChild("Flamethrower"))
        if t then t:SetAttribute("Cooldown",0)
            Fluent:Notify({Title="Flamethrower",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Flamethrower",Content="Not found.",Duration=3}) end
    end,
})

-- PAINTBALL GUN
Tabs.Combat:AddSection("Paintball Gun")
Tabs.Combat:AddButton({ Title = "Modded Paintball Gun", Description = "Ah, yes! The good ol' ranged guns!",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Paintball Gun") or (p.Character and p.Character:FindFirstChild("Paintball Gun"))
        if t then t:SetAttribute("Firerate",0) t:SetAttribute("ProjectileSpeed",2250)
            Fluent:Notify({Title="Paintball Gun",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Paintball Gun",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded BB Gun",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("BB Gun") or (p.Character and p.Character:FindFirstChild("BB Gun"))
        if t then t:SetAttribute("Firerate",0) t:SetAttribute("MinShots",2) t:SetAttribute("MaxShots",99999)
            Fluent:Notify({Title="BB Gun",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="BB Gun",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Freeze Ray (Always Charged)",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Freeze Ray") or (p.Character and p.Character:FindFirstChild("Freeze Ray"))
        if t then t:SetAttribute("Firerate",0) t:SetAttribute("ProjectileSpeed",2250) t:SetAttribute("ChargeTime",0)
            Fluent:Notify({Title="Freeze Ray",Content="Always Charged!",Duration=2})
        else Fluent:Notify({Title="Freeze Ray",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Freeze Ray (Hold to Charge)",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Freeze Ray") or (p.Character and p.Character:FindFirstChild("Freeze Ray"))
        if t then t:SetAttribute("Firerate",0) t:SetAttribute("ProjectileSpeed",2250)
            Fluent:Notify({Title="Freeze Ray",Content="Hold to Charge!",Duration=2})
        else Fluent:Notify({Title="Freeze Ray",Content="Not found.",Duration=3}) end
    end,
})

-- SUPERBALL
Tabs.Combat:AddSection("Superball")
Tabs.Combat:AddButton({ Title = "Modded Ninja Stars", Description = "Bounce.",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Ninja Stars") or (p.Character and p.Character:FindFirstChild("Ninja Stars"))
        if t then t:SetAttribute("ThrowRate",0) t:SetAttribute("Capacity",10000000) t:SetAttribute("ChargeRate",0)
            Fluent:Notify({Title="Ninja Stars",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Ninja Stars",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Bazooka",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Bazooka") or (p.Character and p.Character:FindFirstChild("Bazooka"))
        if t then t:SetAttribute("ReloadTick",0) t:SetAttribute("Capacity",100) t:SetAttribute("PassiveReloadTick",0)
            Fluent:Notify({Title="Bazooka",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Bazooka",Content="Not found.",Duration=3}) end
    end,
})

-- TIMEBOMB
Tabs.Combat:AddSection("Timebomb")
Tabs.Combat:AddButton({ Title = "Modded Subspace Tripmine", Description = "Chat is this real?",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Subspace Tripmine") or (p.Character and p.Character:FindFirstChild("Subspace Tripmine"))
        if t then t:SetAttribute("Cooldown",0)
            Fluent:Notify({Title="Subspace Tripmine",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Subspace Tripmine",Content="Not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddButton({ Title = "Modded Explosive Pinata",
    Callback = function()
        local p = LocalPlayer
        local t = p.Backpack:FindFirstChild("Explosive Pinata") or (p.Character and p.Character:FindFirstChild("Explosive Pinata"))
        if t then t:SetAttribute("Cooldown",0)
            Fluent:Notify({Title="Explosive Pinata",Content="Modded!",Duration=2})
        else Fluent:Notify({Title="Explosive Pinata",Content="Not found.",Duration=3}) end
    end,
})

-- TROWEL
Tabs.Combat:AddSection("Trowel")
local WrenchToggle = Tabs.Combat:AddToggle("FrozenWrench", {
    Title = "Frozen Wrench", Description = "Hey look guys! I'm a Builder Man!", Default = false,
})
WrenchToggle:OnChanged(function(v)
    local p = LocalPlayer
    local t = p.Backpack:FindFirstChild("Wrench") or (p.Character and p.Character:FindFirstChild("Wrench"))
    if t then t:SetAttribute("TimeScale", v and 0 or 1)
    else Fluent:Notify({Title="Wrench",Content="Not found.",Duration=3}) end
end)

-- HATS
Tabs.Combat:AddSection("Hats")
Tabs.Combat:AddButton({ Title = "Electric Punk (Lighting Chance)",
    Callback = function()
        local ae = LocalPlayer.Backpack.Parent:FindFirstChild("AccessoryEffects")
        if ae then ae:SetAttribute("Lightning_Chance",100)
            Fluent:Notify({Title="Electric Punk",Content="Lightning at 100%!",Duration=3})
        else Fluent:Notify({Title="Error",Content="AccessoryEffects not found.",Duration=3}) end
    end,
})
Tabs.Combat:AddInput("MeleeRangeInput", {
    Title = "Melee Range (5 = +500%)", Default = "5", Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(v) meleeRangeVal = v end,
})
Tabs.Combat:AddInput("PogoRangeInput", {
    Title = "Pogo Range (5 = +500%)", Default = "5", Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(v) pogoRangeVal = v end,
})
Tabs.Combat:AddButton({ Title = "Bandit/Stage Prop (Melee Range & Pogo Range)",
    Callback = function()
        local ae = LocalPlayer.Backpack.Parent:FindFirstChild("AccessoryEffects")
        if ae then
            ae:SetAttribute("Melee_Range", meleeRangeVal)
            ae:SetAttribute("Pogo_Range", pogoRangeVal)
            Fluent:Notify({Title="Bandit/Stage Prop",Content="Ranges set!",Duration=3})
        else Fluent:Notify({Title="Error",Content="AccessoryEffects not found.",Duration=3}) end
    end,
})

-- CHARACTER
Tabs.Combat:AddSection("Character")
Tabs.Combat:AddButton({ Title = "Infinite Dashes",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            char:SetAttribute("DashRegenTime",0.05)
            char:SetAttribute("DashRegenFury",0.05)
            Fluent:Notify({Title="Dashes",Content="Infinite dashes!",Duration=3})
        end
    end,
})
Tabs.Combat:AddInput("UtilityInput", {
    Title = "Utility Boost Value", Default = "2", Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(v) utilityVal = v end,
})
Tabs.Combat:AddButton({ Title = "Utility Boost",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            char:SetAttribute("UtilityBoost", utilityVal)
            Fluent:Notify({Title="Utility",Content="Boost set to "..utilityVal,Duration=3})
        end
    end,
})

-- MOVEMENT
Tabs.Combat:AddSection("Movement and Camera")
local IJToggle = Tabs.Combat:AddToggle("InfJump", { Title = "Infinite Jump", Default = false })
IJToggle:OnChanged(function(v) Toggles.InfiniteJump = v end)

local SpeedToggle = Tabs.Combat:AddToggle("SpeedToggle", { Title = "Speed Multiplier", Default = false })
SpeedToggle:OnChanged(function(v)
    Toggles.Speed = v
    if not v then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)
local SpeedSlider = Tabs.Combat:AddSlider("SpeedSlider", { Title = "Speed Value", Default = 16, Min = 16, Max = 700, Rounding = 0 })
SpeedSlider:OnChanged(function(v) SpeedValue = v end)

local FOVToggle2 = Tabs.Combat:AddToggle("FOVToggle", { Title = "FOV Extender", Default = false })
FOVToggle2:OnChanged(function(v)
    Toggles.FOV = v
    if not v then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end
end)
local FOVSlider = Tabs.Combat:AddSlider("FOVSlider", { Title = "Camera FOV", Default = 90, Min = 90, Max = 170, Rounding = 0 })
FOVSlider:OnChanged(function(v) FOVValue = v end)

local CamToggle = Tabs.Combat:AddToggle("CamDist", { Title = "Camera Distance Bypass", Default = false })
CamToggle:OnChanged(function(v)
    Toggles.CamDist = v
    LocalPlayer.CameraMaxZoomDistance = v and CamDistValue or 400
end)
local CamSlider = Tabs.Combat:AddSlider("CamDistSlider", { Title = "Max Zoom Distance", Default = 500, Min = 50, Max = 3000, Rounding = 0 })
CamSlider:OnChanged(function(v)
    CamDistValue = v
    if Toggles.CamDist then LocalPlayer.CameraMaxZoomDistance = v end
end)

-- ============================================================
-- // VISUALS
-- ============================================================
Tabs.Visuals:AddSection("NPC ESP")
local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable NPC ESP", Description = "Name and HP. Boss names are renamed.", Default = false,
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

local FontEnumMap = {
    ["GothamBold"]=Enum.Font.GothamBold,["Gotham"]=Enum.Font.Gotham,
    ["Arial"]=Enum.Font.Arial,["ArialBold"]=Enum.Font.ArialBold,
    ["Code"]=Enum.Font.Code,["Bangers"]=Enum.Font.Bangers,
    ["SourceSans"]=Enum.Font.SourceSans,["Fantasy"]=Enum.Font.Fantasy,
}
local ESPFontDrop = Tabs.Visuals:AddDropdown("ESPFontDrop", {
    Title = "ESP Font",
    Values = {"GothamBold","Gotham","Arial","ArialBold","Code","Bangers","SourceSans","Fantasy"},
    Default = "GothamBold",
})
ESPFontDrop:OnChanged(function(v)
    ESPFont = FontEnumMap[v] or Enum.Font.GothamBold
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

Tabs.Visuals:AddSection("Highlight Chams")
local HLToggle = Tabs.Visuals:AddToggle("HLToggle", { Title = "Enable Highlight Chams", Default = false })
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
local HLTransSlider = Tabs.Visuals:AddSlider("HLTransSlider", { Title = "Fill Transparency", Default = 60, Min = 0, Max = 100, Rounding = 0 })
HLTransSlider:OnChanged(function(v)
    ESPHLFillTrans = v / 100
    refreshESP(function(obj) if obj.Name == "_DivinityHL" then obj.FillTransparency = ESPHLFillTrans end end)
end)

Tabs.Visuals:AddSection("Custom Crosshair")
local CHToggle = Tabs.Visuals:AddToggle("CHToggle", { Title = "Enable Crosshair", Default = false })
CHToggle:OnChanged(function(v) Toggles.Crosshair = v if not v then hideAllCH() end end)

local CHTypeDrop = Tabs.Visuals:AddDropdown("CHType", {
    Title = "Crosshair Type", Values = {"Cross","X","Dot","Circle","Square"}, Default = "Cross",
})
CHTypeDrop:OnChanged(function(v) crosshairType = v end)

local CHCursorToggle = Tabs.Visuals:AddToggle("CHCursor", { Title = "Follow Cursor", Default = false })
CHCursorToggle:OnChanged(function(v) Toggles.CrosshairCursor = v end)

local CHSpinToggle = Tabs.Visuals:AddToggle("CHSpin", { Title = "Spin Crosshair", Default = false })
CHSpinToggle:OnChanged(function(v) Toggles.CrosshairSpin = v end)

local CHSpinSlider = Tabs.Visuals:AddSlider("CHSpinSpeed", { Title = "Spin Speed", Default = 2, Min = 1, Max = 20, Rounding = 0 })
CHSpinSlider:OnChanged(function(v) spinSpeed = v end)

local CHSizeSlider = Tabs.Visuals:AddSlider("CHSize", { Title = "Crosshair Size", Default = 12, Min = 3, Max = 60, Rounding = 0 })
CHSizeSlider:OnChanged(function(v) crosshairSize = v end)

local CHGapSlider = Tabs.Visuals:AddSlider("CHGap", { Title = "Center Gap", Default = 4, Min = 0, Max = 30, Rounding = 0 })
CHGapSlider:OnChanged(function(v) crosshairGap = v end)

local CHThickSlider = Tabs.Visuals:AddSlider("CHThick", { Title = "Line Thickness", Default = 2, Min = 1, Max = 8, Rounding = 0 })
CHThickSlider:OnChanged(function(v) crosshairThick = v end)

local CHCP = Tabs.Visuals:AddColorpicker("CHCP", { Title = "Crosshair Color", Default = Color3.fromRGB(255,50,50) })
CHCP:OnChanged(function(v) crosshairColor = v end)

Tabs.Visuals:AddButton({
    Title = "Import Crosshair from Folder",
    Description = "Reads preset .txt from Divinity/Crosshairs (format: type,size,gap,thick,R,G,B)",
    Callback = function()
        if not listfiles then
            Fluent:Notify({Title="Import",Content="Executor does not support listfiles.",Duration=4}) return
        end
        local files = listfiles("Divinity/Crosshairs")
        if #files == 0 then
            Fluent:Notify({Title="Import",Content="No files in Divinity/Crosshairs.",Duration=4}) return
        end
        local content = readfile(files[1])
        local parts = string.split(content, ",")
        if #parts >= 7 then
            crosshairType  = parts[1] or "Cross"
            crosshairSize  = tonumber(parts[2]) or 12
            crosshairGap   = tonumber(parts[3]) or 4
            crosshairThick = tonumber(parts[4]) or 2
            crosshairColor = Color3.fromRGB(tonumber(parts[5]) or 255, tonumber(parts[6]) or 50, tonumber(parts[7]) or 50)
            Fluent:Notify({Title="Import",Content="Loaded: "..files[1]:match("([^/\\]+)$"),Duration=4})
        else
            Fluent:Notify({Title="Import",Content="Invalid format. Use: type,size,gap,thick,R,G,B",Duration=5})
        end
    end,
})

-- ============================================================
-- // SCRIPT EXECUTOR
-- ============================================================
Tabs.Scripts:AddSection("Options")
local DestToggle = Tabs.Scripts:AddToggle("DestroyUI", { Title = "Destroy UI on Execute", Default = false })
DestToggle:OnChanged(function(v) Toggles.DestroyOnExec = v end)

Tabs.Scripts:AddSection("Custom Script")
Tabs.Scripts:AddInput("ScriptBox", {
    Title = "Script", Default = "", Placeholder = "loadstring(game:HttpGet(''))()  or  print('hi')",
    Numeric = false, Finished = false,
    Callback = function(v) scriptInput = v end,
})
Tabs.Scripts:AddButton({ Title = "Execute Script",
    Callback = function()
        if scriptInput == "" then Fluent:Notify({Title="Executor",Content="Paste a script first.",Duration=3}) return end
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        local fn, err = loadstring(scriptInput)
        if fn then pcall(fn) Fluent:Notify({Title="Executor",Content="Executed.",Duration=3})
        else Fluent:Notify({Title="Error",Content=tostring(err),Duration=6}) end
    end,
})

Tabs.Scripts:AddSection("Presets")
Tabs.Scripts:AddButton({ Title = "Execute CI Marik Script",
    Callback = function()
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/marik611377/scripts/main/combatinitation.lua"))() end)
        Fluent:Notify({Title="CI Marik",Content="Script executed!",Duration=4})
    end,
})
Tabs.Scripts:AddButton({ Title = "Execute Infinite Yield",
    Callback = function()
        if Toggles.DestroyOnExec then pcall(function() Window:Destroy() end) UIBlur:Destroy() end
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
        Fluent:Notify({Title="Infinite Yield",Content="IY loaded!",Duration=4})
    end,
})
Tabs.Scripts:AddButton({
    Title = "Execute KeySystem",
    Description = "Opens a preview of the key system with Close + I Don't Care buttons",
    Callback = function()
        task.spawn(function()
            buildKeyUI(VALID_KEY, KEY_FILE, "Divinity — Key System Preview", "Preview Mode", true)
        end)
    end,
})

-- ============================================================
-- // MUSIC
-- ============================================================
Tabs.Music:AddSection("Play by Sound ID")
Tabs.Music:AddInput("MusicID", {
    Title = "Roblox Sound ID", Default = "", Placeholder = "rbxassetid://1234567890",
    Numeric = false, Finished = false,
    Callback = function(v) musicIDInput = v end,
})
Tabs.Music:AddButton({ Title = "Play ID",
    Callback = function()
        if musicIDInput == "" then Fluent:Notify({Title="Music",Content="Enter a sound ID.",Duration=3}) return end
        if currentSound then currentSound:Stop() currentSound:Destroy() currentSound = nil end
        local s = Instance.new("Sound")
        s.SoundId = musicIDInput s.Volume = 0.5 s.Looped = true
        s.Parent = game:GetService("SoundService")
        s:Play() currentSound = s
        Fluent:Notify({Title="Music",Content="Playing!",Duration=3})
    end,
})

Tabs.Music:AddSection("Play from Folder")
Tabs.Music:AddParagraph({
    Title = "How it works",
    Content = "Put .txt files in Divinity/Music. Each file should contain just the rbxassetid:// sound ID.",
})

local musicFolderList = {"(refresh to load)"}
local musicDrop = Tabs.Music:AddDropdown("MusicDrop", {
    Title = "Track", Values = musicFolderList, Default = musicFolderList[1],
})
musicDrop:OnChanged(function(v) selectedFolderTrack = v end)

Tabs.Music:AddButton({ Title = "Refresh Folder",
    Callback = function()
        if not listfiles then Fluent:Notify({Title="Music",Content="Executor does not support listfiles.",Duration=3}) return end
        local files = listfiles("Divinity/Music")
        if #files > 0 then
            local names = {}
            for _, f in ipairs(files) do table.insert(names, f:match("([^/\\]+)$") or f) end
            musicDrop:SetValues(names)
            musicDrop:SetValue(names[1])
            selectedFolderTrack = names[1]
            Fluent:Notify({Title="Music",Content=#names.." track(s) found.",Duration=3})
        else
            Fluent:Notify({Title="Music",Content="No files in Divinity/Music.",Duration=3})
        end
    end,
})
Tabs.Music:AddButton({ Title = "Play Selected Track",
    Callback = function()
        if selectedFolderTrack == "" or selectedFolderTrack == "(refresh to load)" then
            Fluent:Notify({Title="Music",Content="Refresh the folder first.",Duration=3}) return
        end
        local content = ""
        pcall(function() content = readfile("Divinity/Music/" .. selectedFolderTrack) end)
        if content == "" then Fluent:Notify({Title="Music",Content="Could not read file.",Duration=3}) return end
        content = content:gsub("%s+","")
        if currentSound then currentSound:Stop() currentSound:Destroy() currentSound = nil end
        local s = Instance.new("Sound")
        s.SoundId = content s.Volume = 0.5 s.Looped = true
        s.Parent = game:GetService("SoundService")
        s:Play() currentSound = s
        Fluent:Notify({Title="Music",Content="Playing: "..selectedFolderTrack,Duration=3})
    end,
})

Tabs.Music:AddSection("Controls")
Tabs.Music:AddButton({ Title = "Stop",
    Callback = function()
        if currentSound then
            currentSound:Stop() currentSound:Destroy() currentSound = nil
            Fluent:Notify({Title="Music",Content="Stopped.",Duration=2})
        else Fluent:Notify({Title="Music",Content="Nothing playing.",Duration=2}) end
    end,
})
local VolSlider = Tabs.Music:AddSlider("MusicVol", { Title = "Volume", Default = 50, Min = 0, Max = 100, Rounding = 0 })
VolSlider:OnChanged(function(v) if currentSound then currentSound.Volume = v/100 end end)

-- ============================================================
-- // PATCH NOTES
-- ============================================================
Tabs.Patches:AddParagraph({Title="v1.0.0 — v14.90.90",Content="From v1.0.0 to v14.90.90 there is no patch notes."})
Tabs.Patches:AddParagraph({Title="v15.0.0 — v15.11.0",Content="Fluent UI rewrite, ESP, Highlight Chams, Speed/FOV/Cam Distance, Key System, CI Marik presets, Bring NPCs, Crosshair, Music tab."})
Tabs.Patches:AddParagraph({Title="v15.12.0",Content="Kill Aura, Modded Weapons, Music tab, Patch Notes tab, Multi-user key system, ESP players excluded."})
Tabs.Patches:AddParagraph({Title="v15.13.0  (Current)",Content="Exact Marik weapon sections (Sword/Slingshot/Paintball/Superball/Timebomb/Trowel/Hats/Character).\nNPC rename system — bosses renamed, lobby = Lobby NPC, others = tier 1 skid.\nHP text in ESP (no health bar).\nCrosshair types: Cross/X/Dot/Circle/Square + folder import.\nMusic folder picker separated from ID input.\nKill Aura lag fixed with NPC caching.\nExecute KeySystem preview in Script Executor.\nSubtitle: Experimental.\nSupported executors: Everything BUT level 2/3."})

-- ============================================================
-- // SETTINGS
-- ============================================================
local MuteToggle = Tabs.Settings:AddToggle("MuteAll", { Title = "Disable All Sounds", Default = false })
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
-- // NPC LISTENER
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

    if Toggles.BringNPCs and root and (now - lastBring) >= 0.25 then
        lastBring = now
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 and isNPC(obj.Parent) then
                local npcRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
                if npcRoot then npcRoot.CFrame = root.CFrame * CFrame.new(0, 0, -4.5) end
            end
        end
    end

    if Toggles.KillAura and root then
        if now - lastNPCCache >= 1.5 then
            lastNPCCache = now
            cachedNPCs = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 and isNPC(obj.Parent) then
                    local r = obj.Parent:FindFirstChild("HumanoidRootPart")
                    if r then table.insert(cachedNPCs, {hum=obj, root=r}) end
                end
            end
        end
        if now - lastKillAura >= 0.35 then
            lastKillAura = now
            for _, data in ipairs(cachedNPCs) do
                if data.hum and data.hum.Health > 0 then
                    local dist = (root.Position - data.root.Position).Magnitude
                    if dist <= KillAuraDist then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        pcall(function() data.hum:TakeDamage(10) end)
                    end
                end
            end
        end
    end

    if Toggles.Crosshair then
        if Toggles.CrosshairSpin then crosshairAngle = (crosshairAngle + spinSpeed) % 360 end
        updateCrosshair()
    else
        hideAllCH()
    end
end)

-- ============================================================
-- // INIT
-- ============================================================
Window:SelectTab(1)

Fluent:Notify({
    Title    = "GDEV SMELLING SALTS",
    Content  = "Divinity v15.13.0 loaded. Welcome back.",
    Duration = 5,
})
