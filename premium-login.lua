--[[
	Premium key system dashboard frontend.
	Same visual direction as ui/ui_library/ui.lua, but standalone and backend-ready.

	Usage:

	local key_system = loadstring(readfile("ui/key_system/key_sys.lua"))()

	local view = key_system.create({
		product_name = "Axon",
		product_tag = "PREMIUM GATEWAY",
		version = "v2.4.1",
		build = "GLASSMORPH",
		invite_url = "https://discord.gg/yourinvite",
		luarmor = {
			enabled = true,
			script_id = "your_luarmor_script_id",
			project_id = "optional_reference_only",
			save_key = true,
			save_file = "AxonAssets/AxonKey_Save.txt",
			auto_check_saved_key = true,
			load_on_success = true,
			load_target = nil, -- optional function or URL, otherwise api.load_script()
		},
	})
]]

local function safe_cloneref(instance)
	if cloneref then
		local ok, result = pcall(cloneref, instance)
		if ok and result then
			return result
		end
	end

	return instance
end

local players = safe_cloneref(game:GetService("Players"))
local tween_service = safe_cloneref(game:GetService("TweenService"))
local user_input_service = safe_cloneref(game:GetService("UserInputService"))
local core_gui = safe_cloneref(game:GetService("CoreGui"))
local http_service = safe_cloneref(game:GetService("HttpService"))

local local_player = players.LocalPlayer

local dim2 = UDim2.new
local vec2 = Vector2.new
local rgb = Color3.fromRGB
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local theme = {
	outline = rgb(15, 14, 71),
	inline = rgb(39, 39, 87),
	accent = rgb(134, 134, 172),
	high_contrast = rgb(15, 14, 71),
	low_contrast = rgb(80, 80, 129),
	header_surface = rgb(80, 80, 129),
	sidebar_surface = rgb(29, 29, 87),
	content_surface = rgb(16, 16, 74),
	section_surface = rgb(23, 23, 81),
	nav_surface = rgb(90, 90, 143),
	control_surface = rgb(70, 70, 122),
	text = rgb(226, 226, 229),
	text_secondary = rgb(200, 201, 218),
	value_text = rgb(200, 201, 218),
	separator = rgb(53, 53, 106),
	surface_highlight = rgb(154, 154, 192),
	glass_tint = rgb(39, 39, 87),
	glow = rgb(134, 134, 172),
	shadow = rgb(15, 14, 71),
	success = rgb(105, 187, 146),
	error = rgb(211, 108, 122),
	warning = rgb(218, 186, 111),
}

theme.contrast = rgbseq({
	rgbkey(0, theme.low_contrast),
	rgbkey(1, theme.inline),
})

local fonts = {
	hero = Enum.Font.GothamBlack,
	title = Enum.Font.GothamBold,
	section = Enum.Font.GothamSemibold,
	body = Enum.Font.GothamMedium,
	small = Enum.Font.Gotham,
	mono = Enum.Font.Code,
}

local sizes = {
	hero = 30,
	title = 18,
	section = 14,
	body = 13,
	small = 11,
	micro = 10,
}

local key_system = {}
local dashboard = {}
dashboard.__index = dashboard
local icon_cache = {}
local luarmor_api_cache = {}

local default_luarmor_config = { 
	enabled = false,
	script_id = "",
	project_id = "",
	library_url = "https://sdkapi-public.luarmor.net/library.lua",
	save_key = true,
	save_file = "AxonAssets/AxonKey_Save.txt",
	auto_check_saved_key = false,
	load_on_success = true,
	load_target = nil,
	destroy_on_success = false,
}

local function trim_string(value)
	return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function create_instance(class_name, properties)
	local instance = Instance.new(class_name)

	for property, value in pairs(properties or {}) do
		instance[property] = value
	end

	return instance
end

local function tween(object, properties, duration, style, direction)
	local tween_object = tween_service:Create(
		object,
		TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
		properties
	)

	tween_object:Play()
	return tween_object
end

local function apply_corner(parent, radius)
	return create_instance("UICorner", {
		Parent = parent,
		CornerRadius = UDim.new(0, radius or 8),
	})
end

local function apply_stroke(parent, color_value, transparency, thickness)
	return create_instance("UIStroke", {
		Parent = parent,
		Color = color_value or theme.outline,
		Transparency = transparency == nil and 0.38 or transparency,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Round,
	})
end

local function apply_gradient(parent, colors, rotation, transparency)
	return create_instance("UIGradient", {
		Parent = parent,
		Color = colors or theme.contrast,
		Rotation = rotation or 90,
		Transparency = transparency,
	})
end

local function create_shadow(parent, radius, transparency, offset)
	local shadow = create_instance("Frame", {
		Parent = parent,
		Name = "Shadow",
		Position = dim2(0, 0, 0, offset or 10),
		Size = dim2(1, 0, 1, 0),
		BackgroundColor3 = theme.shadow,
		BackgroundTransparency = transparency == nil and 0.82 or transparency,
		BorderSizePixel = 0,
		ZIndex = math.max(0, (parent.ZIndex or 1) - 1),
	})

	apply_corner(shadow, radius or 12)
	return shadow
end

local function create_text(parent, properties)
	local sanitized = {}
	for property, value in pairs(properties) do
		if property ~= "button" then
			sanitized[property] = value
		end
	end
	sanitized.Parent = parent

	local label = create_instance(properties.button and "TextButton" or "TextLabel", sanitized)
	label.Font = properties.Font or fonts.body
	label.TextColor3 = properties.TextColor3 or theme.text
	label.TextSize = properties.TextSize or sizes.body
	label.BackgroundTransparency = properties.BackgroundTransparency == nil and 1 or label.BackgroundTransparency
	label.BorderSizePixel = 0

	if properties.button then
		label.AutoButtonColor = false
	end

	return label
end

local function get_mount_parent()
	if gethui then
		local ok, result = pcall(gethui)
		if ok and result then
			return result
		end
	end

	if local_player then
		local player_gui = local_player:FindFirstChildOfClass("PlayerGui")
		if player_gui then
			return player_gui
		end
	end

	return core_gui
end

local function protect_gui(gui)
	if syn and syn.protect_gui then
		pcall(syn.protect_gui, gui)
	elseif protectgui then
		pcall(protectgui, gui)
	end
end

local function get_clipboard_text()
	local readers = {
		getclipboard,
		readclipboard,
		clipboard and clipboard.get or nil,
	}

	for _, reader in ipairs(readers) do
		if type(reader) == "function" then
			local ok, result = pcall(reader)
			if ok and type(result) == "string" and result ~= "" then
				return result
			end
		end
	end

	return nil
end

local function set_clipboard_text(value)
	local writers = {
		setclipboard,
		toclipboard,
		clipboard and clipboard.set or nil,
	}

	for _, writer in ipairs(writers) do
		if type(writer) == "function" then
			local ok = pcall(writer, value)
			if ok then
				return true
			end
		end
	end

	return false
end

local function short_guid()
	local ok, guid = pcall(function()
		return http_service:GenerateGUID(false)
	end)

	if ok and type(guid) == "string" and guid ~= "" then
		return guid:gsub("%-", ""):sub(1, 10):upper()
	end

	return "SESSION00"
end

local function format_seconds(total_seconds)
	local minutes = math.floor(total_seconds / 60)
	local seconds = total_seconds % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function ensure_folder_for_file(file_path)
	if not makefolder or not isfolder then
		return
	end

	local normalized = tostring(file_path or ""):gsub("\\", "/")
	local segments = {}

	for segment in normalized:gmatch("([^/]+)") do
		table.insert(segments, segment)
	end

	if #segments <= 1 then
		return
	end

	local current = ""
	for index = 1, #segments - 1 do
		current = current == "" and segments[index] or (current .. "/" .. segments[index])
		if not isfolder(current) then
			pcall(makefolder, current)
		end
	end
end

local function read_text_file(file_path)
	if not isfile or not readfile then
		return nil
	end

	if not isfile(file_path) then
		return nil
	end

	local ok, result = pcall(readfile, file_path)
	if not ok or type(result) ~= "string" then
		return nil
	end

	result = trim_string(result)
	return result ~= "" and result or nil
end

local function write_text_file(file_path, value)
	if not writefile then
		return false
	end

	ensure_folder_for_file(file_path)

	local ok = pcall(writefile, file_path, tostring(value or ""))
	return ok
end

