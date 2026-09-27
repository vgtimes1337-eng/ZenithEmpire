-- ============================================================
-- Zenith Empire — GUI.lua
-- Главное окно + навигация + палитра + drag
-- ============================================================

local ZE = _G.ZenithEmpire
if not ZE then return end

local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local Theme = ZE.Theme
local CFG = ZE.Config
local U = ZE.Utils
local Create = U.Create
local Corner = U.Corner
local Stroke = U.Stroke
local Tween = U.Tween
local Click = U.Click

local GUI = {}
ZE.GUI = GUI

local gui = Create("ScreenGui", {
    Name="ZenithEmpire", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999,
    Parent=(gethui and gethui()) or CoreGui
})
GUI.Root = gui
ZE.Gui = gui

local mainBlur = Create("BlurEffect", {Size=0, Parent=Lighting})
GUI.Blur = mainBlur

local MainGroup = Create("CanvasGroup", {
    Name="MainGroup", Size=UDim2.new(0,700,0,430),
    Position=UDim2.new(0.5,-470,0.5,-215),
    BackgroundTransparency=1, BorderSizePixel=0,
    Visible=false, GroupTransparency=1, ZIndex=50, Parent=gui
})
GUI.MainGroup = MainGroup

local Main = Create("Frame", {
    Name="Main", Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Theme.Bg, BackgroundTransparency=0,
    BorderSizePixel=0, ZIndex=50, Parent=MainGroup
})
Corner(Main, 12)
Stroke(Main, Theme.Stroke, 1.2)
Create("UIGradient", {Color=ColorSequence.new(Theme.Bg2, Theme.Bg), Rotation=90, Parent=Main})
GUI.Main = Main

-- DRAG
local dragging, start, sp
local bar = Create("Frame", {Size=UDim2.new(1,0,0,44), BackgroundTransparency=1, ZIndex=51, Parent=Main})
bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true; start=i.Position; sp=MainGroup.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - start
        MainGroup.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        if ZE.Preview and ZE.Preview.Group then
            ZE.Preview.Group.Position = UDim2.new(
                MainGroup.Position.X.Scale,
                MainGroup.Position.X.Offset + MainGroup.AbsoluteSize.X + 20,
                MainGroup.Position.Y.Scale,
                MainGroup.Position.Y.Offset
            )
        end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)

-- LOGO
local logo = Create("Frame", {
    Size=UDim2.new(0,32,0,32), Position=UDim2.new(0,14,0,8),
    BackgroundColor3=Theme.Accent, BorderSizePixel=0, ZIndex=51, Parent=Main
})
Corner(logo, 9)
Create("TextLabel", {
    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
    Text="Z", TextColor3=Theme.Bg, Font=Enum.Font.GothamBlack,
    TextSize=18, ZIndex=52, Parent=logo
})
Create("TextLabel", {
    Size=UDim2.new(0,200,0,20), Position=UDim2.new(0,54,0,10),
    BackgroundTransparency=1, Text="ZENITH EMPIRE", TextColor3=Theme.Text,
    Font=Enum.Font.GothamBold, TextSize=15,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=51, Parent=Main
})
Create("TextLabel", {
    Size=UDim2.new(0,200,0,12), Position=UDim2.new(0,54,0,27),
    BackgroundTransparency=1, Text="By ALTRON", TextColor3=Theme.TextMuted,
    Font=Enum.Font.Gotham, TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=51, Parent=Main
})

local closeBtn = Create("TextButton", {
    Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,-38,0,12),
    BackgroundColor3=Theme.Element, Text="x", TextColor3=Theme.TextDim,
    Font=Enum.Font.GothamBold, TextSize=12,
    AutoButtonColor=false, ZIndex=51, Parent=Main
})
Corner(closeBtn, 7)
closeBtn.MouseEnter:Connect(function() Tween(closeBtn, 0.15, {BackgroundColor3=Theme.Danger, TextColor3=Color3.fromRGB(255,255,255)}) end)
closeBtn.MouseLeave:Connect(function() Tween(closeBtn, 0.15, {BackgroundColor3=Theme.Element, TextColor3=Theme.TextDim}) end)
closeBtn.MouseButton1Click:Connect(function() Click(); GUI:Hide() end)

-- NAV
local Nav = Create("Frame", {
    Size=UDim2.new(0,155,1,-95), Position=UDim2.new(0,12,0,50),
    BackgroundColor3=Theme.Panel, BackgroundTransparency=0.25,
    BorderSizePixel=0, ZIndex=51, Parent=Main
})
Corner(Nav, 10)
Stroke(Nav, Theme.Stroke, 1)

