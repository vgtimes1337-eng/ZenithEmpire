-- ============================================================
-- Zenith Empire — Core.lua
-- Тема + Config + Utils + SaveManager + Notify
-- ============================================================

local ZE = _G.ZenithEmpire
if not ZE then return end

local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ТЕМА
ZE.Theme = {
    Bg=Color3.fromRGB(12,12,14), Bg2=Color3.fromRGB(18,18,21),
    Panel=Color3.fromRGB(22,22,26), Element=Color3.fromRGB(30,30,35),
    ElementHov=Color3.fromRGB(42,42,48), Stroke=Color3.fromRGB(60,60,68),
    StrokeHov=Color3.fromRGB(200,200,210), Accent=Color3.fromRGB(255,255,255),
    Accent2=Color3.fromRGB(210,210,220), Text=Color3.fromRGB(240,240,245),
    TextDim=Color3.fromRGB(170,170,180), TextMuted=Color3.fromRGB(110,110,120),
    Success=Color3.fromRGB(160,220,170), Danger=Color3.fromRGB(230,120,130),
    Warning=Color3.fromRGB(240,200,120),
}

-- CONFIG
local CFG = _G.ZenithCfg or {}
_G.ZenithCfg = CFG
ZE.Config = CFG

CFG.UI = CFG.UI or {}
CFG.UI.Accent = CFG.UI.Accent or Color3.fromRGB(255,255,255)
CFG.UI.UIScale = CFG.UI.UIScale or 1
CFG.UI.Blur = CFG.UI.Blur ~= false
CFG.UI.Sounds = CFG.UI.Sounds ~= false
CFG.UI.ClickSound = CFG.UI.ClickSound or "rbxassetid://6895079853"
CFG.UI.NotifPos = CFG.UI.NotifPos or "BottomRight"
CFG.UI.AnimSpeed = CFG.UI.AnimSpeed or 0.28
CFG.UI.ActiveProfile = CFG.UI.ActiveProfile or ""

CFG.Master = CFG.Master ~= false
CFG.ToggleKey = CFG.ToggleKey or Enum.KeyCode.RightShift
CFG.PanicKey = CFG.PanicKey or Enum.KeyCode.End
CFG.Notifications = CFG.Notifications ~= false
CFG.NotifTime = CFG.NotifTime or 3
CFG.FPS = CFG.FPS ~= false
CFG.Ping = CFG.Ping ~= false
CFG.Memory = CFG.Memory or false
CFG.ActiveConfig = CFG.ActiveConfig or ""

CFG.Aimbot = CFG.Aimbot or {
    Enabled=false, Key=Enum.UserInputType.MouseButton2, Mode="Hold",
    Smoothness=0.15, FOV=90, MaxDistance=500, TargetPart="Head",
    TeamCheck=true, VisibleCheck=true, WallCheck=false, AutoFire=false,
    DrawFOV=true, FOVColor=Color3.fromRGB(255,255,255),
}

CFG.Player = CFG.Player or {
    WalkSpeed=16, JumpPower=50, Fly=false, FlySpeed=50,
    Noclip=false, InfiniteJump=false, AntiFling=false,
    AntiVoid=false, AntiAFK=false, GodMode=false, HipHeight=2,
}

CFG.World = CFG.World or {
    Fullbright=false, TimeOfDay=14, RemoveFog=false, RemoveGrass=false,
    Bloom=false, BloomIntensity=0.7, ColorCorrect=false,
    CCContrast=0.15, CCSaturation=0.15, NightVision=false,
    NightVisionIntensity=1, FreezeTime=false,
}

CFG.Combat = CFG.Combat or {
    NoRecoil=false, NoSpread=false, RapidFire=false, InfiniteAmmo=false,
    HitboxExpander=false, HitboxSize=5, AutoReload=false, InstantKill=false,
}

CFG.Misc = CFG.Misc or {
    AntiAFK=false, RejoinServer=false, ServerHop=false, AutoRespawn=false,
    CopyPosition=false, ShowCoordinates=false, FPSBoost=false,
    DisableParticles=false, DisableShadows=false,
}

CFG.ESP = CFG.ESP or {
    Box=false, BoxColor=Color3.fromRGB(255,255,255), BoxThick=1.5,
    Name=false, NameColor=Color3.fromRGB(255,255,255), NameSize=12,
    Health=false, HealthColor=Color3.fromRGB(160,220,170),
    Distance=false, DistanceColor=Color3.fromRGB(220,220,220),
    Tracer=false, TracerColor=Color3.fromRGB(255,255,255),
    HeadDot=false, HeadDotColor=Color3.fromRGB(255,255,255),
    Chams=false, ChamsColor=Color3.fromRGB(255,255,255), ChamsTransp=0.5,
    Outline=false, OutlineColor=Color3.fromRGB(255,255,255),
    Rainbow=false, TeamCheck=false, DistanceLimit=500,
}

CFG.Char = CFG.Char or {}
local function ensure(t, k, d)
    t[k] = t[k] or {}
    for a, b in pairs(d) do if t[k][a] == nil then t[k][a] = b end end
