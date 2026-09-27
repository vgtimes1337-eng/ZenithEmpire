-- ============================================================
-- Zenith Empire — init.lua
-- Чит-меню для Roblox | Загрузчик модулей
-- ============================================================

if _G.ZenithEmpireLoaded then warn("[Zenith Empire] Уже загружено") return end
_G.ZenithEmpireLoaded = true

_G.ZenithEmpire = _G.ZenithEmpire or {}
local ZE = _G.ZenithEmpire

ZE.Version = "2.1.0"
ZE.Build = "release"
ZE.Title = "Zenith Empire"

local Players = game:GetService("Players")
ZE.LocalPlayer = Players.LocalPlayer

-- ⚠️ ЗАМЕНИ ТВОЙ_НИК на свой GitHub username
local BASE = "https://raw.githubusercontent.com/ТВОЙ_НИК/Zenith-Empire/main/"

local MODULES = {
    "Core.lua",
    "GUI.lua",
    "Widgets.lua",
    "Preview.lua",
    "Effects.lua",
    "ESP.lua",
    "Aimbot.lua",
    "Player.lua",
    "World.lua",
    "Combat.lua",
    "Misc.lua",
    "Pages.lua",
    "Performance.lua",
}

local function loadModule(path)
    local url = BASE .. path .. "?v=" .. tostring(os.time())
    local ok, src = pcall(function() return game:HttpGet(url) end)
    if not ok or not src or #src < 30 then
        warn("[Zenith Empire] Не удалось скачать: " .. path)
        return false
    end
    local head = src:sub(1, 30):lower()
    if head:find("<!doctype") or head:find("<html") or head:find("404") then
        warn("[Zenith Empire] 404: " .. path)
        return false
    end
    local fn, err = loadstring(src)
    if not fn then
        warn("[Zenith Empire] Compile error " .. path .. ": " .. tostring(err))
        return false
    end
    local ok2, err2 = pcall(fn)
    if not ok2 then
        warn("[Zenith Empire] Runtime error " .. path .. ": " .. tostring(err2))
        return false
    end
    return true
end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "ZenithEmpireLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.Parent = CoreGui

local LoadingBg = Instance.new("Frame")
LoadingBg.Size = UDim2.new(1, 0, 1, 0)
LoadingBg.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
LoadingBg.BackgroundTransparency = 1
LoadingBg.BorderSizePixel = 0
LoadingBg.Parent = LoadingGui

local LoadingCenter = Instance.new("Frame")
LoadingCenter.Size = UDim2.new(0, 420, 0, 180)
LoadingCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingCenter.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingCenter.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
LoadingCenter.BorderSizePixel = 0
LoadingCenter.Parent = LoadingGui

local LCCorner = Instance.new("UICorner")
LCCorner.CornerRadius = UDim.new(0, 18)
LCCorner.Parent = LoadingCenter

local LCStroke = Instance.new("UIStroke")
LCStroke.Color = Color3.fromRGB(70, 70, 80)
LCStroke.Thickness = 1
LCStroke.Transparency = 0.4
LCStroke.Parent = LoadingCenter

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 60)
LoadingTitle.Position = UDim2.new(0, 0, 0, 20)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "ZENITH EMPIRE"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.TextSize = 32
LoadingTitle.Font = Enum.Font.GothamBlack
LoadingTitle.Parent = LoadingCenter

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 24)
LoadingSub.Position = UDim2.new(0, 0, 0, 78)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "Загрузка..."
LoadingSub.TextColor3 = Color3.fromRGB(170, 170, 180)
LoadingSub.TextSize = 14
LoadingSub.Font = Enum.Font.Gotham
LoadingSub.Parent = LoadingCenter

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0.8, 0, 0, 4)
LoadingBarBg.Position = UDim2.new(0.1, 0, 1, -32)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
LoadingBarBg.BorderSizePixel = 0
LoadingBarBg.Parent = LoadingCenter

local LBBgCorner = Instance.new("UICorner")
LBBgCorner.CornerRadius = UDim.new(1, 0)
LBBgCorner.Parent = LoadingBarBg

local LoadingBarFill = Instance.new("Frame")
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingBarFill.BorderSizePixel = 0
LoadingBarFill.Parent = LoadingBarBg

local LBFillCorner = Instance.new("UICorner")
LBFillCorner.CornerRadius = UDim.new(1, 0)
LBFillCorner.Parent = LoadingBarFill

TweenService:Create(LoadingBg, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

task.spawn(function()
    local total = #MODULES
    for i, path in ipairs(MODULES) do
        LoadingSub.Text = "Загрузка: " .. path
        TweenService:Create(LoadingBarFill, TweenInfo.new(0.15), {
            Size = UDim2.new(i / total, 0, 1, 0)
        }):Play()
        loadModule(path)
        task.wait(0.04)
    end

    LoadingSub.Text = "Готово"
    task.wait(0.3)

    local fadeOut = TweenService:Create(LoadingBg, TweenInfo.new(0.4), {BackgroundTransparency = 1})
    fadeOut:Play()
    TweenService:Create(LoadingCenter, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    fadeOut.Completed:Connect(function()
        LoadingGui:Destroy()
        if ZE.StartAll then ZE.StartAll() end
        if ZE.GUI and ZE.GUI.Show then ZE.GUI:Show() end
    end)
end)

print("[Zenith Empire] " .. ZE.Title .. " v" .. ZE.Version .. " загружен.")