local NavScroll = Create("ScrollingFrame", {
    Size=UDim2.new(1,-8,1,-16), Position=UDim2.new(0,4,0,8),
    BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=2, ScrollBarImageColor3=Theme.Accent,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ScrollingDirection=Enum.ScrollingDirection.Y,
    ZIndex=52, Parent=Nav
})
local NavHolder = Create("Frame", {
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, ZIndex=52, Parent=NavScroll
})
Create("UIListLayout", {Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=NavHolder})

-- CONTENT
local Content = Create("Frame", {
    Size=UDim2.new(1,-195,1,-105), Position=UDim2.new(0,178,0,52),
    BackgroundTransparency=1, ClipsDescendants=true, ZIndex=51, Parent=Main
})

local PageTitle = Create("TextLabel", {
    Size=UDim2.new(1,0,0,26), BackgroundTransparency=1,
    Text="Главная", TextColor3=Theme.Text,
    Font=Enum.Font.GothamBold, TextSize=18,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=52, Parent=Content
})
Create("Frame", {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,30),
    BackgroundColor3=Theme.Stroke, BorderSizePixel=0, ZIndex=52, Parent=Content
})

local Scroll = Create("ScrollingFrame", {
    Size=UDim2.new(1,0,1,-40), Position=UDim2.new(0,0,0,38),
    BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=Theme.Accent,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ScrollingDirection=Enum.ScrollingDirection.Y,
    ZIndex=52, Parent=Content
})
Create("UIListLayout", {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, Parent=Scroll})

GUI.Scroll = Scroll
GUI.PageTitle = PageTitle
GUI.NavHolder = NavHolder

-- PLAYER TAG
Create("TextLabel", {
    Size=UDim2.new(0,200,0,16), Position=UDim2.new(1,-214,1,-22),
    BackgroundTransparency=1, Text="@"..ZE.LocalPlayer.Name,
    TextColor3=Theme.TextMuted, Font=Enum.Font.GothamMedium,
    TextSize=11, TextXAlignment=Enum.TextXAlignment.Right,
    ZIndex=51, Parent=Main
})

-- SHOW / HIDE
GUI.IsOpen = false

function GUI:Show()
    if GUI.IsOpen then return end
    GUI.IsOpen = true
    MainGroup.Visible = true
    if ZE.Preview and ZE.Preview.Group then ZE.Preview.Group.Visible = true end
    MainGroup.GroupTransparency = 1
    if ZE.Preview and ZE.Preview.Group then ZE.Preview.Group.GroupTransparency = 1 end
    Tween(MainGroup, CFG.UI.AnimSpeed, {GroupTransparency=0})
    if ZE.Preview and ZE.Preview.Group then Tween(ZE.Preview.Group, CFG.UI.AnimSpeed, {GroupTransparency=0}) end
    if CFG.UI.Blur then Tween(mainBlur, 0.3, {Size=14}) end
end

function GUI:Hide()
    if not GUI.IsOpen then return end
    GUI.IsOpen = false
    Tween(MainGroup, CFG.UI.AnimSpeed*0.8, {GroupTransparency=1})
    if ZE.Preview and ZE.Preview.Group then Tween(ZE.Preview.Group, CFG.UI.AnimSpeed*0.8, {GroupTransparency=1}) end
    if CFG.UI.Blur then Tween(mainBlur, 0.3, {Size=0}) end
    task.delay(CFG.UI.AnimSpeed*0.9, function()
        if not GUI.IsOpen then
            MainGroup.Visible = false
            if ZE.Preview and ZE.Preview.Group then ZE.Preview.Group.Visible = false end
        end
    end)
end

function GUI:Toggle()
    if GUI.IsOpen then GUI:Hide() else GUI:Show() end
end

-- INPUT
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CFG.ToggleKey then
        GUI:Toggle()
    elseif input.KeyCode == CFG.PanicKey then
        GUI:Hide()
        for name, cfg in pairs(CFG.Char) do
            if type(cfg) == "table" and cfg.Enabled ~= nil then cfg.Enabled = false end
        end
        for _, k in ipairs({"Box","Name","Health","Distance","Tracer","HeadDot","Chams","Outline","Rainbow"}) do
            CFG.ESP[k] = false
        end
        CFG.Aimbot.Enabled = false
        CFG.Player.Fly = false
        CFG.Player.Noclip = false
        if ZE.Notify then ZE.Notify("PANIC — всё выключено", ZE.Theme.Danger) end
    end
end)