local function load_luarmor_api(library_url)
	local target_url = trim_string(library_url)
	if target_url == "" then
		target_url = default_luarmor_config.library_url
	end

	if luarmor_api_cache[target_url] then
		return luarmor_api_cache[target_url]
	end

	local ok, result = pcall(function()
		local source = game:HttpGet(target_url)
		local chunk, err = loadstring(source)
		if not chunk then
			error(err or "Failed to compile Luarmor library.")
		end

		return chunk()
	end)

	if not ok or type(result) ~= "table" then
		return nil, tostring(result)
	end

	luarmor_api_cache[target_url] = result
	return result
end

local function assign_script_key(key_text)
	if getgenv then
		local ok, environment = pcall(getgenv)
		if ok and type(environment) == "table" then
			environment.script_key = key_text
		end
	end

	_G.script_key = key_text
	pcall(function()
		script_key = key_text
	end)
end

local function run_load_target(load_target, key_text, api, controller)
	if type(load_target) == "function" then
		local ok, result, extra = pcall(load_target, key_text, api, controller)
		if not ok then
			return false, result
		end

		if result == false then
			return false, extra or "Custom load target returned false."
		end

		return true, result
	end

	local payload = trim_string(load_target)
	if payload == "" then
		return false, "No load target configured."
	end

	local ok, result = pcall(function()
		local source = payload
		if payload:match("^https?://") then
			source = game:HttpGet(payload)
		end

		local chunk, err = loadstring(source)
		if not chunk then
			error(err or "Failed to compile load target.")
		end

		return chunk()
	end)

	if not ok then
		return false, result
	end

	if result == false then
		return false, "Load target returned false."
	end

	return true, result
end

local function format_luarmor_error(status)
	if type(status) ~= "table" then
		return "Luarmor returned an unexpected response."
	end

	local code = tostring(status.code or "")
	local message = trim_string(status.message or status.reason or status.detail or status.status)

	if message ~= "" then
		return message
	end

	local mapped = {
		KEY_INVALID = "Invalid key.",
		KEY_INCORRECT = "Invalid key.",
		KEY_EXPIRED = "This key has expired.",
		KEY_BANNED = "This key is banned.",
		KEY_HWID_LOCKED = "This key is locked to another device.",
		KEY_HWID_MISMATCH = "This key is locked to another device.",
		KEY_BLACKLISTED = "This key is blacklisted.",
	}

	return mapped[code] or ("Luarmor rejected the key" .. (code ~= "" and (" (" .. code .. ").") or "."))
end

local function get_custom_asset(path)
	if getcustomasset then
		local ok, result = pcall(getcustomasset, path)
		if ok and result then
			return result
		end
	end

	if getsynasset then
		local ok, result = pcall(getsynasset, path)
		if ok and result then
			return result
		end
	end

	return nil
end

local function resolve_icon_asset(icon)
	if icon == nil or icon == "" then
		return nil
	end

	if icon_cache[icon] ~= nil then
		return icon_cache[icon] or nil
	end

	if type(icon) == "number" then
		local asset = {image = "rbxassetid://" .. tostring(icon)}
		icon_cache[icon] = asset
		return asset
	end

	if type(icon) ~= "string" then
		icon_cache[icon] = false
		return nil
	end

	if string.find(icon, "rbxasset") or string.find(icon, "://") then
		local asset = {image = icon}
		icon_cache[icon] = asset
		return asset
	end

	local safe_name = string.match(string.lower(icon), "^%s*(.-)%s*$")
	safe_name = safe_name and safe_name:gsub("%s+", "-"):gsub("[^%w%-_]", "") or ""

	if safe_name == "" then
		icon_cache[icon] = false
		return nil
	end

	local folder = "ui/key_system/icons"
	local file_path = string.format("%s/lucide_%s.png", folder, safe_name)

	if makefolder and isfolder and not isfolder(folder) then
		pcall(makefolder, folder)
	end

	if isfile and writefile and not isfile(file_path) then
		local ok, data = pcall(function()
			return game:HttpGet(string.format(
				"https://api.iconify.design/lucide:%s.png?width=64&height=64&color=white",
				http_service:UrlEncode(safe_name)
			))
		end)

		if ok and type(data) == "string" and #data > 0 then
			pcall(writefile, file_path, data)
		end
	end

	if isfile and isfile(file_path) then
		local asset_path = get_custom_asset(file_path)
		if asset_path then
			local asset = {image = asset_path}
			icon_cache[icon] = asset
			return asset
		end
	end

	icon_cache[icon] = false
	return nil
end

local function create_orbit_visual(parent, properties)
	local cfg = properties or {}
	local container = create_instance("Frame", {
		Parent = parent,
		Name = cfg.Name or "OrbitVisual",
		AnchorPoint = cfg.AnchorPoint or vec2(0.5, 0.5),
		Position = cfg.Position or dim2(0.5, 0, 0.5, 0),
		Size = cfg.Size or dim2(0, 220, 0, 220),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = cfg.ZIndex or 0,
	})

	local ring_size = cfg.RingSize or dim2(0, cfg.Size.X.Offset - 22, 0, cfg.Size.Y.Offset - 22)
	local inner_size = cfg.InnerSize or dim2(0, cfg.Size.X.Offset - 52, 0, cfg.Size.Y.Offset - 52)
	local dot_size = cfg.DotSize or dim2(0, 12, 0, 12)

	local outer_ring = create_instance("Frame", {
		Parent = container,
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = ring_size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = cfg.ZIndex or 0,
	})
	apply_corner(outer_ring, 999)

	create_instance("UIStroke", {
		Parent = outer_ring,
		Color = cfg.OuterColor or theme.separator,
		Thickness = cfg.OuterThickness or 1,
		Transparency = cfg.OuterTransparency == nil and 0.62 or cfg.OuterTransparency,
	})

	local inner_ring = create_instance("Frame", {
		Parent = container,
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = inner_size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = cfg.ZIndex or 0,
	})
	apply_corner(inner_ring, 999)

	create_instance("UIStroke", {
		Parent = inner_ring,
		Color = cfg.InnerColor or theme.accent,
		Thickness = cfg.InnerThickness or 1,
		Transparency = cfg.InnerTransparency == nil and 0.82 or cfg.InnerTransparency,
	})

	local orbit_dot = create_instance("Frame", {
		Parent = container,
		AnchorPoint = vec2(0.5, 0.5),
		Position = cfg.DotPosition or dim2(1, -10, 0.5, 0),
		Size = dot_size,
		BorderSizePixel = 0,
		BackgroundColor3 = cfg.DotColor or theme.accent,
		BackgroundTransparency = cfg.DotTransparency == nil and 0.06 or cfg.DotTransparency,
		ZIndex = (cfg.ZIndex or 0) + 1,
	})
	apply_corner(orbit_dot, 999)

	local orbit_dot_core = create_instance("Frame", {
		Parent = orbit_dot,
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = dim2(0, math.max(4, dot_size.X.Offset - 8), 0, math.max(4, dot_size.Y.Offset - 8)),
		BorderSizePixel = 0,
		BackgroundColor3 = cfg.DotCoreColor or theme.high_contrast,
		ZIndex = (cfg.ZIndex or 0) + 2,
	})
	apply_corner(orbit_dot_core, 999)

	return container
end

local function surface(parent, properties)
	local radius = properties.radius or 14

	local shell = create_instance("Frame", {
		Parent = parent,
		Name = properties.Name or "",
		AnchorPoint = properties.AnchorPoint,
		Position = properties.Position or dim2(),
		Size = properties.Size or dim2(1, 0, 0, 60),
		BackgroundColor3 = properties.OutlineColor or theme.outline,
		BackgroundTransparency = properties.OutlineTransparency == nil and 0.04 or properties.OutlineTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = properties.ClipsDescendants == true,
		ZIndex = properties.ZIndex,
		Visible = properties.Visible ~= false,
	})

	apply_corner(shell, radius)

	if properties.Shadow ~= false then
		create_shadow(shell, radius, properties.ShadowTransparency, properties.ShadowOffset)
	end

	local fill = create_instance("Frame", {
		Parent = shell,
		Name = "Fill",
		Position = dim2(0, 1, 0, 1),
		Size = dim2(1, -2, 1, -2),
		BackgroundColor3 = properties.FillColor or theme.section_surface,
		BackgroundTransparency = properties.FillTransparency == nil and 0.02 or properties.FillTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = properties.FillClipsDescendants ~= false,
		ZIndex = properties.ZIndex and (properties.ZIndex + 1) or nil,
	})

	apply_corner(fill, math.max(0, radius - 1))
	apply_stroke(fill, properties.StrokeColor or theme.outline, properties.StrokeTransparency, properties.StrokeThickness)

	if properties.Gradient ~= false then
		apply_gradient(fill, properties.GradientColor or theme.contrast, properties.GradientRotation or 90, properties.GradientTransparency)
	end

	return shell, fill