end
ensure(CFG.Char, "Halo",      {Enabled=false, Color=Color3.fromRGB(255,255,255), Size=1, Speed=1.5})
ensure(CFG.Char, "Aura",      {Enabled=false, Color=Color3.fromRGB(255,255,255), Size=1, Transp=0.7, Pulse=true})
ensure(CFG.Char, "Outline",   {Enabled=false, Color=Color3.fromRGB(255,255,255)})
ensure(CFG.Char, "Chams",     {Enabled=false, Color=Color3.fromRGB(255,255,255), Transp=0.5})
ensure(CFG.Char, "Trail",     {Enabled=false, Color=Color3.fromRGB(255,255,255), Life=0.6})
ensure(CFG.Char, "Glow",      {Enabled=false, Color=Color3.fromRGB(255,255,255), Bright=5, Range=16})
ensure(CFG.Char, "Orbs",      {Enabled=false, Color=Color3.fromRGB(255,255,255), Count=4, Size=0.6, Radius=4, Speed=2})
ensure(CFG.Char, "Ring",      {Enabled=false, Color=Color3.fromRGB(255,255,255), Size=6, Speed=1})
ensure(CFG.Char, "NeonBody",  {Enabled=false, Color=Color3.fromRGB(255,255,255)})
ensure(CFG.Char, "Particles", {Enabled=false, Color=Color3.fromRGB(255,255,255), Rate=30, Size=0.4})
ensure(CFG.Char, "Rainbow",   {Enabled=false, Speed=1})
ensure(CFG.Char, "FireAura",  {Enabled=false, Size=1, Rate=50})
ensure(CFG.Char, "IceAura",   {Enabled=false, Size=1})
ensure(CFG.Char, "Lightning", {Enabled=false, Color=Color3.fromRGB(180,220,255), Count=6})
ensure(CFG.Char, "Wings",     {Enabled=false, Color=Color3.fromRGB(255,255,255), Size=1})

-- UTILS
local function Create(c, p, ch)
    local o = Instance.new(c)
    for k, v in pairs(p or {}) do if k ~= "Parent" then o[k] = v end end
    for _, x in ipairs(ch or {}) do x.Parent = o end
    if p and p.Parent then o.Parent = p.Parent end
    return o
end
local function Corner(p, r) return Create("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function Stroke(p, c, t) return Create("UIStroke", {Color = c or ZE.Theme.Stroke, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
local function Tween(o, t, p)
    local tw = TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p)
    tw:Play(); return tw
end
local function SafeCall(fn, ...)
    if not fn then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[Zenith Empire] " .. tostring(err)) end
end
local function PlaySound(id, vol)
    if not CFG.UI.Sounds then return end
    task.spawn(function()
        local s = Create("Sound", {SoundId=id, Volume=vol or 0.4, Parent=SoundService})
        s:Play(); task.wait(2)
        if s.Parent then s:Destroy() end
    end)
end
local function Click() PlaySound(CFG.UI.ClickSound, 0.3) end
local function GetChar() return ZE.LocalPlayer.Character end
local function RainbowColor()
    local speed = CFG.Char.Rainbow.Speed or 1
    return Color3.fromHSV((tick() * speed % 10) / 10, 1, 1)
end
local function GetColor(cfg)
    if CFG.Char.Rainbow.Enabled then return RainbowColor() end
    return cfg.Color
end

ZE.Utils = {
    Create=Create, Corner=Corner, Stroke=Stroke, Tween=Tween,
    SafeCall=SafeCall, PlaySound=PlaySound, Click=Click,
    GetChar=GetChar, RainbowColor=RainbowColor, GetColor=GetColor,
}

-- SAVE MANAGER
local CONFIG_FOLDER = "ZenithEmpire"
local CONFIG_INDEX = CONFIG_FOLDER .. "/index.json"
local MAX_SLOTS = 15

local function EnsureFolder()
    if not writefile then return false end
    pcall(function()
        if makefolder and not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    end)
    return true
end

local function GetConfigList()
    if not readfile or not isfile then return {} end
    local list = {}
    pcall(function()
        if isfile(CONFIG_INDEX) then
            local data = HttpService:JSONDecode(readfile(CONFIG_INDEX))
            if type(data) == "table" then
                for _, name in ipairs(data) do table.insert(list, name) end
            end
        end
    end)
    return list
end

local function SaveConfigList(list)
    if not writefile then return end
    pcall(function() writefile(CONFIG_INDEX, HttpService:JSONEncode(list)) end)
end

local function SerializeTable(t, seen)
    seen = seen or {}
    if seen[t] then return nil end
    seen[t] = true
    local out = {}
    for k, v in pairs(t) do
        if type(v) == "number" or type(v) == "boolean" or type(v) == "string" then
            out[k] = v
        elseif type(v) == "table" then
            out[k] = SerializeTable(v, seen)
        elseif typeof(v) == "Color3" then
            out[k] = {__color = true, R = v.R, G = v.G, B = v.B}
        elseif typeof(v) == "EnumItem" then
            out[k] = {__enum = tostring(v.EnumType), Name = v.Name}
        end
    end
    return out
end