-- PALETTE
local Palette = Create("Frame", {
    Size=UDim2.new(0,240,0,240), Position=UDim2.new(0.5,-120,0.5,-120),
    BackgroundColor3=Theme.Bg2, BorderSizePixel=0,
    Visible=false, ZIndex=200, Parent=gui
})
Corner(Palette, 12)
Stroke(Palette, Theme.StrokeHov, 1.5)
Create("TextLabel", {
    Size=UDim2.new(1,-40,0,24), Position=UDim2.new(0,14,0,8),
    BackgroundTransparency=1, Text="COLOR", TextColor3=Theme.Text,
    Font=Enum.Font.GothamBold, TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201, Parent=Palette
})
local palClose = Create("TextButton", {
    Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-30,0,10),
    BackgroundColor3=Theme.Element, Text="x", TextColor3=Theme.TextDim,
    Font=Enum.Font.GothamBold, TextSize=11,
    AutoButtonColor=false, ZIndex=201, Parent=Palette
})
Corner(palClose, 6)
palClose.MouseButton1Click:Connect(function() Palette.Visible=false end)

local swatchColors = {
    Color3.fromRGB(255,255,255), Color3.fromRGB(220,220,220), Color3.fromRGB(180,180,180),
    Color3.fromRGB(130,130,130), Color3.fromRGB(80,80,80),    Color3.fromRGB(30,30,30),
    Color3.fromRGB(255,80,80),   Color3.fromRGB(255,160,80),  Color3.fromRGB(255,220,80),
    Color3.fromRGB(180,255,100), Color3.fromRGB(120,240,160), Color3.fromRGB(80,220,220),
    Color3.fromRGB(80,160,255),  Color3.fromRGB(120,100,255), Color3.fromRGB(180,80,255),
    Color3.fromRGB(255,80,200),  Color3.fromRGB(255,120,160), Color3.fromRGB(140,70,40),
    Color3.fromRGB(100,60,40),   Color3.fromRGB(60,40,30),
}
local pickRow = Create("Frame", {
    Size=UDim2.new(1,-20,0,90), Position=UDim2.new(0,10,0,36),
    BackgroundTransparency=1, ZIndex=201, Parent=Palette
})
Create("UIGridLayout", {CellSize=UDim2.new(0,28,0,28), CellPadding=UDim2.new(0,6,0,6), Parent=pickRow})
GUI.PalCallback = nil
for _, col in ipairs(swatchColors) do
    local sw = Create("TextButton", {BackgroundColor3=col, Text="", AutoButtonColor=false, ZIndex=202, Parent=pickRow})
    Corner(sw, 6); Stroke(sw, Theme.Stroke, 1)
    sw.MouseButton1Click:Connect(function()
        Click()
        if GUI.PalCallback then GUI.PalCallback(col) end
        Palette.Visible=false
    end)
end

local hueBar = Create("Frame", {
    Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,10,0,138),
    BackgroundColor3=Color3.fromRGB(60,60,60), BorderSizePixel=0, ZIndex=201, Parent=Palette
})
Corner(hueBar, 6)
Create("UIGradient", {
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
    }, Parent=hueBar
})
local satBar = Create("Frame", {
    Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,10,0,158),
    BackgroundColor3=Color3.fromRGB(60,60,60), BorderSizePixel=0, ZIndex=201, Parent=Palette
})
Corner(satBar, 6)
local hueHandle = Create("Frame", {
    Size=UDim2.new(0,8,0,16), Position=UDim2.new(0,-4,0.5,-8),
    BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, ZIndex=202, Parent=hueBar
})
Corner(hueHandle, 3)
local satHandle = Create("Frame", {
    Size=UDim2.new(0,8,0,16), Position=UDim2.new(1,-4,0.5,-8),
    BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, ZIndex=202, Parent=satBar
})
Corner(satHandle, 3)

local hueVal, satVal = 0, 1
local function dragBar(barObj, cb)
    local drag = false
    barObj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; cb(i) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then cb(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
end
dragBar(hueBar, function(i)
    local p = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
    hueVal = p
    hueHandle.Position = UDim2.new(p, -4, 0.5, -8)
    if GUI.PalCallback then GUI.PalCallback(Color3.fromHSV(hueVal, satVal, 1)) end
end)
dragBar(satBar, function(i)
    local p = math.clamp((i.Position.X - satBar.AbsolutePosition.X) / satBar.AbsoluteSize.X, 0, 1)
    satVal = p
    satHandle.Position = UDim2.new(p, -4, 0.5, -8)
    if GUI.PalCallback then GUI.PalCallback(Color3.fromHSV(hueVal, satVal, 1)) end
end)

function GUI:OpenPalette(initial, cb)
    GUI.PalCallback = cb
    if initial then
        local h, s = Color3.toHSV(initial)
        hueVal, satVal = h, s
        hueHandle.Position = UDim2.new(h, -4, 0.5, -8)
        satHandle.Position = UDim2.new(s, -4, 0.5, -8)
    end
    Palette.Visible = true
end

print("[Zenith Empire] GUI.lua загружен")
