--[[
	PandaUI Library - Clean White Theme
	Inspired by Panda Key System dashboard
	Features: Offset shadow buttons, light cards, modern sidebar, acrylic support
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ─────────────────────────────────────────────
-- Acrylic Blur System
-- ─────────────────────────────────────────────
local LoadAcrylic = function()
	local GuiSystem = {}

	local Twen = TweenService
	local CurrentCamera = workspace.CurrentCamera

	function GuiSystem:Hash()
		return string.reverse(string.gsub(HttpService:GenerateGUID(false), '..', function(aa)
			return string.reverse(aa)
		end))
	end

	local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
		local n = planeNormal
		local d = rayDirection
		local v = rayOrigin - planePos
		local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z)
		local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z)
		local a = -num / den
		return rayOrigin + (a * rayDirection), a
	end

	function GuiSystem.new(frame)
		local Part = Instance.new("Part", workspace)
		local DepthOfField = Instance.new("DepthOfFieldEffect", game:GetService("Lighting"))
		local SurfaceGui = Instance.new("SurfaceGui", Part)
		local BlockMesh = Instance.new("BlockMesh")
		BlockMesh.Parent = Part

		Part.Material = Enum.Material.Glass
		Part.Transparency = 1
		Part.Reflectance = 10
		Part.CastShadow = false
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CollisionGroup = GuiSystem:Hash()
		Part.Size = Vector3.new(1, 1, 1) * 0.01
		Part.Color = Color3.fromRGB(0, 0, 0)

		Twen:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Transparency = 0.85
		}):Play()

		DepthOfField.Enabled = true
		DepthOfField.FarIntensity = 1
		DepthOfField.FocusDistance = 0
		DepthOfField.InFocusRadius = 500
		DepthOfField.NearIntensity = 1

		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.Adornee = Part
		SurfaceGui.Active = true
		SurfaceGui.Face = Enum.NormalId.Front
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

		DepthOfField.Name = GuiSystem:Hash()
		Part.Name = GuiSystem:Hash()
		SurfaceGui.Name = GuiSystem:Hash()

		local C4 = {
			Update = nil,
			Collection = SurfaceGui,
			Enabled = true,
			Instances = {
				BlockMesh = BlockMesh,
				Part = Part,
				DepthOfField = DepthOfField,
				SurfaceGui = SurfaceGui,
			},
			Signal = nil
		}

		local Update = function()
			pcall(function()
				local userSettings = UserSettings():GetService("UserGameSettings")
				local qualityLevel = userSettings.SavedQualityLevel.Value
				if qualityLevel < 8 then
					Twen:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Transparency = 1
					}):Play()
				else
					Twen:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Transparency = 0.85
					}):Play()
				end
			end)

			local corner0 = frame.AbsolutePosition
			local corner1 = corner0 + frame.AbsoluteSize

			local ray0 = CurrentCamera:ScreenPointToRay(corner0.X, corner0.Y, 1)
			local ray1 = CurrentCamera:ScreenPointToRay(corner1.X, corner1.Y, 1)

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ)
			local planeNormal = CurrentCamera.CFrame.LookVector

			local pos0 = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
			local pos1 = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0)
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1)

			local size = pos1 - pos0
			local center = (pos0 + pos1) / 2

			BlockMesh.Offset = center
			BlockMesh.Scale = size / 0.0101
			Part.CFrame = CurrentCamera.CFrame
		end

		C4.Update = Update
		C4.Signal = RunService.RenderStepped:Connect(Update)

		pcall(function()
			C4.Signal2 = CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
				Part.CFrame = CurrentCamera.CFrame
			end)
		end)

		C4.Destroy = function()
			C4.Signal:Disconnect()
			if C4.Signal2 then C4.Signal2:Disconnect() end
			C4.Update = function() end
			Twen:Create(Part, TweenInfo.new(1), { Transparency = 1 }):Play()
			DepthOfField:Destroy()
			Part:Destroy()
		end

		return C4
	end

	return GuiSystem
end

-- ─────────────────────────────────────────────
-- Theme Colors (Panda Style)
-- ─────────────────────────────────────────────
local Theme = {
	Background      = Color3.fromRGB(245, 247, 250),   -- Light gray-white
	Card            = Color3.fromRGB(255, 255, 255),   -- Pure white
	CardBorder      = Color3.fromRGB(230, 233, 240),   -- Soft border
	Sidebar         = Color3.fromRGB(255, 255, 255),
	TextPrimary     = Color3.fromRGB(20, 22, 30),      -- Almost black
	TextSecondary   = Color3.fromRGB(120, 130, 150),   -- Muted gray
	TextMuted       = Color3.fromRGB(160, 170, 185),
	Accent          = Color3.fromRGB(0, 120, 255),     -- Panda Blue
	AccentDark      = Color3.fromRGB(0, 90, 210),
	AccentSoft      = Color3.fromRGB(230, 240, 255),
	Success         = Color3.fromRGB(34, 197, 94),
	Warning         = Color3.fromRGB(245, 158, 11),
	Danger          = Color3.fromRGB(239, 68, 68),
	Shadow          = Color3.fromRGB(0, 0, 0),
	ToggleOff       = Color3.fromRGB(210, 215, 225),
	InputBg         = Color3.fromRGB(248, 250, 252),
	Hover           = Color3.fromRGB(240, 243, 248),
}