local function DeserializeTable(data, target)
    for k, v in pairs(data) do
        if type(v) == "table" then
            if v.__color then target[k] = Color3.new(v.R, v.G, v.B)
            elseif v.__enum then pcall(function() target[k] = Enum[v.__enum][v.Name] end)
            else
                if type(target[k]) ~= "table" then target[k] = {} end
                DeserializeTable(v, target[k])
            end
        else target[k] = v end
    end
end

local function SaveConfig(name)
    if not writefile then return false, "Executor не поддерживает writefile" end
    if not name or name == "" then return false, "Введите имя" end
    name = name:gsub("[^%w_%- ]", "")
    if name == "" then return false, "Неверное имя" end
    EnsureFolder()
    local data = SerializeTable(_G.ZenithCfg)
    local ok, err = pcall(function()
        writefile(CONFIG_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    if not ok then return false, tostring(err) end
    local list = GetConfigList()
    local found = false
    for _, n in ipairs(list) do if n == name then found = true break end end
    if not found then
        if #list >= MAX_SLOTS then return false, "Лимит слотов: " .. MAX_SLOTS end
        table.insert(list, name); SaveConfigList(list)
    end
    CFG.ActiveConfig = name
    return true, "Сохранено: " .. name
end

local function LoadConfig(name)
    if not readfile or not isfile then return false, "Executor не поддерживает readfile" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if not isfile(path) then return false, "Файл не найден" end
    local ok, content = pcall(function() return readfile(path) end)
    if not ok or not content then return false, "Ошибка чтения" end
    local decodeOk, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not decodeOk then return false, "Ошибка парсинга" end
    DeserializeTable(data, _G.ZenithCfg)
    CFG.ActiveConfig = name
    return true, "Загружено: " .. name
end

local function DeleteConfig(name)
    if not delfile then return false, "Нет delfile" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    pcall(function() if isfile(path) then delfile(path) end end)
    local list = GetConfigList()
    local newList = {}
    for _, n in ipairs(list) do if n ~= name then table.insert(newList, n) end end
    SaveConfigList(newList)
    return true, "Удалено: " .. name
end

local function RenameConfig(old, new)
    if old == new then return false, "Одно и то же имя" end
    new = new:gsub("[^%w_%- ]", "")
    if new == "" then return false, "Неверное имя" end
    if not writefile or not isfile then return false, "Нет доступа" end
    local oldPath = CONFIG_FOLDER .. "/" .. old .. ".json"
    local newPath = CONFIG_FOLDER .. "/" .. new .. ".json"
    if isfile(newPath) then return false, "Имя занято" end
    local content = readfile(oldPath)
    writefile(newPath, content)
    delfile(oldPath)
    local list = GetConfigList()
    for i, n in ipairs(list) do if n == old then list[i] = new end end
    SaveConfigList(list)
    if CFG.ActiveConfig == old then CFG.ActiveConfig = new end
    return true, "Переименовано: " .. old .. " → " .. new
end

ZE.SaveManager = {
    Save=SaveConfig, Load=LoadConfig, Delete=DeleteConfig,
    Rename=RenameConfig, GetList=GetConfigList,
    MAX_SLOTS=MAX_SLOTS, FOLDER=CONFIG_FOLDER,
}

-- NOTIFY
local notifGui = Create("ScreenGui", {
    Name="ZenithEmpireNotifs", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=1000,
    Parent=(gethui and gethui()) or CoreGui
})
ZE.NotifGui = notifGui

local NotifHolder = Create("Frame", {
    Size=UDim2.new(0,260,0,400), Position=UDim2.new(1,-280,1,-420),
    BackgroundTransparency=1, Parent=notifGui
})
Create("UIListLayout", {
    Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder,
    VerticalAlignment=Enum.VerticalAlignment.Bottom, Parent=NotifHolder
})

local function Notify(text, color)
    if not CFG.Notifications then return end
    color = color or ZE.Theme.Accent
    local f = Create("Frame", {
        Size=UDim2.new(1,0,0,32), BackgroundColor3=ZE.Theme.Bg2,
        BackgroundTransparency=1, LayoutOrder=-tick(), Parent=NotifHolder
    })
    Corner(f, 8)
    Stroke(f, color, 1)
    Create("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=color, BorderSizePixel=0, Parent=f})
    Create("TextLabel", {
        Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1, Text=text, TextColor3=ZE.Theme.Text,
        Font=Enum.Font.GothamMedium, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=f
    })
    Tween(f, 0.25, {BackgroundTransparency=0.1})
    task.delay(CFG.NotifTime, function()
        Tween(f, 0.25, {BackgroundTransparency=1})
        for _, c in ipairs(f:GetDescendants()) do
            if c:IsA("TextLabel") then Tween(c, 0.2, {TextTransparency=1}) end
        end
        task.wait(0.3); f:Destroy()
    end)
end
ZE.Notify = Notify

ZE.Folders = ZE.Folders or {}
ZE.Folders.Char = ZE.Folders.Char or Create("Folder", {Name="ZenithEmpire_Char", Parent=workspace})

print("[Zenith Empire] Core.lua загружен")
