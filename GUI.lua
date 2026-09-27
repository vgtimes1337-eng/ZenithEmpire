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
    Size=UDim2.new(1,-8,1,-16), Position=UDim2.new(