end

local function button_surface(parent, properties)
	local shell, fill = surface(parent, {
		Name = properties.Name,
		Position = properties.Position,
		Size = properties.Size,
		AnchorPoint = properties.AnchorPoint,
		FillColor = properties.FillColor,
		OutlineColor = properties.OutlineColor,
		Gradient = properties.Gradient,
		GradientColor = properties.GradientColor,
		GradientTransparency = properties.GradientTransparency,
		GradientRotation = properties.GradientRotation,
		radius = properties.radius or 12,
		Shadow = properties.Shadow,
		ShadowTransparency = properties.ShadowTransparency,
		ShadowOffset = properties.ShadowOffset,
		ZIndex = properties.ZIndex,
	})

	local hitbox = create_instance("TextButton", {
		Parent = fill,
		Name = "Hitbox",
		BackgroundTransparency = 1,
		Size = dim2(1, 0, 1, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = (fill.ZIndex or 1) + 3,
	})

	return shell, fill, hitbox
end

local function make_hoverable(fill, base_color, hover_color)
	return function(state)
		tween(fill, {
			BackgroundColor3 = state and hover_color or base_color,
		}, 0.18)
	end
end

function dashboard:_connect(connection)
	table.insert(self.connections, connection)
	return connection
end

function dashboard:_make_button(parent, properties)
	local shell, fill, hitbox = button_surface(parent, properties)
	local icon_asset = resolve_icon_asset(properties.Icon or properties.icon or properties.icon_image)
	local has_icon = icon_asset ~= nil
	local text_left = has_icon and 46 or 14

	local accent_strip = create_instance("Frame", {
		Parent = fill,
		AnchorPoint = vec2(0, 0.5),
		Position = dim2(0, text_left, 0.5, 0),
		Size = dim2(0, 20, 0, 2),
		BackgroundColor3 = properties.AccentColor or theme.accent,
		BackgroundTransparency = properties.AccentTransparency == nil and 0.04 or properties.AccentTransparency,
		BorderSizePixel = 0,
		ZIndex = (fill.ZIndex or 1) + 1,
	})
	apply_corner(accent_strip, 999)

	local icon_holder
	local icon
	if has_icon then
		icon_holder = create_instance("Frame", {
			Parent = fill,
			Position = dim2(0, 14, 0.5, -12),
			Size = dim2(0, 24, 0, 24),
			BackgroundColor3 = properties.IconSurfaceColor or theme.inline,
			BackgroundTransparency = properties.IconSurfaceTransparency == nil and 0.18 or properties.IconSurfaceTransparency,
			BorderSizePixel = 0,
			ZIndex = (fill.ZIndex or 1) + 1,
		})
		apply_corner(icon_holder, 8)

		icon = create_instance("ImageLabel", {
			Parent = icon_holder,
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(0, 14, 0, 14),
			BackgroundTransparency = 1,
			Image = icon_asset.image,
			ImageColor3 = properties.IconColor3 or theme.text,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = (icon_holder.ZIndex or 1) + 1,
		})
	end

	local label = create_text(fill, {
		Position = dim2(0, text_left, 0, 12),
		Size = dim2(1, -(text_left + 14), 0, 16),
		Text = properties.Text or "Button",
		Font = properties.Font or fonts.section,
		TextSize = properties.TextSize or sizes.body,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = (fill.ZIndex or 1) + 1,
	})

	local helper = create_text(fill, {
		Position = dim2(0, text_left, 0, 30),
		Size = dim2(1, -(text_left + 14), 0, 14),
		Text = properties.Helper or "",
		Font = fonts.small,
		TextSize = sizes.small,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = (fill.ZIndex or 1) + 1,
	})

	local base_color = properties.FillColor or theme.control_surface
	local hover_color = properties.HoverColor or theme.low_contrast
	local hover = make_hoverable(fill, base_color, hover_color)

	self:_connect(hitbox.MouseEnter:Connect(function()
		if not self.busy or properties.AllowWhileBusy == true then
			hover(true)
		end
	end))

	self:_connect(hitbox.MouseLeave:Connect(function()
		hover(false)
	end))

	self:_connect(hitbox.MouseButton1Down:Connect(function()
		if not self.busy or properties.AllowWhileBusy == true then
			tween(shell, {Size = shell.Size + dim2(0, 0, 0, -2)}, 0.08)
		end
	end))

	self:_connect(hitbox.MouseButton1Up:Connect(function()
		tween(shell, {Size = properties.Size}, 0.08)
	end))

	self:_connect(hitbox.MouseButton1Click:Connect(function()
		if self.busy and properties.AllowWhileBusy ~= true then
			return
		end

		if type(properties.Callback) == "function" then
			properties.Callback()
		end
	end))

	return {
		root = shell,
		fill = fill,
		button = hitbox,
		label = label,
		helper = helper,
		icon = icon,
		set_enabled = function(_, enabled)
			hitbox.Active = enabled
			hitbox.Selectable = enabled
			label.TextTransparency = enabled and 0 or 0.35
			helper.TextTransparency = enabled and 0 or 0.45
			accent_strip.BackgroundTransparency = enabled and 0.04 or 0.55
			if icon_holder then
				icon_holder.BackgroundTransparency = enabled and (properties.IconSurfaceTransparency == nil and 0.18 or properties.IconSurfaceTransparency) or 0.52
			end
			if icon then
				icon.ImageTransparency = enabled and 0 or 0.35
			end
			tween(fill, {
				BackgroundColor3 = enabled and base_color or theme.inline,
			}, 0.16)
		end,
	}
end

function dashboard:_make_metric_card(parent, properties)
	local shell, fill = surface(parent, {
		Position = properties.Position,
		Size = properties.Size,
		FillColor = properties.FillColor or theme.control_surface,
		GradientTransparency = numseq({
			numkey(0, 0.08),
			numkey(1, 0.28),
		}),
		radius = properties.radius or 12,
		ShadowTransparency = 0.9,
		ShadowOffset = 6,
		GradientRotation = 120,
	})

	local title = create_text(fill, {
		Position = dim2(0, 12, 0, 10),
		Size = dim2(1, -24, 0, 12),
		Text = properties.Title or "Metric",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = (fill.ZIndex or 1) + 1,
	})

	local value = create_text(fill, {
		Position = dim2(0, 12, 0, 24),
		Size = dim2(1, -24, 0, 20),
		Text = properties.Value or "--",
		Font = fonts.title,
		TextSize = 17,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = (fill.ZIndex or 1) + 1,
	})

	local note = create_text(fill, {
		Position = dim2(0, 12, 1, -20),
		Size = dim2(1, -24, 0, 10),
		Text = properties.Note or "",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.value_text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = (fill.ZIndex or 1) + 1,
	})

	return {
		root = shell,
		fill = fill,
		title = title,
		value = value,
		note = note,
		set = function(_, next_value, next_note)
			if next_value ~= nil then
				value.Text = tostring(next_value)
			end
			if next_note ~= nil then
				note.Text = tostring(next_note)
			end
		end,
	}
end

function dashboard:_make_step(parent, properties)
	local row = create_instance("Frame", {
		Parent = parent,
		Name = "StepRow",
		Size = dim2(1, 0, 0, 34),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	local dot_shell, dot_fill = surface(row, {
		Position = dim2(0, 0, 0.5, -9),
		Size = dim2(0, 18, 0, 18),
		FillColor = theme.inline,
		Gradient = false,
		radius = 999,
		Shadow = false,
	})

	local dot_core = create_instance("Frame", {
		Parent = dot_fill,
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = dim2(0, 6, 0, 6),
		BackgroundColor3 = theme.value_text,
		BackgroundTransparency = 0.18,
		BorderSizePixel = 0,
		ZIndex = (dot_fill.ZIndex or 1) + 1,
	})
	apply_corner(dot_core, 999)

	local title = create_text(row, {
		Position = dim2(0, 28, 0, 2),
		Size = dim2(1, -110, 0, 16),
		Text = properties.Title or "Step",
		Font = fonts.section,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local subtitle = create_text(row, {
		Position = dim2(0, 28, 0, 16),
		Size = dim2(1, -110, 0, 14),
		Text = properties.Subtitle or "",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local state_pill_shell, state_pill_fill = surface(row, {
		AnchorPoint = vec2(1, 0.5),
		Position = dim2(1, 0, 0.5, 0),
		Size = dim2(0, 76, 0, 20),
		FillColor = theme.control_surface,
		Gradient = false,
		radius = 999,
		Shadow = false,
	})

	local state_label = create_text(state_pill_fill, {
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = dim2(1, -12, 1, 0),
		Text = "Queued",
		Font = fonts.small,
		TextSize = sizes.small,
		TextColor3 = theme.value_text,
	})

	local card = {
		row = row,
		dot_fill = dot_fill,
		dot_core = dot_core,
		title = title,
		subtitle = subtitle,
		state_fill = state_pill_fill,
		state_label = state_label,
	}

	function card:set_state(state, detail)
		if state == "active" then
			dot_fill.BackgroundColor3 = theme.nav_surface
			dot_core.BackgroundColor3 = theme.accent
			state_pill_fill.BackgroundColor3 = theme.nav_surface
			state_label.Text = detail or "Running"
			state_label.TextColor3 = theme.text
		elseif state == "done" then
			dot_fill.BackgroundColor3 = theme.success
			dot_core.BackgroundColor3 = theme.text
			state_pill_fill.BackgroundColor3 = theme.success
			state_label.Text = detail or "Done"
			state_label.TextColor3 = theme.high_contrast
		elseif state == "error" then
			dot_fill.BackgroundColor3 = theme.error
			dot_core.BackgroundColor3 = theme.text
			state_pill_fill.BackgroundColor3 = theme.error
			state_label.Text = detail or "Error"
			state_label.TextColor3 = theme.text
		else
			dot_fill.BackgroundColor3 = theme.inline
			dot_core.BackgroundColor3 = theme.value_text
			state_pill_fill.BackgroundColor3 = theme.control_surface
			state_label.Text = detail or "Queued"
			state_label.TextColor3 = theme.value_text
		end
	end

	card:set_state("waiting", properties.StateText)
	return card
end

function dashboard:_make_log_row(message, tone_name)
	local tone_color = theme[tone_name] or theme.value_text

	local row = create_instance("Frame", {
		Parent = self.activity_list,
		Name = "LogRow",
		Size = dim2(1, 0, 0, 40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = #self.logs + 1,
	})

	local rail = create_instance("Frame", {
		Parent = row,
		Position = dim2(0, 0, 0, 8),
		Size = dim2(0, 2, 1, -16),
		BackgroundColor3 = tone_color,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
	})
	apply_corner(rail, 999)

	local stamp = create_text(row, {
		Position = dim2(0, 12, 0, 4),
		Size = dim2(0, 70, 0, 12),
		Text = os.date("!%H:%M:%S UTC"),
		Font = fonts.mono,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local text = create_text(row, {
		Position = dim2(0, 12, 0, 18),
		Size = dim2(1, -12, 0, 18),
		Text = tostring(message or ""),
		Font = fonts.small,
		TextSize = sizes.small,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.text,
	})

	return {
		root = row,
		stamp = stamp,
		text = text,
	}
end

function dashboard:_resize_activity_canvas()
	if not self.activity_layout or not self.activity_scroller then
		return
	end

	self.activity_scroller.CanvasSize = dim2(0, 0, 0, self.activity_layout.AbsoluteContentSize.Y + 4)
end

function dashboard:_set_metric(key, value, note)
	local card = self.metric_cards[key]
	if card then
		card:set(value, note)
	end
end

function dashboard:_update_fingerprint()
	if self.key_length_value then
		self.key_length_value.Text = string.format("%02d chars", #trim_string(self.key_box and self.key_box.Text or ""))
	end
end

function dashboard:_set_step(index, state, detail)
	local step = self.steps[index]
	if step then
		step:set_state(state, detail)
	end
end

function dashboard:set_progress(alpha)
	local clamped = math.clamp(tonumber(alpha) or 0, 0, 1)
	self.progress_value = clamped

	if self.progress_fill then
		tween(self.progress_fill, {
			Size = dim2(clamped, 0, 1, 0),
		}, 0.22)
	end

	if self.progress_text then
		self.progress_text.Text = string.format("%d%%", math.floor(clamped * 100 + 0.5))
	end
end

function dashboard:set_status(kind, message)
	local mode = kind or "idle"
	local color_value = theme.value_text
	local panel_color = theme.control_surface

	if mode == "authenticating" then
		color_value = theme.accent
		panel_color = theme.nav_surface
	elseif mode == "success" then
		color_value = theme.success
		panel_color = theme.success
	elseif mode == "error" then
		color_value = theme.error
		panel_color = theme.error
	elseif mode == "warning" then
		color_value = theme.warning
		panel_color = theme.warning
	elseif mode == "info" then
		color_value = theme.surface_highlight
		panel_color = theme.low_contrast
	end

	self.status_kind = mode

	if self.status_title then
		self.status_title.Text = ({
			idle = "Waiting For License",
			authenticating = "Authenticating Session",
			success = "Access Granted",
			error = "Validation Failed",
			warning = "Action Required",
			info = "System Notice",
		})[mode] or "Waiting For License"
	end

	if self.status_message then
		self.status_message.Text = tostring(message or "Paste your premium key to begin.")
	end

	if self.status_badge_fill then
		tween(self.status_badge_fill, {
			BackgroundColor3 = panel_color,
		}, 0.18)
	end

	if self.status_badge_text then
		self.status_badge_text.Text = string.upper(mode)
		self.status_badge_text.TextColor3 = mode == "success" and theme.high_contrast or theme.text
	end

	if self.live_dot then
		tween(self.live_dot, {
			BackgroundColor3 = color_value,
		}, 0.18)
	end

	if self.activity_hint then
		self.activity_hint.Text = ({
			idle = "Gateway armed and waiting for client input.",
			authenticating = "Running local mock pipeline while backend hooks are offline.",
			success = "Frontend flow completed. Attach backend validation next.",
			error = "Client mock rejected the current input or flow state.",
			warning = "Additional action required before session can proceed.",
			info = "Monitoring panel updated.",
		})[mode] or "Gateway armed and waiting for client input."
	end
end

function dashboard:set_busy(state)
	self.busy = state == true

	for _, button in ipairs(self.action_buttons) do
		button:set_enabled(not self.busy)
	end

	if self.key_box then
		self.key_box.TextEditable = not self.busy
	end

	if self.loader_sheen then
		self.loader_sheen.Visible = self.busy
	end
end

function dashboard:set_key(value)
	if self.key_box then
		self.key_box.Text = tostring(value or "")
		self:_update_fingerprint()
	end
end

function dashboard:get_key()
	return trim_string(self.key_box and self.key_box.Text or "")
end

function dashboard:set_metrics(metrics)
	if type(metrics) ~= "table" then
		return
	end

	for key, value in pairs(metrics) do
		if type(value) == "table" then
			self:_set_metric(key, value.value, value.note)
		else
			self:_set_metric(key, value, nil)
		end
	end
end

function dashboard:push_log(message, tone_name)
	if not self.activity_list or not self.activity_scroller or not self.activity_layout then
		return
	end

	local row = self:_make_log_row(message, tone_name)
	table.insert(self.logs, row)

	while #self.logs > 8 do
		local old = table.remove(self.logs, 1)
		if old and old.root then
			old.root:Destroy()
		end
	end

	for index, item in ipairs(self.logs) do
		if item.root then
			item.root.LayoutOrder = index
		end
	end

	self:_resize_activity_canvas()
	self.activity_scroller.CanvasPosition = vec2(0, math.max(0, self.activity_layout.AbsoluteContentSize.Y))
end

function dashboard:show()
	if self.screen_gui then
		self.screen_gui.Enabled = true
	end
end

function dashboard:hide()
	if self.screen_gui then
		self.screen_gui.Enabled = false
	end
end

function dashboard:_smooth_close(should_destroy)
	if self.destroyed or not self.screen_gui then
		if should_destroy then
			self:destroy()
		else
			self:hide()
		end
		return
	end

	if self.is_closing then
		return
	end

	self.is_closing = true
	self:set_busy(true)

	local close_duration = 0.28
	local root = self.window_root
	local overlay = self.overlay
	local initial_position = root and root.Position or nil
	local initial_size = root and root.Size or nil
	local initial_overlay_transparency = overlay and overlay.BackgroundTransparency or 0.12

	if root then
		tween(root, {
			Position = root.Position + dim2(0, 0, 0, 22),
			Size = root.Size + dim2(0, -30, 0, -24),
		}, close_duration, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	end

	if overlay then
		tween(overlay, {
			BackgroundTransparency = 1,
		}, close_duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	end

	task.delay(close_duration + 0.03, function()
		if self.destroyed then
			return
		end

		if should_destroy then
			self:destroy()
			return
		end

		self:hide()

		if root and initial_position and initial_size then
			root.Position = initial_position
			root.Size = initial_size
		end

		if overlay then
			overlay.BackgroundTransparency = initial_overlay_transparency
		end

		self.is_closing = false
		self:set_busy(false)
	end)
end

function dashboard:destroy()
	if self.destroyed then
		return
	end

	self.destroyed = true
	self.run_token = self.run_token + 1

	for _, connection in ipairs(self.connections) do
		if connection and connection.Disconnect then
			connection:Disconnect()
		end
	end

	if self.screen_gui then
		self.screen_gui:Destroy()
		self.screen_gui = nil
	end
end

function dashboard:_dragify(handle, target)
	local dragging = false
	local drag_origin
	local start_position

	self:_connect(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			drag_origin = input.Position
			start_position = target.Position

			self:_connect(input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end))
		end
	end))

	self:_connect(user_input_service.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - drag_origin
			target.Position = dim2(
				start_position.X.Scale,
				start_position.X.Offset + delta.X,
				start_position.Y.Scale,
				start_position.Y.Offset + delta.Y
			)
		end
	end))
end

function dashboard:_get_luarmor_config()
	if type(self.options.luarmor) ~= "table" then
		return nil
	end

	local merged = {}
	for key, value in pairs(default_luarmor_config) do
		merged[key] = value
	end

	for key, value in pairs(self.options.luarmor) do
		merged[key] = value
	end

	return merged
end

function dashboard:_authenticate_with_luarmor(key_text, source_label)
	local config = self:_get_luarmor_config()
	if not config or config.enabled ~= true then
		return false
	end

	key_text = trim_string(key_text or self:get_key())
	if key_text == "" then
		self:set_status("error", "A premium key is required before the session can start.")
		self:set_progress(0)
		self:push_log("Luarmor check rejected an empty key.", "error")
		self:set_busy(false)
		return true
	end

	local script_id = trim_string(config.script_id)
	local project_id = trim_string(config.project_id)
	if script_id == "" then
		local message = project_id ~= ""
			and "Set luarmor.script_id first. Luarmor key checks do not use project_id alone."
			or "Set luarmor.script_id in the config before authenticating."
		self:set_status("error", message)
		self:set_progress(0)
		self:push_log(message, "error")
		self:set_busy(false)
		return true
	end

	self.run_token = self.run_token + 1
	local token = self.run_token
	local source_name = trim_string(source_label) ~= "" and trim_string(source_label) or "Manual submit"

	self:set_busy(true)
	self:set_progress(0.12)
	self:set_status("authenticating", "Connecting to Luarmor and checking your key.")
	self:push_log(source_name .. ": Luarmor validation started.", "accent")

	task.spawn(function()
		local function still_valid()
			return not self.destroyed and token == self.run_token
		end

		local api, load_error = load_luarmor_api(config.library_url)
		if not still_valid() then
			return
		end

		if not api then
			self:set_busy(false)
			self:set_progress(0)
			self:set_status("error", "Failed to load the Luarmor library.")
			self:push_log("Luarmor library load failed: " .. tostring(load_error), "error")
			return
		end

		self:set_progress(0.34)

		local ok_set, set_error = pcall(function()
			api.script_id = script_id
		end)

		if not still_valid() then
			return
		end

		if not ok_set then
			self:set_busy(false)
			self:set_progress(0)
			self:set_status("error", "Failed to configure Luarmor for this script.")
			self:push_log("Unable to assign Luarmor script_id: " .. tostring(set_error), "error")
			return
		end

		self:set_progress(0.56)
		self:set_status("authenticating", "Validating the submitted key with Luarmor.")

		local ok_check, status = pcall(function()
			return api.check_key(key_text)
		end)

		if not still_valid() then
			return
		end

		if not ok_check then
			self:set_busy(false)
			self:set_progress(0)
			self:set_status("error", "Luarmor key validation failed to run.")
			self:push_log("Luarmor check_key error: " .. tostring(status), "error")
			return
		end

		if type(status) == "table" and status.code == "KEY_VALID" then
			assign_script_key(key_text)

			if config.save_key ~= false and trim_string(config.save_file) ~= "" then
				write_text_file(config.save_file, key_text)
			end

			self:set_progress(1)
			self:set_status("success", "Key accepted. Premium access granted.")
			self:push_log("Luarmor accepted the submitted key.", "success")

			local load_target = config.load_target
			if load_target ~= nil and load_target ~= false and load_target ~= "" then
				self:push_log("Queued configured post-auth load target.", "accent")
				task.spawn(function()
					local load_ok, load_result = run_load_target(load_target, key_text, api, self)
					if not load_ok then
						warn("[key_system] Load target failed: " .. tostring(load_result))
					end
				end)
			elseif config.load_on_success ~= false then
				self:push_log("Queued Luarmor script load for this script_id.", "accent")
				task.spawn(function()
					local load_ok, load_result = pcall(function()
						return api.load_script()
					end)
					if not load_ok then
						warn("[key_system] api.load_script() failed: " .. tostring(load_result))
					end
				end)
			end

			if not still_valid() then
				return
			end

			self:push_log("Authentication complete. Closing key system.", "accent")
			self:_smooth_close(config.destroy_on_success == true)

			return
		end

		self:set_busy(false)
		self:set_progress(0)
		self:set_status("error", format_luarmor_error(status))
		self:push_log("Luarmor rejected the key with code " .. tostring(type(status) == "table" and status.code or "UNKNOWN") .. ".", "error")
	end)

	return true
end

function dashboard:_auto_check_saved_luarmor_key()
	local config = self:_get_luarmor_config()
	if not config or config.enabled ~= true or config.auto_check_saved_key ~= true then
		return
	end

	local save_file = trim_string(config.save_file)
	if save_file == "" then
		return
	end

	local saved_key = read_text_file(save_file)
	if not saved_key then
		return
	end

	self:set_key(saved_key)
	self:push_log("Saved Luarmor key found. Checking it automatically.", "info")
	self:_authenticate_with_luarmor(saved_key, "Saved key")
end

function dashboard:_begin_fake_auth()
	local key_text = self:get_key()
	if key_text == "" then
		self:set_status("error", "A premium key is required before the session can start.")
		self:push_log("Rejected empty submit attempt.", "error")
		self:_set_step(1, "error", "No Key")
		return
	end

	self.run_token = self.run_token + 1
	local token = self.run_token

	self:set_busy(true)
	self:set_progress(0.08)
	self:set_status("authenticating", "Capturing client key and preparing the secure session.")
	self:push_log("Input accepted. Local mock authentication started.", "accent")

	for index = 1, #self.steps do
		self:_set_step(index, "waiting", "Queued")
	end

	task.spawn(function()
		local function still_valid()
			return not self.destroyed and token == self.run_token
		end

		local stages = {
			{
				progress = 0.22,
				metric = {"queue", "LIVE", "client routed"},
				status = "Hashing license payload locally.",
				log = "Step 1 complete: payload normalized.",
			},
			{
				progress = 0.46,
				metric = {"lock", "BOUND", "device synced"},
				status = "Checking session policy and reserved access lane.",
				log = "Step 2 complete: secure lane reserved.",
			},
			{
				progress = 0.72,
				metric = {"channel", "TLS-EDGE", "mock secure route"},
				status = "Negotiating secure route and response policy.",
				log = "Step 3 complete: tunnel warmed and staged.",
			},
			{
				progress = 1,
				metric = {"tier", "PREMIUM", "frontend ready"},
				status = "Frontend authentication finished. Backend connector still pending.",
				log = "Step 4 complete: UI mock flow succeeded.",
			},
		}

		for index, stage in ipairs(stages) do
			if not still_valid() then
				return
			end

			self:_set_step(index, "active", "Running")
			task.wait(0.65)

			if not still_valid() then
				return
			end

			self:set_progress(stage.progress)
			self:set_status(index == #stages and "success" or "authenticating", stage.status)
			self:_set_metric(stage.metric[1], stage.metric[2], stage.metric[3])
			self:push_log(stage.log, index == #stages and "success" or "accent")
			self:_set_step(index, "done", "Done")
		end

		if still_valid() then
			self:set_busy(false)
		end
	end)
end

function dashboard:_handle_authenticate()
	local luarmor_started = self:_authenticate_with_luarmor(self:get_key(), "Manual submit")
	if luarmor_started then
		return
	end

	local callback = self.options.on_authenticate
	if type(callback) == "function" then
		self.run_token = self.run_token + 1
		self:set_busy(true)
		self:set_status("authenticating", "Submitting key to external authentication handler.")
		self:push_log("Forwarded key to custom on_authenticate callback.", "accent")

		task.spawn(function()
			local ok, err = pcall(callback, self:get_key(), self)
			if not ok then
				self:set_busy(false)
				self:set_status("error", "Custom authentication callback threw an error.")
				self:push_log("Callback failure: " .. tostring(err), "error")
			end
		end)

		return
	end

	self:_begin_fake_auth()
end

function dashboard:_pulse_orbs()
	if self.ambient_orbits then
		for index, orbit in ipairs(self.ambient_orbits) do
			tween_service:Create(
				orbit,
				TweenInfo.new(16 + (index * 3), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
				{
					Rotation = index % 2 == 0 and -360 or 360,
				}
			):Play()
		end
	end

	if self.ambient_orbs then
		for index, orb in ipairs(self.ambient_orbs) do
			local direction = index % 2 == 0 and -1 or 1
			local goal_position = orb.Position + dim2(0, 18 * direction, 0, -16 * direction)
			local goal_transparency = math.max(0.12, orb.ImageTransparency - 0.08)

			tween_service:Create(
				orb,
				TweenInfo.new(7 + index, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
				{
					Position = goal_position,
					ImageTransparency = goal_transparency,
				}
			):Play()
		end
	end
end

function dashboard:_play_intro()
	self.overlay.BackgroundTransparency = 1
	self.window_root.Position = self.window_root.Position + dim2(0, 0, 0, 26)
	self.window_root.Size = self.window_root.Size + dim2(0, -28, 0, -26)

	tween(self.overlay, {
		BackgroundTransparency = 0.12,
	}, 0.32)

	tween(self.window_root, {
		Position = self.window_root.Position - dim2(0, 0, 0, 26),
		Size = self.window_root.Size + dim2(0, 28, 0, 26),
	}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

function dashboard:_bind_focus_state()
	self:_connect(self.key_box.Focused:Connect(function()
		tween(self.input_fill, {
			BackgroundColor3 = theme.low_contrast,
		}, 0.18)
	end))

	self:_connect(self.key_box.FocusLost:Connect(function(enter_pressed)
		tween(self.input_fill, {
			BackgroundColor3 = theme.control_surface,
		}, 0.18)
		self:_update_fingerprint()

		if enter_pressed then
			self:_handle_authenticate()
		end
	end))

	self:_connect(self.key_box:GetPropertyChangedSignal("Text"):Connect(function()
		self:_update_fingerprint()
	end))
end

function dashboard:_bind_buttons()
	local function copy_invite()
		local invite = trim_string(self.options.invite_url)
		if invite == "" then
			self:set_status("warning", "No invite URL configured yet.")
			self:push_log("Join Discord requested without invite_url.", "warning")
			return
		end

		if set_clipboard_text(invite) then
			self:set_status("info", "Discord invite copied to clipboard.")
			self:push_log("Copied Discord invite to clipboard.", "accent")
		else
			self:set_status("warning", "Clipboard write is unavailable in this executor.")
			self:push_log("Clipboard write failed for Discord invite.", "warning")
		end

		if type(self.options.on_join_discord) == "function" then
			pcall(self.options.on_join_discord, invite, self)
		end
	end

	local function paste_key()
		local clipboard = get_clipboard_text()
		if clipboard and clipboard ~= "" then
			self:set_key(clipboard)
			self:set_status("info", "Pasted license from clipboard.")
			self:push_log("Clipboard payload inserted into key field.", "accent")
		else
			self:set_status("warning", "Clipboard read is unavailable. Use Ctrl+V in the key field.")
			self:push_log("Clipboard read unavailable for paste action.", "warning")
			self.key_box:CaptureFocus()
		end

		if type(self.options.on_paste) == "function" then
			pcall(self.options.on_paste, self)
		end
	end

	self.authenticate_button = self:_make_button(self.button_grid, {
		Name = "AuthenticateButton",
		Size = dim2(1, 0, 0, 60),
		FillColor = theme.nav_surface,
		HoverColor = theme.low_contrast,
		AccentColor = theme.text,
		Icon = "shield-check",
		Text = "Authenticate",
		Helper = "Start premium access session",
		Callback = function()
			self:_handle_authenticate()
		end,
	})

	self.paste_button = self:_make_button(self.button_grid, {
		Name = "PasteButton",
		Position = dim2(0, 0, 0, 72),
		Size = dim2(0.5, -6, 0, 56),
		Icon = "clipboard-paste",
		Text = "Paste Key",
		Helper = "Clipboard or manual focus",
		Callback = paste_key,
	})

	self.discord_button = self:_make_button(self.button_grid, {
		Name = "DiscordButton",
		Position = dim2(0.5, 6, 0, 72),
		Size = dim2(0.5, -6, 0, 56),
		FillColor = rgb(88, 101, 242),
		HoverColor = rgb(108, 121, 255),
		AccentColor = theme.text,
		Icon = "messages-square",
		Text = "Discord",
		Helper = "Copy invite link",
		Callback = copy_invite,
	})

	self.action_buttons = {
		self.authenticate_button,
		self.paste_button,
		self.discord_button,
	}
end

function dashboard:_bind_hotkeys()
	self:_connect(user_input_service.InputBegan:Connect(function(input, processed)
		if processed or self.destroyed then
			return
		end

		if input.KeyCode == Enum.KeyCode.RightShift then
			if self.screen_gui then
				self.screen_gui.Enabled = not self.screen_gui.Enabled
			end
		end
	end))
end

function dashboard:_start_session_clock()
	task.spawn(function()
		while not self.destroyed and self.screen_gui do
			local elapsed = os.clock() - self.created_at
			self:_set_metric("session", self.session_id, format_seconds(math.floor(elapsed)))
			self:_set_metric("heartbeat", tostring(13 + math.floor((elapsed * 11) % 19)) .. "ms", "ui live")
			task.wait(1)
		end
	end)
end

function dashboard:_build_background()
	local is_mobile = user_input_service.TouchEnabled and not user_input_service.KeyboardEnabled
	local background_image = trim_string(self.options.background_image)
	if background_image == "" then
		background_image = "rbxassetid://80127661120802"
	end
	self.background_image_id = background_image

	self.overlay = create_instance("Frame", {
		Parent = self.screen_gui,
		Size = dim2(1, 0, 1, 0),
		BackgroundColor3 = theme.shadow,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
	})

	apply_gradient(self.overlay, rgbseq({
		rgbkey(0, theme.shadow),
		rgbkey(0.55, theme.content_surface),
		rgbkey(1, theme.shadow),
	}), 135, numseq({
		numkey(0, 0.08),
		numkey(1, 0.3),
	}))

	self.ambient_orbs = {}
	self.ambient_orbits = {}
end

function dashboard:_build_header(is_mobile)
	local header = create_instance("Frame", {
		Parent = self.window_fill,
		Position = dim2(0, 18, 0, 12),
		Size = dim2(1, -36, 0, 110),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	self.header = header
end

function dashboard:_build_overview_panel(parent, is_mobile)
	local panel_width = is_mobile and 0 or 246
	local panel_height = is_mobile and 182 or 0

	local _, fill = surface(parent, {
		Position = dim2(0, 0, 0, 0),
		Size = is_mobile and dim2(1, 0, 0, panel_height) or dim2(0, panel_width, 1, 0),
		FillColor = theme.sidebar_surface,
		GradientTransparency = numseq({
			numkey(0, 0.06),
			numkey(1, 0.24),
		}),
		GradientRotation = 140,
		radius = 16,
		ShadowTransparency = 0.88,
		ShadowOffset = 8,
	})

	local beam = create_instance("Frame", {
		Parent = fill,
		Position = dim2(0, 18, 0, 18),
		Size = dim2(0, 32, 0, 3),
		BackgroundColor3 = theme.accent,
		BorderSizePixel = 0,
	})
	apply_corner(beam, 999)

	create_text(fill, {
		Position = dim2(0, 18, 0, 34),
		Size = dim2(1, -36, 0, is_mobile and 28 or 60),
		Text = "Premium\nlicense gateway",
		Font = fonts.hero,
		TextSize = is_mobile and 20 or sizes.hero,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	create_text(fill, {
		Position = dim2(0, 18, 0, is_mobile and 98 or 110),
		Size = dim2(1, -36, 0, 56),
		Text = "A polished frontend for key entry, staged auth states, telemetry, and account flow handoff.",
		Font = fonts.body,
		TextSize = sizes.body,
		TextColor3 = theme.text_secondary,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	if is_mobile then
		local badge_row = create_instance("Frame", {
			Parent = fill,
			Position = dim2(0, 18, 1, -36),
			Size = dim2(1, -36, 0, 18),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		create_text(badge_row, {
			Position = dim2(0, 0, 0, 0),
			Size = dim2(0.5, 0, 1, 0),
			Text = "BUILD " .. tostring(self.options.build or "GLASS"),
			Font = fonts.mono,
			TextSize = sizes.micro,
			TextColor3 = theme.value_text,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create_text(badge_row, {
			Position = dim2(0.5, 0, 0, 0),
			Size = dim2(0.5, 0, 1, 0),
			Text = "VER " .. tostring(self.options.version or "v1.0.0"),
			Font = fonts.mono,
			TextSize = sizes.micro,
			TextColor3 = theme.value_text,
			TextXAlignment = Enum.TextXAlignment.Right,
		})

		return
	end

	local card_specs = {
		{title = "Session Route", value = "EDGE", note = "priority tunnel"},
		{title = "Protection", value = "L3", note = "local mock shield"},
		{title = "Release", value = tostring(self.options.version or "v1.0.0"), note = tostring(self.options.build or "GLASS")},
	}

	for index, card in ipairs(card_specs) do
		local _, card_fill = surface(fill, {
			Position = dim2(0, 18, 0, 198 + ((index - 1) * 86)),
			Size = dim2(1, -36, 0, 72),
			FillColor = theme.section_surface,
			GradientTransparency = numseq({
				numkey(0, 0.08),
				numkey(1, 0.28),
			}),
			GradientRotation = 115,
			radius = 12,
			ShadowTransparency = 0.92,
			ShadowOffset = 6,
		})

		create_text(card_fill, {
			Position = dim2(0, 12, 0, 10),
			Size = dim2(1, -24, 0, 12),
			Text = card.title,
			Font = fonts.small,
			TextSize = sizes.micro,
			TextColor3 = theme.text_secondary,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create_text(card_fill, {
			Position = dim2(0, 12, 0, 26),
			Size = dim2(1, -24, 0, 18),
			Text = card.value,
			Font = fonts.title,
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create_text(card_fill, {
			Position = dim2(0, 12, 1, -18),
			Size = dim2(1, -24, 0, 10),
			Text = card.note,
			Font = fonts.small,
			TextSize = sizes.micro,
			TextColor3 = theme.value_text,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
	end

	create_text(fill, {
		Position = dim2(0, 18, 1, -28),
		Size = dim2(1, -36, 0, 12),
		Text = "Client-only mock flow. Backend connector comes next.",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
end

function dashboard:_build_auth_panel(parent, is_mobile)
	local _, fill = surface(parent, {
		Position = dim2(0, 0, 0, 0),
		Size = dim2(1, 0, 1, 0),
		FillColor = theme.section_surface,
		FillTransparency = 0.12,
		GradientTransparency = numseq({
			numkey(0, 0.08),
			numkey(1, 0.26),
		}),
		GradientRotation = 108,
		radius = 16,
		ShadowTransparency = 0.86,
		ShadowOffset = 8,
	})

	table.insert(self.ambient_orbits, create_orbit_visual(fill, {
		Name = "PanelOrbit",
		Position = is_mobile and dim2(0.5, 0, 0.45, 0) or dim2(0.5, 0, 0.47, 0),
		Size = is_mobile and dim2(0, 220, 0, 220) or dim2(0, 320, 0, 320),
		InnerSize = is_mobile and dim2(0, 178, 0, 178) or dim2(0, 256, 0, 256),
		DotSize = is_mobile and dim2(0, 12, 0, 12) or dim2(0, 14, 0, 14),
		OuterTransparency = 0.78,
		InnerTransparency = 0.86,
		DotTransparency = 0.18,
		ZIndex = 0,
	}))

	self.status_title = create_text(fill, {
		Position = dim2(0, 18, 0, 26),
		Size = dim2(1, -36, 0, 24),
		Text = "Waiting For License",
		Font = fonts.title,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	self.status_message = create_text(fill, {
		Position = dim2(0, 18, 0, 54),
		Size = dim2(1, -36, 0, 32),
		Text = "Enter your premium key to unlock the client session.",
		Font = fonts.body,
		TextSize = 12,
		TextColor3 = theme.text_secondary,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	local _, input_fill = surface(fill, {
		Position = dim2(0, 18, 0, 102),
		Size = dim2(1, -36, 0, 62),
		FillColor = theme.control_surface,
		GradientTransparency = numseq({
			numkey(0, 0.1),
			numkey(1, 0.28),
		}),
		GradientRotation = 100,
		radius = 13,
		ShadowTransparency = 0.9,
		ShadowOffset = 6,
	})

	create_text(input_fill, {
		Position = dim2(0, 14, 0, 10),
		Size = dim2(1, -28, 0, 12),
		Text = "LICENSE KEY",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	self.key_box = create_instance("TextBox", {
		Parent = input_fill,
		Position = dim2(0, 14, 0, 26),
		Size = dim2(1, -28, 0, 24),
		BackgroundTransparency = 1,
		Text = trim_string(self.options.default_key),
		PlaceholderText = "PASTE-YOUR-PREMIUM-KEY",
		PlaceholderColor3 = theme.value_text,
		TextColor3 = theme.text,
		ClearTextOnFocus = false,
		Font = fonts.section,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextEditable = true,
	})

	self.input_fill = input_fill

	local _, progress_fill = surface(fill, {
		Position = dim2(0, 18, 0, 176),
		Size = dim2(1, -36, 0, 54),
		FillColor = theme.control_surface,
		Gradient = false,
		radius = 12,
		Shadow = false,
	})

	create_text(progress_fill, {
		Position = dim2(0, 12, 0, 8),
		Size = dim2(1, -70, 0, 12),
		Text = "PIPELINE STATUS",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	self.progress_text = create_text(progress_fill, {
		AnchorPoint = vec2(1, 0),
		Position = dim2(1, -12, 0, 8),
		Size = dim2(0, 46, 0, 12),
		Text = "0%",
		Font = fonts.mono,
		TextSize = sizes.micro,
		TextColor3 = theme.value_text,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local track = create_instance("Frame", {
		Parent = progress_fill,
		Position = dim2(0, 12, 0, 28),
		Size = dim2(1, -24, 0, 12),
		BackgroundColor3 = theme.inline,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	})
	apply_corner(track, 999)

	self.progress_fill = create_instance("Frame", {
		Parent = track,
		Size = dim2(0, 0, 1, 0),
		BackgroundColor3 = theme.accent,
		BorderSizePixel = 0,
	})
	apply_corner(self.progress_fill, 999)
	apply_gradient(self.progress_fill, rgbseq({
		rgbkey(0, theme.surface_highlight),
		rgbkey(1, theme.accent),
	}), 0)

	self.loader_sheen = create_instance("Frame", {
		Parent = self.progress_fill,
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(1, 0, 0.5, 0),
		Size = dim2(0, 44, 1, 0),
		BackgroundColor3 = theme.text,
		BackgroundTransparency = 0.72,
		BorderSizePixel = 0,
		Visible = false,
	})
	apply_gradient(self.loader_sheen, rgbseq({
		rgbkey(0, theme.text),
		rgbkey(1, theme.accent),
	}), 90, numseq({
		numkey(0, 0.75),
		numkey(1, 1),
	}))
	apply_corner(self.loader_sheen, 999)

	self.button_grid = create_instance("Frame", {
		Parent = fill,
		Position = dim2(0, 18, 0, 250),
		Size = dim2(1, -36, 0, 128),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})
end

function dashboard:_build_telemetry_panel(parent, is_mobile)
	local right_x = is_mobile and 0 or 728
	local width = is_mobile and 1 or 296
	local panel_y = is_mobile and 886 or 204
	local panel_size = is_mobile and dim2(1, 0, 0, 390) or dim2(0, width, 1, -204)
	local metric_card_height = is_mobile and 82 or 58
	local metric_row_y = is_mobile and 92 or 68
	local metrics_height = is_mobile and 184 or 126
	local activity_y = is_mobile and 244 or 186
	local activity_bottom = is_mobile and -258 or -200

	local _, fill = surface(parent, {
		Position = dim2(0, right_x, 0, panel_y),
		Size = panel_size,
		FillColor = theme.section_surface,
		GradientTransparency = numseq({
			numkey(0, 0.08),
			numkey(1, 0.28),
		}),
		GradientRotation = 120,
		radius = 16,
		ShadowTransparency = 0.88,
		ShadowOffset = 8,
	})

	create_text(fill, {
		Position = dim2(0, 18, 0, 18),
		Size = dim2(1, -36, 0, 16),
		Text = "LIVE TELEMETRY",
		Font = fonts.small,
		TextSize = sizes.small,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local metrics_holder = create_instance("Frame", {
		Parent = fill,
		Position = dim2(0, 18, 0, 46),
		Size = dim2(1, -36, 0, metrics_height),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	self.metric_cards = {
		session = self:_make_metric_card(metrics_holder, {
			Title = "Session",
			Value = self.session_id,
			Note = "starting",
			Size = dim2(0.5, -6, 0, metric_card_height),
		}),
		tier = self:_make_metric_card(metrics_holder, {
			Title = "Tier",
			Value = "PREMIUM",
			Note = "frontend mock",
			Position = dim2(0.5, 6, 0, 0),
			Size = dim2(0.5, -6, 0, metric_card_height),
		}),
		channel = self:_make_metric_card(metrics_holder, {
			Title = "Channel",
			Value = "IDLE",
			Note = "no backend",
			Position = dim2(0, 0, 0, metric_row_y),
			Size = dim2(0.5, -6, 0, metric_card_height),
		}),
		lock = self:_make_metric_card(metrics_holder, {
			Title = "Device Lock",
			Value = "OPEN",
			Note = "awaiting key",
			Position = dim2(0.5, 6, 0, metric_row_y),
			Size = dim2(0.5, -6, 0, metric_card_height),
		}),
	}

	self.metric_cards.queue = self.metric_cards.channel
	self.metric_cards.heartbeat = self.metric_cards.lock

	local _, activity_fill = surface(fill, {
		Position = dim2(0, 18, 0, activity_y),
		Size = dim2(1, -36, 1, activity_bottom),
		FillColor = theme.control_surface,
		Gradient = false,
		radius = 12,
		Shadow = false,
	})

	create_text(activity_fill, {
		Position = dim2(0, 12, 0, 10),
		Size = dim2(1, -24, 0, 14),
		Text = "Activity Feed",
		Font = fonts.section,
		TextSize = sizes.body,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	self.activity_hint = create_text(activity_fill, {
		Position = dim2(0, 12, 0, 28),
		Size = dim2(1, -24, 0, 24),
		Text = "Gateway armed and waiting for client input.",
		Font = fonts.small,
		TextSize = sizes.small,
		TextColor3 = theme.text_secondary,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	create_instance("Frame", {
		Parent = activity_fill,
		Position = dim2(0, 12, 0, 60),
		Size = dim2(1, -24, 0, 1),
		BackgroundColor3 = theme.separator,
		BackgroundTransparency = 0.24,
		BorderSizePixel = 0,
	})

	self.activity_scroller = create_instance("ScrollingFrame", {
		Parent = activity_fill,
		Position = dim2(0, 12, 0, 72),
		Size = dim2(1, -24, 1, -84),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = dim2(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = theme.accent,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
	})

	self.activity_list = create_instance("Frame", {
		Parent = self.activity_scroller,
		Size = dim2(1, -4, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	self.activity_layout = create_instance("UIListLayout", {
		Parent = self.activity_list,
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	self:_connect(self.activity_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:_resize_activity_canvas()
	end))

	self.logs = {}
end

function dashboard:_build_steps(parent, is_mobile)
	local container = create_instance("Frame", {
		Parent = parent,
		Position = dim2(0, is_mobile and 0 or 728, 0, is_mobile and 676 or 0),
		Size = is_mobile and dim2(1, 0, 0, 196) or dim2(0, 296, 0, 190),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	local _, fill = surface(container, {
		Size = dim2(1, 0, 1, 0),
		FillColor = theme.section_surface,
		GradientTransparency = numseq({
			numkey(0, 0.08),
			numkey(1, 0.24),
		}),
		GradientRotation = 90,
		radius = 16,
		ShadowTransparency = 0.9,
		ShadowOffset = 7,
	})

	create_text(fill, {
		Position = dim2(0, 18, 0, 16),
		Size = dim2(1, -36, 0, 16),
		Text = "Pipeline Steps",
		Font = fonts.section,
		TextSize = sizes.body,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local list = create_instance("Frame", {
		Parent = fill,
		Position = dim2(0, 18, 0, 44),
		Size = dim2(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	create_instance("UIListLayout", {
		Parent = list,
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	self.steps = {
		self:_make_step(list, {Title = "Capture Input", Subtitle = "Normalize raw client key."}),
		self:_make_step(list, {Title = "Validate Device", Subtitle = "Prepare seat and machine lane."}),
		self:_make_step(list, {Title = "Open Secure Route", Subtitle = "Stage handshake and response tunnel."}),
		self:_make_step(list, {Title = "Grant Session", Subtitle = "Finalize premium access state."}),
	}
end

function dashboard:_build_footer(is_mobile)
	local footer = create_instance("Frame", {
		Parent = self.window_fill,
		AnchorPoint = vec2(0, 1),
		Position = dim2(0, 18, 1, -14),
		Size = dim2(1, -36, 0, 18),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	create_text(footer, {
		Position = dim2(0, 0, 0, 0),
		Size = dim2(is_mobile and 0.64 or 0.7, 0, 1, 0),
		Text = "",
		Font = fonts.small,
		TextSize = sizes.micro,
		TextColor3 = theme.text_secondary,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	create_text(footer, {
		Position = dim2(is_mobile and 0.64 or 0.7, 0, 0, 0),
		Size = dim2(is_mobile and 0.36 or 0.3, 0, 1, 0),
		Text = "Toggle: RightShift",
		Font = fonts.mono,
		TextSize = sizes.micro,
		TextColor3 = theme.value_text,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
end

function dashboard:_build()
	local is_mobile = user_input_service.TouchEnabled and not user_input_service.KeyboardEnabled
	local mount_parent = get_mount_parent()

	self.screen_gui = create_instance("ScreenGui", {
		Name = "AxonPremiumKeySystem",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 99998,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	protect_gui(self.screen_gui)
	self.screen_gui.Parent = mount_parent

	self:_build_background()

	local window_size = is_mobile and dim2(0.95, 0, 0.74, 0) or dim2(0, 820, 0, 550)
	local window_root, window_fill = surface(self.overlay, {
		AnchorPoint = vec2(0.5, 0.5),
		Position = dim2(0.5, 0, 0.5, 0),
		Size = window_size,
		FillColor = theme.content_surface,
		FillTransparency = 0.06,
		GradientTransparency = numseq({
			numkey(0, 0.06),
			numkey(1, 0.24),
		}),
		GradientRotation = 130,
		radius = 20,
		ShadowTransparency = 0.78,
		ShadowOffset = 12,
		ZIndex = 2,
		ClipsDescendants = true,
		FillClipsDescendants = true,
	})

	self.window_root = window_root
	self.window_fill = window_fill

	self.window_brand = create_instance("ImageLabel", {
		Parent = window_fill,
		Name = "WindowBrand",
		AnchorPoint = vec2(0.5, 0),
		Position = dim2(0.5, 0, 0, is_mobile and 6 or 10),
		Size = is_mobile and dim2(1, -18, 0, 128) or dim2(1, -36, 0, 208),
		BackgroundTransparency = 1,
		Image = self.background_image_id or "rbxassetid://80127661120802",
		ImageTransparency = 0,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 0,
	})

	local top_glass = create_instance("Frame", {
		Parent = window_fill,
		Size = dim2(1, 0, 0, is_mobile and 146 or 214),
		BackgroundColor3 = theme.header_surface,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
	})
	apply_gradient(top_glass, rgbseq({
		rgbkey(0, theme.header_surface),
		rgbkey(1, theme.section_surface),
	}), 90, numseq({
		numkey(0, 0.1),
		numkey(1, 0.36),
	}))

	local body = create_instance("Frame", {
		Parent = window_fill,
		Position = dim2(0, 18, 0, is_mobile and 136 or 192),
		Size = dim2(1, -36, 1, is_mobile and -168 or -224),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	self.body = body

	self:_build_header(is_mobile)
	self:_dragify(self.header, self.window_root)
	self:_build_auth_panel(body, is_mobile)
	self:_build_footer(is_mobile)
	self:_bind_focus_state()
	self:_bind_buttons()
	self:_bind_hotkeys()
	self:_pulse_orbs()
	self:_update_fingerprint()
	self:set_progress(0)
	self:set_status("idle", "Enter your premium key to begin.")
	self:push_log("Dashboard initialized. Backend hooks not attached yet.", "info")
	self:push_log("Session " .. short_guid() .. " prepared on client.", "accent")
	self:_start_session_clock()
	self:_play_intro()
end

function key_system.create(options)
	local instance = setmetatable({
		options = options or {},
		connections = {},
		action_buttons = {},
		metric_cards = {},
		steps = {},
		logs = {},
		busy = false,
		destroyed = false,
		run_token = 0,
		progress_value = 0,
		created_at = os.clock(),
		session_id = short_guid():sub(1, 6),
	}, dashboard)

	instance:_build()
	instance:_auto_check_saved_luarmor_key()
	return instance
end

return key_system