-- ─────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────
local function Tween(obj, props, t, style, dir)
	style = style or Enum.EasingStyle.Quad
	dir = dir or Enum.EasingDirection.Out
	TweenService:Create(obj, TweenInfo.new(t or 0.2, style, dir), props):Play()
end

local function New(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	if parent then obj.Parent = parent end
	return obj
end

local function MakeDraggable(frame, handle)
	handle = handle or frame
	local dragging = false
	local dragInput, mousePos, framePos

	local function update(input)
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Offset Shadow Button (the signature Panda style)
local function CreateOffsetButton(parent, props)
	props = props or {}
	local size = props.Size or UDim2.new(0, 180, 0, 42)
	local position = props.Position or UDim2.new(0, 0, 0, 0)
	local text = props.Text or "Button"
	local bgColor = props.BackgroundColor3 or Theme.Accent
	local textColor = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	local font = props.Font or Enum.Font.GothamBold
	local textSize = props.TextSize or 15
	local cornerRadius = props.CornerRadius or 10
	local offset = props.Offset or 4
	local zIndex = props.ZIndex or 10
	local name = props.Name or "OffsetButton"

	local container = New("Frame", {
		Name = name,
		Size = size,
		Position = position,
		BackgroundTransparency = 1,
		ZIndex = zIndex,
	}, parent)

	-- Black shadow layer (offset)
	local shadow = New("Frame", {
		Name = "Shadow",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, offset, 0, offset),
		BackgroundColor3 = Theme.Shadow,
		BorderSizePixel = 0,
		ZIndex = zIndex,
	}, container)
	New("UICorner", { CornerRadius = UDim.new(0, cornerRadius) }, shadow)

	-- Main button
	local btn = New("TextButton", {
		Name = "Button",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = bgColor,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = textColor,
		TextSize = textSize,
		Font = font,
		AutoButtonColor = false,
		ZIndex = zIndex + 1,
	}, container)
	New("UICorner", { CornerRadius = UDim.new(0, cornerRadius) }, btn)

	-- Hover effects
	btn.MouseEnter:Connect(function()
		Tween(btn, { BackgroundColor3 = props.HoverColor or Theme.AccentDark }, 0.15)
		Tween(shadow, { Position = UDim2.new(0, offset + 1, 0, offset + 1) }, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, { BackgroundColor3 = bgColor }, 0.15)
		Tween(shadow, { Position = UDim2.new(0, offset, 0, offset) }, 0.15)
	end)
	btn.MouseButton1Down:Connect(function()
		Tween(btn, { Position = UDim2.new(0, 1, 0, 1) }, 0.08)
		Tween(shadow, { Position = UDim2.new(0, offset - 1, 0, offset - 1) }, 0.08)
	end)
	btn.MouseButton1Up:Connect(function()
		Tween(btn, { Position = UDim2.new(0, 0, 0, 0) }, 0.08)
		Tween(shadow, { Position = UDim2.new(0, offset, 0, offset) }, 0.08)
	end)

	return container, btn
end

-- Soft Card with subtle border
local function CreateCard(parent, props)
	props = props or {}
	local card = New("Frame", {
		Name = props.Name or "Card",
		Size = props.Size or UDim2.new(1, 0, 0, 100),
		Position = props.Position or UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex or 5,
	}, parent)
	New("UICorner", { CornerRadius = UDim.new(0, props.CornerRadius or 12) }, card)
	New("UIStroke", {
		Color = Theme.CardBorder,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, card)
	return card
end

-- Icon helper
local function GetImageData(name, image)
	name = (name or "home"):lower()
	local atlas = "rbxassetid://3926305904"

	local icons = {
		ads       = { atlas, Vector2.new(205, 565), Vector2.new(35, 35) },
		list      = { atlas, Vector2.new(485, 205), Vector2.new(35, 35) },
		folder    = { atlas, Vector2.new(805, 45),  Vector2.new(35, 35) },
		earth     = { atlas, Vector2.new(604, 324), Vector2.new(35, 35) },
		locked    = { atlas, Vector2.new(524, 644), Vector2.new(35, 35) },
		home      = { atlas, Vector2.new(964, 205), Vector2.new(35, 35) },
		mouse     = { "rbxassetid://94866180901611" },
		user      = { "rbxassetid://10494577250" },
		cosmetics = { "rbxassetid://111448140849101" },
		sun       = { "rbxassetid://119948798441279" },
		shop      = { "rbxassetid://97513888174732" },
		farm      = { "rbxassetid://88262334591015" },
		code      = { "rbxassetid://137998322875646" },
		crosshair = { "rbxassetid://107944169329467" },
		image     = { "rbxassetid://111273759419615" },
		layers    = { "rbxassetid://99581501168713" },
		side      = { "rbxassetid://109111534633587" },
		grenade   = { "rbxassetid://106253651509472" },
		bio       = { "rbxassetid://78652086695674" },
		camera    = { "rbxassetid://103880096339912" },
		car       = { "rbxassetid://116283987324457" },
		run       = { "rbxassetid://117007794770586" },
		box       = { "rbxassetid://140255234172865" },
		gun       = { "rbxassetid://93001822915827" },
		sword     = { "rbxassetid://82635240213192" },
		knife     = { "rbxassetid://94102397172403" },
		gear      = { "rbxassetid://134488580093972" },
		settings  = { "rbxassetid://134488580093972" },
	}

	local data = icons[name]
	if data then
		image.Image = data[1]
		if data[2] then
			image.ImageRectOffset = data[2]
			image.ImageRectSize = data[3]
		end
	else
		image.Image = "rbxassetid://3926305904"
		image.ImageRectOffset = Vector2.new(964, 205)
		image.ImageRectSize = Vector2.new(35, 35)
	end
end

-- Popup registry
local _openPopups = {}
local function RegisterPopup(frame, closeFn)
	for _, p in ipairs(_openPopups) do
		if p.frame == frame then return end
	end
	table.insert(_openPopups, { frame = frame, closeFn = closeFn })
end
local function UnregisterPopup(frame)
	for i, p in ipairs(_openPopups) do
		if p.frame == frame then table.remove(_openPopups, i); return end
	end
end
local function CloseAllPopupsExcept(exceptFrame)
	for _, p in ipairs(_openPopups) do
		if p.frame ~= exceptFrame then pcall(p.closeFn) end
	end
end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local mp = UserInputService:GetMouseLocation()
	local toClose = {}
	for _, p in ipairs(_openPopups) do
		if p.frame and p.frame.Visible then
			local pos = p.frame.AbsolutePosition
			local size = p.frame.AbsoluteSize
			local inside = mp.X >= pos.X and mp.X <= pos.X + size.X
				and mp.Y >= pos.Y and mp.Y <= pos.Y + size.Y
			if not inside then table.insert(toClose, p.closeFn) end
		end
	end
	for _, fn in ipairs(toClose) do pcall(fn) end
end)

-- ─────────────────────────────────────────────
-- Library
-- ─────────────────────────────────────────────
local Library = {}
Library.__index = Library

local _registeredElements = {}

function Library:AddWindow(hubTitle, hubImage, gameTitle)
	hubTitle = hubTitle or "Panda Hub"
	hubImage = hubImage or ""
	gameTitle = gameTitle or "Roblox"

	local mainColor = Theme.Accent
	local tabs = {}
	local activeTabIndex = nil
	local tabOrder = 0
	local WindowObj = {}

	-- ScreenGui
	local ScreenGui = New("ScreenGui", {
		Name = "PandaUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
	}, game:GetService("CoreGui"))

	-- Main Window Frame
	local MainFrame = New("Frame", {
		Name = "MainFrame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 720, 0, 480),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, ScreenGui)
	New("UICorner", { CornerRadius = UDim.new(0, 16) }, MainFrame)
	New("UIStroke", {
		Color = Color3.fromRGB(220, 225, 235),
		Thickness = 1,
	}, MainFrame)

	-- Soft drop shadow behind window
	local WindowShadow = New("ImageLabel", {
		Name = "WindowShadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 8),
		Size = UDim2.new(0, 740, 0, 500),
		BackgroundTransparency = 1,
		Image = "rbxassetid://131807052980902",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.75,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(50, 50, 50, 50),
		ZIndex = 0,
	}, ScreenGui)

	MakeDraggable(MainFrame, MainFrame)

	-- Acrylic (optional, subtle)
	local AcrylicLib = LoadAcrylic()
	local AcrylicBlur = AcrylicLib.new(MainFrame)

	-- ── Sidebar ──────────────────────────────
	local Sidebar = New("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 210, 1, 0),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		ZIndex = 10,
	}, MainFrame)
	New("UICorner", { CornerRadius = UDim.new(0, 16) }, Sidebar)

	-- Sidebar right border
	local SideBorder = New("Frame", {
		Name = "SideBorder",
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = Theme.CardBorder,
		BorderSizePixel = 0,
		ZIndex = 11,
	}, Sidebar)

	-- Logo / Title area
	local LogoArea = New("Frame", {
		Name = "LogoArea",
		Size = UDim2.new(1, 0, 0, 64),
		BackgroundTransparency = 1,
		ZIndex = 12,
	}, Sidebar)

	local LogoIcon = New("ImageLabel", {
		Name = "LogoIcon",
		Position = UDim2.new(0, 18, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundTransparency = 1,
		Image = hubImage ~= "" and hubImage or "rbxassetid://10494577250",
		ZIndex = 13,
	}, LogoArea)

	local LogoText = New("TextLabel", {
		Name = "LogoText",
		Position = UDim2.new(0, 54, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(1, -70, 0, 22),
		BackgroundTransparency = 1,
		Text = hubTitle,
		TextColor3 = Theme.TextPrimary,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	}, LogoArea)

	-- Search box
	local SearchBox = New("Frame", {
		Name = "SearchBox",
		Position = UDim2.new(0, 14, 0, 68),
		Size = UDim2.new(1, -28, 0, 36),
		BackgroundColor3 = Theme.InputBg,
		BorderSizePixel = 0,
		ZIndex = 12,
	}, Sidebar)
	New("UICorner", { CornerRadius = UDim.new(0, 10) }, SearchBox)
	New("UIStroke", {
		Color = Theme.CardBorder,
		Thickness = 1,
	}, SearchBox)

	local SearchIcon = New("ImageLabel", {
		Position = UDim2.new(0, 10, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 16, 0, 16),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3926305904",
		ImageRectOffset = Vector2.new(964, 324),
		ImageRectSize = Vector2.new(36, 36),
		ImageColor3 = Theme.TextMuted,
		ZIndex = 13,
	}, SearchBox)

	local SearchInput = New("TextBox", {
		Position = UDim2.new(0, 34, 0, 0),
		Size = UDim2.new(1, -42, 1, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Search...",
		PlaceholderColor3 = Theme.TextMuted,
		Text = "",
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 13,
	}, SearchBox)

	-- Tab list container
	local TabList = New("ScrollingFrame", {
		Name = "TabList",
		Position = UDim2.new(0, 0, 0, 116),
		Size = UDim2.new(1, 0, 1, -180),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.CardBorder,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 12,
	}, Sidebar)
	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}, TabList)
	New("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	}, TabList)

	-- User footer
	local UserFooter = New("Frame", {
		Name = "UserFooter",
		Position = UDim2.new(0, 0, 1, -56),
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundTransparency = 1,
		ZIndex = 12,
	}, Sidebar)

	local UserAvatar = New("ImageLabel", {
		Position = UDim2.new(0, 16, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 32, 0, 32),
		BackgroundColor3 = Theme.AccentSoft,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
		ZIndex = 13,
	}, UserFooter)
	New("UICorner", { CornerRadius = UDim.new(1, 0) }, UserAvatar)

	local UserName = New("TextLabel", {
		Position = UDim2.new(0, 56, 0.5, -8),
		Size = UDim2.new(1, -70, 0, 16),
		BackgroundTransparency = 1,
		Text = LocalPlayer.DisplayName,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 13,
	}, UserFooter)

	local UserSub = New("TextLabel", {
		Position = UDim2.new(0, 56, 0.5, 8),
		Size = UDim2.new(1, -70, 0, 14),
		BackgroundTransparency = 1,
		Text = gameTitle,
		TextColor3 = Theme.TextMuted,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	}, UserFooter)

	-- ── Content Area ─────────────────────────
	local ContentArea = New("Frame", {
		Name = "ContentArea",
		Position = UDim2.new(0, 210, 0, 0),
		Size = UDim2.new(1, -210, 1, 0),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 5,
	}, MainFrame)

	-- Top bar
	local TopBar = New("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundTransparency = 1,
		ZIndex = 6,
	}, ContentArea)

	local PageTitle = New("TextLabel", {
		Position = UDim2.new(0, 24, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0.5, 0, 0, 24),
		BackgroundTransparency = 1,
		Text = "Home",
		TextColor3 = Theme.TextPrimary,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 7,
	}, TopBar)

	-- Close button
	local CloseBtn = New("TextButton", {
		Position = UDim2.new(1, -40, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundColor3 = Theme.Hover,
		BorderSizePixel = 0,
		Text = "×",
		TextColor3 = Theme.TextSecondary,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 7,
	}, TopBar)
	New("UICorner", { CornerRadius = UDim.new(0, 8) }, CloseBtn)
	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, { BackgroundColor3 = Theme.Danger, TextColor3 = Color3.fromRGB(255,255,255) }, 0.15)
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, { BackgroundColor3 = Theme.Hover, TextColor3 = Theme.TextSecondary }, 0.15)
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(MainFrame, { Size = UDim2.new(0, 0, 0, 0) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		Tween(WindowShadow, { ImageTransparency = 1 }, 0.25)
		task.delay(0.3, function()
			if AcrylicBlur then AcrylicBlur:Destroy() end
			ScreenGui:Destroy()
		end)
	end)

	-- Minimize button
	local MinBtn = New("TextButton", {
		Position = UDim2.new(1, -72, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundColor3 = Theme.Hover,
		BorderSizePixel = 0,
		Text = "–",
		TextColor3 = Theme.TextSecondary,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 7,
	}, TopBar)
	New("UICorner", { CornerRadius = UDim.new(0, 8) }, MinBtn)
	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, { BackgroundColor3 = Theme.CardBorder }, 0.15)
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, { BackgroundColor3 = Theme.Hover }, 0.15)
	end)

	-- Tab content holder
	local TabHose = New("Frame", {
		Name = "TabHose",
		Position = UDim2.new(0, 0, 0, 52),
		Size = UDim2.new(1, 0, 1, -52),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 5,
	}, ContentArea)

	-- ── Add Tab ──────────────────────────────
	function WindowObj:AddTab(tabName, iconName)
		tabOrder = tabOrder + 1
		local tabIndex = tabOrder
		local isFirst = tabIndex == 1

		-- Sidebar tab button
		local TabBtn = New("Frame", {
			Name = "Tab_" .. tabName,
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = isFirst and Theme.TextPrimary or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = isFirst and 0 or 1,
			BorderSizePixel = 0,
			LayoutOrder = tabIndex,
			ZIndex = 13,
		}, TabList)
		New("UICorner", { CornerRadius = UDim.new(0, 10) }, TabBtn)

		-- Blue accent bar on active
		local AccentBar = New("Frame", {
			Name = "AccentBar",
			Size = UDim2.new(0, 3, 0.55, 0),
			Position = UDim2.new(1, -3, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			Visible = isFirst,
			ZIndex = 14,
		}, TabBtn)
		New("UICorner", { CornerRadius = UDim.new(1, 0) }, AccentBar)

		local TabIcon = New("ImageLabel", {
			Position = UDim2.new(0, 14, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, 18, 0, 18),
			BackgroundTransparency = 1,
			ImageColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary,
			ZIndex = 14,
		}, TabBtn)
		GetImageData(iconName or "home", TabIcon)

		local TabLabel = New("TextLabel", {
			Position = UDim2.new(0, 42, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -55, 0, 18),
			BackgroundTransparency = 1,
			Text = tabName,
			TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary,
			TextSize = 13,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 14,
		}, TabBtn)

		local ClickArea = New("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 15,
		}, TabBtn)

		-- Content columns
		local Left = New("ScrollingFrame", {
			Name = "Left",
			Size = UDim2.new(0.48, 0, 1, -16),
			Position = UDim2.new(0.02, 0, 0, 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.CardBorder,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = isFirst,
			ZIndex = 6,
		}, TabHose)
		New("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, Left)
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 4),
		}, Left)

		local Right = New("ScrollingFrame", {
			Name = "Right",
			Size = UDim2.new(0.48, 0, 1, -16),
			Position = UDim2.new(0.50, 0, 0, 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.CardBorder,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = isFirst,
			LayoutOrder = 1,
			ZIndex = 6,
		}, TabHose)
		New("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, Right)
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 8),
		}, Right)

		local function HideContent()
			Left.Visible = false
			Right.Visible = false
			Tween(TabBtn, { BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255,255,255) }, 0.18)
			Tween(TabLabel, { TextColor3 = Theme.TextSecondary }, 0.18)
			Tween(TabIcon, { ImageColor3 = Theme.TextSecondary }, 0.18)
			AccentBar.Visible = false
		end

		local function ShowContent()
			Left.Visible = true
			Right.Visible = true
			Tween(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.TextPrimary }, 0.2)
			Tween(TabLabel, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
			Tween(TabIcon, { ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
			AccentBar.Visible = true
			PageTitle.Text = tabName
		end

		table.insert(tabs, {
			btn = TabBtn,
			icon = TabIcon,
			txt = TabLabel,
			hide = HideContent,
			show = ShowContent,
			left = Left,
			right = Right,
		})

		ClickArea.MouseButton1Click:Connect(function()
			for _, t in ipairs(tabs) do
				t.hide()
			end
			ShowContent()
			activeTabIndex = tabIndex
		end)

		if isFirst then
			activeTabIndex = tabIndex
			PageTitle.Text = tabName
		end

		-- Hover
		ClickArea.MouseEnter:Connect(function()
			if activeTabIndex ~= tabIndex then
				Tween(TabBtn, { BackgroundTransparency = 0.92, BackgroundColor3 = Theme.Hover }, 0.12)
			end
		end)
		ClickArea.MouseLeave:Connect(function()
			if activeTabIndex ~= tabIndex then
				Tween(TabBtn, { BackgroundTransparency = 1 }, 0.12)
			end
		end)

		local TabObj = {}
		local sectionOrder = { left = 0, right = 0 }

		-- ── Add Section ──────────────────────
		function TabObj:AddSection(title, side)
			side = (side or "left"):lower()
			local parentCol = (side == "right") and Right or Left
			sectionOrder[side] = sectionOrder[side] + 1

			local Section = CreateCard(parentCol, {
				Name = "Section_" .. title,
				Size = UDim2.new(1, 0, 0, 0),
				CornerRadius = 14,
			})
			Section.AutomaticSize = Enum.AutomaticSize.Y
			Section.LayoutOrder = sectionOrder[side]

			New("UIPadding", {
				PaddingTop = UDim.new(0, 14),
				PaddingBottom = UDim.new(0, 14),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
			}, Section)

			local SectionTitle = New("TextLabel", {
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Text = title,
				TextColor3 = Theme.TextPrimary,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 0,
				ZIndex = 7,
			}, Section)

			local SectionContent = New("Frame", {
				Name = "Content",
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1,
				ZIndex = 7,
			}, Section)
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, SectionContent)
			New("UIPadding", {
				PaddingTop = UDim.new(0, 10),
			}, SectionContent)

			-- Make Section use list layout
			local secLayout = New("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, Section)

			local SectionObj = {}
			local elementOrder = 0

			local function nextOrder()
				elementOrder = elementOrder + 1
				return elementOrder
			end

			-- ── Toggle ───────────────────────
			function SectionObj:AddToggle(text, default, callback)
				default = default or false
				local order = nextOrder()

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(1, -56, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local ToggleBg = New("Frame", {
					Position = UDim2.new(1, -44, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 44, 0, 24),
					BackgroundColor3 = default and Theme.Accent or Theme.ToggleOff,
					BorderSizePixel = 0,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, ToggleBg)

				local Knob = New("Frame", {
					Position = default and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 18, 0, 18),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 10,
				}, ToggleBg)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, Knob)
				-- Soft shadow on knob
				New("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 0,
					Transparency = 0.9,
				}, Knob)

				local enabled = default
				local Click = New("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 11,
				}, Row)

				Click.MouseButton1Click:Connect(function()
					enabled = not enabled
					Tween(ToggleBg, { BackgroundColor3 = enabled and Theme.Accent or Theme.ToggleOff }, 0.18)
					Tween(Knob, {
						Position = enabled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
					}, 0.18, Enum.EasingStyle.Back)
					if callback then callback(enabled) end
				end)

				local obj = {}
				function obj:Set(v)
					enabled = v
					Tween(ToggleBg, { BackgroundColor3 = enabled and Theme.Accent or Theme.ToggleOff }, 0.18)
					Tween(Knob, {
						Position = enabled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
					}, 0.18)
					if callback then callback(enabled) end
				end
				function obj:Get() return enabled end
				table.insert(_registeredElements, { key = "toggle_" .. text, obj = obj })
				return obj
			end

			-- ── Button ───────────────────────
			function SectionObj:AddButton(text, callback)
				local order = nextOrder()

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 42),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local container, btn = CreateOffsetButton(Row, {
					Size = UDim2.new(1, 0, 0, 38),
					Text = text,
					BackgroundColor3 = Theme.Accent,
					TextSize = 13,
					CornerRadius = 10,
					Offset = 3,
					ZIndex = 9,
				})

				btn.MouseButton1Click:Connect(function()
					if callback then callback() end
				end)

				return btn
			end

			-- ── Slider ───────────────────────
			function SectionObj:AddSlider(text, min, max, default, callback)
				min = min or 0
				max = max or 100
				default = default or min
				local order = nextOrder()
				local value = default

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 52),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(0.7, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local ValueLabel = New("TextLabel", {
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.new(0.3, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = tostring(default),
					TextColor3 = Theme.Accent,
					TextSize = 13,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right,
					ZIndex = 9,
				}, Row)

				local Track = New("Frame", {
					Position = UDim2.new(0, 0, 0, 30),
					Size = UDim2.new(1, 0, 0, 6),
					BackgroundColor3 = Theme.ToggleOff,
					BorderSizePixel = 0,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, Track)

				local Fill = New("Frame", {
					Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel = 0,
					ZIndex = 10,
				}, Track)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, Fill)

				local Knob = New("Frame", {
					Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 16, 0, 16),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 11,
				}, Track)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, Knob)
				New("UIStroke", {
					Color = Theme.Accent,
					Thickness = 2,
				}, Knob)

				local sliding = false
				local function update(inputX)
					local rel = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
					value = math.floor(min + (max - min) * rel + 0.5)
					Fill.Size = UDim2.new(rel, 0, 1, 0)
					Knob.Position = UDim2.new(rel, 0, 0.5, 0)
					ValueLabel.Text = tostring(value)
					if callback then callback(value) end
				end

				Track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						update(input.Position.X)
					end
				end)
				Knob.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						update(input.Position.X)
					end
				end)

				local obj = {}
				function obj:Set(v)
					value = math.clamp(v, min, max)
					local rel = (value - min) / (max - min)
					Fill.Size = UDim2.new(rel, 0, 1, 0)
					Knob.Position = UDim2.new(rel, 0, 0.5, 0)
					ValueLabel.Text = tostring(value)
					if callback then callback(value) end
				end
				function obj:Get() return value end
				table.insert(_registeredElements, { key = "slider_" .. text, obj = obj })
				return obj
			end

			-- ── Dropdown ─────────────────────
			function SectionObj:AddDropdown(text, options, default, callback)
				options = options or {}
				default = default or (options[1] or "")
				local order = nextOrder()
				local selected = default
				local open = false

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(0.4, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local DropBtn = New("TextButton", {
					Position = UDim2.new(0.42, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0.58, 0, 0, 32),
					BackgroundColor3 = Theme.InputBg,
					BorderSizePixel = 0,
					Text = "  " .. selected,
					TextColor3 = Theme.TextPrimary,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 8) }, DropBtn)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, DropBtn)

				local Arrow = New("TextLabel", {
					Position = UDim2.new(1, -22, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 16, 0, 16),
					BackgroundTransparency = 1,
					Text = "▾",
					TextColor3 = Theme.TextMuted,
					TextSize = 12,
					Font = Enum.Font.GothamBold,
					ZIndex = 10,
				}, DropBtn)

				local DropList = New("Frame", {
					Position = UDim2.new(0.42, 0, 1, 4),
					Size = UDim2.new(0.58, 0, 0, 0),
					BackgroundColor3 = Theme.Card,
					BorderSizePixel = 0,
					Visible = false,
					ClipsDescendants = true,
					ZIndex = 50,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 8) }, DropList)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, DropList)
				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0),
				}, DropList)

				for i, opt in ipairs(options) do
					local OptBtn = New("TextButton", {
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = Theme.Card,
						BorderSizePixel = 0,
						Text = "  " .. opt,
						TextColor3 = Theme.TextPrimary,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutoButtonColor = false,
						LayoutOrder = i,
						ZIndex = 51,
					}, DropList)
					OptBtn.MouseEnter:Connect(function()
						Tween(OptBtn, { BackgroundColor3 = Theme.AccentSoft }, 0.1)
					end)
					OptBtn.MouseLeave:Connect(function()
						Tween(OptBtn, { BackgroundColor3 = Theme.Card }, 0.1)
					end)
					OptBtn.MouseButton1Click:Connect(function()
						selected = opt
						DropBtn.Text = "  " .. selected
						open = false
						Tween(DropList, { Size = UDim2.new(0.58, 0, 0, 0) }, 0.15)
						task.delay(0.15, function() DropList.Visible = false end)
						UnregisterPopup(DropList)
						if callback then callback(selected) end
					end)
				end

				DropBtn.MouseButton1Click:Connect(function()
					open = not open
					if open then
						CloseAllPopupsExcept(DropList)
						DropList.Visible = true
						local h = math.min(#options * 30, 150)
						Tween(DropList, { Size = UDim2.new(0.58, 0, 0, h) }, 0.18)
						RegisterPopup(DropList, function()
							open = false
							Tween(DropList, { Size = UDim2.new(0.58, 0, 0, 0) }, 0.15)
							task.delay(0.15, function() DropList.Visible = false end)
							UnregisterPopup(DropList)
						end)
					else
						Tween(DropList, { Size = UDim2.new(0.58, 0, 0, 0) }, 0.15)
						task.delay(0.15, function() DropList.Visible = false end)
						UnregisterPopup(DropList)
					end
				end)

				local obj = {}
				function obj:Set(v)
					selected = v
					DropBtn.Text = "  " .. selected
					if callback then callback(selected) end
				end
				function obj:Get() return selected end
				table.insert(_registeredElements, { key = "dropdown_" .. text, obj = obj })
				return obj
			end

			-- ── TextBox ──────────────────────
			function SectionObj:AddTextBox(text, placeholder, callback)
				local order = nextOrder()
				placeholder = placeholder or "Enter text..."

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(0.35, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local Box = New("TextBox", {
					Position = UDim2.new(0.38, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0.62, 0, 0, 32),
					BackgroundColor3 = Theme.InputBg,
					BorderSizePixel = 0,
					PlaceholderText = placeholder,
					PlaceholderColor3 = Theme.TextMuted,
					Text = "",
					TextColor3 = Theme.TextPrimary,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 8) }, Box)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, Box)
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
				}, Box)

				Box.Focused:Connect(function()
					Tween(Box:FindFirstChildOfClass("UIStroke"), { Color = Theme.Accent }, 0.15)
				end)
				Box.FocusLost:Connect(function(enter)
					Tween(Box:FindFirstChildOfClass("UIStroke"), { Color = Theme.CardBorder }, 0.15)
					if callback then callback(Box.Text, enter) end
				end)

				local obj = {}
				function obj:Set(v) Box.Text = tostring(v) end
				function obj:Get() return Box.Text end
				table.insert(_registeredElements, { key = "textbox_" .. text, obj = obj })
				return obj
			end

			-- ── Label / Paragraph ─────────────
			function SectionObj:AddLabel(text)
				local order = nextOrder()
				local Label = New("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextSecondary,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					LayoutOrder = order,
					ZIndex = 9,
				}, SectionContent)
				return Label
			end

			-- ── Color Picker ─────────────────
			function SectionObj:AddColorPicker(text, default, callback)
				default = default or Color3.fromRGB(0, 120, 255)
				local order = nextOrder()
				local h, s, v = Color3.toHSV(default)
				local color = { h, s, v }
				local pickerOpen = false

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(1, -48, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local ColorBtn = New("TextButton", {
					Position = UDim2.new(1, -36, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 32, 0, 24),
					BackgroundColor3 = default,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 6) }, ColorBtn)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, ColorBtn)

				-- Picker popup
				local PickerFrame = New("Frame", {
					Position = UDim2.new(1, -200, 1, 6),
					Size = UDim2.new(0, 200, 0, 180),
					BackgroundColor3 = Theme.Card,
					BorderSizePixel = 0,
					Visible = false,
					ZIndex = 60,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 12) }, PickerFrame)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, PickerFrame)

				local RGB = New("ImageButton", {
					Position = UDim2.new(0.05, 0, 0.06, 0),
					Size = UDim2.new(0.7, 0, 0.7, 0),
					Image = "rbxassetid://14333614705",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 61,
				}, PickerFrame)
				New("UICorner", { CornerRadius = UDim.new(0, 6) }, RGB)

				local RGBCircle = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 12, 0, 12),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 62,
				}, RGB)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, RGBCircle)
				New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 1 }, RGBCircle)

				local Darkness = New("ImageButton", {
					Position = UDim2.new(0.8, 0, 0.06, 0),
					Size = UDim2.new(0.14, 0, 0.7, 0),
					Image = "rbxassetid://156579757",
					BackgroundColor3 = default,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 61,
				}, PickerFrame)
				New("UICorner", { CornerRadius = UDim.new(0, 4) }, Darkness)

				local DarknessCircle = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(1.2, 0, 0, 4),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 62,
				}, Darkness)
				New("UICorner", { CornerRadius = UDim.new(1, 0) }, DarknessCircle)

				local HexLabel = New("TextLabel", {
					Position = UDim2.new(0.05, 0, 0.82, 0),
					Size = UDim2.new(0.9, 0, 0.12, 0),
					BackgroundColor3 = Theme.InputBg,
					Text = string.format("#%02X%02X%02X", default.R*255, default.G*255, default.B*255),
					TextColor3 = Theme.TextPrimary,
					TextSize = 12,
					Font = Enum.Font.GothamBold,
					ZIndex = 61,
				}, PickerFrame)
				New("UICorner", { CornerRadius = UDim.new(0, 6) }, HexLabel)

				local function updateColor()
					local c = Color3.fromHSV(color[1], color[2], color[3])
					ColorBtn.BackgroundColor3 = c
					Darkness.BackgroundColor3 = Color3.fromHSV(color[1], color[2], 1)
					HexLabel.Text = string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
					if callback then callback(c) end
				end

				local wheelDown, slideDown = false, false

				local function updateRing()
					local ml = UserInputService:GetMouseLocation()
					local x = math.clamp((ml.X - RGB.AbsolutePosition.X) / RGB.AbsoluteSize.X, 0, 1)
					local y = math.clamp((ml.Y - RGB.AbsolutePosition.Y) / RGB.AbsoluteSize.Y, 0, 1)
					RGBCircle.Position = UDim2.new(x, 0, y, 0)
					color = { 1 - x, 1 - y, color[3] }
					updateColor()
				end

				local function updateSlide()
					local ml = UserInputService:GetMouseLocation()
					local y = math.clamp((ml.Y - Darkness.AbsolutePosition.Y) / Darkness.AbsoluteSize.Y, 0, 1)
					DarknessCircle.Position = UDim2.new(0.5, 0, y, 0)
					color[3] = 1 - y
					updateColor()
				end

				RGB.MouseButton1Down:Connect(function() wheelDown = true; updateRing() end)
				Darkness.MouseButton1Down:Connect(function() slideDown = true; updateSlide() end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						wheelDown = false
						slideDown = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if wheelDown then updateRing() end
						if slideDown then updateSlide() end
					end
				end)

				ColorBtn.MouseButton1Click:Connect(function()
					pickerOpen = not pickerOpen
					if pickerOpen then
						CloseAllPopupsExcept(PickerFrame)
						PickerFrame.Visible = true
						RegisterPopup(PickerFrame, function()
							pickerOpen = false
							PickerFrame.Visible = false
							UnregisterPopup(PickerFrame)
						end)
					else
						PickerFrame.Visible = false
						UnregisterPopup(PickerFrame)
					end
				end)

				-- Init positions
				task.defer(function()
					RGBCircle.Position = UDim2.new(1 - h, 0, 1 - s, 0)
					DarknessCircle.Position = UDim2.new(0.5, 0, 1 - v, 0)
				end)

				local obj = {}
				function obj:Set(c)
					local nh, ns, nv = Color3.toHSV(c)
					color = { nh, ns, nv }
					updateColor()
					RGBCircle.Position = UDim2.new(1 - nh, 0, 1 - ns, 0)
					DarknessCircle.Position = UDim2.new(0.5, 0, 1 - nv, 0)
				end
				function obj:Get()
					return Color3.fromHSV(color[1], color[2], color[3])
				end
				table.insert(_registeredElements, { key = "colorpicker_" .. text, obj = obj })
				return obj
			end

			-- ── Keybind ──────────────────────
			function SectionObj:AddKeybind(text, default, callback)
				default = default or Enum.KeyCode.Unknown
				local order = nextOrder()
				local key = default
				local listening = false

				local Row = New("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)

				local Label = New("TextLabel", {
					Size = UDim2.new(0.55, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9,
				}, Row)

				local KeyBtn = New("TextButton", {
					Position = UDim2.new(0.58, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0.42, 0, 0, 28),
					BackgroundColor3 = Theme.InputBg,
					BorderSizePixel = 0,
					Text = key.Name,
					TextColor3 = Theme.TextPrimary,
					TextSize = 12,
					Font = Enum.Font.GothamBold,
					AutoButtonColor = false,
					ZIndex = 9,
				}, Row)
				New("UICorner", { CornerRadius = UDim.new(0, 8) }, KeyBtn)
				New("UIStroke", {
					Color = Theme.CardBorder,
					Thickness = 1,
				}, KeyBtn)

				KeyBtn.MouseButton1Click:Connect(function()
					listening = true
					KeyBtn.Text = "..."
					Tween(KeyBtn:FindFirstChildOfClass("UIStroke"), { Color = Theme.Accent }, 0.15)
				end)

				UserInputService.InputBegan:Connect(function(input, gp)
					if not listening then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						key = input.KeyCode
						KeyBtn.Text = key.Name
						listening = false
						Tween(KeyBtn:FindFirstChildOfClass("UIStroke"), { Color = Theme.CardBorder }, 0.15)
						if callback then callback(key) end
					end
				end)

				local obj = {}
				function obj:Set(k)
					key = k
					KeyBtn.Text = key.Name
				end
				function obj:Get() return key end
				table.insert(_registeredElements, { key = "keybind_" .. text, obj = obj })
				return obj
			end

			-- ── Separator ────────────────────
			function SectionObj:AddSeparator()
				local order = nextOrder()
				local Sep = New("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Theme.CardBorder,
					BorderSizePixel = 0,
					LayoutOrder = order,
					ZIndex = 8,
				}, SectionContent)
				return Sep
			end

			return SectionObj
		end

		return TabObj
	end

	-- Notification system
	function WindowObj:Notify(title, content, duration)
		duration = duration or 3
		local Notif = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -20, 0, -80),
			Size = UDim2.new(0, 280, 0, 70),
			BackgroundColor3 = Theme.Card,
			BorderSizePixel = 0,
			ZIndex = 100,
		}, ScreenGui)
		New("UICorner", { CornerRadius = UDim.new(0, 12) }, Notif)
		New("UIStroke", {
			Color = Theme.CardBorder,
			Thickness = 1,
		}, Notif)

		-- Accent bar
		local Bar = New("Frame", {
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			ZIndex = 101,
		}, Notif)
		New("UICorner", { CornerRadius = UDim.new(0, 4) }, Bar)

		New("TextLabel", {
			Position = UDim2.new(0, 16, 0, 12),
			Size = UDim2.new(1, -28, 0, 18),
			BackgroundTransparency = 1,
			Text = title,
			TextColor3 = Theme.TextPrimary,
			TextSize = 13,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 101,
		}, Notif)

		New("TextLabel", {
			Position = UDim2.new(0, 16, 0, 34),
			Size = UDim2.new(1, -28, 0, 24),
			BackgroundTransparency = 1,
			Text = content,
			TextColor3 = Theme.TextSecondary,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ZIndex = 101,
		}, Notif)

		Tween(Notif, { Position = UDim2.new(1, -20, 0, 20) }, 0.35, Enum.EasingStyle.Back)
		task.delay(duration, function()
			Tween(Notif, { Position = UDim2.new(1, -20, 0, -80) }, 0.3)
			task.delay(0.35, function() Notif:Destroy() end)
		end)
	end

	return WindowObj
end

return Library
