-- REASON: Dumbass customer put their library in a request and flexed his non existant security and ended up getting it leaked by himself... 😭
-- The code here is horrendous this is my 2nd library, the added on code was made to suit the old code however I should have just converted to a newer version of my code kind of an oopsie. 
-- CHANGELOG:
-- Structural UI refactor: flattened shared control surfaces, added one-shot theme binding helpers, removed the legacy colorpicker path,
-- and simplified section/dropdown/hover rendering so the library keeps the same APIs while looking less boxed and layered.

-- variables
	local uis = cloneref(game:GetService("UserInputService"))
	local players = cloneref(game:GetService("Players"))
	local ws = cloneref(game:GetService("Workspace"))
	local http_service = cloneref(game:GetService("HttpService"))
	local gui_service = cloneref(game:GetService("GuiService"))
	local lighting = cloneref(game:GetService("Lighting"))
	local marketplace_service = cloneref(game:GetService("MarketplaceService"))
	local run = cloneref(game:GetService("RunService"))
	local stats = cloneref(game:GetService("Stats"))
	local coregui = cloneref(game:GetService("CoreGui"))
	local debris = cloneref(game:GetService("Debris"))
	local tween_service = cloneref(game:GetService("TweenService"))
	local sound_service = cloneref(game:GetService("SoundService"))
	local starter_gui = cloneref(game:GetService("StarterGui"))
	local rs = cloneref(game:GetService("ReplicatedStorage"))

	local vec2 = Vector2.new
	local vec3 = Vector3.new
	local dim2 = UDim2.new
	local dim = UDim.new 
	local rect = Rect.new
	local cfr = CFrame.new
	local empty_cfr = cfr()
	local point_object_space = empty_cfr.PointToObjectSpace
	local angle = CFrame.Angles
	local dim_offset = UDim2.fromOffset

	local color = Color3.new
	local hsv = Color3.fromHSV
	local rgb = Color3.fromRGB
	local hex = Color3.fromHex
	local rgbseq = ColorSequence.new
	local rgbkey = ColorSequenceKeypoint.new
	local numseq = NumberSequence.new
	local numkey = NumberSequenceKeypoint.new

	local camera = ws.CurrentCamera
	local lp = players.LocalPlayer 
	local mouse = lp:GetMouse() 
	local gui_offset = gui_service:GetGuiInset().Y

	local max = math.max 
	local floor = math.floor 
	local min = math.min 
	local abs = math.abs 
	local noise = math.noise
	local rad = math.rad 
	local random = math.random 
	local pow = math.pow 
	local sin = math.sin 
	local pi = math.pi 
	local tan = math.tan 
	local atan2 = math.atan2 
	local cos = math.cos 
	local round = math.round;
	local clamp = math.clamp; 
	local ceil = math.ceil; 
	local sqrt = math.sqrt;
	local acos = math.acos; 

	local insert = table.insert 
	local find = table.find 
	local remove = table.remove
	local concat = table.concat
-- 

-- library init
	local library = {
		directory = "Axon",
		version = "glassmorphism_v2_integrated", -- MODERNIZED VERSION WITH INTEGRATED TABS
		folders = {
			"/fonts",
			"/configs",
			"/images"
		},
		flags = {},
		config_flags = {},
		visible_flags = {},
		guis = {},
		connections = {},
		notifications = {},
		playerlist_data = {},

		current_tab,
		current_element_open,
		dock_button_holder,
		old_config;
		font,
		keybind_list,
		binds = {},

		copied_flag;
		is_rainbow;
		icon_cache = {},
		lucide_icons = nil,

		instances = {};
		drawings = {};
		page_tweens = {};
		page_fade_targets = {};
		page_card_scales = {};

		display_orders = 0; 
	}

	local flags = library.flags
	local config_flags = library.config_flags
	local place_name_cache

	local themes = {
		preset = {
			["outline"] = hex("#0F0E47"),
			["inline"] = hex("#272757"),
			["accent"] = hex("#8686AC"),
			["contrast"] = rgbseq{
				rgbkey(0, hex("#505081")),
				rgbkey(1, hex("#272757"))
			},
			["high_contrast"] = hex("#0F0E47"),
			["low_contrast"] = hex("#505081"),
			["header_surface"] = hex("#505081"),
			["sidebar_surface"] = hex("#1D1D57"),
			["content_surface"] = hex("#10104A"),
			["section_surface"] = hex("#171751"),
			["nav_surface"] = hex("#5A5A8F"),
			["control_surface"] = hex("#46467A"),
			["text"] = hex("#E2E2E5"),
			["text_outline"] = hex("#0A0A31"),
			["text_secondary"] = hex("#E2E2E5"),
			["value_text"] = hex("#C8C9DA"),
			["separator"] = hex("#35356A"),
			["surface_highlight"] = hex("#9A9AC0"),
			["glass_tint"] = hex("#272757"),
			["glow"] = hex("#8686AC"),
			["shadow"] = hex("#0F0E47"),
		},

		utility = {
			["outline"] = {
				["BackgroundColor3"] = {},
				["Color"] = {},
			},
			["inline"] = {
				["BackgroundColor3"] = {},
				["ImageColor3"] = {},
			},
			["accent"] = {
				["BackgroundColor3"] = {},
				["TextColor3"] = {},
				["ImageColor3"] = {},
				["ScrollBarImageColor3"] = {},
				["Color"] = {}
			},
			["contrast"] = {
				["Color"] = {},
			},
			["text"] = {
				["TextColor3"] = {},
				["BackgroundColor3"] = {},
			},
			["text_outline"] = {
				["Color"] = {},
			},
			["text_secondary"] = {
				["TextColor3"] = {},
				["ImageColor3"] = {},
				["PlaceholderColor3"] = {},
				["BackgroundColor3"] = {},
			},
			["value_text"] = {
				["TextColor3"] = {},
			},
			["separator"] = {
				["BackgroundColor3"] = {},
				["Color"] = {},
			},
			["surface_highlight"] = {
				["BackgroundColor3"] = {},
				["Color"] = {},
			},
			["glass_tint"] = {
				["BackgroundColor3"] = {},
			},
			["glow"] = {
				["ImageColor3"] = {},
				["Color"] = {},
			},
			["shadow"] = {
				["BackgroundColor3"] = {},
				["Color"] = {},
				["ImageColor3"] = {},
			},
			["high_contrast"] = {
				["BackgroundColor3"] = {},
			},
			["low_contrast"] = {
				["BackgroundColor3"] = {},
			},
			["header_surface"] = {
				["BackgroundColor3"] = {},
			},
			["sidebar_surface"] = {
				["BackgroundColor3"] = {},
			},
			["content_surface"] = {
				["BackgroundColor3"] = {},
			},
			["section_surface"] = {
				["BackgroundColor3"] = {},
			},
			["nav_surface"] = {
				["BackgroundColor3"] = {},
			},
			["control_surface"] = {
				["BackgroundColor3"] = {},
			}
		}, 

		find = {
			["Frame"] = "BackgroundColor3", 
			["TextLabel"] = "TextColor3", 
			["UIGradient"] = "Color",
			["UIStroke"] = "Color",
			["ImageLabel"] = "ImageColor3",
			["TextButton"] = "BackgroundColor3", 
			["ScrollingFrame"] = "ScrollBarImageColor3"
		}
	}

	local keys = {
		[Enum.KeyCode.LeftShift] = "LS",
		[Enum.KeyCode.RightShift] = "RS",
		[Enum.KeyCode.LeftControl] = "LC",
		[Enum.KeyCode.RightControl] = "RC",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.Backspace] = "BS",
		[Enum.KeyCode.Return] = "Ent",
		[Enum.KeyCode.LeftAlt] = "LA",
		[Enum.KeyCode.RightAlt] = "RA",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.One] = "1",
		[Enum.KeyCode.Two] = "2",
		[Enum.KeyCode.Three] = "3",
		[Enum.KeyCode.Four] = "4",
		[Enum.KeyCode.Five] = "5",
		[Enum.KeyCode.Six] = "6",
		[Enum.KeyCode.Seven] = "7",
		[Enum.KeyCode.Eight] = "8",
		[Enum.KeyCode.Nine] = "9",
		[Enum.KeyCode.Zero] = "0",
		[Enum.KeyCode.KeypadOne] = "Num1",
		[Enum.KeyCode.KeypadTwo] = "Num2",
		[Enum.KeyCode.KeypadThree] = "Num3",
		[Enum.KeyCode.KeypadFour] = "Num4",
		[Enum.KeyCode.KeypadFive] = "Num5",
		[Enum.KeyCode.KeypadSix] = "Num6",
		[Enum.KeyCode.KeypadSeven] = "Num7",
		[Enum.KeyCode.KeypadEight] = "Num8",
		[Enum.KeyCode.KeypadNine] = "Num9",
		[Enum.KeyCode.KeypadZero] = "Num0",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
		[Enum.KeyCode.Tilde] = "~",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.RightParenthesis] = ")",
		[Enum.KeyCode.LeftParenthesis] = "(",
		[Enum.KeyCode.Semicolon] = ",",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.Asterisk] = "*",
		[Enum.KeyCode.Plus] = "+",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Backquote] = "`",
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
		[Enum.KeyCode.Escape] = "ESC",
		[Enum.KeyCode.Space] = "SPC",
	}
		
	library.__index = library

	for _, path in next, library.folders do 
		makefolder(library.directory .. path)
	end 

	writefile("ffff.ttf", game:HttpGet("https://github.com/weasely111/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"))

	local tahoma = {
		name = "SmallestPixel7",
		faces = {
			{
				name = "Regular",
				weight = 400,
				style = "normal",
				assetId = getcustomasset("ffff.ttf")
			}
		}
	}

	writefile("dddd.ttf", http_service:JSONEncode(tahoma))

	library.font = Font.new(getcustomasset("dddd.ttf"), Enum.FontWeight.Regular)

	local ui_tokens = {
		spacing = {
			xxs = 4,
			xs = 6,
			sm = 8,
			md = 12,
			lg = 16,
			xl = 24,
		},
		radius = {
			sm = 4,
			md = 6,
			lg = 8,
		},
		font = {
			title = 15,
			section = 12,
			label = 13,
			helper = 11,
		},
		stroke = {
			thin = 1,
			surface = 0.34,
			divider = 0.58,
			hover = 0.78,
		},
		shadow = {
			window_offset = 10,
			window_transparency = 0.8,
			section_offset = 6,
			section_transparency = 0.88,
		},
		control = {
			header_height = 42,
			sidebar_item = 38,
			row_height = 34,
			label_row_height = 18,
			field_height = 30,
			slider_height = 14,
			slider_handle = 14,
			slider_handle_hover = 16,
			slider_handle_drag = 18,
			slider_handle_core = 6,
			segmented_height = 28,
			section_header = 32,
			labeled_row_height = 42,
			label_offset_y = 1,
			field_offset_y = 18,
			slider_offset_y = 22,
			toggle_width = 30,
			toggle_height = 18,
			toggle_knob = 12,
			row_left_width = 36,
			row_accessory_width = 78,
			row_label_gap = 10,
			dropdown_radius = 7,
			dropdown_option_height = 29,
			dropdown_max_height = 176,
			dropdown_gap = 6,
			hover_fill_transparency = 0.955,
			hover_fill_active_transparency = 0.925,
			toggle_glow = 18,
			toggle_glow_hover = 22,
			preview_padding = 10,
		},
		layout = {
			sidebar_width = 188,
			shell_padding = 14,
			content_gap = 14,
			section_padding = 14,
			row_gap = 5,
		}
	}

	local function apply_surface_stroke(parent, theme, transparency, thickness)
		local stroke = library:create("UIStroke", {
			Parent = parent,
			Color = themes.preset[theme or "outline"],
			Thickness = thickness or ui_tokens.stroke.thin,
			Transparency = transparency or ui_tokens.stroke.surface,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Round,
		})
		library:apply_theme_once(stroke, theme or "outline", "Color")
		return stroke
	end

	local function create_shadow(parent, options)
		local cfg = options or {}
		local offset = cfg.offset or ui_tokens.shadow.section_offset
		local shadow = library:create("Frame", {
			Parent = parent,
			Name = cfg.name or "shadow",
			Position = dim2(0, 0, 0, offset),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = cfg.color or themes.preset.shadow,
			BackgroundTransparency = cfg.transparency or ui_tokens.shadow.section_transparency,
			ZIndex = (cfg.zindex or parent.ZIndex or 1) - 1,
			Active = false,
			Selectable = false,
		})
		library:apply_theme_once(shadow, "shadow", "BackgroundColor3")
		library:apply_corner(shadow, cfg.radius or ui_tokens.radius.lg)
		return shadow
	end

	local function create_field_surface(parent, options)
		local cfg = options or {}
		local fill_theme = cfg.fill_theme
		local fill_color = cfg.fill_color or ((fill_theme and themes.preset[fill_theme]) or themes.preset.control_surface)

		local root = library:create(cfg.button and "TextButton" or "Frame", {
			Parent = parent,
			Name = cfg.name or "",
			AnchorPoint = cfg.anchor_point,
			Position = cfg.position or dim2(),
			Size = cfg.size or dim2(1, 0, 0, ui_tokens.control.field_height),
			BorderSizePixel = 0,
			BackgroundColor3 = cfg.outer_color or themes.preset.outline,
			BackgroundTransparency = 1,
			AutoButtonColor = cfg.button and false or nil,
			Text = cfg.button and "" or nil,
			ZIndex = cfg.zindex,
			AutomaticSize = cfg.automatic_size,
			ClipsDescendants = false,
			Active = cfg.active,
		})
		library:apply_corner(root, cfg.outer_radius or ui_tokens.radius.md)

		if cfg.shadow then
			create_shadow(root, {
				offset = cfg.shadow_offset,
				transparency = cfg.shadow_transparency,
				radius = cfg.shadow_radius or cfg.outer_radius or ui_tokens.radius.md,
				zindex = cfg.zindex,
			})
		end

		local surface = library:create("Frame", {
			Parent = root,
			Name = "fill",
			Position = dim2(0, 0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = fill_color,
			BackgroundTransparency = cfg.fill_transparency or 0,
			ZIndex = cfg.zindex and (cfg.zindex + 1) or nil,
			ClipsDescendants = cfg.clips_descendants ~= false,
		})
		library:apply_corner(surface, cfg.fill_radius or cfg.outer_radius or ui_tokens.radius.sm)
		if fill_theme then
			library:apply_theme_once(surface, fill_theme, "BackgroundColor3")
		else
			library:apply_theme_once(surface, "control_surface", "BackgroundColor3")
		end

		local stroke
		if cfg.outer_theme ~= false then
			stroke = apply_surface_stroke(
				surface,
				cfg.outer_theme or "outline",
				cfg.stroke_transparency or ui_tokens.stroke.surface,
				cfg.stroke_thickness or ui_tokens.stroke.thin
			)
		end

		if cfg.gradient then
			local gradient = library:create("UIGradient", {
				Parent = surface,
				Rotation = cfg.gradient_rotation or 90,
				Color = cfg.gradient_color or themes.preset.contrast,
				Transparency = cfg.gradient_transparency,
			})
			library:apply_theme_once(gradient, cfg.gradient_theme or "contrast", "Color")
		end

		return root, stroke, surface
	end

	local function create_section_shell(parent, options)
		local cfg = options or {}
		local shell = library:create("Frame", {
			Parent = parent,
			Name = cfg.name or "",
			Size = cfg.size or dim2(1, 0, 0, 0),
			AutomaticSize = cfg.automatic_size or Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		if cfg.shadow ~= false then
			create_shadow(shell, {
				offset = cfg.shadow_offset or ui_tokens.shadow.section_offset,
				transparency = cfg.shadow_transparency or ui_tokens.shadow.section_transparency,
				radius = cfg.radius or ui_tokens.radius.md,
			})
		end

		local surface = library:create("Frame", {
			Parent = shell,
			Name = "surface",
			Size = dim2(1, 0, 0, 0),
			AutomaticSize = cfg.automatic_size or Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundColor3 = cfg.surface_color or themes.preset.section_surface,
			ClipsDescendants = cfg.clips_descendants == true,
		})
		library:apply_theme_once(surface, cfg.surface_theme or "section_surface", "BackgroundColor3")
		library:apply_corner(surface, cfg.radius or ui_tokens.radius.md)
		apply_surface_stroke(
			surface,
			cfg.stroke_theme or "outline",
			cfg.stroke_transparency or ui_tokens.stroke.surface,
			cfg.stroke_thickness or ui_tokens.stroke.thin
		)

		if cfg.gradient ~= false then
			local gradient = library:create("UIGradient", {
				Parent = surface,
				Rotation = cfg.gradient_rotation or 90,
				Color = themes.preset.contrast,
				Transparency = numseq{
					numkey(0, 0.16),
					numkey(1, 0.42),
				},
			})
			library:apply_theme_once(gradient, "contrast", "Color")
		end

		return shell, surface
	end

	local function create_row_frame(parent, options)
		local cfg = options or {}
		local row = library:create(cfg.clickable and "TextButton" or "Frame", {
			Parent = parent,
			Name = cfg.name or "",
			Text = cfg.clickable and "" or nil,
			AutoButtonColor = cfg.clickable and false or nil,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = cfg.size or dim2(1, -8, 0, cfg.height or ui_tokens.control.row_height),
			AutomaticSize = cfg.automatic_size,
		})

		return row
	end

	local function create_row_columns(row, options)
		local cfg = options or {}
		local left_width = cfg.left_width or ui_tokens.control.row_left_width
		local right_width = cfg.right_width or ui_tokens.control.row_accessory_width
		local gap = cfg.gap or ui_tokens.control.row_label_gap

		local content = library:create("Frame", {
			Parent = row,
			Name = "row_content",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
		})

		local left = library:create("Frame", {
			Parent = content,
			Name = "left_slot",
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 0),
			Size = dim2(0, left_width, 1, 0),
			BorderSizePixel = 0,
		})

		local middle = library:create("Frame", {
			Parent = content,
			Name = "middle_slot",
			BackgroundTransparency = 1,
			Position = dim2(0, left_width + gap, 0, 0),
			Size = dim2(1, -(left_width + right_width + (gap * 2)), 1, 0),
			BorderSizePixel = 0,
		})

		local right = library:create("Frame", {
			Parent = content,
			Name = "right_slot",
			AnchorPoint = vec2(1, 0),
			Position = dim2(1, 0, 0, 0),
			Size = dim2(0, right_width, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		})

		local accessories = library:create("Frame", {
			Parent = right,
			Name = "right_accessories",
			AnchorPoint = vec2(1, 0.5),
			Position = dim2(1, 0, 0.5, 0),
			Size = dim2(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		})

		library:create("UIListLayout", {
			Parent = accessories,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = dim(0, ui_tokens.spacing.xs),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		return {
			content = content,
			left = left,
			middle = middle,
			right = right,
			accessories = accessories,
		}
	end

	local function SectionHeader(parent, title, options)
		local cfg = options or {}
		local position = cfg.position or dim2(0, ui_tokens.layout.section_padding, 0, ui_tokens.layout.section_padding)
		local size = cfg.size or dim2(1, -(ui_tokens.layout.section_padding * 2), 0, ui_tokens.control.section_header)

		local holder = library:create("Frame", {
			Parent = parent,
			Name = "section_header",
			Position = position,
			Size = size,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		})

		local text = library:create("TextLabel", {
			Parent = holder,
			Name = "title",
			FontFace = library.font,
			TextColor3 = themes.preset.text,
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 0),
			Size = dim2(1, 0, 0, ui_tokens.control.section_header - 12),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = title or "",
			BorderSizePixel = 0,
			TextSize = ui_tokens.font.section + 1,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme_once(text, "text", "TextColor3")

		local divider = library:create("Frame", {
			Parent = holder,
			Name = "divider",
			Position = dim2(0, 34, 1, -1),
			Size = dim2(1, -34, 0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.separator,
			BackgroundTransparency = 0.32,
		})
		library:apply_theme_once(divider, "separator", "BackgroundColor3")

		local accent = library:create("Frame", {
			Parent = holder,
			Name = "accent",
			Position = dim2(0, 0, 1, -2),
			Size = dim2(0, 28, 0, 2),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
		})
		library:apply_theme_once(accent, "accent", "BackgroundColor3")
		library:apply_corner(accent, 2)

		return {
			holder = holder,
			text = text,
			divider = divider,
			accent = accent,
		}
	end

	local function TabBar(parent, options)
		local cfg = {
			items = options.items or {},
			buttons = {},
		}

		local outline, stroke, fill = create_field_surface(parent, {
			position = options.position or dim2(0, ui_tokens.layout.section_padding, 0, ui_tokens.layout.section_padding),
			size = options.size or dim2(1, -(ui_tokens.layout.section_padding * 2), 0, ui_tokens.control.segmented_height),
			fill_theme = "section_surface",
			fill_color = themes.preset.section_surface,
			clips_descendants = true,
		})

		local holder = library:create("Frame", {
			Parent = fill,
			Name = "tab_bar",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
		})

		library:create("UIPadding", {
			Parent = holder,
			PaddingTop = dim(0, 1),
			PaddingBottom = dim(0, 1),
			PaddingLeft = dim(0, 1),
			PaddingRight = dim(0, 1),
		})

		library:create("UIListLayout", {
			Parent = holder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = dim(0, ui_tokens.spacing.xxs),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		for index, item in next, cfg.items do
			local tab_button = library:create("TextButton", {
				Parent = holder,
				Name = "",
				Text = "",
				AutoButtonColor = false,
				BackgroundColor3 = themes.preset.low_contrast,
				BorderSizePixel = 0,
				Size = dim2(0, 0, 1, 0),
			})
			library:apply_theme_once(tab_button, "low_contrast", "BackgroundColor3")
			library:apply_corner(tab_button, ui_tokens.radius.sm)

			local hover_fill = library:create("Frame", {
				Parent = tab_button,
				Name = "",
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.surface_highlight,
				BackgroundTransparency = 1,
			})
			library:apply_theme_once(hover_fill, "surface_highlight", "BackgroundColor3")
			library:apply_corner(hover_fill, ui_tokens.radius.sm)

			local active_fill = library:create("Frame", {
				Parent = tab_button,
				Name = "",
				Position = dim2(0, 0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 1,
			})
			library:apply_theme_once(active_fill, "accent", "BackgroundColor3")
			library:apply_corner(active_fill, ui_tokens.radius.sm)

			local label = library:create("TextLabel", {
				Parent = tab_button,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text_secondary,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				ZIndex = 2,
				BorderSizePixel = 0,
				Text = tostring(item),
				TextSize = ui_tokens.font.helper,
			})
			library:apply_theme_once(label, "text_secondary", "TextColor3")

			tab_button.MouseEnter:Connect(function()
				if cfg.active_index ~= index then
					library:tween(hover_fill, {
						BackgroundTransparency = 0.9
					}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
			end)

			tab_button.MouseLeave:Connect(function()
				library:tween(hover_fill, {
					BackgroundTransparency = 1
				}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end)

			cfg.buttons[index] = {
				button = tab_button,
				label = label,
				hover_fill = hover_fill,
				active_fill = active_fill,
			}
		end

		function cfg.set_active(active_index)
			cfg.active_index = active_index

			for index, button in next, cfg.buttons do
				local selected = index == active_index
				library:tween(button.active_fill, {
					BackgroundTransparency = selected and 0.84 or 1
				}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(button.hover_fill, {
					BackgroundTransparency = 1
				}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				button.label.TextColor3 = selected and themes.preset.text or themes.preset.text_secondary
			end
		end

		cfg.outline = outline
		cfg.stroke = stroke
		cfg.fill = fill
		cfg.holder = holder

		return cfg
	end

	local function ToggleRow(self, options)
		local cfg = {
			enabled = options.enabled or false,
			name = options.name or "Toggle",
			flag = options.flag or tostring(random(1, 9999999)),
			callback = options.callback or function() end,
			default = options.default or false,
			colorpicker = options.color or nil,
			visible = options.visible or true,
			tooltip = options.tooltip or nil,
			image = options.image or nil,
		}

		local toggle_holder = create_row_frame(self.holder, {
			clickable = true,
			height = ui_tokens.control.row_height,
		})

		local columns = create_row_columns(toggle_holder)
		cfg.right_holder = columns.accessories

		local toggle, toggle_stroke, toggle_fill = create_field_surface(columns.left, {
			button = true,
			position = dim2(0, 0, 0.5, -(ui_tokens.control.toggle_height / 2)),
			size = dim2(0, ui_tokens.control.toggle_width, 0, ui_tokens.control.toggle_height),
			fill_theme = "control_surface",
			fill_color = themes.preset.control_surface,
			outer_radius = 999,
			fill_radius = 999,
		})

		local toggle_glow = library:create("Frame", {
			Parent = toggle_fill,
			Name = "toggle_glow",
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(0, ui_tokens.control.toggle_glow, 0, ui_tokens.control.toggle_glow),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1,
			ZIndex = 2,
		})
		library:apply_theme_once(toggle_glow, "accent", "BackgroundColor3")
		library:apply_corner(toggle_glow, 999)

		local active_fill = library:create("Frame", {
			Parent = toggle_fill,
			Name = "active_fill",
			Position = dim2(0, 0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1,
		})
		library:apply_theme_once(active_fill, "accent", "BackgroundColor3")
		library:apply_corner(active_fill, 999)

		local knob_shadow = library:create("Frame", {
			Parent = toggle_fill,
			Name = "knob_shadow",
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 1, 0.5, 1),
			Size = dim2(0, ui_tokens.control.toggle_knob + 4, 0, ui_tokens.control.toggle_knob + 4),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.shadow,
			BackgroundTransparency = 0.86,
			ZIndex = 3,
		})
		library:apply_theme_once(knob_shadow, "shadow", "BackgroundColor3")
		library:apply_corner(knob_shadow, 999)

		local knob = library:create("Frame", {
			Parent = toggle_fill,
			Name = "knob",
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 3, 0.5, 0),
			Size = dim2(0, ui_tokens.control.toggle_knob, 0, ui_tokens.control.toggle_knob),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.text,
			ZIndex = 4,
		})
		library:apply_theme_once(knob, "text", "BackgroundColor3")
		library:apply_corner(knob, 999)
		apply_surface_stroke(knob, "surface_highlight", 0.42, 1)

		local knob_core = library:create("Frame", {
			Parent = knob,
			Name = "knob_core",
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(0, 4, 0, 4),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1,
			ZIndex = 5,
		})
		library:apply_theme_once(knob_core, "accent", "BackgroundColor3")
		library:apply_corner(knob_core, 999)

		local text_offset = 0
		if cfg.image then
			local image_label = library:create("ImageLabel", {
				Parent = columns.middle,
				Name = "icon",
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0.5, -8),
				Size = dim2(0, 16, 0, 16),
				Image = "rbxassetid://" .. (tostring(cfg.image):match("%d+") or tostring(cfg.image)),
				BorderSizePixel = 0,
			})
			text_offset = 24
		end

		local text = library:create("TextLabel", {
			Parent = columns.middle,
			Name = "text",
			FontFace = library.font,
			TextColor3 = themes.preset.text,
			BackgroundTransparency = 1,
			Position = dim2(0, text_offset, 0, 0),
			Size = dim2(1, -text_offset, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BorderSizePixel = 0,
			Text = cfg.name,
			TextSize = ui_tokens.font.label,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme_once(text, "text", "TextColor3")

		library:hoverify(toggle_holder, toggle)

		local knob_size_tween
		local knob_shadow_tween
		local knob_glow_tween

		local function get_toggle_position(enabled, size)
			if enabled then
				return dim2(1, -(size + 3), 0.5, 0)
			end

			return dim2(0, 3, 0.5, 0)
		end

		local function set_knob_size(size, instant)
			if knob_size_tween then
				knob_size_tween:Cancel()
			end
			if knob_shadow_tween then
				knob_shadow_tween:Cancel()
			end

			local goal_position = get_toggle_position(cfg.enabled, size)
			local shadow_size = size + 4
			local shadow_goal = dim2(
				goal_position.X.Scale,
				goal_position.X.Offset - 2,
				goal_position.Y.Scale,
				goal_position.Y.Offset + 1
			)

			if instant then
				knob.Size = dim2(0, size, 0, size)
				knob.Position = goal_position
				knob_shadow.Size = dim2(0, shadow_size, 0, shadow_size)
				knob_shadow.Position = shadow_goal
				return
			end

			knob_size_tween = tween_service:Create(
				knob,
				TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = dim2(0, size, 0, size),
					Position = goal_position,
				}
			)
			knob_size_tween:Play()

			knob_shadow_tween = tween_service:Create(
				knob_shadow,
				TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = dim2(0, shadow_size, 0, shadow_size),
					Position = shadow_goal,
				}
			)
			knob_shadow_tween:Play()
		end

		local function set_hovered(hovered)
			if knob_glow_tween then
				knob_glow_tween:Cancel()
			end

			local glow_size = hovered and ui_tokens.control.toggle_glow_hover or ui_tokens.control.toggle_glow
			local glow_transparency = cfg.enabled and (hovered and 0.88 or 0.92) or 1

			library:tween(toggle_stroke, {
				Transparency = hovered and ui_tokens.stroke.hover or ui_tokens.stroke.surface
			}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			knob_glow_tween = tween_service:Create(
				toggle_glow,
				TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = dim2(0, glow_size, 0, glow_size),
					BackgroundTransparency = glow_transparency,
				}
			)
			knob_glow_tween:Play()

			set_knob_size(hovered and (ui_tokens.control.toggle_knob + 1) or ui_tokens.control.toggle_knob)
		end

		function cfg.set(bool)
			cfg.enabled = bool

			library:tween(active_fill, {
				BackgroundTransparency = bool and 0.2 or 1,
			}, 0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			library:tween(knob_core, {
				BackgroundTransparency = bool and 0 or 1,
			}, 0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			library:tween(toggle_glow, {
				BackgroundTransparency = bool and 0.92 or 1,
			}, 0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

			set_knob_size(ui_tokens.control.toggle_knob)

			flags[cfg.flag] = bool
			cfg.callback(bool)
		end

		function cfg.set_element_visible(bool)
			toggle_holder.Visible = bool
		end

		library:connection(toggle_holder.MouseButton1Click, function()
			cfg.set(not cfg.enabled)
		end)

		library:connection(toggle.MouseButton1Click, function()
			cfg.set(not cfg.enabled)
		end)

		toggle_holder.MouseEnter:Connect(function()
			set_hovered(true)
		end)

		toggle_holder.MouseLeave:Connect(function()
			set_hovered(false)
		end)

		if cfg.tooltip then
			library:tool_tip({name = cfg.tooltip, path = toggle_holder})
		end

		set_knob_size(ui_tokens.control.toggle_knob, true)
		cfg.set(cfg.default)
		cfg.set_element_visible(cfg.visible)

		library.config_flags[cfg.flag] = cfg.set
		library.visible_flags[cfg.flag] = cfg.set_element_visible

		library:_attach_element(cfg, toggle_holder, {type = "toggle", text_label = text})

		return setmetatable(cfg, library)
	end

	local function SliderRow(self, options)
		local cfg = {
			name = options.name or nil,
			suffix = options.suffix or "",
			flag = options.flag or tostring(2^789),
			callback = options.callback or function() end,
			visible = options.visible or true,
			input_disabled = options.input or false,
			custom_color = options.custom or nil,
			tooltip = options.tooltip or nil,

			min = options.min or options.minimum or 0,
			max = options.max or options.maximum or 100,
			intervals = options.interval or options.decimal or 1,
			default = options.default or 10,

			dragging = false,
			value = options.default or 10,
		}

		local row_height = cfg.name and ui_tokens.control.row_height or ui_tokens.control.slider_height
		local slider_real = create_row_frame(self.holder, {
			height = row_height,
			automatic_size = Enum.AutomaticSize.Y,
		})

		local text_label
		local slider_text
		local reserved_value_width = 40
		if cfg.name then
			text_label = library:create("TextLabel", {
				Parent = slider_real,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				Text = cfg.name,
				BackgroundTransparency = 1,
				Position = dim2(0, 2, 0.5, -7),
				Size = dim2(0, 0, 0, 14),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BorderSizePixel = 0,
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = rgb(255, 255, 255),
			})
			library:apply_theme_once(text_label, "text", "TextColor3")

			slider_text = library:create("TextLabel", {
				Parent = slider_real,
				FontFace = library.font,
				TextColor3 = themes.preset.value_text,
				Text = "",
				BackgroundTransparency = 1,
				AnchorPoint = vec2(1, 0.5),
				Position = dim2(1, -1, 0.5, 0),
				Size = dim2(0, reserved_value_width, 0, 14),
				AutomaticSize = Enum.AutomaticSize.None,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center,
				BorderSizePixel = 0,
				TextSize = ui_tokens.font.helper,
				BackgroundColor3 = rgb(255, 255, 255),
			})
			library:apply_theme_once(slider_text, "value_text", "TextColor3")

			local function get_reserved_value_width()
				local max_preview = tostring(cfg.max) .. cfg.suffix .. "/" .. tostring(cfg.max) .. cfg.suffix
				local min_preview = tostring(cfg.min) .. cfg.suffix .. "/" .. tostring(cfg.max) .. cfg.suffix
				local preview_text = (#max_preview >= #min_preview) and max_preview or min_preview
				local previous_text = slider_text.Text

				slider_text.Text = preview_text
				local text_bounds = slider_text.TextBounds.X
				slider_text.Text = previous_text

				return math.max(text_bounds, (#preview_text * 6) + 8, 40)
			end

			reserved_value_width = get_reserved_value_width()
			slider_text.Size = dim2(0, reserved_value_width, 0, 14)
		end

		local track_holder = library:create("Frame", {
			Parent = slider_real,
			Name = "track_holder",
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0.5, -(ui_tokens.control.slider_height / 2)),
			Size = dim2(1, 0, 0, ui_tokens.control.slider_height),
			BorderSizePixel = 0,
		})

		if cfg.name then
			local function update_track_layout()
				local label_width = math.clamp(((text_label and text_label.AbsoluteSize.X) or 92) + 8, 84, 156)
				local value_width = math.max(reserved_value_width, 36)
				local left_offset = label_width
				local right_offset = value_width + 6

				track_holder.Position = dim2(0, left_offset, 0.5, -(ui_tokens.control.slider_height / 2))
				track_holder.Size = dim2(1, -(left_offset + right_offset), 0, ui_tokens.control.slider_height)
			end

			library:connection(text_label:GetPropertyChangedSignal("AbsoluteSize"), update_track_layout)
			update_track_layout()
		end

		local slider_button, _, slider_fill = create_field_surface(track_holder, {
			button = true,
			size = dim2(1, -1, 0, ui_tokens.control.slider_height),
			fill_theme = "low_contrast",
			fill_color = themes.preset.low_contrast,
			outer_radius = 999,
			inline_radius = 999,
			fill_radius = 999,
			clips_descendants = false,
		})

		local fill = library:create("Frame", {
			Parent = slider_fill,
			Name = "progress",
			Position = dim2(0, 0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = cfg.custom_color or themes.preset.accent,
		})
		if not cfg.custom_color then
			library:apply_theme_once(fill, "accent", "BackgroundColor3")
		end
		library:apply_corner(fill, 999)

		local current_percent = 0

		local function resolve_handle_position(percent, size, y_offset)
			return dim2(
				percent,
				floor((size * 0.5) - (percent * size)),
				0.5,
				y_offset or 0
			)
		end

		local handle = library:create("Frame", {
			Parent = slider_fill,
			Name = "handle",
			AnchorPoint = vec2(0.5, 0.5),
			Position = resolve_handle_position(current_percent, ui_tokens.control.slider_handle, 0),
			Size = dim2(0, ui_tokens.control.slider_handle, 0, ui_tokens.control.slider_handle),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.content_surface,
			ZIndex = 6,
		})
		library:apply_theme_once(handle, "content_surface", "BackgroundColor3")
		library:apply_corner(handle, 999)
		apply_surface_stroke(handle, "surface_highlight", 0.42, 1)

		local handle_shadow = library:create("Frame", {
			Parent = slider_fill,
			Name = "handle_shadow",
			AnchorPoint = vec2(0.5, 0.5),
			Position = resolve_handle_position(current_percent, ui_tokens.control.slider_handle + 4, 1),
			Size = dim2(0, ui_tokens.control.slider_handle + 4, 0, ui_tokens.control.slider_handle + 4),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.shadow,
			BackgroundTransparency = 0.84,
			ZIndex = 5,
		})
		library:apply_theme_once(handle_shadow, "shadow", "BackgroundColor3")
		library:apply_corner(handle_shadow, 999)

		local handle_core = library:create("Frame", {
			Parent = handle,
			Name = "handle_core",
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(0, ui_tokens.control.slider_handle_core, 0, ui_tokens.control.slider_handle_core),
			BorderSizePixel = 0,
			BackgroundColor3 = cfg.custom_color or themes.preset.accent,
			ZIndex = 7,
		})
		if not cfg.custom_color then
			library:apply_theme_once(handle_core, "accent", "BackgroundColor3")
		end
		library:apply_corner(handle_core, 999)

		if not cfg.input_disabled then
			library:hoverify(slider_real, slider_button)
		end

		local function update_value_text()
			if slider_text then
				slider_text.Text = tostring(cfg.value) .. cfg.suffix .. "/" .. tostring(cfg.max) .. cfg.suffix
			end
		end

		local fill_tween
		local handle_tween
		local handle_scale_tween
		local handle_shadow_tween
		local handle_core_tween

		local function set_handle_size(size)
			if handle_scale_tween then
				handle_scale_tween:Cancel()
			end
			if handle_shadow_tween then
				handle_shadow_tween:Cancel()
			end
			if handle_core_tween then
				handle_core_tween:Cancel()
			end

			local core_size = math.max(ui_tokens.control.slider_handle_core, size - 8)
			local shadow_size = size + 4

			handle_scale_tween = tween_service:Create(
				handle,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = dim2(0, size, 0, size),
					Position = resolve_handle_position(current_percent, size, 0)
				}
			)
			handle_scale_tween:Play()

			handle_shadow_tween = tween_service:Create(
				handle_shadow,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = dim2(0, shadow_size, 0, shadow_size),
					Position = resolve_handle_position(current_percent, shadow_size, 1)
				}
			)
			handle_shadow_tween:Play()

			handle_core_tween = tween_service:Create(
				handle_core,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = dim2(0, core_size, 0, core_size)}
			)
			handle_core_tween:Play()
		end

		function cfg.set(value)
			if type(value) == "userdata" then
				return
			end

			cfg.value = math.clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

			local denominator = cfg.max - cfg.min
			local percent = denominator == 0 and 0 or ((cfg.value - cfg.min) / denominator)
			current_percent = percent

			if fill_tween then
				fill_tween:Cancel()
			end
			if handle_tween then
				handle_tween:Cancel()
			end

			fill_tween = tween_service:Create(
				fill,
				TweenInfo.new(cfg.dragging and 0.05 or 0.09, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{Size = dim2(percent, 0, 1, 0)}
			)
			fill_tween:Play()
			handle_tween = tween_service:Create(
				handle,
				TweenInfo.new(cfg.dragging and 0.05 or 0.09, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{Position = resolve_handle_position(percent, handle.Size.X.Offset, 0)}
			)
			handle_tween:Play()

			tween_service:Create(
				handle_shadow,
				TweenInfo.new(cfg.dragging and 0.05 or 0.09, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{Position = resolve_handle_position(percent, handle_shadow.Size.X.Offset, 1)}
			):Play()
			update_value_text()

			flags[cfg.flag] = cfg.value
			cfg.callback(flags[cfg.flag])
		end

		function cfg.set_element_visible(bool)
			slider_real.Visible = bool
		end

		if not cfg.input_disabled then
			library:connection(uis.InputChanged, function(input)
				if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local size_x = (input.Position.X - slider_button.AbsolutePosition.X) / slider_button.AbsoluteSize.X
					local value = ((cfg.max - cfg.min) * size_x) + cfg.min
					cfg.set(value)
				end
			end)

			library:connection(uis.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					cfg.dragging = false
					set_handle_size(library:hovering(slider_button) and ui_tokens.control.slider_handle_hover or ui_tokens.control.slider_handle)
				end
			end)

			slider_button.MouseButton1Down:Connect(function()
				cfg.dragging = true
				set_handle_size(ui_tokens.control.slider_handle_drag)
			end)

			slider_button.MouseEnter:Connect(function()
				if not cfg.dragging then
					set_handle_size(ui_tokens.control.slider_handle_hover)
				end
			end)

			slider_button.MouseLeave:Connect(function()
				if not cfg.dragging then
					set_handle_size(ui_tokens.control.slider_handle)
				end
			end)
		end

		if cfg.tooltip then
			library:tool_tip({name = cfg.tooltip, path = slider_real})
		end

		cfg.set(cfg.default)
		cfg.set_element_visible(cfg.visible)

		config_flags[cfg.flag] = cfg.set
		library.config_flags[cfg.flag] = cfg.set
		library.visible_flags[cfg.flag] = cfg.set_element_visible

		library:_attach_element(cfg, slider_real, {type = "slider", text_label = text_label})

		return setmetatable(cfg, library)
	end

	local function DropdownRow(self, cfg)
		local dropdown_real = create_row_frame(self.holder, {
			height = cfg.name and ui_tokens.control.labeled_row_height or ui_tokens.control.field_height,
			automatic_size = Enum.AutomaticSize.Y,
		})

		local main_text
		if cfg.name then
			local text_offset = 2
			if cfg.image then
				local image_label = library:create("ImageLabel", {
					Parent = dropdown_real,
					Name = "icon",
					BackgroundTransparency = 1,
					Position = dim2(0, 2, 0, ui_tokens.control.label_offset_y - 1),
					Size = dim2(0, 16, 0, 16),
					Image = "rbxassetid://" .. (tostring(cfg.image):match("%d+") or tostring(cfg.image)),
					BorderSizePixel = 0,
				})
				text_offset = 22
			end

			main_text = library:create("TextLabel", {
				Parent = dropdown_real,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Name = "text",
				BackgroundTransparency = 1,
				Position = dim2(0, text_offset, 0, ui_tokens.control.label_offset_y),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			library:apply_theme_once(main_text, "text", "TextColor3")
		end

		local right_components = library:create("Frame", {
			Parent = dropdown_real,
			Name = "right_components",
			AnchorPoint = vec2(1, 0),
			Position = dim2(1, 0, 0, cfg.name and ui_tokens.control.field_offset_y or 0),
			BorderSizePixel = 0,
			Size = dim2(0, ui_tokens.control.row_accessory_width, 0, ui_tokens.control.field_height),
			BackgroundTransparency = 1,
		})

		local right_accessories = library:create("Frame", {
			Parent = right_components,
			Name = "right_accessories",
			AnchorPoint = vec2(1, 0.5),
			Position = dim2(1, 0, 0.5, 0),
			Size = dim2(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		})
		cfg.right_holder = right_accessories

		library:create("UIListLayout", {
			Parent = right_accessories,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = dim(0, ui_tokens.spacing.xs),
			Name = "list",
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local trigger, _, trigger_surface = create_field_surface(dropdown_real, {
			button = true,
			position = dim2(0, 0, 0, cfg.name and ui_tokens.control.field_offset_y or 0),
			size = dim2(1, -1, 0, ui_tokens.control.field_height),
			fill_theme = "control_surface",
			fill_color = themes.preset.control_surface,
			outer_radius = ui_tokens.control.dropdown_radius,
			fill_radius = ui_tokens.control.dropdown_radius - 1,
			gradient = true,
			gradient_theme = "contrast",
			gradient_transparency = numseq{
				numkey(0, 0.24),
				numkey(1, 0.52),
			},
		})

		local trigger_fill = library:create("Frame", {
			Parent = trigger_surface,
			Name = "",
			ZIndex = 3,
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1
		})
		library:apply_theme_once(trigger_fill, "accent", "BackgroundColor3")
		library:apply_corner(trigger_fill, ui_tokens.control.dropdown_radius - 1)

		local trigger_indicator = library:create("Frame", {
			Parent = trigger_surface,
			Name = "",
			ZIndex = 4,
			Position = dim2(0, 10, 0.5, -6),
			Size = dim2(0, 2, 0, 12),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1
		})
		library:apply_theme_once(trigger_indicator, "accent", "BackgroundColor3")
		library:apply_corner(trigger_indicator, 1)

		local value_text = library:create("TextLabel", {
			Parent = trigger_surface,
			FontFace = library.font,
			TextColor3 = themes.preset.text_secondary,
			ZIndex = 4,
			BorderColor3 = rgb(0, 0, 0),
			Text = "Select...",
			Name = "text",
			Size = dim2(1, -34, 1, 0),
			Position = dim2(0, 16, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BorderSizePixel = 0,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextSize = ui_tokens.font.label,
			BackgroundColor3 = rgb(255, 255, 255)
		})
		library:apply_theme_once(value_text, "text_secondary", "TextColor3")

		local caret = library:create("TextLabel", {
			Parent = trigger_surface,
			FontFace = library.font,
			TextColor3 = themes.preset.accent,
			ZIndex = 4,
			BorderColor3 = rgb(0, 0, 0),
			Text = ">",
			Name = "caret",
			AnchorPoint = vec2(1, 0.5),
			Position = dim2(1, -12, 0.5, -1),
			Size = dim2(0, 10, 0, 10),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = ui_tokens.font.helper,
			Rotation = 90,
			BackgroundColor3 = rgb(255, 255, 255)
		})
		library:apply_theme_once(caret, "accent", "TextColor3")

		library:hoverify(dropdown_real, trigger)

		return {
			root = dropdown_real,
			main_text = main_text,
			right_holder = right_accessories,
			trigger = trigger,
			trigger_fill = trigger_fill,
			trigger_indicator = trigger_indicator,
			value_text = value_text,
			caret = caret,
		}
	end

	local config_holder 
-- 

-- library functions 
	-- misc functions
		function library:hoverify(hover, parent)
			local hover_instance = library:create("Frame", {
				Parent = parent,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = (parent.ZIndex or 1) + 1,
				Active = false,
				Selectable = false,
			})
			library:apply_theme_once(hover_instance, "accent", "BackgroundColor3")

			library:apply_corner(hover_instance, 3)

			local hover_stroke = library:create("UIStroke", {
				Parent = hover_instance,
				Color = themes.preset.accent,
				Thickness = 1,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			})
			library:apply_theme_once(hover_stroke, "accent", "Color")

			hover.MouseEnter:Connect(function()
				library:tween(hover_instance, {BackgroundTransparency = ui_tokens.control.hover_fill_transparency}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(hover_stroke, {Transparency = ui_tokens.stroke.hover}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end)

			hover.MouseLeave:Connect(function()
				library:tween(hover_instance, {BackgroundTransparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(hover_stroke, {Transparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end)

			return hover_instance
		end 

		function library:hovering(Object)
			if type(Object) == "table" then 
				local Pass = false;

				for _,obj in Object do 
					if library:hovering(obj) then 
						Pass = true
						return Pass
					end 
				end 
			else 
				local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
				local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
				
				return (y_cond and x_cond)
			end 
		end  

		function library:resolve_udim2(value)
			value = value or dim2()

			return dim2(
				0,
				floor((camera.ViewportSize.X * value.X.Scale) + value.X.Offset),
				0,
				floor((camera.ViewportSize.Y * value.Y.Scale) + value.Y.Offset)
			)
		end

		function library:normalize_window_size(value, minimum)
			local viewport = camera.ViewportSize
			local resolved = library:resolve_udim2(value)
			local minimum_size = minimum or Vector2.new(680, 480)
			local max_width = math.max(minimum_size.X, viewport.X - 40)
			local max_height = math.max(minimum_size.Y, viewport.Y - 40)

			return dim2(
				0,
				clamp(resolved.X.Offset, minimum_size.X, max_width),
				0,
				clamp(resolved.Y.Offset, minimum_size.Y, max_height)
			)
		end

		function library:normalize_window_position(value, size, anchor_point)
			local viewport = camera.ViewportSize
			local resolved_size = library:resolve_udim2(size)
			local anchor = anchor_point or vec2(0, 0)
			local resolved = value and library:resolve_udim2(value) or dim2(
				0,
				floor((viewport.X - resolved_size.X.Offset) / 2),
				0,
				floor((viewport.Y - resolved_size.Y.Offset) / 2)
			)
			local min_x = floor(12 + (resolved_size.X.Offset * anchor.X))
			local min_y = floor(12 + (resolved_size.Y.Offset * anchor.Y))
			local max_x = floor(viewport.X - 12 - (resolved_size.X.Offset * (1 - anchor.X)))
			local max_y = floor(viewport.Y - 12 - (resolved_size.Y.Offset * (1 - anchor.Y)))

			return dim2(
				0,
				clamp(resolved.X.Offset, min_x, max_x),
				0,
				clamp(resolved.Y.Offset, min_y, max_y)
			)
		end

		function library:make_resizable(frame, minimum_size) 
			local Frame = Instance.new("TextButton")
			Frame.Position = dim2(1, -10, 1, -10)
			Frame.BorderColor3 = rgb(0, 0, 0)
			Frame.Size = dim2(0, 10, 0, 10)
			Frame.BorderSizePixel = 0
			Frame.BackgroundColor3 = rgb(255, 255, 255)
			Frame.Parent = frame
			Frame.BackgroundTransparency = 1 
			Frame.Text = ""

			local resizing = false 
			local start_size 
			local start 
			local og_size = library:resolve_udim2(minimum_size or frame.Size)

			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = true
					start = input.Position
					start_size = frame.Size
				end
			end)

			Frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_size = dim2(
						start_size.X.Scale,
						math.clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							og_size.X.Offset,
							viewport_x - frame.AbsolutePosition.X - 12
						),
						start_size.Y.Scale,
						math.clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							og_size.Y.Offset,
							viewport_y - frame.AbsolutePosition.Y - 12
						)
					)
					frame.Size = current_size
				end
			end)
		end

		function library:draggify(frame, target)
			local drag_target = target or frame
			local dragging = false 
			local start_size = drag_target.Position
			local start 

			frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					start = input.Position
					start_size = drag_target.Position

					if library.current_element_open then 
						local current = library.current_element_open
						current.set_visible(false)
						current.open = false 
						library.current_element_open = nil 
					end 

					if drag_target.Parent:IsA("ScreenGui") and drag_target.Parent.DisplayOrder ~= 999999 then 
						library.display_orders = library.display_orders + 1 -- shit code
						drag_target.Parent.DisplayOrder = library.display_orders
					end   
				end
			end)

			frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_position = dim2(
						0,
						clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							0,
							viewport_x - drag_target.Size.X.Offset
						),
						0,
						clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							0,
							viewport_y - drag_target.Size.Y.Offset
						)
					)

					drag_target.Position = current_position
				end
			end)
		end

		function library:new_drawing(class, properties)
			local ins = Drawing.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.drawings, ins)

			return ins 
		end 
		
		function library:new_item(class, properties) 
			local ins = Instance.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.instances, ins)

			return ins 
		end 

		function library:convert_enum(enum)
			local enum_parts = {}
		
			for part in string.gmatch(enum, "[%w_]+") do
				insert(enum_parts, part)
			end
		
			local enum_table = Enum
			for i = 2, #enum_parts do
				local enum_item = enum_table[enum_parts[i]]
		
				enum_table = enum_item
			end
		
			return enum_table
		end

		function library:tween(obj, properties, duration, easing_style, easing_direction)
			-- Default to smoother, slightly longer animations
			duration = duration or 0.3
			easing_style = easing_style or Enum.EasingStyle.Exponential
			easing_direction = easing_direction or Enum.EasingDirection.Out

			local tween = tween_service:Create(obj, TweenInfo.new(duration, easing_style, easing_direction, 0, false, 0), properties):Play()

			return tween
		end 

		function library:config_list_update() 
			if not config_holder then return end 
		
			local list = {}
		
			for idx, file in next, listfiles(library.directory .. "/configs") do
				local name = string.sub(file:gsub(library.directory .. "/configs\\", ""):gsub(library.directory .. "\\configs\\", ""), 1, -5)
				list[#list + 1] = name
			end
			
			config_holder.refresh_options(list)
		end 

		function library:get_config()
			local Config = {}
		
			for _, v in flags do
				if type(v) == "table" and v.key then
					Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
				elseif type(v) == "table" and v["Transparency"] and v["Color"] then
					Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
				else
					Config[_] = v
				end
			end 
			
			return http_service:JSONEncode(Config)
		end

		function library:load_config(config_json) 
			local config = http_service:JSONDecode(config_json)
		
			for _, v in next, config do 
				local function_set = library.config_flags[_]
				
				if function_set then 
					if type(v) == "table" and v["Transparency"] and v["Color"] then
						function_set(hex(v["Color"]), v["Transparency"])
					elseif type(v) == "table" and v["active"] then 
						function_set(v)
					else 
						function_set(v)
					end
				end 
			end 
		end 
		
		function library:round(number, float) 
			local multiplier = 1 / (float or 1)

			return floor(number * multiplier + 0.5) / multiplier
		end 

		function library:apply_theme(instance, theme, property) 
			if not themes.utility[theme] then
				themes.utility[theme] = {}
			end

			if not themes.utility[theme][property] then
				themes.utility[theme][property] = {}
			end

			if not find(themes.utility[theme][property], instance) then
				insert(themes.utility[theme][property], instance)
			end
		end

		function library:apply_theme_once(instance, theme, property)
			library:apply_theme(instance, theme, property)
		end

		function library:update_theme(theme, color)
			for _, property in next, themes.utility[theme] do 

				for m, object in next, property do 
					if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
						object[_] = color 
					end
				end 
			end 

			themes.preset[theme] = color 
		end 

		function library:connection(signal, callback)
			local connection = signal:Connect(callback)
			
			insert(library.connections, connection)

			return connection 
		end

		function library:apply_stroke(parent) 
			local stroke = library:create("UIStroke", {
				Parent = parent,
				Color = themes.preset.text_outline, 
				LineJoinMode = Enum.LineJoinMode.Miter,
				Transparency = 0.78,
				Thickness = 1
			}) 
			
			library:apply_theme_once(stroke, "text_outline", "Color")
		end

		function library:create(instance, options)
			local ins = Instance.new(instance) 
			
			for prop, value in next, options do 
				ins[prop] = value
			end
			
			if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
				library:apply_theme(ins, "text", "TextColor3")
				library:apply_stroke(ins)
			elseif instance == "ScreenGui" then 
				insert(library.guis, ins)
			end
			
			return ins
		end

		function library:apply_corner(parent, radius)
			local corner = library:create("UICorner", {
				Parent = parent,
				CornerRadius = UDim.new(0, radius or 3)
			})
			return corner
		end

		function library:apply_glass(parent, blur_intensity, tint_transparency)
			-- Create semi-transparent layer with gradient for frosted glass effect
			local glass_layer = library:create("Frame", {
				Parent = parent,
				BackgroundColor3 = themes.preset.glass_tint,
				BackgroundTransparency = tint_transparency or 0.3,
				BorderSizePixel = 0,
				Size = dim2(1, 0, 1, 0),
				ZIndex = parent.ZIndex or 1
			})

			library:apply_theme(glass_layer, "glass_tint", "BackgroundColor3")

			-- Add subtle gradient for depth
			library:create("UIGradient", {
				Parent = glass_layer,
				Rotation = 135,
				Transparency = numseq{
					numkey(0, 0.2),
					numkey(1, 0.5)
				}
			})

			library:apply_corner(glass_layer, 3)
			return glass_layer
		end

		function library:apply_glow(parent, glow_size, glow_color)
			local glow = library:create("ImageLabel", {
				Parent = parent,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(1, glow_size * 2, 1, glow_size * 2),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5028857084",
				ImageColor3 = glow_color or themes.preset.glow,
				ImageTransparency = 0.7,
				ZIndex = (parent.ZIndex or 1) - 1
			})

			library:apply_theme(glow, "glow", "ImageColor3")
			return glow
		end

		function library:micro_tween(obj, properties)
			return library:tween(obj, properties, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		end

		function library:bump_gui_zindex(root, offset)
			if root and root:IsA("GuiObject") then
				root.ZIndex = (root.ZIndex or 1) + offset
			end

			for _, descendant in next, root:GetDescendants() do
				if descendant:IsA("GuiObject") then
					descendant.ZIndex = (descendant.ZIndex or 1) + offset
				end
			end
		end

		function library:get_lucide_icons()
			if library.lucide_icons ~= nil then
				return library.lucide_icons or nil
			end

			local ok, icons = pcall(function()
				local source = game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua")
				return loadstring(source)()
			end)

			library.lucide_icons = ok and type(icons) == "table" and icons or false

			return library.lucide_icons or nil
		end

		function library:resolve_tab_icon_asset(icon)
			if icon == nil or icon == "" then
				return nil
			end

			if library.icon_cache[icon] ~= nil then
				return library.icon_cache[icon] or nil
			end

			if type(icon) == "number" then
				local asset = {
					image = "rbxassetid://" .. tostring(icon)
				}
				library.icon_cache[icon] = asset
				return asset
			end

			if type(icon) ~= "string" then
				library.icon_cache[icon] = false
				return nil
			end

			if string.find(icon, "rbxasset") or string.find(icon, "://") then
				local asset = {
					image = icon
				}
				library.icon_cache[icon] = asset
				return asset
			end

			local safe_name = string.match(string.lower(icon), "^%s*(.-)%s*$")
			safe_name = safe_name and safe_name:gsub("%s+", "-"):gsub("[^%w%-_]", "") or ""

			if safe_name == "" then
				library.icon_cache[icon] = false
				return nil
			end

			local lucide_icons = library:get_lucide_icons()
			local sized_icons = lucide_icons and lucide_icons["48px"]
			local lucide_entry = sized_icons and sized_icons[safe_name]

			if lucide_entry and type(lucide_entry[1]) == "number" and type(lucide_entry[2]) == "table" and type(lucide_entry[3]) == "table" then
				local asset = {
					image = "rbxassetid://" .. tostring(lucide_entry[1]),
					image_rect_size = vec2(lucide_entry[2][1], lucide_entry[2][2]),
					image_rect_offset = vec2(lucide_entry[3][1], lucide_entry[3][2]),
				}
				library.icon_cache[icon] = asset
				return asset
			end

			local file_path = string.format("%s/images/lucide_%s.png", library.directory, safe_name)
			if not isfile(file_path) then
				local ok, data = pcall(function()
					return game:HttpGet(string.format(
						"https://api.iconify.design/lucide:%s.png?width=64&height=64&color=white",
						http_service:UrlEncode(safe_name)
					))
				end)

				if ok and type(data) == "string" and #data > 0 then
					writefile(file_path, data)
				end
			end

			if isfile(file_path) then
				local asset = {
					image = getcustomasset(file_path)
				}
				library.icon_cache[icon] = asset
				return asset
			end

			library.icon_cache[icon] = false
			return nil
		end
	--

		function library:get_place_display_name(refresh)
			if not place_name_cache or refresh then
				local ok, info = pcall(marketplace_service.GetProductInfo, marketplace_service, game.PlaceId)
				place_name_cache = ok and tostring(info and info.Name or "") ~= "" and tostring(info.Name) or "Unknown"
			end

			return place_name_cache
		end

		function library:play_window_intro(items, panel_cfg)
			if not items or not items.main_holder or not items.sgui or items.loader_overlay then
				return
			end

			items.main_holder.Visible = false

			local intro_scale = items.main_holder:FindFirstChild("intro_scale") or library:create("UIScale", {
				Parent = items.main_holder,
				Name = "intro_scale",
				Scale = 0.965,
			})
			intro_scale.Scale = 0.965

			local overlay_root, _, overlay_shell = create_field_surface(items.sgui, {
				name = "loader_overlay",
				anchor_point = items.main_holder.AnchorPoint,
				position = items.main_holder.Position,
				size = items.main_holder.Size,
				zindex = 20,
				shadow = false,
				outer_theme = false,
				shadow_offset = ui_tokens.shadow.window_offset,
				shadow_transparency = ui_tokens.shadow.window_transparency,
				fill_theme = "inline",
				fill_color = themes.preset.inline,
				fill_transparency = 1,
				outer_radius = 6,
				fill_radius = 5,
				clips_descendants = true,
			})
			overlay_root.BackgroundTransparency = 1
			overlay_shell.BackgroundTransparency = 1
			items.loader_overlay = overlay_root

			local overlay = library:create("Frame", {
				Parent = overlay_shell,
				Name = "loader_overlay_fill",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.content_surface,
				BackgroundTransparency = 1,
				ZIndex = 22,
				ClipsDescendants = true,
			})
			library:apply_corner(overlay, 4)

			local overlay_gradient = library:create("UIGradient", {
				Parent = overlay,
				Rotation = 135,
				Color = themes.preset.contrast,
				Transparency = numseq{
					numkey(0, 1),
					numkey(0.5, 1),
					numkey(1, 1),
				},
			})
			library:apply_theme_once(overlay_gradient, "contrast", "Color")

			local stages = {
				{percent = 30, status = "Preparing theme and shell", label = "BOOT"},
				{percent = 60, status = "Building tabs and controls", label = "SYNC"},
				{percent = 90, status = "Syncing sections and pages", label = "BUILD"},
				{percent = 100, status = "Opening " .. tostring((panel_cfg and panel_cfg.name) or "interface"), label = "READY"},
			}

			local overlay_scale = library:create("UIScale", {
				Parent = overlay_root,
				Name = "loader_overlay_scale",
				Scale = 0.97,
			})

			local accent_glow_left = library:create("Frame", {
				Parent = overlay,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.22, 0, 0.24, 0),
				Size = dim2(0, 240, 0, 240),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 0.955,
				ZIndex = 21,
			})
			library:apply_theme_once(accent_glow_left, "accent", "BackgroundColor3")
			library:apply_corner(accent_glow_left, 999)

			local accent_glow_right = library:create("Frame", {
				Parent = overlay,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.78, 0, 0.74, 0),
				Size = dim2(0, 300, 0, 300),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.low_contrast,
				BackgroundTransparency = 0.968,
				ZIndex = 21,
			})
			library:apply_theme_once(accent_glow_right, "low_contrast", "BackgroundColor3")
			library:apply_corner(accent_glow_right, 999)

			for index = 1, 6 do
				local vertical_line = library:create("Frame", {
					Parent = overlay,
					Name = "",
					AnchorPoint = vec2(0.5, 0),
					Position = dim2(index / 7, 0, 0, 0),
					Size = dim2(0, 1, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.separator,
					BackgroundTransparency = 0.94,
					ZIndex = 21,
				})
				library:apply_theme_once(vertical_line, "separator", "BackgroundColor3")
			end

			for index = 1, 4 do
				local horizontal_line = library:create("Frame", {
					Parent = overlay,
					Name = "",
					AnchorPoint = vec2(0, 0.5),
					Position = dim2(0, 0, index / 5, 0),
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.separator,
					BackgroundTransparency = 0.955,
					ZIndex = 21,
				})
				library:apply_theme_once(horizontal_line, "separator", "BackgroundColor3")
			end

			local hero_shell, hero_stroke, hero_fill = create_field_surface(overlay, {
				name = "loader_card",
				anchor_point = vec2(0.5, 0.5),
				position = dim2(0.5, 0, 0.5, 0),
				size = dim2(0, 454, 0, 294),
				zindex = 22,
				shadow = true,
				shadow_offset = 14,
				shadow_transparency = 0.82,
				fill_theme = "section_surface",
				fill_color = themes.preset.section_surface,
				gradient = true,
				gradient_rotation = 122,
				gradient_theme = "contrast",
				gradient_transparency = numseq{
					numkey(0, 0),
					numkey(0.46, 0),
					numkey(1, 0),
				},
				outer_radius = 16,
				fill_radius = 15,
				clips_descendants = true,
			})
			hero_shell.BackgroundTransparency = 1

			local hero_scale = library:create("UIScale", {
				Parent = hero_shell,
				Name = "loader_scale",
				Scale = 0.9,
			})

			local hero_strip = library:create("Frame", {
				Parent = hero_fill,
				Name = "",
				Position = dim2(0, 26, 0, 18),
				Size = dim2(0, 54, 0, 3),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 0,
				ZIndex = 24,
			})
			library:apply_theme_once(hero_strip, "accent", "BackgroundColor3")
			library:apply_corner(hero_strip, 999)

			local boot_shell, _, boot_fill = create_field_surface(hero_fill, {
				name = "boot_badge",
				position = dim2(0, 24, 0, 26),
				size = dim2(0, 110, 0, 26),
				zindex = 24,
				fill_theme = "control_surface",
				fill_color = themes.preset.control_surface,
				fill_transparency = 0,
				outer_radius = 999,
				fill_radius = 999,
				stroke_transparency = 0.54,
			})
			boot_shell.BackgroundTransparency = 1

			local boot_dot = library:create("Frame", {
				Parent = boot_fill,
				Name = "",
				AnchorPoint = vec2(0, 0.5),
				Position = dim2(0, 10, 0.5, 0),
				Size = dim2(0, 6, 0, 6),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 26,
			})
			library:apply_theme_once(boot_dot, "accent", "BackgroundColor3")
			library:apply_corner(boot_dot, 999)

			local boot_label = library:create("TextLabel", {
				Parent = boot_fill,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 24, 0, 0),
				Size = dim2(1, -30, 1, 0),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = "LOADING",
				TextSize = 11,
				TextColor3 = themes.preset.value_text,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 26,
			})
			library:apply_theme_once(boot_label, "value_text", "TextColor3")

			local percent_shell, _, percent_fill = create_field_surface(hero_fill, {
				name = "percent_badge",
				anchor_point = vec2(1, 0),
				position = dim2(1, -24, 0, 26),
				size = dim2(0, 84, 0, 30),
				zindex = 24,
				fill_theme = "control_surface",
				fill_color = themes.preset.control_surface,
				fill_transparency = 0,
				outer_radius = 999,
				fill_radius = 999,
				stroke_transparency = 0.48,
			})
			percent_shell.BackgroundTransparency = 1

			local percent_label = library:create("TextLabel", {
				Parent = percent_fill,
				Name = "",
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = "0%",
				TextSize = 16,
				TextColor3 = themes.preset.text,
				ZIndex = 26,
			})
			library:apply_theme_once(percent_label, "text", "TextColor3")

			local orbit_container = library:create("Frame", {
				Parent = hero_fill,
				Name = "orbit_container",
				AnchorPoint = vec2(0.5, 0),
				Position = dim2(0.5, 0, 0, 24),
				Size = dim2(0, 130, 0, 130),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 23,
			})

			local orbit_ring = library:create("Frame", {
				Parent = orbit_container,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(0, 116, 0, 116),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 23,
			})
			library:apply_corner(orbit_ring, 999)
			local orbit_ring_stroke = library:create("UIStroke", {
				Parent = orbit_ring,
				Color = themes.preset.separator,
				Thickness = 1,
				Transparency = 0.45,
			})
			library:apply_theme_once(orbit_ring_stroke, "separator", "Color")

			local orbit_ring_inner = library:create("Frame", {
				Parent = orbit_container,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(0, 96, 0, 96),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 23,
			})
			library:apply_corner(orbit_ring_inner, 999)
			local orbit_ring_inner_stroke = library:create("UIStroke", {
				Parent = orbit_ring_inner,
				Color = themes.preset.accent,
				Thickness = 1,
				Transparency = 0.78,
			})
			library:apply_theme_once(orbit_ring_inner_stroke, "accent", "Color")

			local orbit_dot = library:create("Frame", {
				Parent = orbit_container,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(1, -7, 0.5, 0),
				Size = dim2(0, 10, 0, 10),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 24,
			})
			library:apply_theme_once(orbit_dot, "accent", "BackgroundColor3")
			library:apply_corner(orbit_dot, 999)

			local orbit_dot_core = library:create("Frame", {
				Parent = orbit_dot,
				Name = "",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(0, 4, 0, 4),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.high_contrast,
				ZIndex = 25,
			})
			library:apply_theme_once(orbit_dot_core, "high_contrast", "BackgroundColor3")
			library:apply_corner(orbit_dot_core, 999)

			local play_shell, play_stroke, play_fill = create_field_surface(hero_fill, {
				name = "play_shell",
				anchor_point = vec2(0.5, 0),
				position = dim2(0.5, 0, 0, 41),
				size = dim2(0, 96, 0, 96),
				zindex = 24,
				shadow = true,
				shadow_offset = 12,
				shadow_transparency = 0.84,
				fill_theme = "accent",
				fill_color = themes.preset.accent,
				fill_transparency = 0,
				outer_radius = 999,
				fill_radius = 999,
				stroke_transparency = 0.2,
				clips_descendants = true,
			})
			play_shell.BackgroundTransparency = 1

			local play_glow = library:apply_glow(play_fill, 24, themes.preset.accent)
			play_glow.ImageTransparency = 0.8
			play_glow.ZIndex = 23

			local play_core = library:create("Frame", {
				Parent = play_fill,
				Name = "play_core",
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(0, 66, 0, 66),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.high_contrast,
				BackgroundTransparency = 0,
				ZIndex = 25,
			})
			library:apply_theme_once(play_core, "high_contrast", "BackgroundColor3")
			library:apply_corner(play_core, 999)

			local play_core_stroke = library:create("UIStroke", {
				Parent = play_core,
				Color = themes.preset.surface_highlight,
				Thickness = 1,
				Transparency = 0.7,
			})
			library:apply_theme_once(play_core_stroke, "surface_highlight", "Color")

			local play_icon_asset = library:resolve_tab_icon_asset("play")
			if play_icon_asset then
				local play_icon = library:create("ImageLabel", {
					Parent = play_core,
					Name = "play_icon",
					BackgroundTransparency = 1,
					AnchorPoint = vec2(0.5, 0.5),
					Position = dim2(0.5, 2, 0.5, 0),
					Size = dim2(0, 44, 0, 44),
					BorderSizePixel = 0,
					Image = play_icon_asset.image,
					ImageRectSize = play_icon_asset.image_rect_size,
					ImageRectOffset = play_icon_asset.image_rect_offset,
					ImageColor3 = themes.preset.accent,
					ZIndex = 26,
				})
				library:apply_theme_once(play_icon, "accent", "ImageColor3")
			else
				local play_fallback = library:create("TextLabel", {
					Parent = play_core,
					Name = "play_fallback",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					FontFace = library.font,
					Text = ">",
					TextSize = 36,
					TextColor3 = themes.preset.accent,
					ZIndex = 26,
				})
				library:apply_theme_once(play_fallback, "accent", "TextColor3")
			end

			local experience_label = library:create("TextLabel", {
				Parent = hero_fill,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 30, 0, 154),
				Size = dim2(1, -60, 0, 14),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = "CURRENT EXPERIENCE",
				TextSize = 11,
				TextColor3 = themes.preset.value_text,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 24,
			})
			library:apply_theme_once(experience_label, "value_text", "TextColor3")

			local title = library:create("TextLabel", {
				Parent = hero_fill,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 32, 0, 172),
				Size = dim2(1, -64, 0, 28),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = library:get_place_display_name(),
				TextSize = 22,
				TextColor3 = themes.preset.text,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 24,
			})
			library:apply_theme_once(title, "text", "TextColor3")

			local subtitle = library:create("TextLabel", {
				Parent = hero_fill,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 36, 0, 201),
				Size = dim2(1, -72, 0, 18),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = "Loading " .. tostring((panel_cfg and panel_cfg.name) or "interface"),
				TextSize = ui_tokens.font.label,
				TextColor3 = themes.preset.text_secondary,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 24,
			})
			library:apply_theme_once(subtitle, "text_secondary", "TextColor3")

			local status_label = library:create("TextLabel", {
				Parent = hero_fill,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 34, 0, 224),
				Size = dim2(1, -68, 0, 16),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = stages[1].status,
				TextSize = 11,
				TextColor3 = themes.preset.value_text,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 24,
			})
			library:apply_theme_once(status_label, "value_text", "TextColor3")

			local progress_track = library:create("Frame", {
				Parent = hero_fill,
				Name = "",
				Position = dim2(0, 26, 1, -24),
				Size = dim2(1, -52, 0, 8),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.control_surface,
				BackgroundTransparency = 0,
				ZIndex = 24,
			})
			library:apply_theme_once(progress_track, "control_surface", "BackgroundColor3")
			library:apply_corner(progress_track, 999)

			local progress_fill = library:create("Frame", {
				Parent = progress_track,
				Name = "",
				Size = dim2(0, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ClipsDescendants = true,
				ZIndex = 25,
			})
			library:apply_theme_once(progress_fill, "accent", "BackgroundColor3")
			library:apply_corner(progress_fill, 999)

			local progress_gradient = library:create("UIGradient", {
				Parent = progress_fill,
				Rotation = 0,
				Color = rgbseq{
					rgbkey(0, themes.preset.surface_highlight),
					rgbkey(0.5, themes.preset.accent),
					rgbkey(1, themes.preset.high_contrast),
				},
			})

			local progress_sheen = library:create("Frame", {
				Parent = progress_fill,
				Name = "",
				Position = dim2(0, -48, 0, -4),
				Size = dim2(0, 40, 1, 8),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.high_contrast,
				BackgroundTransparency = 0.72,
				ZIndex = 26,
			})
			library:apply_theme_once(progress_sheen, "high_contrast", "BackgroundColor3")
			library:apply_corner(progress_sheen, 999)

			local fade_targets = {
				accent_glow_left,
				accent_glow_right,
				hero_fill,
				hero_strip,
				boot_fill,
				percent_fill,
				play_fill,
				play_core,
				progress_track,
				progress_fill,
			}

			task.spawn(function()
				tween_service:Create(
					overlay_scale,
					TweenInfo.new(0.44, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 1}
				):Play()

				tween_service:Create(
					hero_scale,
					TweenInfo.new(0.52, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 1}
				):Play()

				local stage_time = 1.25
				local tween_time = 1.02
				local displayed_percent = 0

				task.spawn(function()
					local animation_started = os.clock()

					while overlay_root and overlay_root.Parent do
						local elapsed = os.clock() - animation_started
						orbit_container.Rotation = (elapsed * 38) % 360
						progress_gradient.Offset = vec2(((elapsed * 0.7) % 2) - 1, 0)

						local glow_wave = (sin(elapsed * 2.3) + 1) * 0.5
						local left_wave = (sin(elapsed * 1.1) + 1) * 0.5
						local right_wave = (sin(elapsed * 1.25 + 1.4) + 1) * 0.5

						play_glow.ImageTransparency = 0.84 - (glow_wave * 0.08)
						accent_glow_left.BackgroundTransparency = 0.965 - (left_wave * 0.02)
						accent_glow_right.BackgroundTransparency = 0.972 - (right_wave * 0.014)

						task.wait()
					end
				end)

				local function animate_percent(target_percent)
					local start_percent = displayed_percent
					local started = os.clock()

					while overlay_root and overlay_root.Parent do
						local alpha = clamp((os.clock() - started) / tween_time, 0, 1)
						local eased = tween_service:GetValue(alpha, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
						local value = floor(start_percent + ((target_percent - start_percent) * eased) + 0.5)

						percent_label.Text = tostring(value) .. "%"
						if alpha >= 1 then
							break
						end

						run.RenderStepped:Wait()
					end

					displayed_percent = target_percent
					percent_label.Text = tostring(target_percent) .. "%"
				end

				for index, stage in ipairs(stages) do
					if not overlay.Parent then
						return
					end

					status_label.Text = stage.status

					tween_service:Create(
						progress_fill,
						TweenInfo.new(tween_time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{Size = dim2(stage.percent / 100, 0, 1, 0)}
					):Play()

					progress_sheen.Position = dim2(0, -48, 0, -4)
					tween_service:Create(
						progress_sheen,
						TweenInfo.new(tween_time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Position = dim2(1, 10, 0, -4)}
					):Play()

					animate_percent(stage.percent)
					task.wait(max(stage_time - tween_time, 0))
				end

				displayed_percent = 100
				percent_label.Text = "100%"
				progress_fill.Size = dim2(1, 0, 1, 0)
				status_label.Text = "Ready"
				subtitle.Text = tostring((panel_cfg and panel_cfg.name) or "Interface") .. " loaded"

				items.main_holder.Visible = true
				tween_service:Create(
					intro_scale,
					TweenInfo.new(0.34, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 1}
				):Play()

				tween_service:Create(
					hero_scale,
					TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 1.035}
				):Play()

				tween_service:Create(
					overlay_scale,
					TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 1.02}
				):Play()

				local fade_info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				for _, target in ipairs(fade_targets) do
					if target and target.Parent then
						tween_service:Create(target, fade_info, {BackgroundTransparency = 1}):Play()
					end
				end

				for _, descendant in ipairs(overlay:GetDescendants()) do
					if descendant:IsA("TextLabel") then
						tween_service:Create(descendant, fade_info, {TextTransparency = 1}):Play()
					elseif descendant:IsA("ImageLabel") then
						tween_service:Create(descendant, fade_info, {ImageTransparency = 1}):Play()
					elseif descendant:IsA("UIStroke") then
						tween_service:Create(descendant, fade_info, {Transparency = 1}):Play()
					elseif descendant:IsA("Frame") and descendant.Name == "shadow" then
						tween_service:Create(descendant, fade_info, {BackgroundTransparency = 1}):Play()
					end
				end

				task.wait(0.34)

				if overlay_root and overlay_root.Parent then
					overlay_root:Destroy()
				end
				items.loader_overlay = nil
			end)
		end
	--

	-- elements 
		local function get_ui_mount_parent()
			if library.hidden_gui_parent and library.hidden_gui_parent.Parent then
				return library.hidden_gui_parent
			end

			local base_parent = coregui
			pcall(function()
				if gethui then
					base_parent = gethui() or coregui
				end
			end)

			local mount_parent = base_parent
			local ok, mount = pcall(function()
				local folder = Instance.new("Folder")
				folder.Name = ""
				folder.Archivable = false
				folder.Parent = base_parent
				return folder
			end)

			if ok and mount then
				library.hidden_gui_parent = mount
				insert(library.instances, mount)
				mount_parent = mount
			else
				library.hidden_gui_parent = base_parent
			end

			return mount_parent
		end

		local tooltip_sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = get_ui_mount_parent(),
			Name = "",
			DisplayOrder = 500, 
		})

		function library:tool_tip(options) 
			local cfg = {
				name = options.name or "hi", 
				path = options.path or nil, 
			}

			if cfg.path then 
				local watermark_outline = library:create("Frame", {
					Parent = tooltip_sgui,
					Name = "",
					Size = dim2(0, 0, 0, 22),
					Position = dim2(0, 500, 0, 300),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = themes.preset.outline
				})
				
				local watermark_inline = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				local watermark_background = library:create("Frame", {
					Parent = watermark_inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = watermark_background,
					Name = "",
					Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local text = library:create("TextLabel", {
					Parent = watermark_background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = " " .. cfg.name .. " ",
					Size = dim2(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = text,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				cfg.path.MouseEnter:Connect(function()
					watermark_outline.Visible = true
				end)

				cfg.path.MouseLeave:Connect(function()
					watermark_outline.Visible = false
				end)

				library:connection(uis.InputChanged, function(input)
					if watermark_outline.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
						watermark_outline.Position = dim_offset(input.Position.X + 10, input.Position.Y + 10)
					end
				end)

				cfg.frame = watermark_outline
				cfg.text_label = text
			end

			return cfg
		end

		-- ===== Element augmentation API (additive, opt-in per element) =====
		-- Adds a uniform method surface to UI elements: SetVisibility, SetValue, SetText,
		-- SetOptions, SetTooltip, Destroy, Disable/Enable, Lock/Unlock, OnChanged/OnHover/OnFocus.
		-- Constructors call library:_attach_element(cfg, root_instance, opts) right before they
		-- return; these methods then become available because every element returns
		-- setmetatable(cfg, library) and library.__index = library.
		function library:_attach_element(cfg, root, opts)
			opts = opts or {}
			cfg.element_root = root
			cfg.element_type = opts.type or "element"
			cfg._text_label = opts.text_label
			cfg._textbox = opts.textbox
			cfg._hooks = {changed = {}, hover = {}, focus = {}}
			cfg._disabled = false
			cfg._locked = false

			-- Chain user callback so OnChanged hooks fire on subsequent value changes.
			-- Initial cfg.set(default) calls from inside the constructor already happened
			-- before this point, so they will not trigger OnChanged. That is intentional.
			local original_callback = cfg.callback
			if type(original_callback) == "function" then
				cfg.callback = function(...)
					original_callback(...)
					if cfg._hooks then
						for _, fn in ipairs(cfg._hooks.changed) do
							local ok, err = pcall(fn, ...)
							if not ok then warn("[ui] OnChanged hook error: " .. tostring(err)) end
						end
					end
				end
			end

			if root and typeof and typeof(root) == "Instance" and root:IsA("GuiObject") then
				pcall(function()
					library:connection(root.MouseEnter, function()
						if not cfg._hooks then return end
						for _, fn in ipairs(cfg._hooks.hover) do
							local ok, err = pcall(fn, true)
							if not ok then warn("[ui] OnHover hook error: " .. tostring(err)) end
						end
					end)
					library:connection(root.MouseLeave, function()
						if not cfg._hooks then return end
						for _, fn in ipairs(cfg._hooks.hover) do
							local ok, err = pcall(fn, false)
							if not ok then warn("[ui] OnHover hook error: " .. tostring(err)) end
						end
					end)
				end)
			end

			if opts.textbox then
				pcall(function()
					library:connection(opts.textbox.Focused, function()
						if not cfg._hooks then return end
						for _, fn in ipairs(cfg._hooks.focus) do pcall(fn, true) end
					end)
					library:connection(opts.textbox.FocusLost, function(enter_pressed)
						if not cfg._hooks then return end
						for _, fn in ipairs(cfg._hooks.focus) do pcall(fn, false, enter_pressed) end
					end)
				end)
			end

			-- Auto-attach tooltip from constructor options (also re-attachable via :SetTooltip).
			if opts.tooltip then
				library:tool_tip({name = tostring(opts.tooltip), path = root})
				cfg.tooltip = opts.tooltip
			end

			return cfg
		end

		function library:SetVisibility(state, instant)
			state = state and true or false
			local root = self.element_root

			if not root then
				if type(self.set_element_visible) == "function" then
					self.set_element_visible(state)
				end
				return self
			end

			-- Capture the row's natural geometry on first call so we can restore it later.
			if self._visibility_state == nil then
				self._visibility_state = root.Visible
				self._natural_size = root.Size
				self._natural_automatic_size = root.AutomaticSize
				self._natural_clips = root.ClipsDescendants
				self._natural_height = root.AbsoluteSize.Y
			end

			-- Sync with external visibility changes (e.g. config load via visible_flags).
			if self._visibility_anim_id == nil and root.Visible ~= self._visibility_state then
				self._visibility_state = root.Visible
			end

			if self._visibility_state == state and not instant then return self end
			self._visibility_state = state

			self._visibility_anim_id = (self._visibility_anim_id or 0) + 1
			local anim_id = self._visibility_anim_id

			if instant then
				root.Size = self._natural_size
				root.AutomaticSize = self._natural_automatic_size
				root.ClipsDescendants = self._natural_clips
				root.Visible = state
				return self
			end

			-- Snapshot the current rendered height — for AutomaticSize.Y rows this is
			-- whatever the layout has produced so far.
			local rendered_height = root.AbsoluteSize.Y
			if rendered_height <= 0 then rendered_height = self._natural_height end
			if rendered_height <= 0 then rendered_height = self._natural_size.Y.Offset end

			-- Disable AutomaticSize during the tween so the explicit Size.Y.Offset wins.
			root.AutomaticSize = Enum.AutomaticSize.None
			root.ClipsDescendants = true

			local duration = 0.18
			local x_scale = self._natural_size.X.Scale
			local x_offset = self._natural_size.X.Offset

			if state then
				root.Size = dim2(x_scale, x_offset, 0, 0)
				root.Visible = true
				library:tween(
					root,
					{Size = dim2(x_scale, x_offset, 0, rendered_height > 0 and rendered_height or self._natural_height)},
					duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
				)
				task.delay(duration + 0.02, function()
					if self._visibility_anim_id ~= anim_id then return end
					if self._visibility_state ~= true then return end
					root.AutomaticSize = self._natural_automatic_size
					root.ClipsDescendants = self._natural_clips
					root.Size = self._natural_size
				end)
			else
				root.Size = dim2(x_scale, x_offset, 0, rendered_height)
				library:tween(
					root,
					{Size = dim2(x_scale, x_offset, 0, 0)},
					duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In
				)
				task.delay(duration + 0.02, function()
					if self._visibility_anim_id ~= anim_id then return end
					if self._visibility_state ~= false then return end
					root.Visible = false
					root.Size = self._natural_size
					root.AutomaticSize = self._natural_automatic_size
					root.ClipsDescendants = self._natural_clips
				end)
			end

			return self
		end

		function library:GetVisibility()
			if self._visibility_state ~= nil then return self._visibility_state end
			if self.element_root then return self.element_root.Visible end
			return nil
		end

		function library:SetValue(value)
			if type(self.set) == "function" then
				self.set(value)
			end
			return self
		end

		function library:GetValue()
			if self.flag ~= nil and flags[self.flag] ~= nil then return flags[self.flag] end
			if self.value ~= nil then return self.value end
			if self.enabled ~= nil then return self.enabled end
			return nil
		end

		function library:SetText(text)
			text = tostring(text)
			if self._text_label then
				self._text_label.Text = text
				self.name = text
				return self
			end
			-- For textbox (no separate name label), SetText writes the input contents.
			if self.element_type == "textbox" and type(self.set) == "function" then
				self.set(text)
				return self
			end
			if self.element_type == "label" and type(self.set) == "function" then
				self.set(text)
				self.name = text
			end
			return self
		end

		function library:SetOptions(items)
			if type(self.refresh_options) == "function" then
				self.refresh_options(items)
			end
			return self
		end

		function library:SetTooltip(text)
			if not self.element_root then return self end
			if text == nil or text == "" then
				-- Remove existing tooltip if any.
				if self._tooltip_handle and self._tooltip_handle.frame then
					pcall(function() self._tooltip_handle.frame:Destroy() end)
					self._tooltip_handle = nil
				end
				self.tooltip = nil
				return self
			end
			text = tostring(text)
			if self._tooltip_handle and self._tooltip_handle.text_label then
				self._tooltip_handle.text_label.Text = " " .. text .. " "
			else
				self._tooltip_handle = library:tool_tip({name = text, path = self.element_root})
			end
			self.tooltip = text
			return self
		end

		function library:Destroy()
			if self._destroyed then return self end
			self._destroyed = true
			if self.element_root then
				pcall(function() self.element_root:Destroy() end)
			end
			if self.flag then
				flags[self.flag] = nil
				config_flags[self.flag] = nil
				library.visible_flags[self.flag] = nil
				library.config_flags[self.flag] = nil
			end
			self._hooks = nil
			return self
		end

		local function _ensure_disable_overlay(root)
			local overlay = root:FindFirstChild("_disabled_overlay")
			if overlay then return overlay end

			overlay = library:create("Frame", {
				Parent = root,
				Name = "_disabled_overlay",
				Size = dim2(1, 0, 1, 0),
				Position = dim2(0, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.shadow,
				BackgroundTransparency = 1,
				ZIndex = 50,
			})
			library:apply_corner(overlay, 4)
			library:apply_theme_once(overlay, "shadow", "BackgroundColor3")

			return overlay
		end

		local function _set_element_interactive(self, allow)
			local root = self.element_root
			if not root then return end

			if root:IsA("GuiObject") then
				root.Active = allow
				if root:IsA("GuiButton") then
					root.AutoButtonColor = allow
				end
			end

			for _, descendant in ipairs(root:GetDescendants()) do
				if descendant:IsA("GuiButton") and descendant.Name ~= "_disabled_overlay" then
					descendant.Active = allow
					descendant.AutoButtonColor = allow
				end
			end

			local overlay = _ensure_disable_overlay(root)
			library:tween(
				overlay,
				{BackgroundTransparency = allow and 1 or 0.5},
				0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
			)
		end

		function library:Disable()
			self._disabled = true
			_set_element_interactive(self, false)
			return self
		end

		function library:Enable()
			self._disabled = false
			if not self._locked then
				_set_element_interactive(self, true)
			end
			return self
		end

		function library:IsDisabled() return self._disabled == true end

		function library:Lock()
			self._locked = true
			_set_element_interactive(self, false)
			return self
		end

		function library:Unlock()
			self._locked = false
			if not self._disabled then
				_set_element_interactive(self, true)
			end
			return self
		end

		function library:IsLocked() return self._locked == true end

		function library:OnChanged(fn)
			if type(fn) ~= "function" then return self end
			if not self._hooks then self._hooks = {changed = {}, hover = {}, focus = {}} end
			insert(self._hooks.changed, fn)
			return self
		end

		function library:OnHover(fn)
			if type(fn) ~= "function" then return self end
			if not self._hooks then self._hooks = {changed = {}, hover = {}, focus = {}} end
			insert(self._hooks.hover, fn)
			return self
		end

		function library:OnFocus(fn)
			if type(fn) ~= "function" then return self end
			if not self._hooks then self._hooks = {changed = {}, hover = {}, focus = {}} end
			insert(self._hooks.focus, fn)
			return self
		end
		-- ===== end element augmentation API =====

		function library:panel(options)
			local cfg = {
				name = options.text or options.name or "Window", 
				size = options.size or dim2(0, 530, 0, 590),
				position = options.position,
				anchor_point = options.anchor_point or vec2(0, 0),
				minimum_size = options.minimum_size or Vector2.new(680, 480),

				image = options.image or "rbxassetid://79856374238119",
				open = options.open or true,

				items = {},
			}

			cfg.size = library:normalize_window_size(cfg.size, cfg.minimum_size)
			cfg.position = library:normalize_window_position(cfg.position, cfg.size, cfg.anchor_point)
			
			local items = cfg.items do 
				items.sgui = library:create("ScreenGui", {
					Enabled = true,
					Parent = get_ui_mount_parent(),
					Name = ""
				})

				items.main_holder = library:create("Frame", {
					Parent = items.sgui,
					Name = "",
					AnchorPoint = vec2(cfg.anchor_point.X, cfg.anchor_point.Y),
					Position = cfg.position,
					Active = true,
					Visible = false,
					BorderColor3 = rgb(0, 0, 0),
					Size = cfg.size,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					BackgroundTransparency = 1
				})
				library:apply_corner(items.main_holder, 6)
				apply_surface_stroke(items.main_holder, "outline", ui_tokens.stroke.surface, 1)
				create_shadow(items.main_holder, {
					offset = ui_tokens.shadow.window_offset,
					transparency = ui_tokens.shadow.window_transparency,
					radius = 10,
				})
				library:make_resizable(items.main_holder, dim2(0, cfg.minimum_size.X, 0, cfg.minimum_size.Y))

				items.window_inline = library:create("Frame", {
					Parent = items.main_holder,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					BackgroundTransparency = 1
				})
				library:apply_corner(items.window_inline, 5)

				items.window_holder = library:create("Frame", {
					Parent = items.window_inline,
					Name = "",
					ClipsDescendants = true,
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.content_surface
				})
				library:apply_theme(items.window_holder, "content_surface", "BackgroundColor3")
				library:apply_corner(items.window_holder, 4)

				items.UIGradient = library:create("UIGradient", {
					Parent = items.window_holder,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(24, 27, 34)),
						rgbkey(1, rgb(18, 20, 28))
					}
				})
				library:apply_theme(items.UIGradient, "contrast", "Color")

				local header_padding = 16
				local close_button_width = 26
				local header_button_gap = 6
				local header_button_count = 3
				local header_button_stack_width = (close_button_width * header_button_count) + (header_button_gap * (header_button_count - 1))
				local close_button_reserved = header_button_stack_width + header_padding + 18
				local fullscreen_restore_bounds
				local is_fullscreen = false

				items.header = library:create("Frame", {
					Parent = items.window_holder,
					Name = "",
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.header_surface,
					Size = dim2(1, 0, 0, ui_tokens.control.header_height),
					ClipsDescendants = true
				})
				library:apply_theme_once(items.header, "header_surface", "BackgroundColor3")
				library:apply_corner(items.header, 4)
				apply_surface_stroke(items.header, "separator", 0.84, ui_tokens.stroke.thin)
				library:draggify(items.header, items.main_holder)

				local header_gradient = library:create("UIGradient", {
					Parent = items.header,
					Name = "",
					Rotation = 90,
					Color = themes.preset.contrast,
					Transparency = numseq{
						numkey(0, 0.2),
						numkey(0.45, 0.34),
						numkey(1, 0.56)
					}
				})
				library:apply_theme_once(header_gradient, "contrast", "Color")

				local header_mask = library:create("Frame", {
					Parent = items.header,
					Name = "",
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.header_surface,
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 1, 0),
					Size = dim2(1, 0, 0, 0),
					ZIndex = 2
				})
				library:apply_theme_once(header_mask, "header_surface", "BackgroundColor3")

				local header_hover = library:create("Frame", {
					Parent = items.header,
					Name = "hover",
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 1,
					Active = false,
					Selectable = false,
					ZIndex = 2
				})
				library:apply_theme_once(header_hover, "accent", "BackgroundColor3")
				library:apply_corner(header_hover, 4)

				items.text = library:create("TextLabel", {
					Parent = items.header,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					BackgroundTransparency = 1,
					Position = dim2(0, header_padding, 0, 0),
					Size = dim2(1, -close_button_reserved, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					BorderSizePixel = 0,
					TextSize = ui_tokens.font.title,
					ZIndex = 3,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(items.text, "text", "TextColor3")

				items.header_accent = library:create("Frame", {
					Parent = items.header,
					Name = "",
					BorderSizePixel = 0,
					Position = dim2(0, header_padding, 1, -3),
					Size = dim2(0, 28, 0, 2),
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 0.06,
					ZIndex = 3
				})
				library:apply_theme_once(items.header_accent, "accent", "BackgroundColor3")
				library:apply_corner(items.header_accent, 2)

				items.header_line = library:create("Frame", {
					Parent = items.header,
					Name = "",
					Position = dim2(0, 0, 1, -1),
					BorderSizePixel = 0,
					Size = dim2(1, 0, 0, 1),
					BackgroundColor3 = themes.preset.separator,
					BackgroundTransparency = 0.38,
					ZIndex = 3
				})
				library:apply_theme_once(items.header_line, "separator", "BackgroundColor3")

				local header_actions = library:create("Frame", {
					Parent = items.header,
					Name = "actions",
					AnchorPoint = vec2(1, 0.5),
					Position = dim2(1, -header_padding, 0.5, 0),
					Size = dim2(0, header_button_stack_width, 0, close_button_width),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ZIndex = 4
				})

				library:create("UIListLayout", {
					Parent = header_actions,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = dim(0, header_button_gap),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				local function create_header_action_button(icon_name, fallback_text)
					local button = library:create("TextButton", {
						Parent = header_actions,
						Name = icon_name .. "_button",
						BorderColor3 = rgb(0, 0, 0),
						Text = "",
						Size = dim2(0, close_button_width, 0, close_button_width),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.header_surface,
						BackgroundTransparency = 1,
						AutoButtonColor = false,
						ZIndex = 4
					})
					library:apply_theme_once(button, "header_surface", "BackgroundColor3")
					library:apply_corner(button, 8)

					local button_stroke = library:create("UIStroke", {
						Parent = button,
						Color = themes.preset.separator,
						Thickness = ui_tokens.stroke.thin,
						Transparency = 0.86,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						LineJoinMode = Enum.LineJoinMode.Round
					})
					library:apply_theme_once(button_stroke, "separator", "Color")

					local button_hover = library:create("Frame", {
						Parent = button,
						Name = "hover",
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						BackgroundTransparency = 1,
						Active = false,
						Selectable = false,
						ZIndex = 5
					})
					library:apply_theme_once(button_hover, "accent", "BackgroundColor3")
					library:apply_corner(button_hover, 8)

					local icon_asset = library:resolve_tab_icon_asset(icon_name)
					if icon_asset then
						local icon = library:create("ImageLabel", {
							Parent = button,
							Name = "icon",
							BackgroundTransparency = 1,
							AnchorPoint = vec2(0.5, 0.5),
							Position = dim2(0.5, 0, 0.5, 0),
							Size = dim2(0, 12, 0, 12),
							BorderSizePixel = 0,
							Image = icon_asset.image,
							ImageRectSize = icon_asset.image_rect_size,
							ImageRectOffset = icon_asset.image_rect_offset,
							ImageColor3 = themes.preset.text_secondary,
							ZIndex = 6
						})
						library:apply_theme_once(icon, "text_secondary", "ImageColor3")
					else
						local fallback = library:create("TextLabel", {
							Parent = button,
							Name = "fallback",
							BackgroundTransparency = 1,
							Size = dim2(1, 0, 1, 0),
							BorderSizePixel = 0,
							FontFace = library.font,
							Text = fallback_text,
							TextSize = ui_tokens.font.helper,
							TextColor3 = themes.preset.text_secondary,
							ZIndex = 6
						})
						library:apply_theme_once(fallback, "text_secondary", "TextColor3")
					end

					button.MouseEnter:Connect(function()
						library:tween(button_hover, {
							BackgroundTransparency = 0.92
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(button_stroke, {
							Transparency = 0.5
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end)

					button.MouseLeave:Connect(function()
						library:tween(button_hover, {
							BackgroundTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(button_stroke, {
							Transparency = 0.86
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(button, {
							Size = dim2(0, close_button_width, 0, close_button_width)
						}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end)

					button.MouseButton1Down:Connect(function()
						library:tween(button_hover, {
							BackgroundTransparency = 0.86
						}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(button, {
							Size = dim2(0, close_button_width - 2, 0, close_button_width - 2)
						}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end)

					button.MouseButton1Up:Connect(function()
						library:tween(button_hover, {
							BackgroundTransparency = 0.92
						}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(button, {
							Size = dim2(0, close_button_width, 0, close_button_width)
						}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end)

					return {
						button = button,
						stroke = button_stroke,
						hover = button_hover,
					}
				end

				local minimize_button = create_header_action_button("minus", "-")
				local fullscreen_button = create_header_action_button("expand", "+")
				local close_button = create_header_action_button("x", "x")
				items.minimize_button = minimize_button
				items.close_button = close_button

				items.header.MouseEnter:Connect(function()
					library:tween(header_hover, {
						BackgroundTransparency = 0.975
					}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end)

				items.header.MouseLeave:Connect(function()
					library:tween(header_hover, {
						BackgroundTransparency = 1
					}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end)

				local function update_fullscreen_button_visual()
					library:tween(fullscreen_button.hover, {
						BackgroundTransparency = is_fullscreen and 0.9 or 1
					}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					library:tween(fullscreen_button.stroke, {
						Transparency = is_fullscreen and 0.48 or 0.86
					}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end

				local function set_fullscreen(bool)
					local viewport = camera.ViewportSize

					if bool then
						if not is_fullscreen then
							fullscreen_restore_bounds = {
								size = items.main_holder.Size,
								position = items.main_holder.Position,
							}
						end

						local fullscreen_size = dim2(0, math.max(cfg.minimum_size.X, viewport.X - 24), 0, math.max(cfg.minimum_size.Y, viewport.Y - 24))
						local width = fullscreen_size.X.Offset
						local height = fullscreen_size.Y.Offset

						items.main_holder.Size = fullscreen_size
						items.main_holder.Position = dim2(
							0, 12 + floor(width * cfg.anchor_point.X),
							0, 12 + floor(height * cfg.anchor_point.Y)
						)
						is_fullscreen = true
					else
						if fullscreen_restore_bounds then
							items.main_holder.Size = fullscreen_restore_bounds.size
							items.main_holder.Position = fullscreen_restore_bounds.position
						else
							items.main_holder.Size = cfg.size
							items.main_holder.Position = cfg.position
						end
						is_fullscreen = false
					end

					update_fullscreen_button_visual()
				end

				minimize_button.button.MouseButton1Click:Connect(function()
					if cfg.on_minimize then
						cfg.on_minimize()
					else
						items.sgui.Enabled = false
					end
				end)

				fullscreen_button.button.MouseButton1Click:Connect(function()
					set_fullscreen(not is_fullscreen)
				end)

				close_button.button.MouseButton1Click:Connect(function()
					if cfg.on_close then
						cfg.on_close()
					else
						-- Destroy all GUIs
						for _, gui in library.guis do
							if gui and gui.Parent then
								gui:Destroy()
							end
						end
						-- Disconnect all connections
						for _, connection in library.connections do
							if connection then
								connection:Disconnect()
							end
						end
						-- Clear tables
						library.guis = {}
						library.connections = {}
					end
				end)

				update_fullscreen_button_visual()

				items.body = library:create("Frame", {
					Parent = items.window_holder,
					Name = "",
					Position = dim2(0, 0, 0, ui_tokens.control.header_height),
					Size = dim2(1, 0, 1, -ui_tokens.control.header_height),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				})

				items.sidebar_outline = library:create("Frame", {
					Parent = items.body,
					Name = "",
					Position = dim2(0, ui_tokens.layout.shell_padding, 0, ui_tokens.layout.shell_padding),
					Size = dim2(0, ui_tokens.layout.sidebar_width, 1, -(ui_tokens.layout.shell_padding * 2)),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					BackgroundTransparency = 1
				})
				library:apply_corner(items.sidebar_outline, 4)
				apply_surface_stroke(items.sidebar_outline, "outline", ui_tokens.stroke.surface, 1)

				items.sidebar_inline = library:create("Frame", {
					Parent = items.sidebar_outline,
					Name = "",
					Position = dim2(0, 0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					BackgroundTransparency = 1
				})
				library:apply_corner(items.sidebar_inline, 3)

				items.sidebar_background = library:create("Frame", {
					Parent = items.sidebar_inline,
					Name = "",
					Position = dim2(0, 0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.section_surface
				})
				library:apply_theme_once(items.sidebar_background, "section_surface", "BackgroundColor3")
				library:apply_corner(items.sidebar_background, 3)

				local sidebar_gradient = library:create("UIGradient", {
					Parent = items.sidebar_background,
					Rotation = 90,
					Color = themes.preset.contrast,
					Transparency = numseq{
						numkey(0, 0.12),
						numkey(1, 0.44)
					}
				})
				library:apply_theme_once(sidebar_gradient, "contrast", "Color")

				items.sidebar = library:create("ScrollingFrame", {
					Parent = items.sidebar_background,
					Name = "",
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					ScrollBarImageColor3 = themes.preset.accent,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206"
				})
				library:apply_theme(items.sidebar, "accent", "ScrollBarImageColor3")

				library:create("UIPadding", {
					Parent = items.sidebar,
					PaddingTop = dim(0, 12),
					PaddingBottom = dim(0, 12),
					PaddingLeft = dim(0, 12),
					PaddingRight = dim(0, 12)
				})

				items.sidebar_stack = library:create("Frame", {
					Parent = items.sidebar,
					Name = "",
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				})

				library:create("UIListLayout", {
					Parent = items.sidebar_stack,
					Padding = dim(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.module_label = library:create("TextLabel", {
					Parent = items.sidebar_stack,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					BorderColor3 = rgb(0, 0, 0),
					Text = "MODULES",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 16),
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					TextSize = 11,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(items.module_label, "text_secondary", "TextColor3")

				items.module_tab_holder = library:create("Frame", {
					Parent = items.sidebar_stack,
					Name = "",
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				})

				library:create("UIListLayout", {
					Parent = items.module_tab_holder,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.sidebar_divider = library:create("Frame", {
					Parent = items.sidebar_stack,
					Name = "",
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.low_contrast
				})
				library:apply_theme(items.sidebar_divider, "low_contrast", "BackgroundColor3")

				items.system_label = library:create("TextLabel", {
					Parent = items.sidebar_stack,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					BorderColor3 = rgb(0, 0, 0),
					Text = "SYSTEM",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 16),
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					TextSize = 11,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(items.system_label, "text_secondary", "TextColor3")

				items.system_tab_holder = library:create("Frame", {
					Parent = items.sidebar_stack,
					Name = "",
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				})

				library:create("UIListLayout", {
					Parent = items.system_tab_holder,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.content_outline = library:create("Frame", {
					Parent = items.body,
					Name = "",
					Position = dim2(
						0,
						ui_tokens.layout.shell_padding + ui_tokens.layout.sidebar_width + ui_tokens.layout.content_gap,
						0,
						ui_tokens.layout.shell_padding
					),
					Size = dim2(
						1,
						-(ui_tokens.layout.shell_padding * 2 + ui_tokens.layout.sidebar_width + ui_tokens.layout.content_gap),
						1,
						-(ui_tokens.layout.shell_padding * 2)
					),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(items.content_outline, "outline", "BackgroundColor3")
				library:apply_corner(items.content_outline, 4)

				items.content_inline = library:create("Frame", {
					Parent = items.content_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					BackgroundTransparency = 1
				})
				library:apply_corner(items.content_inline, 3)

				items.content_background = library:create("Frame", {
					Parent = items.content_inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.content_surface
				})
				library:apply_theme(items.content_background, "content_surface", "BackgroundColor3")
				library:apply_corner(items.content_background, 3)

				items.content_gradient = library:create("UIGradient", {
					Parent = items.content_background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(22, 24, 32)),
						rgbkey(1, rgb(18, 20, 27))
					}
				})
				library:apply_theme(items.content_gradient, "contrast", "Color")

				items.holder = library:create("Frame", {
					Parent = items.content_background,
					Name = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					ClipsDescendants = true
				})

				library:create("UIPadding", {
					Parent = items.holder,
					PaddingTop = dim(0, 12),
					PaddingBottom = dim(0, 12),
					PaddingLeft = dim(0, 12),
					PaddingRight = dim(0, 12)
				})

			end 

			return setmetatable(cfg, library)
		end 

		local sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = get_ui_mount_parent(),
			Name = "",
			DisplayOrder = 999999, 
		})

		local notif_holder = library:create("ScreenGui", {
			Parent = get_ui_mount_parent(),
			Name = "",
			IgnoreGuiInset = true, 
			DisplayOrder = 999999, 
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})

		function library:fold_elements(origin, elements)
			for _, x in next, elements do 
				local flag = library.visible_flags[x]

				if flag then    
					flag(flags[origin])
				end     
			end 
		end 

		function library:indicator() 
			local cfg = {
				items = {};
			}

			local items = cfg.items; do 
				items.Window = library:create( "Frame" , {
					Parent = sgui;
					Name = "\0";
					Position = dim2(0, 400, 0, 500);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 322, 0, 147);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Window, "outline", "BackgroundColor3"); library:draggify(items.Window)
				
				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Indicators";
					Parent = items.Window;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 13;
				}); 

				items.Accent = library:create( "Frame" , {
					Parent = items.Window;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3")
				
				items.Background = library:create( "Frame" , {
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.high_contrast
				});	library:apply_theme(items.Background, "high_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.Background;
					Name = "\0";
					Position = dim2(0, 4, 0, 18);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -22);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3"); local image_holder = items.LowContrast;
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Info";
					Parent = items.Outline;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 13;
				});

				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});
				
				items.Accent = library:create( "Frame" , {
					Name = "\0";
					Parent = items.LowContrast;
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 2);
					BackgroundColor3 = themes.preset.accent;
					BorderSizePixel = 0;
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3");
				
				items.Shadow = library:create( "Frame" , {
					AnchorPoint = vec2(0, 1);
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 0, 1, 0);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 1);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent;
				}); library:apply_theme(items.Shadow, "accent", "BackgroundColor3");
				
				library:create( "UIGradient" , {
					Rotation = 90;
					Parent = items.Shadow;
					Color = rgbseq{rgbkey(0, rgb(150, 150, 150)), rgbkey(1, rgb(150, 150, 150))}
				});
				
				items.holder = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 76, 0, 21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});	

				library:create("UIListLayout", {
					Parent = items.holder,
					Padding = dim(0, 4),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.Inline = library:create( "Frame" , {
					Parent = image_holder;
					Name = "\0";
					Position = dim2(0, 10, 0, 28);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 68, 0, 67);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.Profile = library:create( "ImageLabel" , {
					BorderColor3 = rgb(0, 0, 0);
					Parent = items.LowContrast;
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
					BackgroundTransparency = 1;
					Name = "\0";
					Size = dim2(1, 0, 1, 0);
					BorderSizePixel = 0;
				});	

				local section = setmetatable(items, library)
				items.label = section:label({name = "Player: "})
				items.slider = section:slider({name = "Health", custom = rgb(255, 0, 0), min = 0, max = 100, default = 50, input = true})
				
				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});            
			end

			function cfg.set_visible(bool)
				items.Window.Visible = bool
			end 

			function cfg.change_health(int)
				items.slider.set(int)
			end

			function cfg.change_profile(player)
				items.label.set(string.format("Player: %s (%s)", player.Name, player.DisplayName))
				items.Profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. player.UserId .."&width=420&height=420&format=png"
			end 

			return setmetatable(cfg, library)
		end     

		function library:window(properties)
			local window = setmetatable({opened = true}, library)
			local opened = {}

			library.cache = library:create("ScreenGui", {
				Enabled = false,
				Parent = get_ui_mount_parent(),
				Name = ""
			})

			function window.set_menu_visibility(bool)
				window.opened = bool

				if bool then
					for _, gui in opened do
						gui.Enabled = true
					end
					opened = {}
				else
					for _, gui in library.guis do
						if gui.Enabled then 
							gui.Enabled = false
							table.insert(opened, gui)
						end
					end
				end

				sgui.Enabled = true
				notif_holder.Enabled = true
				tooltip_sgui.Enabled = true
				library.cache.Enabled = false

				-- Keep toggle button always visible
				if window.toggle_sgui then
					window.toggle_sgui.Enabled = true
				end

				for _, tooltip in tooltip_sgui:GetChildren() do
					tooltip.Visible = false
				end

				-- Close any opened dropdown/popup windows when hiding UI
				if library.current_element_open then
					local current = library.current_element_open
					current.set_visible(false)
					current.open = false
					library.current_element_open = nil
				end
			end

			library:connection(uis.InputBegan, function(input, game_event)
				if uis:GetFocusedTextBox() then
					return
				end

				local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
				local menu_bind = flags["ui_bind"]
				local bound_key = type(menu_bind) == "table" and menu_bind.key or Enum.KeyCode.RightShift

				if selected_key == bound_key then
					window.set_menu_visibility(not window.opened)
				end
			end)

			-- keybind list
				local outline, _, background = create_field_surface(sgui, {
					position = dim2(0, 50, 0, 200),
					size = dim2(0, 224, 0, 56),
					fill_theme = "section_surface",
					fill_color = themes.preset.section_surface,
					gradient = true,
					gradient_theme = "contrast",
					gradient_transparency = numseq{
						numkey(0, 0.18),
						numkey(1, 0.42),
					},
					shadow = true,
					shadow_offset = ui_tokens.spacing.xs,
					shadow_transparency = 0.88,
					outer_radius = ui_tokens.radius.lg,
					fill_radius = ui_tokens.radius.md,
					zindex = 8,
					clips_descendants = true,
					active = true,
				})
				outline.Visible = false
				outline.ClipsDescendants = true
				library:draggify(outline)
				library:make_resizable(outline, dim2(0, 190, 0, 56))
				library.keybind_list_frame = outline

				local accent = library:create("Frame", {
					Parent = background,
					Name = "",
					Position = dim2(0, 12, 0, 12),
					Size = dim2(0, 22, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 0.08,
					ZIndex = 10,
				})
				library:apply_theme_once(accent, "accent", "BackgroundColor3")
				library:apply_corner(accent, 2)

				local text = library:create("TextLabel", {
					Parent = background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					Text = "Keybind List",
					BackgroundTransparency = 1,
					Size = dim2(1, -24, 0, 16),
					Position = dim2(0, 12, 0, 18),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					BorderSizePixel = 0,
					TextSize = ui_tokens.font.label,
					ZIndex = 10,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(text, "text", "TextColor3")
				
				local text_holder = library:create("Frame", {
					Parent = background,
					Name = "",
					Position = dim2(0, 12, 0, 39),
					Size = dim2(1, -24, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.separator,
					BackgroundTransparency = 0.28,
					ZIndex = 10,
				})
				library:apply_theme_once(text_holder, "separator", "BackgroundColor3")

				local keybind_list_holder = library:create("Frame", {
					Parent = background,
					Name = "",
					Position = dim2(0, 12, 0, 46),
					Size = dim2(1, -24, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ZIndex = 10,
				})
				library.keybind_list = keybind_list_holder
				
				local keybind_list_layout = library:create("UIListLayout", {
					Parent = keybind_list_holder,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				library:create("UIPadding", {
					Parent = keybind_list_holder,
					Name = "",
					PaddingBottom = dim(0, 10)
				})

				local function update_keybind_list_size(instant)
					local target_height = max(56, 46 + keybind_list_layout.AbsoluteContentSize.Y + 10)
					local target_size = dim2(outline.Size.X.Scale, outline.Size.X.Offset, 0, target_height)

					if instant then
						outline.Size = target_size
					else
						library:tween(outline, {
							Size = target_size
						}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end

				library:connection(keybind_list_layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					update_keybind_list_size(false)
				end)
				update_keybind_list_size(true)
			--  

			-- main window
				local main_window = library:panel({
					name = properties and properties.name or "Axon | ",
					size = properties and properties.size or dim2(0, 740, 0, 620),
					position = properties and properties.position or nil,
					image = "rbxassetid://98823308062942",
					minimum_size = Vector2.new(680, 480),
				})

				local items = main_window.items

				-- Hook minimize button to hide UI (can bring back with toggle button)
				main_window.on_minimize = function()
					window.set_menu_visibility(false)
				end
				-- Close button actually closes the UI
				main_window.on_close = nil

				window.tab_holder = items.module_tab_holder
				window.module_tab_holder = items.module_tab_holder
				window.system_tab_holder = items.system_tab_holder
				window.section_holder = items.holder
				window.user_tabs = {}
				window.visuals_tab = nil
				window._esp_preview_section = nil

				local watermark = library:watermark({default = os.date('Axon | %b %d %Y | %H:%M:%S')})

				task.spawn(function()
					while task.wait(1) do
						watermark.change_text(os.date('Axon | %b %d %Y | %H:%M:%S'))
					end
				end)

				local Settings = window:tab({name = "Settings", icon = "settings", system = true})
				local Configs = window:tab({name = "Configs", icon = "folder-open", system = true})
				local PlayerList = window:tab({name = "Player List", icon = "users", system = true})

				local theme_column = Settings:column()

				local function refresh_contrast_theme()
					local low_color = flags["Theme Low Contrast"] and flags["Theme Low Contrast"].Color or themes.preset.low_contrast
					local high_color = flags["Theme High Contrast"] and flags["Theme High Contrast"].Color or themes.preset.high_contrast

					library:update_theme("contrast", rgbseq{
						rgbkey(0, low_color),
						rgbkey(1, high_color)
					})
				end

				local function add_theme_row(section, row_name, pickers)
					local row = section:label({name = row_name})

					for _, picker in next, pickers do
						row = row:colorpicker({
							name = picker.name,
							color = themes.preset[picker.theme_key],
							flag = picker.flag,
							callback = picker.callback or function(color_value)
								library:update_theme(picker.theme_key, color_value)
							end
						})
					end
				end

				local theme_section = theme_column:section({name = "Theme"})

			-- Theme Presets
			local theme_presets = {
				["Current"] = {
					-- Keep current colors
				},
							["Emerald"] = {
				outline = Color3.fromRGB(13, 71, 33),
				inline = Color3.fromRGB(39, 87, 55),
				accent = Color3.fromRGB(134, 172, 146),
				glow = Color3.fromRGB(134, 172, 146),
				shadow = Color3.fromRGB(13, 71, 33),
				high_contrast = Color3.fromRGB(13, 71, 33),
				low_contrast = Color3.fromRGB(80, 129, 96),
				header_surface = Color3.fromRGB(80, 129, 96),
				sidebar_surface = Color3.fromRGB(28, 87, 48),
				content_surface = Color3.fromRGB(16, 74, 35),
				section_surface = Color3.fromRGB(23, 81, 42),
				nav_surface = Color3.fromRGB(90, 143, 108),
				control_surface = Color3.fromRGB(70, 122, 87),
				text = Color3.fromRGB(226, 229, 227),
				text_outline = Color3.fromRGB(10, 49, 23),
				text_secondary = Color3.fromRGB(226, 229, 227),
			},
			["Cherry"] = {
				outline = Color3.fromRGB(71, 13, 27),
				inline = Color3.fromRGB(87, 39, 50),
				accent = Color3.fromRGB(172, 134, 143),
				glow = Color3.fromRGB(172, 134, 143),
				shadow = Color3.fromRGB(71, 13, 27),
				high_contrast = Color3.fromRGB(71, 13, 27),
				low_contrast = Color3.fromRGB(129, 80, 91),
				header_surface = Color3.fromRGB(129, 80, 91),
				sidebar_surface = Color3.fromRGB(87, 28, 42),
				content_surface = Color3.fromRGB(74, 16, 29),
				section_surface = Color3.fromRGB(81, 23, 36),
				nav_surface = Color3.fromRGB(143, 90, 102),
				control_surface = Color3.fromRGB(122, 70, 82),
				text = Color3.fromRGB(229, 226, 226),
				text_outline = Color3.fromRGB(49, 10, 19),
				text_secondary = Color3.fromRGB(229, 226, 226),
			},
			["Ocean"] = {
				outline = Color3.fromRGB(13, 43, 71),
				inline = Color3.fromRGB(39, 63, 87),
				accent = Color3.fromRGB(134, 153, 172),
				glow = Color3.fromRGB(134, 153, 172),
				shadow = Color3.fromRGB(13, 43, 71),
				high_contrast = Color3.fromRGB(13, 43, 71),
				low_contrast = Color3.fromRGB(80, 105, 129),
				header_surface = Color3.fromRGB(80, 105, 129),
				sidebar_surface = Color3.fromRGB(28, 59, 87),
				content_surface = Color3.fromRGB(16, 46, 74),
				section_surface = Color3.fromRGB(23, 53, 81),
				nav_surface = Color3.fromRGB(90, 117, 143),
				control_surface = Color3.fromRGB(70, 97, 122),
				text = Color3.fromRGB(226, 227, 229),
				text_outline = Color3.fromRGB(10, 30, 49),
				text_secondary = Color3.fromRGB(226, 227, 229),
			},
			}

			theme_section:dropdown({
				name = "Theme Preset",
				flag = "theme_preset",
				default = "Current",
				options = {"Current", "Emerald", "Cherry", "Ocean"},
				callback = function(selected)
					if selected == "Current" then return end

					local preset = theme_presets[selected]
					if not preset then return end

					-- Apply all theme colors
					for theme_key, color in pairs(preset) do
						-- Map theme keys to their proper flag names
						local flag_mapping = {
							accent = "Theme Accent",
							glow = "Theme Glow",
							shadow = "Theme Shadow",
							outline = "Theme Outline",
							inline = "Theme Inline",
							high_contrast = "Theme High Contrast",
							low_contrast = "Theme Low Contrast",
							header_surface = "Theme Header Surface",
							sidebar_surface = "Theme Sidebar Surface",
							content_surface = "Theme Content Surface",
							section_surface = "Theme Section Surface",
							nav_surface = "Theme Nav Surface",
							control_surface = "Theme Control Surface",
							text = "Theme Text",
							text_outline = "Theme Text Outline",
							text_secondary = "Theme Text Secondary",
						}

						local flag = flag_mapping[theme_key]
						if flag and library.config_flags[flag] then
							-- Use the setter function to properly update the colorpicker
							library.config_flags[flag](color, 1)
						end
					end

					-- Refresh contrast theme
					refresh_contrast_theme()

					library:notification({text = "Applied " .. selected .. " theme", time = 3})
				end
			})

			theme_section:label({name = "Or customize colors manually below"})

				add_theme_row(theme_section, "Accent & Fx", {
					{name = "Accent", theme_key = "accent", flag = "Theme Accent"},
					{name = "Glow", theme_key = "glow", flag = "Theme Glow"},
					{name = "Shadow", theme_key = "shadow", flag = "Theme Shadow"},
				})
				add_theme_row(theme_section, "Base", {
					{name = "Outline", theme_key = "outline", flag = "Theme Outline"},
					{name = "Inline", theme_key = "inline", flag = "Theme Inline"},
					{name = "High", theme_key = "high_contrast", flag = "Theme High Contrast", callback = function(color_value)
						library:update_theme("high_contrast", color_value)
						refresh_contrast_theme()
					end},
					{name = "Low", theme_key = "low_contrast", flag = "Theme Low Contrast", callback = function(color_value)
						library:update_theme("low_contrast", color_value)
						refresh_contrast_theme()
					end},
				})
				add_theme_row(theme_section, "Text", {
					{name = "Main", theme_key = "text", flag = "Theme Text"},
					{name = "Alt", theme_key = "text_secondary", flag = "Theme Text Secondary"},
					{name = "Stroke", theme_key = "text_outline", flag = "Theme Text Outline"},
				})

				local surface_theme_section = theme_column:section({name = "Surface Theme"})
				add_theme_row(surface_theme_section, "Shell", {
					{name = "Header", theme_key = "header_surface", flag = "Theme Header Surface"},
					{name = "Sidebar", theme_key = "sidebar_surface", flag = "Theme Sidebar Surface"},
					{name = "Content", theme_key = "content_surface", flag = "Theme Content Surface"},
				})
				add_theme_row(surface_theme_section, "Panels", {
					{name = "Section", theme_key = "section_surface", flag = "Theme Section Surface"},
					{name = "Nav", theme_key = "nav_surface", flag = "Theme Nav Surface"},
					{name = "Control", theme_key = "control_surface", flag = "Theme Control Surface"},
				})
				add_theme_row(surface_theme_section, "Extra", {
					{name = "Glass", theme_key = "glass_tint", flag = "Theme Glass Tint"},
				})

				local utilities_column = Settings:column()
				local controls_section = utilities_column:section({name = "Controls"})
				controls_section:label({name = "UI Bind"})
				:keybind({flag = "ui_bind", callback = function() end, key = Enum.KeyCode.RightShift})
				controls_section:toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
					library.keybind_list_frame.Visible = bool
				end})
				controls_section:toggle({name = "Watermark", flag = "watermark", callback = function(bool)
					watermark.set_visible(bool)
				end})

				local actions_section = utilities_column:section({name = "Session"})
				actions_section:button_holder({})
				actions_section:button({name = "Copy JobId", callback = function()
					setclipboard(game.JobId)
				end})
				actions_section:button({name = "Copy GameID", callback = function()
					setclipboard(game.GameId)
				end})
				actions_section:button_holder({})
				actions_section:button({name = "Copy Join Script", callback = function()
					setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
				end})
				actions_section:button({name = "Rejoin", callback = function()
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
				end})
				actions_section:button_holder({})
				actions_section:button({name = "Join New Server", callback = function()
					local api_request = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
					local data = api_request.data[random(1, #api_request.data)]

					if data and data.playing <= flags["max_players"] then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.id)
					end
				end})
				actions_section:slider({name = "Max Players", flag = "max_players", min = 0, max = 40, default = 15, interval = 1})
			-- 

			-- cfg holder
				getgenv().load_config = function(name)
				library:load_config(readfile(library.directory .. "/configs/" .. name .. ".cfg"))
			end

			-- Left Column: Config Management
			local configs_left = Configs:column()

			-- Config Browser Section
			local browser_section = configs_left:section({name = "Config Browser"})
			browser_section:label({name = "Select a configuration to manage"})
			config_holder = browser_section:list({flag = "config_name_list"})

			browser_section:button_holder({})
			browser_section:button({name = "Refresh List", callback = function()
				library:config_list_update()
				library:notification({text = "Config list refreshed", time = 2})
			end})

			-- Quick Actions Section
			local quick_actions = configs_left:section({name = "Quick Actions"})
			quick_actions:label({name = "Load and save configurations"})

			quick_actions:button_holder({})
			quick_actions:button({name = "Load Selected", callback = function()
				if flags["config_name_list"] then
					library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
					library:notification({text = "Loaded: " .. flags["config_name_list"], time = 3})
				else
					library:notification({text = "No config selected", time = 2})
				end
			end})
			quick_actions:button({name = "Save to Selected", callback = function()
				if flags["config_name_list"] then
					writefile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg", library:get_config())
					library:config_list_update()
					library:notification({text = "Saved: " .. flags["config_name_list"], time = 3})
				else
					library:notification({text = "No config selected", time = 2})
				end
			end})

			quick_actions:button_holder({})
			quick_actions:button({name = "Delete Selected", callback = function()
				if flags["config_name_list"] then
					delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
					library:config_list_update()
					library:notification({text = "Deleted: " .. flags["config_name_list"], time = 3})
				else
					library:notification({text = "No config selected", time = 2})
				end
			end})

			-- Right Column: Create New & Advanced
			local configs_right = Configs:column()

			-- Create New Config Section
			local create_section = configs_right:section({name = "Create New Config"})
			create_section:label({name = "Enter a name for your new configuration"})
			create_section:textbox({flag = "config_name_text_box", placeholder = "Config name..."})

			create_section:button_holder({})
			create_section:button({name = "Create Config", callback = function()
				if flags["config_name_text_box"] and flags["config_name_text_box"] ~= "" then
					writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:get_config())
					library:config_list_update()
					library:notification({text = "Created: " .. flags["config_name_text_box"], time = 3})
					flags["config_name_text_box"] = ""
				else
					library:notification({text = "Please enter a config name", time = 2})
				end
			end})

			-- Advanced Options Section
			local advanced_section = configs_right:section({name = "Advanced Options"})
			advanced_section:label({name = "Reset and system options"})

			advanced_section:button_holder({})
			advanced_section:button({name = "Unload Config", callback = function()
				library:load_config(library.old_config)
				library:notification({text = "Config unloaded", time = 2})
			end})

			advanced_section:button_holder({})
			advanced_section:button({name = "Unload Menu", callback = function()
				library:load_config(library.old_config)
				library:notification({text = "Menu unloading...", time = 2})

				for _, gui in library.guis do
					gui:Destroy()
				end

				for _, connection in library.connections do
					connection:Disconnect()
				end
			end})

			-- Info Section
			local info_section = configs_right:section({name = "Information"})
			info_section:label({name = "Configs are saved automatically"})
			info_section:label({name = "Location: " .. library.directory .. "/configs/"})
			info_section:label({name = "Format: .cfg file"})
			info_section:label({name = "Tip: Create multiple configs for different scenarios"})
			--

			-- Backward compatibility: older scripts use window.esp_section:esp_preview(...)
				window.esp_section = {
					esp_preview = function(_, properties)
						local target_tab = window.visuals_tab or window.user_tabs[1] or Settings

						if not window._esp_preview_section or not window._esp_preview_section.holder or not window._esp_preview_section.holder.Parent then
							local preview_column = target_tab:column()
							window._esp_preview_section = preview_column:section({name = "ESP Preview"})
						end

						return window._esp_preview_section:esp_preview(properties or {})
					end
				}
			--

			-- playerlist
				local column = PlayerList:column()
				local section = column:section({name = "Player List"})
				section:playerlist({})
				section:dropdown({name = "Priority", items = {"Enemy", "Priority", "Neutral", "Friendly"}, default = "Neutral", flag = "PLAYERLIST_DROPDOWN", callback = function(text)
					library.prioritize(text)
				end})
			--  

			Settings.open_tab()
			library:play_window_intro(items, main_window)

			-- mini toggle button (top center, draggable, tap icon)
			do
				local toggle_btn_size = 35
				local icon_size = 30

				-- Separate ScreenGui so it never gets disabled
				local toggle_sgui = library:create("ScreenGui", {
					Parent = get_ui_mount_parent(),
					Name = "",
					DisplayOrder = 999999,
					ResetOnSpawn = false,
					IgnoreGuiInset = false,
				})

				-- Outer container for shadow effect
				local toggle_container = library:create("Frame", {
					Parent = toggle_sgui,
					Name = "",
					AnchorPoint = vec2(0.5, 0.5),
					Position = dim2(0.5, 0, 0, 10 + toggle_btn_size / 2),
					Size = dim2(0, toggle_btn_size, 0, toggle_btn_size),
					BackgroundTransparency = 1,
				})

				local toggle_btn = library:create("ImageButton", {
					Parent = toggle_container,
					Name = "",
					AnchorPoint = vec2(0.5, 0.5),
					Position = dim2(0.5, 0, 0.5, 0),
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = themes.preset.inline,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Image = "",
				})
				library:apply_theme(toggle_btn, "inline", "BackgroundColor3")
				library:apply_corner(toggle_btn, 8)

				-- Gradient overlay
				local btn_gradient = library:create("UIGradient", {
					Parent = toggle_btn,
					Rotation = 90,
					Color = themes.preset.contrast,
					Transparency = numseq{
						numkey(0, 0.3),
						numkey(1, 0.6),
					}
				})
				library:apply_theme(btn_gradient, "contrast", "Color")

				-- Stroke
				local btn_stroke = library:create("UIStroke", {
					Parent = toggle_btn,
					Color = themes.preset.outline,
					Thickness = 1,
					Transparency = 0.3,
				})
				library:apply_theme(btn_stroke, "outline", "Color")

				-- Icon
				local toggle_icon = library:create("ImageLabel", {
					Parent = toggle_btn,
					Name = "",
					AnchorPoint = vec2(0.5, 0.5),
					Position = dim2(0.5, 0, 0.5, 0),
					Size = dim2(0, icon_size, 0, icon_size),
					BackgroundTransparency = 1,
					Image = "rbxassetid://130540781756620",
					ImageColor3 = themes.preset.text,
					ImageTransparency = 0,
					ScaleType = Enum.ScaleType.Fit,
				})
				library:apply_theme(toggle_icon, "text", "ImageColor3")

				-- Dragging logic (custom to avoid conflicts)
				local dragging = false
				local drag_offset = vec2(0, 0)

				toggle_btn.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						-- Calculate offset from mouse to the container's center
						local abs_pos = toggle_container.AbsolutePosition
						local center_x = abs_pos.X + toggle_btn_size / 2
						local center_y = abs_pos.Y + toggle_btn_size / 2
						drag_offset = vec2(input.Position.X - center_x, input.Position.Y - center_y)
					end
				end)

				toggle_btn.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if dragging then
							dragging = false
						end
					end
				end)

				-- Separate click detection
				local click_start_pos = nil
				toggle_btn.MouseButton1Down:Connect(function()
					click_start_pos = vec2(mouse.X, mouse.Y)
				end)
				toggle_btn.MouseButton1Up:Connect(function()
					if click_start_pos then
						local delta = (vec2(mouse.X, mouse.Y) - click_start_pos).Magnitude
						if delta < 5 then
							window.set_menu_visibility(not window.opened)
						end
						click_start_pos = nil
					end
				end)

				library:connection(uis.InputChanged, function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local viewport = camera.ViewportSize
						local target_x = input.Position.X - drag_offset.X
						local target_y = input.Position.Y - drag_offset.Y

						-- Clamp to screen bounds
						target_x = clamp(target_x, toggle_btn_size / 2, viewport.X - toggle_btn_size / 2)
						target_y = clamp(target_y, toggle_btn_size / 2, viewport.Y - toggle_btn_size / 2)

						-- Smooth movement with tween
						library:tween(toggle_container, {
							Position = dim2(0, target_x, 0, target_y)
						}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end)

				-- Hover effects
				toggle_btn.MouseEnter:Connect(function()
					library:tween(toggle_btn, {BackgroundTransparency = 0}, 0.12)
					library:tween(btn_stroke, {Transparency = 0}, 0.12)
					library:tween(toggle_icon, {ImageTransparency = 0}, 0.12)
				end)
				toggle_btn.MouseLeave:Connect(function()
					library:tween(toggle_btn, {BackgroundTransparency = 0}, 0.12)
					library:tween(btn_stroke, {Transparency = 0.3}, 0.12)
				end)

				window.toggle_button = toggle_btn
				window.toggle_sgui = toggle_sgui
			end

			return window
		end

		function library:watermark(options) 
			local cfg = {
				default = options.text or options.default or os.date('drain.lol | %b %d %Y | %H:%M')
			}

			local watermark_outline = library:create("Frame", {
				Parent = sgui,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(1, -20, 0, 20),
				AnchorPoint = vec2(1, 0),
				Size = dim2(0, 0, 0, 28),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			})
			library:apply_theme(watermark_outline, "outline", "BackgroundColor3")
			library:apply_corner(watermark_outline, 6)
			watermark_outline.Position = dim_offset(watermark_outline.AbsolutePosition.X, watermark_outline.AbsolutePosition.Y)
			library:draggify(watermark_outline)

			local watermark_inline = library:create("Frame", {
				Parent = watermark_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})
			library:apply_theme(watermark_inline, "inline", "BackgroundColor3")
			library:apply_corner(watermark_inline, 5)
			
			local watermark_background = library:create("Frame", {
				Parent = watermark_inline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.high_contrast
			})
			library:apply_theme(watermark_background, "high_contrast", "BackgroundColor3")
			library:apply_corner(watermark_background, 4)
			
			local UIGradient = library:create("UIGradient", {
				Parent = watermark_background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(24, 27, 33)),
					rgbkey(1, rgb(18, 20, 26))
				}
			})
			library:apply_theme(UIGradient, "contrast", "Color")

			local accent = library:create("Frame", {
				Parent = watermark_background,
				Name = "",
				Position = dim2(0, 8, 0, 7),
				Size = dim2(0, 2, 1, -14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})
			library:apply_theme(accent, "accent", "BackgroundColor3")
			library:apply_corner(accent, 2)
			
			local text = library:create("TextLabel", {
				Parent = watermark_background,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "  drain.lol | Beta | Aug 29 2024 | 07:29:00  ",
				Size = dim2(0, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, 16, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			library:create("UIStroke", {
				Parent = text,
				Name = "",
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			
			function cfg.change_text(input)
				text.Text = " ".. input .." "
			end 

			function cfg.set_visible(bool) 
				watermark_outline.Visible = bool
			end 


			cfg.change_text(cfg.default)

			return cfg 

		end 

		function library:esp_preview(properties)
			local source_character = lp.Character or lp.CharacterAdded:Wait()
			source_character.Archivable = true

			local cfg = {
				items = {},
				rotation = 0,
				objects = {},
				preview_username = properties and properties.username or source_character.Name,
				preview_display = properties and properties.display_name or lp.DisplayName,
				preview_weapon = properties and properties.weapon or "Tactical Rifle",
				preview_distance = properties and properties.distance or 127,
				preview_health = properties and properties.health or 78,
				preview_name_style = properties and properties.name_style or "Display + Username",
			}

			local character = source_character:Clone()
			local animate = character:FindFirstChild("Animate")
			if animate then
				animate:Destroy()
			end

			local primary_part = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
			if primary_part then
				character.PrimaryPart = primary_part
			end

			local function get_flag_color(flag_name, fallback)
				local value = flags[flag_name]
				return type(value) == "table" and value.Color or fallback
			end

			local function get_flag_transparency(flag_name, fallback)
				local value = flags[flag_name]
				return type(value) == "table" and value.Transparency or fallback
			end

			local function get_name_text()
				local username = cfg.preview_username or lp.Name
				local display_name = cfg.preview_display or username
				local style = flags["Preview_Name_Mode"] or flags["Name_Mode"] or cfg.preview_name_style

				if style == "Username" then
					return "@" .. username
				elseif style == "Display Name" then
					return display_name
				end

				return string.format("%s (@%s)", display_name, username)
			end

			local items = cfg.items do
				items.root, _, items.fill = create_field_surface(self.holder, {
					size = dim2(1, -8, 0, 252),
					fill_theme = "content_surface",
					fill_color = themes.preset.content_surface,
					gradient = true,
					gradient_theme = "contrast",
					gradient_transparency = numseq{
						numkey(0, 0.22),
						numkey(1, 0.5),
					},
					outer_radius = ui_tokens.radius.md,
					fill_radius = ui_tokens.radius.md,
				})

				items.viewportframe = library:create("ViewportFrame", {
					Parent = items.fill,
					BackgroundTransparency = 0.12,
					Size = dim2(1, -(ui_tokens.control.preview_padding * 2), 1, -(ui_tokens.control.preview_padding * 2)),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 1,
					Position = dim2(0, ui_tokens.control.preview_padding, 0, ui_tokens.control.preview_padding),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.section_surface
				})
				library:apply_theme_once(items.viewportframe, "section_surface", "BackgroundColor3")
				library:apply_corner(items.viewportframe, ui_tokens.radius.md)
				apply_surface_stroke(items.viewportframe, "outline", 0.46, 1)

				items.camera = library:create("Camera", {
					FieldOfView = 32,
					CameraType = Enum.CameraType.Scriptable,
					Parent = items.viewportframe,
					Name = "\0"
				})

				items.viewportframe.CurrentCamera = items.camera
				character.Parent = items.viewportframe

				library:connection(run.RenderStepped, function()
					if not character.Parent or not character.PrimaryPart then
						return
					end

					cfg.rotation = cfg.rotation + 0.5
					character:PivotTo(cfr(Vector3.new(0, 0.1, -4.1)) * angle(0, math.rad(cfg.rotation), 0))
					items.camera.CFrame = cfr(Vector3.new(0, 2.22, 0.62), Vector3.new(0, 2.05, -4.1))
				end)
			end

			local objects = cfg.objects do
				objects.holder = library:create("Frame", {
					Parent = items.viewportframe,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = dim2(0.5, 0, 0.5, 6),
					Size = dim2(0, 160, 0, 214),
					BorderSizePixel = 0,
					AnchorPoint = vec2(0.5, 0.5),
					BackgroundColor3 = rgb(255, 255, 255)
				})

				objects.name = library:create("TextLabel", {
					Parent = library.cache,
					FontFace = library.font,
					TextColor3 = get_flag_color("Name_Color", themes.preset.text),
					Text = get_name_text(),
					Name = "\0",
					TextStrokeTransparency = 0,
					AnchorPoint = vec2(0, 1),
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -5),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13
				})

				objects.box_handler = library:create("Frame", {
					Parent = library.cache,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				objects.box_fill = library:create("Frame", {
					Parent = objects.box_handler,
					Name = "\0",
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = get_flag_color("Box_Fill_Color", get_flag_color("Box_Color", themes.preset.accent)),
					BackgroundTransparency = get_flag_transparency("Box_Fill_Color", 0.78)
				})

				objects.box_color = library:create("UIStroke", {
					Parent = objects.box_handler,
					Name = "\0",
					Color = get_flag_color("Box_Color", themes.preset.text),
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				objects.outline = library:create("Frame", {
					Parent = objects.box_handler,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:create("UIStroke", {
					Parent = objects.outline,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				objects.corners = library:create("Frame", {
					Parent = library.cache,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = dim2(0, -1, 0, 2),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				objects.corner_segments = {}

				local function create_corner_segment(position, size, anchor_point, rotation)
					local segment = library:create("Frame", {
						Parent = objects.corners,
						Name = "line",
						Position = position,
						Size = size,
						AnchorPoint = anchor_point,
						Rotation = rotation or 0,
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(0, 0, 0)
					})

					local inner = library:create("Frame", {
						Parent = segment,
						Name = "inner",
						Position = dim2(0, 1, 0, 1),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = get_flag_color("Box_Color", themes.preset.text)
					})

					insert(objects.corner_segments, inner)
				end

				create_corner_segment(dim2(0, 0, 0, -2), dim2(0.4, 0, 0, 3))
				create_corner_segment(dim2(0, 0, 0, 1), dim2(0, 3, 0.25, 0))
				create_corner_segment(dim2(1, 0, 0, -2), dim2(0.4, 0, 0, 3), vec2(1, 0))
				create_corner_segment(dim2(1, 0, 0, 1), dim2(0, 3, 0.25, 0), vec2(1, 0))
				create_corner_segment(dim2(0, -1, 1, -2), dim2(0.4, 0, 0, 3), vec2(0, 1))
				create_corner_segment(dim2(0, 0, 1, -4), dim2(0, 3, 0.25, 1), vec2(0, 1), 180)
				create_corner_segment(dim2(1, -1, 1, -2), dim2(0.4, 0, 0, 3), vec2(1, 1))
				create_corner_segment(dim2(1, 0, 1, -4), dim2(0, 3, 0.25, 1), vec2(1, 1), 180)

				objects.healthbar_holder = library:create("Frame", {
					Parent = library.cache,
					Name = "\0",
					AnchorPoint = vec2(1, 0),
					Position = dim2(0, -5, 0, 0),
					Size = dim2(0, 4, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 0, 0)
				})

				objects.healthbar = library:create("Frame", {
					Parent = objects.healthbar_holder,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				objects.health_text = library:create("TextLabel", {
					Parent = library.cache,
					FontFace = library.font,
					TextColor3 = get_flag_color("Health_Text_Color", themes.preset.text),
					Text = tostring(cfg.preview_health),
					Name = "\0",
					TextStrokeTransparency = 0,
					AnchorPoint = vec2(1, 0),
					Size = dim2(0, 0, 0, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, -8, 0, -5),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 13
				})

				objects.distance = library:create("TextLabel", {
					Parent = library.cache,
					FontFace = library.font,
					TextColor3 = get_flag_color("Distance_Color", themes.preset.text),
					Text = tostring(cfg.preview_distance) .. " studs",
					Name = "\0",
					TextStrokeTransparency = 0,
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 1, 5),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13
				})

				objects.weapon = library:create("TextLabel", {
					Parent = library.cache,
					FontFace = library.font,
					TextColor3 = get_flag_color("Weapon_Color", themes.preset.text),
					Text = string.format("[ %s ]", cfg.preview_weapon),
					Name = "\0",
					TextStrokeTransparency = 0,
					Size = dim2(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 1, 19),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13
				})

				objects.skeleton = library:create("Frame", {
					Parent = library.cache,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0
				})
				objects.skeleton_segments = {}

				local skeleton_data = {
					{position = dim2(0.5, 0, 0.14, 0), size = dim2(0, 2, 0, 14), rotation = 0},
					{position = dim2(0.5, 0, 0.24, 0), size = dim2(0, 36, 0, 2), rotation = 0},
					{position = dim2(0.5, 0, 0.39, 0), size = dim2(0, 2, 0, 42), rotation = 0},
					{position = dim2(0.39, 0, 0.34, 0), size = dim2(0, 30, 0, 2), rotation = -35},
					{position = dim2(0.61, 0, 0.34, 0), size = dim2(0, 30, 0, 2), rotation = 35},
					{position = dim2(0.44, 0, 0.72, 0), size = dim2(0, 36, 0, 2), rotation = 58},
					{position = dim2(0.56, 0, 0.72, 0), size = dim2(0, 36, 0, 2), rotation = -58},
				}

				for _, segment_data in next, skeleton_data do
					local segment = library:create("Frame", {
						Parent = objects.skeleton,
						Name = "\0",
						AnchorPoint = vec2(0.5, 0.5),
						Position = segment_data.position,
						Size = segment_data.size,
						Rotation = segment_data.rotation,
						BorderSizePixel = 0,
						BackgroundColor3 = get_flag_color("Skeleton_Color", themes.preset.text)
					})

					insert(objects.skeleton_segments, segment)
				end

				objects.chams = library:create("Highlight", {
					Parent = items.viewportframe,
					Adornee = character,
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
					Enabled = false,
					FillColor = get_flag_color("Chams_Fill_Color", rgb(105, 168, 255)),
					OutlineColor = get_flag_color("Chams_Outline_Color", themes.preset.text),
					FillTransparency = get_flag_transparency("Chams_Fill_Color", 0.45),
					OutlineTransparency = get_flag_transparency("Chams_Outline_Color", 0.05)
				})
			end

			function cfg.set_identity(username, display_name)
				if username ~= nil then
					cfg.preview_username = username ~= "" and username or lp.Name
				end

				if display_name ~= nil then
					cfg.preview_display = display_name ~= "" and display_name or cfg.preview_username
				end

				objects.name.Text = get_name_text()
			end

			function cfg.set_name_style(style)
				if style and style ~= "" then
					cfg.preview_name_style = style
				end

				objects.name.Text = get_name_text()
			end

			function cfg.set_weapon(text)
				cfg.preview_weapon = (text and text ~= "") and text or "Tactical Rifle"
				objects.weapon.Text = string.format("[ %s ]", cfg.preview_weapon)
			end

			function cfg.set_distance(value)
				cfg.preview_distance = floor(tonumber(value) or cfg.preview_distance)
				objects.distance.Text = tostring(cfg.preview_distance) .. " studs"
			end

			function cfg.change_health(value)
				if value ~= nil then
					cfg.preview_health = clamp(tonumber(value) or cfg.preview_health, 0, 100)
				end

				local multiplier = clamp(cfg.preview_health / 100, 0, 1)
				local low_color = get_flag_color("Health_Low", rgb(255, 92, 92))
				local high_color = get_flag_color("Health_High", rgb(116, 221, 135))
				local health_color = low_color:Lerp(high_color, multiplier)

				objects.healthbar.Size = dim2(1, -2, multiplier, -2)
				objects.healthbar.Position = dim2(0, 1, 1 - multiplier, 1)
				objects.healthbar.BackgroundColor3 = health_color
				objects.health_text.Text = tostring(floor(cfg.preview_health + 0.5))
				objects.health_text.TextColor3 = get_flag_color("Health_Text_Color", health_color)
			end

			function cfg.refresh_elements()
				local enabled = flags["Enabled"] and true or false
				local show_full_box = enabled and flags["Boxes"] and flags["Box_Type"] ~= "Corner"
				local show_corner_box = enabled and flags["Boxes"] and flags["Box_Type"] == "Corner"

				objects.holder.Parent = enabled and items.viewportframe or library.cache

				cfg.set_name_style(cfg.preview_name_style)
				cfg.set_identity(cfg.preview_username, cfg.preview_display)
				cfg.set_weapon(cfg.preview_weapon)
				cfg.set_distance(cfg.preview_distance)
				cfg.change_health(cfg.preview_health)

				objects.name.Parent = enabled and flags["Names"] and objects.holder or library.cache
				objects.name.TextColor3 = get_flag_color("Name_Color", themes.preset.text)

				objects.distance.Parent = enabled and flags["Distance"] and objects.holder or library.cache
				objects.distance.TextColor3 = get_flag_color("Distance_Color", themes.preset.text)

				objects.weapon.Parent = enabled and flags["Weapon"] and objects.holder or library.cache
				objects.weapon.TextColor3 = get_flag_color("Weapon_Color", themes.preset.text)

				objects.healthbar_holder.Parent = enabled and flags["Healthbar"] and objects.holder or library.cache
				objects.health_text.Parent = enabled and flags["Health_Text"] and objects.holder or library.cache

				objects.skeleton.Parent = enabled and flags["Skeleton"] and objects.holder or library.cache
				for _, segment in next, objects.skeleton_segments do
					segment.BackgroundColor3 = get_flag_color("Skeleton_Color", themes.preset.text)
				end

				objects.box_handler.Parent = show_full_box and objects.holder or library.cache
				objects.corners.Parent = show_corner_box and objects.holder or library.cache
				objects.box_color.Color = get_flag_color("Box_Color", themes.preset.text)

				objects.box_fill.Parent = (show_full_box and flags["Box_Fill"]) and objects.box_handler or library.cache
				objects.box_fill.BackgroundColor3 = get_flag_color("Box_Fill_Color", get_flag_color("Box_Color", themes.preset.accent))
				objects.box_fill.BackgroundTransparency = get_flag_transparency("Box_Fill_Color", 0.78)

				for _, inner in next, objects.corner_segments do
					inner.BackgroundColor3 = get_flag_color("Box_Color", themes.preset.text)
				end

				objects.chams.Enabled = enabled and flags["Chams"] or false
				objects.chams.FillColor = get_flag_color("Chams_Fill_Color", rgb(105, 168, 255))
				objects.chams.OutlineColor = get_flag_color("Chams_Outline_Color", themes.preset.text)
				objects.chams.FillTransparency = get_flag_transparency("Chams_Fill_Color", 0.45)
				objects.chams.OutlineTransparency = get_flag_transparency("Chams_Outline_Color", 0.05)
			end

			cfg.set_identity(cfg.preview_username, cfg.preview_display)
			cfg.set_weapon(cfg.preview_weapon)
			cfg.set_distance(cfg.preview_distance)
			cfg.change_health(cfg.preview_health)
			cfg.refresh_elements()

			return setmetatable(cfg, library)
		end

		function library:refresh_notifications()  	
			local offset_y = 20

			for _, notif in ipairs(library.notifications) do
				local notif_height = notif.AbsoluteSize.Y > 0 and notif.AbsoluteSize.Y or 76

				tween_service:Create(
					notif,
					TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Position = dim2(1, -20, 0, offset_y)}
				):Play()

				offset_y = offset_y + notif_height + 12
			end
		end

		function library:notification(properties)
			local cfg = {
				time = properties.time or 5,
				title = tostring(properties.title or properties.header or "Notification"),
				text = tostring(properties.text or properties.name or "Notification"),
				flashing = false, 
				width = properties.width or 336,
				icon_text = tostring(properties.icon_text or "!"),
			}

			if self.notifications_disabled then
				warn("[ui] " .. cfg.title .. ": " .. cfg.text)
				return
			end
		
			-- Instances
				local card_ok, card, card_stroke, card_fill = pcall(create_field_surface, notif_holder, {
					name = "notification",
					size = dim2(0, cfg.width, 0, 76),
					position = dim2(1, cfg.width + 28, 0, 20),
					anchor_point = vec2(1, 0),
					zindex = 60,
					clips_descendants = true,
					shadow = true,
					shadow_offset = 10,
					shadow_transparency = 0.82,
					fill_theme = "section_surface",
					fill_color = themes.preset.section_surface,
					gradient = true,
					gradient_theme = "contrast",
					gradient_transparency = numseq{
						numkey(0, 0.08),
						numkey(0.45, 0.24),
						numkey(1, 0.42)
					},
					outer_radius = 12,
					fill_radius = 11,
				})
				if not card_ok then
					self.notifications_disabled = true
					if not self.notification_error_reported then
						self.notification_error_reported = true
						warn("[ui] Notifications unavailable in this executor thread: " .. tostring(card))
					end
					warn("[ui] " .. cfg.title .. ": " .. cfg.text)
					return
				end
				card.ClipsDescendants = true
				card_fill.BackgroundTransparency = 1
				if card_stroke then
					card_stroke.Transparency = 1
				end

				local accent_rail = library:create("Frame", {
					Parent = card_fill,
					Name = "",
					Position = dim2(0, 0, 0, 0),
					Size = dim2(0, 4, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 0.04,
					ZIndex = 63,
				})
				library:apply_theme_once(accent_rail, "accent", "BackgroundColor3")
				library:apply_corner(accent_rail, 999)

				local glow = library:create("Frame", {
					Parent = card_fill,
					Name = "",
					Position = dim2(1, -118, 0, -40),
					Size = dim2(0, 154, 0, 154),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 0.95,
					ZIndex = 61,
				})
				library:apply_theme_once(glow, "accent", "BackgroundColor3")
				library:apply_corner(glow, 999)

				local glow_fade = library:create("UIGradient", {
					Parent = glow,
					Rotation = 45,
					Transparency = numseq{
						numkey(0, 0.15),
						numkey(1, 0.85)
					}
				})

				local top_strip = library:create("Frame", {
					Parent = card_fill,
					Name = "",
					Position = dim2(0, 62, 0, 28),
					Size = dim2(0, 28, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 0.1,
					ZIndex = 63,
				})
				library:apply_theme_once(top_strip, "accent", "BackgroundColor3")
				library:apply_corner(top_strip, 999)

				local icon_surface, _, icon_fill = create_field_surface(card_fill, {
					position = dim2(0, 16, 0.5, -17),
					size = dim2(0, 34, 0, 34),
					zindex = 63,
					fill_theme = "accent",
					fill_color = themes.preset.accent,
					fill_transparency = 0.14,
					outer_theme = false,
					outer_radius = 10,
					fill_radius = 9,
				})
				icon_surface.BackgroundTransparency = 1

				local icon_label = library:create("TextLabel", {
					Parent = icon_fill,
					Name = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					FontFace = library.font,
					Text = cfg.icon_text,
					TextSize = 18,
					TextColor3 = themes.preset.high_contrast,
					ZIndex = 65,
				})
				library:apply_theme_once(icon_label, "high_contrast", "TextColor3")

				local header = library:create("TextLabel", {
					Parent = card_fill,
					Name = "",
					BackgroundTransparency = 1,
					Position = dim2(0, 62, 0, 12),
					Size = dim2(1, -78, 0, 13),
					BorderSizePixel = 0,
					FontFace = library.font,
					Text = cfg.title,
					TextSize = 12,
					TextColor3 = themes.preset.value_text,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 64,
				})
				library:apply_theme_once(header, "value_text", "TextColor3")

				local message = library:create("TextLabel", {
					Parent = card_fill,
					Name = "",
					BackgroundTransparency = 1,
					Position = dim2(0, 62, 0, 35),
					Size = dim2(1, -78, 0, 26),
					BorderSizePixel = 0,
					FontFace = library.font,
					Text = cfg.text,
					TextSize = ui_tokens.font.label,
					TextColor3 = themes.preset.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					ZIndex = 64,
				})
				library:apply_theme_once(message, "text", "TextColor3")

				local progress_track = library:create("Frame", {
					Parent = card_fill,
					Name = "",
					Position = dim2(0, 16, 1, -11),
					Size = dim2(1, -32, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.control_surface,
					BackgroundTransparency = 0.38,
					ZIndex = 63,
				})
				library:apply_theme_once(progress_track, "control_surface", "BackgroundColor3")
				library:apply_corner(progress_track, 999)

				local progress_fill = library:create("Frame", {
					Parent = progress_track,
					Name = "",
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					ZIndex = 64,
				})
				library:apply_theme_once(progress_fill, "accent", "BackgroundColor3")
				library:apply_corner(progress_fill, 999)

				insert(library.notifications, card)
				library:refresh_notifications()

				tween_service:Create(
					card_fill,
					TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 0.04}
				):Play()
				if card_stroke then
					tween_service:Create(
						card_stroke,
						TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Transparency = 0.4}
					):Play()
				end

				tween_service:Create(
					progress_fill,
					TweenInfo.new(cfg.time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
					{Size = dim2(0, 0, 1, 0)}
				):Play()
			--
			
			task.spawn(function()
				task.wait(cfg.time)

				local removed_index = find(library.notifications, card)
				if removed_index then
					remove(library.notifications, removed_index)
					library:refresh_notifications()
				end

				tween_service:Create(
					card,
					TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Position = dim2(1, cfg.width + 28, 0, card.Position.Y.Offset)}
				):Play()
				tween_service:Create(
					card_fill,
					TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 1}
				):Play()
				if card_stroke then
					tween_service:Create(
						card_stroke,
						TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Transparency = 1}
					):Play()
				end
				
				for _, v in next, card:GetDescendants() do 
					if v:IsA("TextLabel") then 
						tween_service:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
					elseif v:IsA("Frame") then 
						tween_service:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					elseif v:IsA("ImageLabel") then
						tween_service:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
					elseif v:IsA("UIStroke") then 
						tween_service:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
					end 
				end 

				task.wait(0.25)

				card:Destroy()
			end)    
		end 

		local function get_page_fade_targets(page)
			local cached = library.page_fade_targets[page]
			if cached then
				return cached
			end

			local targets = {}
			for _, descendant in ipairs(page:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					insert(targets, {
						object = descendant,
						property = "BackgroundTransparency",
						shown = descendant.BackgroundTransparency,
					})
				end

				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					insert(targets, {
						object = descendant,
						property = "TextTransparency",
						shown = descendant.TextTransparency,
					})
				elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
					insert(targets, {
						object = descendant,
						property = "ImageTransparency",
						shown = descendant.ImageTransparency,
					})
				elseif descendant:IsA("UIStroke") then
					insert(targets, {
						object = descendant,
						property = "Transparency",
						shown = descendant.Transparency,
					})
				end
			end

			library.page_fade_targets[page] = targets
			return targets
		end

		local function set_page_fade(page, fade)
			for _, target in ipairs(get_page_fade_targets(page)) do
				local object = target.object
				if object and object.Parent then
					local shown = target.shown or 0
					object[target.property] = shown + ((1 - shown) * fade)
				end
			end
		end

		local function tween_page_fade(page, fade, duration)
			for _, target in ipairs(get_page_fade_targets(page)) do
				local object = target.object
				if object and object.Parent then
					local shown = target.shown or 0
					library:tween(
						object,
						{[target.property] = shown + ((1 - shown) * fade)},
						duration,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out
					)
				end
			end
		end

		local function get_page_card_scales(page)
			local cached = library.page_card_scales[page]
			if cached then
				return cached
			end

			local scales = {}
			for _, column in ipairs(page:GetChildren()) do
				if column:IsA("GuiObject") then
					for _, child in ipairs(column:GetChildren()) do
						if child:IsA("GuiObject") and child:FindFirstChild("surface") then
							local scale = child:FindFirstChildOfClass("UIScale") or library:create("UIScale", {
								Parent = child,
								Scale = 1,
							})
							insert(scales, scale)
						end
					end
				end
			end

			library.page_card_scales[page] = scales
			return scales
		end

		local function set_page_cards_scale(page, scale_value)
			for _, scale in ipairs(get_page_card_scales(page)) do
				if scale and scale.Parent then
					scale.Scale = scale_value
				end
			end
		end

		local function tween_page_cards(page, scale_value, duration)
			for index, scale in ipairs(get_page_card_scales(page)) do
				if scale and scale.Parent then
					task.delay((index - 1) * 0.02, function()
						if scale and scale.Parent then
							tween_service:Create(
								scale,
								TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
								{Scale = scale_value}
							):Play()
						end
					end)
				end
			end
		end

		function library:tab(options)	
			local cfg = {
				name = options.name or "tab", 
				enabled = false,
				system = options.system or false,
				icon = options.icon or options.icon_image or options.image,
				icon_text = options.icon_text,
			}
			
			local button_parent = cfg.system and (self.system_tab_holder or self.tab_holder) or (self.module_tab_holder or self.tab_holder)

			if self.user_tabs and not cfg.system then
				insert(self.user_tabs, cfg)

				if tostring(cfg.name):lower() == "visuals" and not self.visuals_tab then
					self.visuals_tab = cfg
				end
			end

			local tab_holder = library:create("TextButton", {
				Parent = button_parent,
				FontFace = library.font,
				TextColor3 = themes.preset.text_secondary,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				Name = "\0",
				BorderSizePixel = 0,
				Size = dim2(1, 0, 0, ui_tokens.control.sidebar_item),
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = themes.preset.outline,
				BackgroundTransparency = 1,
				AutoButtonColor = false
			})
			library:apply_corner(tab_holder, 6)
			local tab_stroke = apply_surface_stroke(tab_holder, "outline", 0.62, 1)

			local inline = library:create("Frame", {
				Parent = tab_holder,
				Size = dim2(1, 0, 1, 0),
				Name = "\0",
				Position = dim2(0, 0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				BackgroundTransparency = 1
			})
			library:apply_corner(inline, 5)

			local background = library:create("Frame", {
				Parent = inline,
				Size = dim2(1, 0, 1, 0),
				Name = "\0",
				Position = dim2(0, 0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.section_surface
			})
			library:apply_theme_once(background, "section_surface", "BackgroundColor3")
			library:apply_corner(background, 4)

			local background_gradient = library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = themes.preset.contrast,
				Transparency = numseq{
					numkey(0, 0.2),
					numkey(1, 0.5)
				}
			})
			library:apply_theme_once(background_gradient, "contrast", "Color")

			local hover_fill = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(0, 0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.surface_highlight,
				BackgroundTransparency = 1
			})
			library:apply_theme_once(hover_fill, "surface_highlight", "BackgroundColor3")
			library:apply_corner(hover_fill, 4)

			local active_fill = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(0, 0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 1
			})
			library:apply_theme(active_fill, "accent", "BackgroundColor3")
			library:apply_corner(active_fill, 4)

			local indicator = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(0, 8, 0, 7),
				Size = dim2(0, 3, 1, -14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 1
			})
			library:apply_theme_once(indicator, "accent", "BackgroundColor3")
			library:apply_corner(indicator, 2)

			local resolved_icon = library:resolve_tab_icon_asset(cfg.icon)
			local fallback_icon_text = cfg.icon_text

			local icon_object
			local icon_surface
			local text_offset = 14
			if resolved_icon then
				icon_surface = library:create("Frame", {
					Parent = background,
					Name = "icon_surface",
					Position = dim2(0, 16, 0.5, -8),
					Size = dim2(0, 18, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.control_surface
				})
				library:apply_theme_once(icon_surface, "control_surface", "BackgroundColor3")
				library:apply_corner(icon_surface, 5)

				icon_object = library:create("ImageLabel", {
					Parent = icon_surface,
					Name = "icon",
					BackgroundTransparency = 1,
					Position = dim2(0, 3, 0, 3),
					Size = dim2(1, -6, 1, -6),
					BorderSizePixel = 0,
					Image = resolved_icon.image,
					ImageRectSize = resolved_icon.image_rect_size,
					ImageRectOffset = resolved_icon.image_rect_offset,
					ImageColor3 = themes.preset.text_secondary,
				})
				library:apply_theme(icon_object, "text_secondary", "ImageColor3")
				text_offset = 42
			elseif fallback_icon_text then
				icon_surface = library:create("Frame", {
					Parent = background,
					Name = "icon_surface",
					Position = dim2(0, 16, 0.5, -8),
					Size = dim2(0, 18, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.control_surface
				})
				library:apply_theme_once(icon_surface, "control_surface", "BackgroundColor3")
				library:apply_corner(icon_surface, 5)

				icon_object = library:create("TextLabel", {
					Parent = icon_surface,
					Name = "icon",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					Text = fallback_icon_text,
					TextSize = ui_tokens.font.helper,
				})
				library:apply_theme(icon_object, "text_secondary", "TextColor3")
				text_offset = 42
			end

			local text = library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text_secondary,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = dim2(0, text_offset, 0, 0),
				Size = dim2(1, -(text_offset + 8), 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = rgb(255, 255, 255)
			}, "text")
			library:apply_theme(text, "accent", "TextColor3")
			library:apply_theme(text, "text_secondary", "TextColor3")

			tab_holder.MouseEnter:Connect(function()
				if not cfg.enabled then
					library:tween(hover_fill, {BackgroundTransparency = 0.9}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					library:tween(tab_stroke, {Transparency = ui_tokens.stroke.hover}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
			end)

			tab_holder.MouseLeave:Connect(function()
				library:tween(hover_fill, {BackgroundTransparency = 1}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(tab_stroke, {Transparency = cfg.enabled and 0.42 or 0.62}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end)

			local section_holder = library:create("ScrollingFrame", {
				Parent = self.section_holder,
				BackgroundTransparency = 1,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				Visible = false,
				Position = dim2(0, 0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				CanvasSize = dim2(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = themes.preset.accent,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				MidImage = "rbxassetid://103468666327206",
				TopImage = "rbxassetid://103468666327206",
				BottomImage = "rbxassetid://103468666327206"
			})
			library:apply_theme_once(section_holder, "accent", "ScrollBarImageColor3")

			local page_canvas = library:create("Frame", {
				Parent = section_holder,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -10, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			cfg.holder = page_canvas

			library:create("UIListLayout", {
				Parent = page_canvas,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local function set_active_state(bool, instant)
				cfg.enabled = bool
				local duration = instant and 0 or 0.16
				local active_transparency = bool and 0.82 or 1
				local indicator_transparency = bool and 0.08 or 1
				local stroke_transparency = bool and 0.42 or 0.62
				local text_color = bool and themes.preset.text or themes.preset.text_secondary
				local icon_surface_color = bool and themes.preset.accent or themes.preset.control_surface

				if duration == 0 then
					active_fill.BackgroundTransparency = active_transparency
					hover_fill.BackgroundTransparency = 1
					indicator.BackgroundTransparency = indicator_transparency
					text.TextColor3 = text_color
					tab_stroke.Transparency = stroke_transparency
				else
					library:tween(active_fill, {BackgroundTransparency = active_transparency}, duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					library:tween(hover_fill, {BackgroundTransparency = 1}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					library:tween(indicator, {BackgroundTransparency = indicator_transparency}, duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					library:tween(text, {TextColor3 = text_color}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					library:tween(tab_stroke, {Transparency = stroke_transparency}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end

				if icon_surface then
					if duration == 0 then
						icon_surface.BackgroundColor3 = icon_surface_color
					else
						library:tween(icon_surface, {BackgroundColor3 = icon_surface_color}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end

				if icon_object then
					local icon_color = bool and themes.preset.high_contrast or themes.preset.text_secondary
					if duration == 0 then
						if icon_object:IsA("ImageLabel") then
							icon_object.ImageColor3 = icon_color
						else
							icon_object.TextColor3 = icon_color
						end
					elseif icon_object:IsA("ImageLabel") then
						library:tween(icon_object, {ImageColor3 = icon_color}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					else
						library:tween(icon_object, {TextColor3 = icon_color}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end
			end

			local function tween_page(page, position, on_complete)
				local existing_tween = library.page_tweens[page]
				if existing_tween then
					existing_tween:Cancel()
				end

				local tween = tween_service:Create(
					page,
					TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Position = position}
				)
				library.page_tweens[page] = tween

				tween.Completed:Connect(function(playback_state)
					if library.page_tweens[page] == tween then
						library.page_tweens[page] = nil
					end

					if playback_state == Enum.PlaybackState.Completed and on_complete then
						on_complete()
					end
				end)

				tween:Play()
			end

			function cfg.open_tab()
				if library.current_tab and library.current_tab.cfg == cfg then
					set_active_state(true, false)
					return
				end

				if library.current_tab and library.current_tab.cfg ~= cfg then
					local previous_tab = library.current_tab
					previous_tab.set_active_state(false, false)
					tween_page_fade(previous_tab.page, 1, 0.12)
					tween_page_cards(previous_tab.page, 0.985, 0.12)
					tween_page(previous_tab.page, dim2(0, -10, 0, 0), function()
						if library.current_tab and library.current_tab.page ~= previous_tab.page then
							previous_tab.page.Visible = false
						end
					end)
				end

				library.current_tab = {
					cfg = cfg,
					page = section_holder,
					set_active_state = set_active_state
				}

				section_holder.Position = dim2(0, 10, 0, 0)
				section_holder.Visible = true
				set_page_fade(section_holder, 1)
				set_page_cards_scale(section_holder, 0.985)
				set_active_state(true, false)
				tween_page(section_holder, dim2(0, 0, 0, 0))
				tween_page_fade(section_holder, 0, 0.16)
				tween_page_cards(section_holder, 1, 0.18)

				if library.current_element_open and library.current_element_open ~= cfg then
					local current = library.current_element_open
					current.set_visible(false)
					current.open = false
					library.current_element_open = nil
				end
			end
			
			tab_holder.MouseButton1Click:Connect(cfg.open_tab)
			
			return setmetatable(cfg, library) 
		end

		function library:column(path) 
			local cfg = {}
			
			local holder = path or self.holder
			
			local column = library:create("Frame", {
				Parent = holder,
				BackgroundTransparency = 1,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})
			library:apply_theme(column, "inline", "BackgroundColor3")
			
			library:create("UIListLayout", {
				Parent = column,
				Padding = dim(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			cfg["holder"] = column

			return setmetatable(cfg, library) 
		end

		function library:multi_section(options)
			local cfg = {
				names = options.names or {"First", "Second", "Third"}, 
				sections = {},
				name = options.name,
			}

			local section, background = create_section_shell(self.holder, {
				radius = ui_tokens.radius.md,
				clips_descendants = true,
			})
			background.ZIndex = 1

			local tab_bar_y = ui_tokens.layout.section_padding
			if cfg.name and cfg.name ~= "" then
				SectionHeader(background, cfg.name)
				tab_bar_y = tab_bar_y + ui_tokens.control.section_header + ui_tokens.spacing.sm
			end

			local tab_bar = TabBar(background, {
				items = cfg.names,
				position = dim2(0, ui_tokens.layout.section_padding, 0, tab_bar_y),
				size = dim2(1, -(ui_tokens.layout.section_padding * 2), 0, ui_tokens.control.segmented_height),
			})

			local content_holder = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(
					0,
					ui_tokens.layout.section_padding,
					0,
					tab_bar_y + ui_tokens.control.segmented_height + ui_tokens.spacing.sm
				),
				Size = dim2(1, -(ui_tokens.layout.section_padding * 2), 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			})
			
			for index, tab in next, cfg.names do 
				local multi = {
					open = false, 
				} 

				local page = library:create("Frame", {
					Parent = content_holder,
					Name = "",
					Visible = false,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local elements = library:create("Frame", {
					Parent = page,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = rgb(255, 255, 255)
				}) multi.holder = elements
				
				library:create("UIListLayout", {
					Parent = elements,
					Name = "",
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = dim(0, ui_tokens.layout.row_gap)
				})
				
				library:create("UIPadding", {
					Parent = elements,
					Name = "",
					PaddingBottom = dim(0, ui_tokens.spacing.sm)
				})
				
				function multi:open_tab(bool) 
					page.Visible = bool 

					if bool then
						tab_bar.set_active(index)
					end
				end

				library:connection(tab_bar.buttons[index].button.MouseButton1Click, function()
					for _, multi_s in next, cfg.sections do 
						multi_s:open_tab(false)
					end

					if library.current_element_open then 
						local current = library.current_element_open
						current.set_visible(false)
						current.open = false 
						library.current_element_open = nil 
					end

					multi:open_tab(true) 
				end)

				cfg.sections[#cfg.sections + 1] = setmetatable(multi, library)
			end 

			cfg.sections[1]:open_tab(true)

			return unpack(cfg.sections)
		end 

		function library:section(options)
			local cfg = {
				name = options.name or "Section", 
			}
			
			local section, background = create_section_shell(self.holder, {
				name = "\0",
				radius = ui_tokens.radius.md,
				clips_descendants = true,
			})

			SectionHeader(background, cfg.name)

			local content_holder = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(
					0,
					ui_tokens.layout.section_padding,
					0,
					ui_tokens.layout.section_padding + ui_tokens.control.section_header + ui_tokens.spacing.xxs
				),
				Size = dim2(1, -(ui_tokens.layout.section_padding * 2), 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			})

			local elements = library:create("Frame", {
				Parent = content_holder,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.holder = elements 

			library:create("UIListLayout", {
				Parent = elements,
				Padding = dim(0, ui_tokens.layout.row_gap),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = elements,
				PaddingBottom = dim(0, ui_tokens.spacing.sm)
			})

			library:_attach_element(cfg, section, {type = "section"})

			return setmetatable(cfg, library)
		end

		function library:slider(options)
			return SliderRow(self, options)
		end 

		function library:toggle(options)
			return ToggleRow(self, options)
		end
		
		function library:_legacy_colorpicker_removed(options)
			local parent = self.right_holder
			
			local cfg = {
				name = options.name or "Color", 
				flag = options.flag or tostring(2^789),
				color = options.color or color(1, 1, 1), -- Default to white color if not provided
				alpha = options.alpha or 1,
				callback = options.callback or function() end,
				right_holder = self.right_holder,
			}

			local dragging_sat = false 
			local dragging_hue = false 
			local dragging_alpha = false 

			local h, s, v = cfg.color:ToHSV() 
			local a = cfg.alpha 
			local popup_animation_id = 0
			local popup_tween
			
			-- colorpicker button 
				local colorpicker_button = library:create("TextButton", {
					Parent = parent,
					Name = "outline",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 20, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(colorpicker_button, "outline", "BackgroundColor3") 
				library:apply_corner(colorpicker_button, 6)
			
				local inline = library:create("Frame", {
					Parent = colorpicker_button,
					Name = "inline",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				library:apply_corner(inline, 5)
			
				local handler = library:create("Frame", {
					Parent = inline,
					Name = "handler",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(250, 165, 27)
				})
				library:apply_corner(handler, 4)

				library:hoverify(colorpicker_button, colorpicker_button)
			
				local UIGradient = library:create("UIGradient", {
					Parent = handler,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
			-- 

			-- colorpicker instances
				local colorpicker_holder = library:create("Frame", {
					Parent = sgui,
					Name = "colorpicker",
					Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 21),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 208, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Visible = false,
					ZIndex = 30,
					ClipsDescendants = true,
				}) library:apply_theme(colorpicker_holder, "outline", "BackgroundColor3") 
				library:apply_corner(colorpicker_holder, 8)

				library:make_resizable(colorpicker_holder)
				
				local window_inline = library:create("Frame", {
					Parent = colorpicker_holder,
					Name = "window_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(window_inline, "inline", "BackgroundColor3") 
				library:apply_corner(window_inline, 7)
				
				local window_holder = library:create("Frame", {
					Parent = window_inline,
					Name = "window_holder",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = themes.preset.outline,
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.high_contrast
				})
				library:apply_theme(window_holder, "high_contrast", "BackgroundColor3")
				library:apply_corner(window_holder, 6)

				local UIGradient = library:create("UIGradient", {
					Parent = window_holder,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
					rgbkey(0, rgb(24, 27, 33)),
					rgbkey(1, rgb(18, 20, 26))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local text = library:create("TextLabel", {
					Parent = window_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "text",
					BackgroundTransparency = 1,
					Position = dim2(0, 8, 0, 8),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(text, "text", "TextColor3")
				
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				library:create("UIPadding", {
					Parent = window_holder,
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local main_holder = library:create("Frame", {
					Parent = window_holder,
					Name = "main_holder",
					Position = dim2(0, 8, 0, 28),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -16, 1, -58),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(main_holder, "inline", "BackgroundColor3") 
				library:apply_corner(main_holder, 6)
				
				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(0, 6, 1, -21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -120, 0, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
				});
				
				local RainbowToggle = setmetatable(cfg, library):toggle({name = "Rainbow", flag = cfg.flag .. "_RAINBOW_FLAG"})

				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(1, 2, 1, -23);
					BorderColor3 = rgb(0, 0, 0);
					AnchorPoint = vec2(1, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
				});
				
				local section = setmetatable(cfg, library)
				section:button_holder({})
				section:button({name = "Copy", callback = function()
					library.copied_flag = flags[cfg.flag]
					library.is_rainbow = cfg.flag .. "_RAINBOW_FLAG"
				end})
				section:button({name = "Paste", callback = function()
					RainbowToggle.set(library.is_rainbow)
					cfg.set(library.copied_flag.Color, library.copied_flag.Transparency)
				end})

				local main_holder_inline = library:create("Frame", {
					Parent = main_holder,
					Name = "main_holder_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder_inline, "outline", "BackgroundColor3") 
				library:apply_corner(main_holder_inline, 5)
				
				local main_holder_background = library:create("Frame", {
					Parent = main_holder_inline,
					Name = "main_holder_background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.high_contrast
				})
				library:apply_theme(main_holder_background, "high_contrast", "BackgroundColor3")
				library:apply_corner(main_holder_background, 4)
				
				local UIGradient = library:create("UIGradient", {
					Parent = main_holder_background,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIPadding", {
					Parent = main_holder_background,
					PaddingTop = dim(0, 4),
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local alpha = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(0, 0.5),
					Name = "alpha",
					Position = dim2(0, 0, 1, -8),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(alpha, "inline", "BackgroundColor3") 
				library:apply_corner(alpha, 4)
				
				local outline = library:create("Frame", {
					Parent = alpha,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				library:apply_corner(outline, 3)
				
				local alpha_drag = library:create("Frame", {
					Parent = outline,
					Name = "alpha_drag",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				library:apply_corner(alpha_drag, 3)
				
				local alphaind = library:create("ImageLabel", {
					Parent = alpha_drag,
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = rgb(0, 0, 0),
					Image = "rbxassetid://18274452449",
					BackgroundTransparency = 1,
					Name = "alphaind",
					Size = dim2(1, 0, 1, 0),
					TileSize = dim2(0, 6, 0, 6),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = alphaind,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local alpha_picker = library:create("Frame", {
					Parent = alpha_drag,
					Name = "alpha_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 4, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local hue = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 0),
					Name = "hue",
					Position = dim2(1, -1, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 1, -20),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false
				})
				library:apply_theme(hue, "inline", "BackgroundColor3")
				library:apply_corner(hue, 4)
				
				local outline = library:create("Frame", {
					Parent = hue,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(outline, "outline", "BackgroundColor3")
				library:apply_corner(outline, 3)
				
				local Frame = library:create("Frame", {
					Parent = outline,
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_corner(Frame, 3)
				
				local UIGradient = library:create("UIGradient", {
					Parent = Frame,
					Rotation = 270,
					Color = rgbseq{
						rgbkey(0, rgb(255, 0, 0)),
						rgbkey(0.17000000178813934, rgb(255, 255, 0)),
						rgbkey(0.33000001311302185, rgb(0, 255, 0)),
						rgbkey(0.5, rgb(0, 255, 255)),
						rgbkey(0.6700000166893005, rgb(0, 0, 255)),
						rgbkey(0.8299999833106995, rgb(255, 0, 255)),
						rgbkey(1, rgb(255, 0, 0))
					}
				}) 
				
				local hue_picker = library:create("Frame", {
					Parent = Frame,
					Name = "hue_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 4),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local visualize = library:create("Frame", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 1),
					Name = "visualize",
					Position = dim2(1, -1, 1, -1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(visualize, "inline", "BackgroundColor3") 
				library:apply_corner(visualize, 4)
				
				local outline = library:create("Frame", {
					Parent = visualize,
					Size = dim2(1, -2, 1, -2),
					Name = "outline",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				library:apply_corner(outline, 3)
				
				local visualize = library:create("Frame", {
					Parent = outline,
					Size = dim2(1, -2, 1, -2),
					Name = "visualize",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				library:apply_corner(visualize, 3)
				
				local satval_picker = library:create("Frame", {
					Parent = main_holder_background,
					Name = "satval_picker",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 1, -20),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(satval_picker, "inline", "BackgroundColor3") 
				library:apply_corner(satval_picker, 4)
				
				local outline = library:create("Frame", {
					Parent = satval_picker,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				library:apply_corner(outline, 3)
				
				local colorpicker = library:create("Frame", {
					Parent = outline,
					Name = "colorpicker",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				library:apply_corner(colorpicker, 3)
				
				local sat = library:create("TextButton", {
					Parent = colorpicker,
					Name = "sat",
					Size = dim2(1, 0, 1, 0),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = sat,
					Rotation = 270,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					},
					Color = rgbseq{
						rgbkey(0, rgb(0, 0, 0)),
						rgbkey(1, rgb(0, 0, 0))
					}
				})
				
				local val = library:create("TextButton", {
					Parent = colorpicker,
					Name = "val",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = val,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local satval_picker_REAL = library:create("Frame", {
					Parent = colorpicker,
					Name = "satval_picker_REAL",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 2, 0, 2),
					BorderSizePixel = 1,
					BackgroundColor3 = rgb(255, 255, 255),
					ZIndex = 3, 
				})
			-- 
				
			function cfg.set_visible(bool)
				popup_animation_id = popup_animation_id + 1
				local animation_id = popup_animation_id
				cfg.open = bool

				if bool then 
					if library.current_element_open and library.current_element_open ~= cfg then 
						local current = library.current_element_open
						current.set_visible(false)
						current.open = false 
					end

					library.current_element_open = cfg
					colorpicker_holder.Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 21)
					colorpicker_holder.Visible = true

					if popup_tween then
						popup_tween:Cancel()
					end

					colorpicker_holder.Size = dim2(0, 208, 0, 0)
					popup_tween = tween_service:Create(
						colorpicker_holder,
						TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{Size = dim2(0, 208, 0, 236)}
					)
					popup_tween:Play()
				elseif library.current_element_open == cfg then
					library.current_element_open = nil

					if popup_tween then
						popup_tween:Cancel()
					end

					popup_tween = tween_service:Create(
						colorpicker_holder,
						TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = dim2(0, 208, 0, 0)}
					)
					popup_tween:Play()

					task.delay(0.14, function()
						if popup_animation_id == animation_id and not cfg.open then
							colorpicker_holder.Visible = false
						end
					end)
				end
			end 

			colorpicker_button.MouseButton1Click:Connect(function()		
				cfg.open = not cfg.open

				cfg.set_visible(cfg.open) 
			end)

			function cfg.set(color, alpha)
				if color then 
					h, s, v = color:ToHSV()
				end 
			
				if alpha then 
					a = alpha
				end 
			
				local hsv_position = Color3.fromHSV(h, s, v)
				local Color = Color3.fromHSV(h, s, v)
				
				local value = 1 - h
				local offset = (value < 1) and 0 or -4
				hue_picker.Position = dim2(0, 0, value, offset)

				local offset = (a < 1) and 0 or -4
				alpha_picker.Position = dim2(a, offset, 0, 0)

				alpha_drag.BackgroundColor3 = Color3.fromHSV(h, s, v)
				
				visualize.BackgroundColor3 = Color
				handler.BackgroundColor3 = Color 

				colorpicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				
				cfg.color = Color
				cfg.alpha = a
				
				local s_offset = (s < 1) and 0 or -3
				local v_offset = (1 - v < 1) and 0 or -3
				satval_picker_REAL.Position = dim2(s, s_offset, 1 - v, v_offset)

				flags[cfg.flag] = {} 
				flags[cfg.flag]["Color"] = Color
				flags[cfg.flag]["Transparency"] = a
			
				cfg.callback(Color, a)
			end

			function cfg.update_color() 
				local mouse = uis:GetMouseLocation() 

				if dragging_sat then	
					s = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - val.AbsolutePosition).X / val.AbsoluteSize.X, 0, 1)
					v = 1 - math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - sat.AbsolutePosition).Y / sat.AbsoluteSize.Y, 0, 1)
				elseif dragging_hue then 
					h = math.clamp(1 - (vec2(mouse.X, mouse.Y - gui_offset) - hue.AbsolutePosition).Y / hue.AbsoluteSize.Y, 0, 1)
				elseif dragging_alpha then 
					a = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - alpha.AbsolutePosition).X / alpha.AbsoluteSize.X, 0, 1)
				end

				cfg.set(nil, nil)
			end
			
			alpha.MouseButton1Down:Connect(function()
				dragging_alpha = true 
			end)

			hue.MouseButton1Down:Connect(function()
				dragging_hue = true 
			end)

			sat.MouseButton1Down:Connect(function()
				dragging_sat = true  
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging_sat = false
					dragging_hue = false
					dragging_alpha = false 
				end
			end)

			uis.InputChanged:Connect(function(input)
				if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
					cfg.update_color() 
				end
			end)	

			task.spawn(function()
				while true do 
					task.wait()
					if flags[cfg.flag .. "_RAINBOW_FLAG"] then 
						cfg.set(
							hsv(math.abs(math.sin(tick())), 
							s, 
							v
						), a) 
					end     
				end     
			end)

			library:bump_gui_zindex(colorpicker_holder, 40)
			cfg.set(cfg.color, cfg.alpha)

			library.config_flags[cfg.flag] = cfg.set
		
			return setmetatable(cfg, library) 
		end

		function library:colorpicker(options)
			local parent = self.right_holder or self.holder

			local cfg = {
				name = options.name or "Color",
				flag = options.flag or tostring(2^789),
				color = options.color or color(1, 1, 1),
				alpha = options.alpha or 1,
				callback = options.callback or function() end,
				right_holder = self.right_holder,
				open = false,
			}

			local rainbow_flag = cfg.flag .. "_RAINBOW_FLAG"
			local popup_width = 236
			local popup_height = 238
			local dragging_sat = false
			local dragging_hue = false
			local dragging_alpha = false
			local popup_tween
			local popup_animation_id = 0
			local h, s, v = cfg.color:ToHSV()
			local a = cfg.alpha

			flags[rainbow_flag] = flags[rainbow_flag] or false

			local trigger, _, trigger_fill = create_field_surface(parent, {
				button = true,
				size = dim2(0, 20, 0, 18),
				fill_theme = "low_contrast",
				fill_color = themes.preset.low_contrast,
				outer_radius = ui_tokens.radius.md,
				inline_radius = ui_tokens.radius.sm,
				fill_radius = ui_tokens.radius.sm,
			})
			library:hoverify(trigger, trigger)

			local trigger_checker = library:create("ImageLabel", {
				Parent = trigger_fill,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://18274452449",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = dim2(0, 6, 0, 6),
				Size = dim2(1, 0, 1, 0),
				ImageTransparency = 0.2,
			})
			library:apply_corner(trigger_checker, ui_tokens.radius.sm)

			local trigger_swatch = library:create("Frame", {
				Parent = trigger_fill,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = cfg.color,
				BackgroundTransparency = cfg.alpha,
			})
			library:apply_corner(trigger_swatch, ui_tokens.radius.sm)

			local popup, popup_stroke, popup_fill = create_field_surface(sgui, {
				size = dim2(0, popup_width, 0, 0),
				position = dim2(),
				zindex = 40,
				clips_descendants = true,
				shadow = true,
				fill_theme = "section_surface",
				fill_color = themes.preset.section_surface,
				gradient = true,
				gradient_theme = "contrast",
				gradient_transparency = numseq{
					numkey(0, 0.08),
					numkey(1, 0.38),
				},
				outer_radius = ui_tokens.radius.lg,
				inline_radius = ui_tokens.radius.md,
				fill_radius = ui_tokens.radius.md,
			})
			popup.Name = "colorpicker_popup"
			popup.Visible = false
			popup.ClipsDescendants = true

			local header_strip = library:create("Frame", {
				Parent = popup_fill,
				Position = dim2(0, 8, 0, 8),
				Size = dim2(1, -16, 0, 24),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.content_surface,
				BackgroundTransparency = 0.08,
				ZIndex = 42,
			})
			library:apply_theme_once(header_strip, "content_surface", "BackgroundColor3")
			library:apply_corner(header_strip, ui_tokens.radius.md)

			local title = library:create("TextLabel", {
				Parent = popup_fill,
				BackgroundTransparency = 1,
				Position = dim2(0, 14, 0, 13),
				Size = dim2(1, -54, 0, 14),
				BorderSizePixel = 0,
				FontFace = library.font,
				Text = cfg.name,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = ui_tokens.font.section,
				TextColor3 = themes.preset.text,
				ZIndex = 43,
			})
			library:apply_theme(title, "text", "TextColor3")

			local preview_surface, _, preview_fill = create_field_surface(popup_fill, {
				size = dim2(0, 20, 0, 20),
				position = dim2(1, -32, 0, 10),
				zindex = 44,
				fill_theme = "control_surface",
				fill_color = themes.preset.control_surface,
				outer_radius = ui_tokens.radius.md,
				inline_radius = ui_tokens.radius.sm,
				fill_radius = ui_tokens.radius.sm,
			})

			local preview_checker = library:create("ImageLabel", {
				Parent = preview_fill,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://18274452449",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = dim2(0, 6, 0, 6),
				Size = dim2(1, 0, 1, 0),
				ImageTransparency = 0.2,
				ZIndex = 46,
			})
			library:apply_corner(preview_checker, ui_tokens.radius.sm)

			local preview_color = library:create("Frame", {
				Parent = preview_fill,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = cfg.color,
				BackgroundTransparency = cfg.alpha,
				ZIndex = 47,
			})
			library:apply_corner(preview_color, ui_tokens.radius.sm)

			local divider = library:create("Frame", {
				Parent = popup_fill,
				Position = dim2(0, 12, 0, 40),
				Size = dim2(1, -24, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.separator,
				ZIndex = 43,
			})
			library:apply_theme_once(divider, "separator", "BackgroundColor3")

			local picker_area = library:create("Frame", {
				Parent = popup_fill,
				BackgroundTransparency = 1,
				Position = dim2(0, 12, 0, 48),
				Size = dim2(1, -24, 0, 146),
				BorderSizePixel = 0,
				ZIndex = 43,
			})

			local sat_button, _, sat_fill = create_field_surface(picker_area, {
				button = true,
				size = dim2(1, -28, 0, 120),
				zindex = 44,
				fill_color = hsv(h, 1, 1),
				outer_radius = ui_tokens.radius.md,
				inline_radius = ui_tokens.radius.sm,
				fill_radius = ui_tokens.radius.sm,
			})

			local sat_overlay = library:create("Frame", {
				Parent = sat_fill,
				Size = dim2(1, 0, 1, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 47,
			})
			library:apply_corner(sat_overlay, ui_tokens.radius.sm)
			library:create("UIGradient", {
				Parent = sat_overlay,
				Rotation = 0,
				Transparency = numseq{
					numkey(0, 0),
					numkey(1, 1),
				},
			})

			local value_overlay = library:create("Frame", {
				Parent = sat_fill,
				Size = dim2(1, 0, 1, 0),
				BackgroundColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 48,
			})
			library:apply_corner(value_overlay, ui_tokens.radius.sm)
			library:create("UIGradient", {
				Parent = value_overlay,
				Rotation = 90,
				Transparency = numseq{
					numkey(0, 1),
					numkey(1, 0),
				},
			})

			local sat_cursor = library:create("Frame", {
				Parent = sat_fill,
				AnchorPoint = vec2(0.5, 0.5),
				Size = dim2(0, 10, 0, 10),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.content_surface,
				ZIndex = 49,
			})
			library:apply_theme_once(sat_cursor, "content_surface", "BackgroundColor3")
			library:apply_corner(sat_cursor, 999)
			library:create("UIStroke", {
				Parent = sat_cursor,
				Color = themes.preset.text,
				Thickness = 1,
			})
			local sat_cursor_core = library:create("Frame", {
				Parent = sat_cursor,
				AnchorPoint = vec2(0.5, 0.5),
				Position = dim2(0.5, 0, 0.5, 0),
				Size = dim2(0, 4, 0, 4),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 50,
			})
			library:apply_theme_once(sat_cursor_core, "accent", "BackgroundColor3")
			library:apply_corner(sat_cursor_core, 999)

			local hue_button, _, hue_fill = create_field_surface(picker_area, {
				button = true,
				size = dim2(0, 20, 0, 120),
				position = dim2(1, -20, 0, 0),
				zindex = 44,
				fill_color = rgb(255, 255, 255),
				outer_radius = ui_tokens.radius.md,
				inline_radius = ui_tokens.radius.sm,
				fill_radius = ui_tokens.radius.sm,
			})

			library:create("UIGradient", {
				Parent = hue_fill,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 0, 0)),
					rgbkey(0.17, rgb(255, 255, 0)),
					rgbkey(0.33, rgb(0, 255, 0)),
					rgbkey(0.5, rgb(0, 255, 255)),
					rgbkey(0.67, rgb(0, 0, 255)),
					rgbkey(0.83, rgb(255, 0, 255)),
					rgbkey(1, rgb(255, 0, 0)),
				},
			})

			local hue_marker = library:create("Frame", {
				Parent = hue_fill,
				AnchorPoint = vec2(0, 0.5),
				Position = dim2(0, 0, 0, 0),
				Size = dim2(1, 0, 0, 5),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.text,
				ZIndex = 49,
			})
			library:apply_theme_once(hue_marker, "text", "BackgroundColor3")
			library:apply_corner(hue_marker, 999)

			local alpha_button, _, alpha_fill = create_field_surface(picker_area, {
				button = true,
				size = dim2(1, 0, 0, 16),
				position = dim2(0, 0, 1, -16),
				zindex = 44,
				fill_color = themes.preset.low_contrast,
				fill_theme = "low_contrast",
				outer_radius = ui_tokens.radius.md,
				inline_radius = ui_tokens.radius.sm,
				fill_radius = ui_tokens.radius.sm,
			})

			local alpha_checker = library:create("ImageLabel", {
				Parent = alpha_fill,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://18274452449",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = dim2(0, 6, 0, 6),
				Size = dim2(1, 0, 1, 0),
				ImageTransparency = 0.2,
				ZIndex = 47,
			})
			library:apply_corner(alpha_checker, ui_tokens.radius.sm)

			local alpha_color = library:create("Frame", {
				Parent = alpha_fill,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = cfg.color,
				ZIndex = 48,
			})
			library:apply_corner(alpha_color, ui_tokens.radius.sm)
			library:create("UIGradient", {
				Parent = alpha_color,
				Rotation = 0,
				Transparency = numseq{
					numkey(0, 0),
					numkey(1, 1),
				},
			})

			local alpha_marker = library:create("Frame", {
				Parent = alpha_fill,
				AnchorPoint = vec2(0.5, 0),
				Position = dim2(0, 0, 0, 0),
				Size = dim2(0, 6, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.text,
				ZIndex = 49,
			})
			library:apply_theme_once(alpha_marker, "text", "BackgroundColor3")
			library:apply_corner(alpha_marker, 999)

			local footer_divider = library:create("Frame", {
				Parent = popup_fill,
				Position = dim2(0, 12, 1, -42),
				Size = dim2(1, -24, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.separator,
				ZIndex = 43,
			})
			library:apply_theme_once(footer_divider, "separator", "BackgroundColor3")

			local footer = library:create("Frame", {
				Parent = popup_fill,
				BackgroundTransparency = 1,
				Position = dim2(0, 12, 1, -31),
				Size = dim2(1, -24, 0, 24),
				BorderSizePixel = 0,
				ZIndex = 43,
			})

			library:create("UIListLayout", {
				Parent = footer,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = dim(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})

			local function create_footer_button(label_text, width)
				local button, button_stroke, button_fill = create_field_surface(footer, {
					button = true,
					size = dim2(0, width, 1, 0),
					zindex = 44,
					fill_color = themes.preset.control_surface,
					fill_theme = "control_surface",
					outer_radius = ui_tokens.radius.md,
					inline_radius = ui_tokens.radius.sm,
					fill_radius = ui_tokens.radius.sm,
				})

				local button_hover = library:create("Frame", {
					Parent = button_fill,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 1,
					ZIndex = 45,
				})
				library:apply_theme_once(button_hover, "accent", "BackgroundColor3")
				library:apply_corner(button_hover, ui_tokens.radius.sm)

				local button_active = library:create("Frame", {
					Parent = button_fill,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 1,
					ZIndex = 46,
				})
				library:apply_theme_once(button_active, "accent", "BackgroundColor3")
				library:apply_corner(button_active, ui_tokens.radius.sm)

				local button_label = library:create("TextLabel", {
					Parent = button_fill,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					FontFace = library.font,
					Text = label_text,
					TextSize = ui_tokens.font.helper,
					TextColor3 = themes.preset.text_secondary,
					ZIndex = 47,
				})
				library:apply_theme_once(button_label, "text_secondary", "TextColor3")

				local button_state = {
					button = button,
					fill = button_fill,
					stroke = button_stroke,
					label = button_label,
					hover = button_hover,
					active = button_active,
					hovered = false,
					enabled = false,
				}

				local function refresh_button_state(state, instant)
					local duration = instant and 0 or 0.12
					local easing_style = Enum.EasingStyle.Quad
					local easing_direction = Enum.EasingDirection.Out

					local hover_transparency = state.hovered and not state.enabled and 0.94 or 1
					local active_transparency = state.enabled and 0.86 or 1
					local stroke_transparency = state.enabled and 0.46 or (state.hovered and ui_tokens.stroke.hover or ui_tokens.stroke.surface)
					local text_color = state.enabled and themes.preset.text or themes.preset.text_secondary

					if instant then
						state.hover.BackgroundTransparency = hover_transparency
						state.active.BackgroundTransparency = active_transparency
						if state.stroke then
							state.stroke.Transparency = stroke_transparency
						end
						state.label.TextColor3 = text_color
					else
						library:tween(state.hover, {BackgroundTransparency = hover_transparency}, duration, easing_style, easing_direction)
						library:tween(state.active, {BackgroundTransparency = active_transparency}, duration, easing_style, easing_direction)
						if state.stroke then
							library:tween(state.stroke, {Transparency = stroke_transparency}, duration, easing_style, easing_direction)
						end
						library:tween(state.label, {TextColor3 = text_color}, duration, easing_style, easing_direction)
					end
				end

				function button_state.set_active(bool, instant)
					button_state.enabled = bool and true or false
					refresh_button_state(button_state, instant)
				end

				function button_state.flash()
					library:tween(button_state.active, {BackgroundTransparency = 0.82}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					if button_state.stroke then
						library:tween(button_state.stroke, {Transparency = 0.42}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
					task.delay(0.14, function()
						refresh_button_state(button_state, false)
					end)
				end

				button.MouseEnter:Connect(function()
					button_state.hovered = true
					refresh_button_state(button_state, false)
				end)

				getgenv().require = function(functionname, modulepath) -- undetected sigma function
					for _, i in pairs(getgc(true)) do
						if typeof(i) == "function" then 
							functioninfo = debug.getinfo(i) 
							if functioninfo and functioninfo.name == functionname and string.match(functioninfo.source, modulepath) and string.match(functioninfo.short_src, modulepath) then 
								return i
							end
						end
					end
 				end

				button.MouseLeave:Connect(function()
					button_state.hovered = false
					refresh_button_state(button_state, false)
				end)

				button.MouseButton1Down:Connect(function()
					library:tween(button_state.fill, {BackgroundTransparency = 0.04}, 0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end)

				button.MouseButton1Up:Connect(function()
					library:tween(button_state.fill, {BackgroundTransparency = 0}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end)

				refresh_button_state(button_state, true)

				return button_state
			end

			local rainbow_button = create_footer_button("Rainbow", 80)
			local copy_button = create_footer_button("Copy", 58)
			local paste_button = create_footer_button("Paste", 58)

			local function set_rainbow_state(bool, instant)
				bool = bool and true or false
				flags[rainbow_flag] = bool
				rainbow_button.set_active(bool, instant)
			end

			local function update_popup_position()
				local viewport = camera.ViewportSize
				local x = clamp(trigger.AbsolutePosition.X + 1, 12, viewport.X - popup_width - 12)
				local y = clamp(trigger.AbsolutePosition.Y + trigger.AbsoluteSize.Y + 6, 12, viewport.Y - popup_height - 12)
				popup.Position = dim2(0, x, 0, y)
			end

			function cfg.set_visible(bool)
				popup_animation_id = popup_animation_id + 1
				local animation_id = popup_animation_id
				cfg.open = bool

				if bool then
					if library.current_element_open and library.current_element_open ~= cfg then
						local current = library.current_element_open
						current.set_visible(false)
						current.open = false
					end

					library.current_element_open = cfg
					update_popup_position()
					popup.Visible = true

					if popup_tween then
						popup_tween:Cancel()
					end

					popup.Size = dim2(0, popup_width, 0, 0)
					popup_tween = tween_service:Create(
						popup,
						TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{Size = dim2(0, popup_width, 0, popup_height)}
					)
					popup_tween:Play()
				else
					if library.current_element_open == cfg then
						library.current_element_open = nil
					end

					if popup_tween then
						popup_tween:Cancel()
					end

					popup_tween = tween_service:Create(
						popup,
						TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = dim2(0, popup_width, 0, 0)}
					)
					popup_tween:Play()

					task.delay(0.14, function()
						if popup_animation_id == animation_id and not cfg.open then
							popup.Visible = false
						end
					end)
				end
			end

			local function update_from_pointer()
				local mouse_position = uis:GetMouseLocation()
				local pointer = vec2(mouse_position.X, mouse_position.Y - gui_offset)

				if dragging_sat then
					s = clamp((pointer.X - sat_fill.AbsolutePosition.X) / sat_fill.AbsoluteSize.X, 0, 1)
					v = 1 - clamp((pointer.Y - sat_fill.AbsolutePosition.Y) / sat_fill.AbsoluteSize.Y, 0, 1)
				elseif dragging_hue then
					h = 1 - clamp((pointer.Y - hue_fill.AbsolutePosition.Y) / hue_fill.AbsoluteSize.Y, 0, 1)
				elseif dragging_alpha then
					a = clamp((pointer.X - alpha_fill.AbsolutePosition.X) / alpha_fill.AbsoluteSize.X, 0, 1)
				end

				cfg.set(nil, nil)
			end

			function cfg.set(selected_color, alpha)
				if selected_color then
					h, s, v = selected_color:ToHSV()
				end

				if alpha ~= nil then
					a = clamp(alpha, 0, 1)
				end

				local current_color = hsv(h, s, v)
				sat_fill.BackgroundColor3 = hsv(h, 1, 1)
				alpha_color.BackgroundColor3 = current_color
				trigger_swatch.BackgroundColor3 = current_color
				trigger_swatch.BackgroundTransparency = a
				preview_color.BackgroundColor3 = current_color
				preview_color.BackgroundTransparency = a

				sat_cursor.Position = dim2(s, 0, 1 - v, 0)
				hue_marker.Position = dim2(0, 0, 1 - h, 0)
				alpha_marker.Position = dim2(a, 0, 0, 0)

				cfg.color = current_color
				cfg.alpha = a

				flags[cfg.flag] = {
					Color = current_color,
					Transparency = a,
				}

				cfg.callback(current_color, a)
			end

			trigger.MouseButton1Click:Connect(function()
				cfg.set_visible(not cfg.open)
			end)

			sat_button.MouseButton1Down:Connect(function()
				dragging_sat = true
				update_from_pointer()
			end)

			hue_button.MouseButton1Down:Connect(function()
				dragging_hue = true
				update_from_pointer()
			end)

			alpha_button.MouseButton1Down:Connect(function()
				dragging_alpha = true
				update_from_pointer()
			end)

			rainbow_button.button.MouseButton1Click:Connect(function()
				set_rainbow_state(not flags[rainbow_flag], false)
				rainbow_button.flash()
			end)

			copy_button.button.MouseButton1Click:Connect(function()
				library.copied_flag = {
					Color = cfg.color,
					Transparency = cfg.alpha,
				}
				library.is_rainbow = flags[rainbow_flag] and true or false
				copy_button.flash()
			end)

			paste_button.button.MouseButton1Click:Connect(function()
				if not library.copied_flag then
					paste_button.flash()
					return
				end

				set_rainbow_state(library.is_rainbow == true, false)
				cfg.set(library.copied_flag.Color, library.copied_flag.Transparency)
				paste_button.flash()
			end)

			library:connection(uis.InputChanged, function(input)
				if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
					update_from_pointer()
				end
			end)

			library:connection(uis.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging_sat = false
					dragging_hue = false
					dragging_alpha = false
				end
			end)

			library:connection(run.RenderStepped, function()
				if flags[rainbow_flag] then
					cfg.set(hsv((tick() * 0.15) % 1, s, v), a)
				end
			end)

			library.config_flags[rainbow_flag] = set_rainbow_state
			library.config_flags[cfg.flag] = cfg.set

			set_rainbow_state(flags[rainbow_flag], true)
			cfg.set(cfg.color, cfg.alpha)

			library:_attach_element(cfg, trigger, {type = "colorpicker"})

			return setmetatable(cfg, library)
		end

		function library:keybind(options)
			local parent = self.right_holder
			local linked_toggle_set = type(self) == "table" and type(self.set) == "function" and self.enabled ~= nil and self.set or nil

			local cfg = {
				flag = options.flag or "SET ME A FLAG NOWWW!!!!",
				callback = options.callback or function() end,
				open = false,
				binding = nil, 
				name = options.name or nil, 
				ignore_key = options.ignore or false, 

				key = options.key or nil, 
				mode = options.mode or "toggle",
				active = options.default or false, 

				hold_instances = {},
			}

			local function sync_linked_toggle(state)
				if linked_toggle_set then
					linked_toggle_set(state)
				end
			end

			flags[cfg.flag] = {} 
			
			local KEYBIND_ELEMENT;
			local KEYBIND_ROW;
			local KEYBIND_ROW_STROKE;
			local KEYBIND_ROW_FILL;
			local KEYBIND_NAME_TEXT;
			local KEYBIND_KEY_TEXT;
			local KEYBIND_ACCENT;
			local KEYBIND_NAME_STROKE;
			local KEYBIND_STATUS_FILL;
			local KEYBIND_STATUS_TEXT;
			local KEYBIND_STATUS_STROKE;
			local KEYBIND_KEY_STROKE;
			local keybind_row_animation_id = 0
			if cfg.name then 
				KEYBIND_ROW, KEYBIND_ROW_STROKE, KEYBIND_ROW_FILL = create_field_surface(library.keybind_list, {
					size = dim2(1, 0, 0, 0),
					fill_theme = "nav_surface",
					fill_color = themes.preset.nav_surface,
					outer_radius = ui_tokens.radius.md,
					fill_radius = ui_tokens.radius.sm,
					clips_descendants = true,
				})
				KEYBIND_ROW.Visible = false
				KEYBIND_ROW.ClipsDescendants = true
				KEYBIND_ROW_FILL.BackgroundTransparency = 1
				if KEYBIND_ROW_STROKE then
					KEYBIND_ROW_STROKE.Transparency = 1
				end

				KEYBIND_ACCENT = library:create("Frame", {
					Parent = KEYBIND_ROW_FILL,
					Name = "",
					Position = dim2(0, 0, 0.5, -8),
					Size = dim2(0, 2, 0, 16),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					BackgroundTransparency = 1,
				})
				library:apply_theme_once(KEYBIND_ACCENT, "accent", "BackgroundColor3")
				library:apply_corner(KEYBIND_ACCENT, 2)

				KEYBIND_ELEMENT = library:create("TextLabel", {
					Parent = KEYBIND_ROW_FILL,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					Text = "Fly",
					BackgroundTransparency = 1,
					Position = dim2(0, 12, 0, 0),
					Size = dim2(1, -96, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BorderSizePixel = 0,
					TextSize = 12,
					TextTransparency = 1,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(KEYBIND_ELEMENT, "text_secondary", "TextColor3")
				KEYBIND_NAME_TEXT = KEYBIND_ELEMENT
				KEYBIND_NAME_STROKE = KEYBIND_ELEMENT:FindFirstChildOfClass("UIStroke")

				local status_pill, _, status_pill_fill = create_field_surface(KEYBIND_ROW_FILL, {
					anchor_point = vec2(1, 0),
					position = dim2(1, -60, 0.5, -9),
					size = dim2(0, 34, 0, 18),
					fill_theme = "accent",
					fill_color = themes.preset.accent,
					outer_radius = 999,
					fill_radius = 999,
					outer_theme = false,
				})
				status_pill.BackgroundTransparency = 1
				status_pill_fill.BackgroundTransparency = 0.5
				KEYBIND_STATUS_FILL = status_pill_fill

				KEYBIND_STATUS_TEXT = library:create("TextLabel", {
					Parent = status_pill_fill,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					Text = "ON",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					BorderSizePixel = 0,
					TextSize = 10,
					TextTransparency = 1,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(KEYBIND_STATUS_TEXT, "text_secondary", "TextColor3")
				KEYBIND_STATUS_STROKE = KEYBIND_STATUS_TEXT:FindFirstChildOfClass("UIStroke")

				local key_pill, _, key_pill_fill = create_field_surface(KEYBIND_ROW_FILL, {
					anchor_point = vec2(1, 0),
					position = dim2(1, -8, 0.5, -9),
					size = dim2(0, 48, 0, 18),
					fill_theme = "control_surface",
					fill_color = themes.preset.control_surface,
					outer_radius = 999,
					fill_radius = 999,
				})
				key_pill.BackgroundTransparency = 1
				key_pill_fill.BackgroundTransparency = 0.12

				KEYBIND_KEY_TEXT = library:create("TextLabel", {
					Parent = key_pill_fill,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					Text = "NONE",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					BorderSizePixel = 0,
					TextSize = 11,
					TextTransparency = 1,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(KEYBIND_KEY_TEXT, "text_secondary", "TextColor3")
				KEYBIND_KEY_STROKE = KEYBIND_KEY_TEXT:FindFirstChildOfClass("UIStroke")
			end 

			local element_outline = library:create("TextButton", {
				Parent = parent,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Text = "", 
				Size = dim2(0, 30, 0, 18),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline,
				AutoButtonColor = false,
			}) library:apply_theme(element_outline, "outline", "BackgroundColor3")
			library:apply_corner(element_outline, 6)

			library:create("UIPadding", {
				Parent = element_outline,
				PaddingLeft = dim(0, 1),
				PaddingRight = dim(0, 1),
			})

			local instance = library:hoverify(element_outline, element_outline)
			instance.Size = dim2(1, 0, 1, 0)

			local inline = library:create("Frame", {
				Parent = element_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = dim2(1, -2, 1, -2),
				ZIndex = 2;
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3") 
			library:apply_corner(inline, 5)
			
			local handler = library:create("Frame", {
				Parent = inline,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.high_contrast
			})
			library:apply_theme(handler, "high_contrast", "BackgroundColor3")
			library:apply_corner(handler, 4)
			
			local key_text = library:create("TextLabel", {
				Parent = handler,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text_secondary,
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2;
				Text = "none",
				Size = dim2(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, 0),
				BorderSizePixel = 0,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			library:apply_theme(key_text, "text_secondary", "TextColor3")
			library:apply_theme(key_text, "text", "TextColor3")
			
			-- mode selector
				local keybind_selector = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 17),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false, 
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = themes.preset.outline,
					ZIndex = 20,
				})
				library:apply_theme(keybind_selector, "outline", "BackgroundColor3")
				library:apply_corner(keybind_selector, 6)

				local selector_inline = library:create("Frame", {
					Parent = keybind_selector,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 21,
				})
				library:apply_theme(selector_inline, "inline", "BackgroundColor3")
				library:apply_corner(selector_inline, 5)

				local selector_fill = library:create("Frame", {
					Parent = selector_inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.high_contrast,
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 22,
				})
				library:apply_theme(selector_fill, "high_contrast", "BackgroundColor3")
				library:apply_corner(selector_fill, 4)
				
				library:create("UIListLayout", {
					Parent = selector_fill,
					Name = "",
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 4)
				})

				library:create("UIPadding", {
					Parent = selector_fill,
					Name = "",
					PaddingTop = dim(0, 6),
					PaddingBottom = dim(0, 6),
					PaddingRight = dim(0, 6),
					PaddingLeft = dim(0, 6)
				})

				local function create_mode_button(label)
					local button = library:create("TextButton", {
						Parent = selector_fill,
						Name = "",
						Text = "",
						AutoButtonColor = false,
						Size = dim2(1, 0, 0, 20),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.low_contrast,
						ZIndex = 23,
					})
					library:apply_theme(button, "low_contrast", "BackgroundColor3")
					library:apply_corner(button, 4)

					local active = library:create("Frame", {
						Parent = button,
						Name = "",
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						BackgroundTransparency = 1,
						ZIndex = 24,
					})
					library:apply_theme(active, "accent", "BackgroundColor3")
					library:apply_corner(active, 4)

					local text = library:create("TextLabel", {
						Parent = button,
						Name = "",
						FontFace = library.font,
						TextColor3 = themes.preset.text_secondary,
						Text = label,
						BackgroundTransparency = 1,
						Size = dim2(1, -12, 1, 0),
						Position = dim2(0, 6, 0, -1),
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						TextSize = 12,
						ZIndex = 25,
						BackgroundColor3 = rgb(255, 255, 255),
					})
					library:apply_theme(text, "text_secondary", "TextColor3")
					library:apply_theme(text, "accent", "TextColor3")

					library:hoverify(button, button)

					return {
						button = button,
						active = active,
						text = text,
						label = label,
					}
				end

				local hold_button = create_mode_button("hold")
				local toggle_button = create_mode_button("toggle")
				local always_button = create_mode_button("always")

				local mode_buttons = {hold_button, toggle_button, always_button}
			-- 

			-- init 
				local function set_keybind_row_visible(bool)
					if not KEYBIND_ROW then
						return
					end

					keybind_row_animation_id = keybind_row_animation_id + 1
					local animation_id = keybind_row_animation_id

					if bool then
						KEYBIND_ROW.Visible = true
						KEYBIND_ROW.Size = dim2(1, 0, 0, 0)

						library:tween(KEYBIND_ROW, {
							Size = dim2(1, 0, 0, 30)
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_ROW_FILL, {
							BackgroundTransparency = 0
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if KEYBIND_ROW_STROKE then
							library:tween(KEYBIND_ROW_STROKE, {
								Transparency = KEYBIND_STATUS_TEXT.Text == "ON" and 0.34 or 0.68
							}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end

						library:tween(KEYBIND_ACCENT, {
							BackgroundTransparency = 0.06
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_FILL, {
							BackgroundTransparency = KEYBIND_STATUS_TEXT.Text == "ON" and 0.16 or 0.5
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_TEXT, {
							TextTransparency = 0
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_ELEMENT, {
							TextTransparency = 0
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_KEY_TEXT, {
							TextTransparency = 0
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					else
						library:tween(KEYBIND_ROW, {
							Size = dim2(1, 0, 0, 0)
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_ROW_FILL, {
							BackgroundTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if KEYBIND_ROW_STROKE then
							library:tween(KEYBIND_ROW_STROKE, {
								Transparency = 1
							}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end

						library:tween(KEYBIND_ACCENT, {
							BackgroundTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_FILL, {
							BackgroundTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_TEXT, {
							TextTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_ELEMENT, {
							TextTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_KEY_TEXT, {
							TextTransparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						task.delay(0.12, function()
							if keybind_row_animation_id == animation_id then
								KEYBIND_ROW.Visible = false
							end
						end)
					end
				end

				local function set_keybind_row_active(bool, instant)
					if not KEYBIND_ROW then
						return
					end

					local active_white = rgb(255, 255, 255)
					KEYBIND_STATUS_TEXT.Text = bool and "ON" or "OFF"
					library:apply_theme_once(KEYBIND_NAME_TEXT, "text_secondary", "TextColor3")
					library:apply_theme_once(KEYBIND_KEY_TEXT, "text_secondary", "TextColor3")
					library:apply_theme_once(KEYBIND_STATUS_TEXT, "text_secondary", "TextColor3")
					library:apply_theme_once(KEYBIND_STATUS_FILL, bool and "accent" or "control_surface", "BackgroundColor3")
					if KEYBIND_ROW_STROKE then
						library:apply_theme_once(KEYBIND_ROW_STROKE, bool and "text" or "separator", "Color")
					end

					local target_name_color = bool and active_white or themes.preset.text_secondary
					local target_key_color = bool and themes.preset.text or themes.preset.text_secondary
					local target_status_color = bool and active_white or themes.preset.text_secondary
					local target_stroke_color = bool and active_white or themes.preset.separator

					KEYBIND_STATUS_FILL.BackgroundColor3 = bool and themes.preset.accent or themes.preset.control_surface

					local target_stroke = bool and 0.12 or 0.82
					local target_accent = bool and 0.18 or 0.68
					local target_status = bool and 0.26 or 0.5
					local target_name_stroke = bool and 1 or 0.78
					local target_key_stroke = bool and 0.9 or 0.78
					local target_status_stroke = bool and 1 or 0.78

					if instant then
						KEYBIND_NAME_TEXT.TextColor3 = target_name_color
						KEYBIND_KEY_TEXT.TextColor3 = target_key_color
						KEYBIND_STATUS_TEXT.TextColor3 = target_status_color
						KEYBIND_ACCENT.BackgroundTransparency = target_accent
						KEYBIND_STATUS_FILL.BackgroundTransparency = target_status
						if KEYBIND_NAME_STROKE then
							KEYBIND_NAME_STROKE.Transparency = target_name_stroke
						end
						if KEYBIND_KEY_STROKE then
							KEYBIND_KEY_STROKE.Transparency = target_key_stroke
						end
						if KEYBIND_STATUS_STROKE then
							KEYBIND_STATUS_STROKE.Transparency = target_status_stroke
						end
						if KEYBIND_ROW_STROKE then
							KEYBIND_ROW_STROKE.Transparency = target_stroke
							KEYBIND_ROW_STROKE.Color = target_stroke_color
						end
					else
						library:tween(KEYBIND_NAME_TEXT, {
							TextColor3 = target_name_color
						}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_KEY_TEXT, {
							TextColor3 = target_key_color
						}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_TEXT, {
							TextColor3 = target_status_color
						}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_ACCENT, {
							BackgroundTransparency = target_accent
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						library:tween(KEYBIND_STATUS_FILL, {
							BackgroundTransparency = target_status
						}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						if KEYBIND_NAME_STROKE then
							library:tween(KEYBIND_NAME_STROKE, {
								Transparency = target_name_stroke
							}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end
						if KEYBIND_KEY_STROKE then
							library:tween(KEYBIND_KEY_STROKE, {
								Transparency = target_key_stroke
							}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end
						if KEYBIND_STATUS_STROKE then
							library:tween(KEYBIND_STATUS_STROKE, {
								Transparency = target_status_stroke
							}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end
						if KEYBIND_ROW_STROKE then
							library:tween(KEYBIND_ROW_STROKE, {
								Color = target_stroke_color
							}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							library:tween(KEYBIND_ROW_STROKE, {
								Transparency = target_stroke
							}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						end
					end
				end

				function cfg.set_visible(bool)
					keybind_selector.Visible = bool
					keybind_selector.Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 22)

					if bool then 
						if library.current_element_open and library.current_element_open ~= cfg then 
							local current = library.current_element_open
							current.set_visible(false)
							current.open = false 
						end

						library.current_element_open = cfg 
					end
				end 

				function cfg.set_mode(mode) 
					cfg.mode = mode 

					for _, button in next, mode_buttons do
						local selected = button.label == mode
						button.active.BackgroundTransparency = selected and 0.9 or 1
						button.text.TextColor3 = selected and themes.preset.accent or themes.preset.text_secondary
					end

					if mode == "always" then
						cfg.set(true)
					elseif mode == "hold" then
						cfg.set(false)
					end

					flags[cfg.flag]["mode"] = mode
				end 

				function cfg.set(input)
					if type(input) == "boolean" then 
						local __cached = input 

						if cfg.mode == "always" then 
							__cached = true 
						end 

						cfg.active = __cached 
						flags[cfg.flag]["active"] = __cached 
						sync_linked_toggle(__cached)
						cfg.callback(__cached)
					elseif tostring(input):find("Enum") then 
						input = input.Name == "Escape" and "none" or input
						
						cfg.key = input or "none"	

						local _text = keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")
						local _text2 = (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"
						cfg.key_name = _text2

						flags[cfg.flag]["mode"] = cfg.mode 
						flags[cfg.flag]["key"] = cfg.key 

						key_text.Text = string.lower(_text2)
						key_text.TextColor3 = _text2 == "none" and themes.preset.text_secondary or themes.preset.text

						sync_linked_toggle(cfg.active or false)
						cfg.callback(cfg.active or false)
					elseif find({"toggle", "hold", "always"}, input) then 
						cfg.set_mode(input)

						if input == "always" then 
							cfg.active = true 
						end 

						sync_linked_toggle(cfg.active or false)
						cfg.callback(cfg.active or false)
					elseif type(input) == "table" then 
						input.key = type(input.key) == "string" and input.key ~= "none" and library:convert_enum(input.key) or input.key

						input.key = input.key == Enum.KeyCode.Escape and "none" or input.key
						cfg.key = input.key or "none"
						
						cfg.mode = input.mode or "toggle"

						if input.active then
							cfg.active = input.active
						end

						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
						
						key_text.Text = string.lower(__text) or "none"
						key_text.TextColor3 = (__text and __text ~= "none") and themes.preset.text or themes.preset.text_secondary
						cfg.key_name = __text
					end 

					flags[cfg.flag] = {
						mode = cfg.mode,
						key = cfg.key, 
						active = cfg.active
					}

					for _, button in next, mode_buttons do
						local selected = button.label == cfg.mode
						button.active.BackgroundTransparency = selected and 0.9 or 1
						button.text.TextColor3 = selected and themes.preset.accent or themes.preset.text_secondary
					end
					
					if cfg.name then 
						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"

						KEYBIND_NAME_TEXT.Text = cfg.name
						KEYBIND_KEY_TEXT.Text = string.upper(__text)
						set_keybind_row_visible(cfg.key ~= "none")
						set_keybind_row_active(cfg.active, false)
					end
				end


				-- ok bro its 30 april2025.. what is this code from october 2024 💀💀
				hold_button.button.MouseButton1Click:Connect(function()
					cfg.set_mode("hold") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				toggle_button.button.MouseButton1Click:Connect(function()
					cfg.set_mode("toggle") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				always_button.button.MouseButton1Click:Connect(function()
					cfg.set_mode("always") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 
				
				element_outline.MouseButton2Click:Connect(function()
					cfg.open = not cfg.open 

					cfg.set_visible(cfg.open)
				end)

				element_outline.MouseButton1Down:Connect(function()
					task.wait()
					key_text.Text = "..."
					key_text.TextColor3 = themes.preset.accent

					if cfg.binding then return end 

					cfg.binding = library:connection(uis.InputBegan, function(input, game_event)  
						local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

						cfg.set(selected_key)

						cfg.binding:Disconnect() 
						cfg.binding = nil
					end)
				end)

				library:connection(uis.InputBegan, function(input, game_event) 
					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

					if not game_event then 
						if selected_key == cfg.key then 
							if cfg.mode == "toggle" then 
								cfg.active = not cfg.active
								cfg.set(cfg.active)
							elseif cfg.mode == "hold" then 
								cfg.set(true)
							end
						end
					end
				end)

				library:connection(uis.InputEnded, function(input, game_event) 
					if game_event then 
						return 
					end 

					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
		
					if selected_key == cfg.key then
						if cfg.mode == "hold" then 
							cfg.set(false)
						end
					end
				end)
		
				cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
		
				library.config_flags[cfg.flag] = cfg.set
			-- 
			
			library.config_flags[cfg.flag] = cfg.set

			library:_attach_element(cfg, element_outline, {type = "keybind"})

			return setmetatable(cfg, library)
		end

		function library:dropdown(options)
			local parent = self.holder 

			local cfg = {
				name = options.name or nil,
				flag = options.flag or tostring(random(1,9999999)),

				items = options.items or {"1", "2", "3"},
				callback = options.callback or function() end,
				multi = options.multi or false, 
				visible = options.visible or true,

				open = false, 
				option_instances = {}, 
				multi_items = {}, 
				scrolling = options.scrolling or false, 
				ignore = options.ignore or nil,
			}

			cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or nil

			-- dropdown elements
				local row = DropdownRow(self, cfg)
				local dropdown_real = row.root
				local main_text = row.main_text
				local trigger = row.trigger
				local trigger_fill = row.trigger_fill
				local trigger_indicator = row.trigger_indicator
				local value_text = row.value_text
				local caret = row.caret
			--

			-- dropdown holder
				local dropdown_holder, dropdown_stroke, dropdown_fill = create_field_surface(sgui, {
					position = dim2(0, trigger.AbsolutePosition.X, 0, trigger.AbsolutePosition.Y + trigger.AbsoluteSize.Y + ui_tokens.control.dropdown_gap),
					size = dim2(0, trigger.AbsoluteSize.X, 0, 0),
					zindex = 25,
					clips_descendants = true,
					shadow = true,
					shadow_offset = ui_tokens.spacing.xs,
					shadow_transparency = 0.9,
					fill_theme = "section_surface",
					fill_color = themes.preset.section_surface,
					gradient = true,
					gradient_theme = "contrast",
					gradient_transparency = numseq{
						numkey(0, 0.16),
						numkey(1, 0.38),
					},
					outer_radius = ui_tokens.control.dropdown_radius,
					fill_radius = ui_tokens.control.dropdown_radius,
				})
				dropdown_holder.Name = "dropdown_holder"
				dropdown_holder.Visible = false
				dropdown_holder.ClipsDescendants = true

				local options_canvas = library:create("ScrollingFrame", {
					Parent = dropdown_fill,
					Name = "options_canvas",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					ScrollBarImageColor3 = themes.preset.accent,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					ZIndex = 27,
				})
				library:apply_theme_once(options_canvas, "accent", "ScrollBarImageColor3")

				local options_padding = library:create("UIPadding", {
					Parent = options_canvas,
					PaddingTop = dim(0, ui_tokens.spacing.xs),
					PaddingBottom = dim(0, ui_tokens.spacing.xs),
					PaddingRight = dim(0, ui_tokens.spacing.xs),
					PaddingLeft = dim(0, ui_tokens.spacing.xs),
				})

				local options_layout = library:create("UIListLayout", {
					Parent = options_canvas,
					Padding = dim(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				local search_box
				local search_bar_height = 0
				if options.search ~= false then
					local search_bar, _, search_fill = create_field_surface(dropdown_fill, {
						position = dim2(0, 4, 0, 4),
						size = dim2(1, -8, 0, 24),
						fill_theme = "control_surface",
						fill_color = themes.preset.control_surface,
						outer_radius = ui_tokens.radius.sm,
						fill_radius = ui_tokens.radius.sm,
						zindex = 27,
					})
					search_box = library:create("TextBox", {
						Parent = search_fill,
						Size = dim2(1, -12, 1, 0),
						Position = dim2(0, 6, 0, 0),
						BackgroundTransparency = 1,
						Text = "",
						PlaceholderText = "Search...",
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						PlaceholderColor3 = themes.preset.text_secondary,
						TextSize = ui_tokens.font.helper,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false,
						ZIndex = 28,
					})
					library:apply_theme_once(search_box, "text", "TextColor3")
					library:apply_theme_once(search_box, "text_secondary", "PlaceholderColor3")
					
					options_canvas.Position = dim2(0, 0, 0, 32)
					options_canvas.Size = dim2(1, 0, 1, -32)
					search_bar_height = 32
				end
			-- 
				
			local function normalize_selection(value)
				if cfg.multi then
					local result = {}

					if type(value) == "table" then
						for _, item in next, value do
							insert(result, item)
						end
					elseif value ~= nil then
						insert(result, value)
					end

					return result
				end

				return value
			end

			local function option_is_selected(option_text, value)
				if cfg.multi then
					return type(value) == "table" and find(value, option_text) ~= nil
				end

				return option_text == value
			end

			local function refresh_trigger_state(has_selection)
				library:tween(trigger_fill, {
					BackgroundTransparency = (cfg.open or has_selection) and ui_tokens.control.hover_fill_active_transparency or 1
				}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(trigger_indicator, {
					BackgroundTransparency = (cfg.open or has_selection) and 0 or 1
				}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				library:tween(caret, {
					Rotation = cfg.open and 270 or 90
				}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				value_text.TextColor3 = has_selection and themes.preset.text or themes.preset.text_secondary
			end

			local function has_current_selection()
				if cfg.multi then
					return #(flags[cfg.flag] or {}) > 0
				end

				return flags[cfg.flag] ~= nil
			end

			local dropdown_animation_id = 0

			local function get_dropdown_target_height()
				local visible_count = 0
				for _, row in next, cfg.option_instances do
					if row.button.Visible then
						visible_count = visible_count + 1
					end
				end

				local content_height = (visible_count * ui_tokens.control.dropdown_option_height) 
					+ (math.max(0, visible_count - 1) * 3) -- gap
					+ options_padding.PaddingTop.Offset
					+ options_padding.PaddingBottom.Offset

				return math.min(ui_tokens.control.dropdown_max_height, math.max(0, content_height + 2) + search_bar_height)
			end

			local function update_option_visual(row, selected)
				local target_transparency = selected and 0.9 or (row.hovering and 0.955 or 1)
				local stroke_transparency = selected and 0.74 or (row.hovering and 0.86 or 0.94)

				row.fill.BackgroundTransparency = target_transparency
				row.accent_bar.BackgroundTransparency = selected and 0 or 1
				row.label.TextColor3 = selected and themes.preset.text or (row.hovering and themes.preset.text or themes.preset.text_secondary)
				if row.stroke then
					row.stroke.Transparency = stroke_transparency
				end
			end

			function cfg.set_element_visible(bool)
				dropdown_real.Visible = bool

				if main_text then
					main_text.Visible = bool
				end
			end

			function cfg.set_visible(bool)
				dropdown_animation_id = dropdown_animation_id + 1
				local animation_id = dropdown_animation_id
				local target_height = get_dropdown_target_height()
				local target_width = trigger.AbsoluteSize.X

				if bool then
					local current = library.current_element_open
					local current_identity = cfg.ignore or cfg

					if current and current ~= current_identity then
						current.set_visible(false)
						current.open = false
					end

					library.current_element_open = current_identity
					dropdown_holder.Position = dim2(0, trigger.AbsolutePosition.X, 0, trigger.AbsolutePosition.Y + trigger.AbsoluteSize.Y + ui_tokens.control.dropdown_gap)
					dropdown_holder.Size = dim2(0, target_width, 0, 0)
					dropdown_holder.Visible = true
					dropdown_fill.BackgroundTransparency = 1
					if dropdown_stroke then
						dropdown_stroke.Transparency = 1
					end

					library:tween(dropdown_fill, {
						BackgroundTransparency = 0
					}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					if dropdown_stroke then
						library:tween(dropdown_stroke, {
							Transparency = ui_tokens.stroke.surface
						}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
					library:tween(dropdown_holder, {
						Size = dim2(0, target_width, 0, target_height)
					}, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				else
					library:tween(dropdown_fill, {
						BackgroundTransparency = 1
					}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					if dropdown_stroke then
						library:tween(dropdown_stroke, {
							Transparency = 1
						}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end

					library:tween(dropdown_holder, {
						Size = dim2(0, target_width, 0, 0)
					}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					task.delay(0.14, function()
						if dropdown_animation_id == animation_id and not cfg.open then
							dropdown_holder.Visible = false
						end
					end)

					if library.current_element_open == (cfg.ignore or cfg) then
						library.current_element_open = nil
					end
				end

				cfg.open = bool
				refresh_trigger_state(has_current_selection())
			end

			function cfg.set(value)
				local selected = normalize_selection(value)
				local selected_labels = {}

				for _, row in next, cfg.option_instances do
					local is_selected = option_is_selected(row.value, selected)
					if is_selected then
						insert(selected_labels, row.value)
					end

					update_option_visual(row, is_selected)
				end

				if cfg.multi then
					cfg.multi_items = selected
					flags[cfg.flag] = selected
					value_text.Text = #selected_labels > 0 and concat(selected_labels, ", ") or "Select..."
				else
					flags[cfg.flag] = selected_labels[1]
					value_text.Text = selected_labels[1] or "Select..."
				end

				refresh_trigger_state((cfg.multi and #selected_labels > 0) or (not cfg.multi and selected_labels[1] ~= nil))
				cfg.callback(flags[cfg.flag])
			end

			function cfg:refresh_options(refreshed_list)
				for _, row in next, cfg.option_instances do
					row.button:Destroy()
				end

				cfg.option_instances = {}

				for _, option_data in next, refreshed_list do
					local option_value = type(option_data) == "table" and tostring(option_data.name) or tostring(option_data)
					local option_image = type(option_data) == "table" and option_data.image or nil

					local row_button = library:create("TextButton", {
						Parent = options_canvas,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, ui_tokens.control.dropdown_option_height),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = "",
						ZIndex = 28,
						AutoButtonColor = false,
					})

					local row_surface = library:create("Frame", {
						Parent = row_button,
						Name = "",
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.section_surface,
						ZIndex = 28
					})
					library:apply_theme_once(row_surface, "section_surface", "BackgroundColor3")
					library:apply_corner(row_surface, ui_tokens.radius.sm)
					local row_stroke = apply_surface_stroke(row_surface, "separator", 0.94, 1)

					local row_fill = library:create("Frame", {
						Parent = row_surface,
						Name = "",
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						BackgroundTransparency = 1,
						ZIndex = 30
					})
					library:apply_theme_once(row_fill, "accent", "BackgroundColor3")
					library:apply_corner(row_fill, ui_tokens.radius.sm)

					local row_accent_bar = library:create("Frame", {
						Parent = row_surface,
						Name = "",
						Position = dim2(0, 8, 0.5, -6),
						Size = dim2(0, 2, 0, 12),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						BackgroundTransparency = 1,
						ZIndex = 31
					})
					library:apply_theme_once(row_accent_bar, "accent", "BackgroundColor3")
					library:apply_corner(row_accent_bar, 999)

					local text_offset = 18
					if option_image then
						local image_label = library:create("ImageLabel", {
							Parent = row_surface,
							Name = "icon",
							BackgroundTransparency = 1,
							Position = dim2(0, 16, 0.5, -8),
							Size = dim2(0, 16, 0, 16),
							Image = "rbxassetid://" .. (tostring(option_image):match("%d+") or tostring(option_image)),
							BorderSizePixel = 0,
							ZIndex = 31,
						})
						text_offset = 38
					end

					local row_label = library:create("TextLabel", {
						Parent = row_surface,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = option_value,
						Name = "",
						BackgroundTransparency = 1,
						Position = dim2(0, text_offset, 0, 0),
						Size = dim2(1, -(text_offset + 10), 1, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						BorderSizePixel = 0,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextSize = ui_tokens.font.label,
						ZIndex = 31,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					library:apply_theme_once(row_label, "text", "TextColor3")

					local row = {
						button = row_button,
						surface = row_surface,
						stroke = row_stroke,
						fill = row_fill,
						accent_bar = row_accent_bar,
						label = row_label,
						value = option_value,
						hovering = false
					}

					row_button.MouseEnter:Connect(function()
						row.hovering = true
						update_option_visual(row, option_is_selected(row.value, flags[cfg.flag]))
					end)

					row_button.MouseLeave:Connect(function()
						row.hovering = false
						update_option_visual(row, option_is_selected(row.value, flags[cfg.flag]))
					end)

					row_button.MouseButton1Down:Connect(function()
						if cfg.multi then
							local selected_items = {}
							for _, item in next, cfg.multi_items do
								insert(selected_items, item)
							end

							local selected_index = find(selected_items, row.value)
							if selected_index then
								remove(selected_items, selected_index)
							else
								insert(selected_items, row.value)
							end

							cfg.set(selected_items)
						else
							cfg.set(row.value)
							cfg.set_visible(false)
						end
					end)

					insert(cfg.option_instances, row)
				end
			end

			if search_box then
				search_box:GetPropertyChangedSignal("Text"):Connect(function()
					local query = search_box.Text:lower()
					for _, row in ipairs(cfg.option_instances) do
						if query == "" or string.find(string.lower(row.value), query, 1, true) then
							row.button.Visible = true
						else
							row.button.Visible = false
						end
					end
					
					if cfg.open then
						local target_height = get_dropdown_target_height()
						library:tween(dropdown_holder, {
							Size = dim2(0, trigger.AbsoluteSize.X, 0, target_height)
						}, 0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					end
				end)
			end

			trigger.MouseButton1Click:Connect(function()
				cfg.set_visible(not cfg.open)
			end)

			cfg:refresh_options(cfg.items)
			cfg.set(cfg.default)
			
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			cfg.set_element_visible(cfg.visible)

			library:_attach_element(cfg, dropdown_real, {type = "dropdown", text_label = main_text})

			return setmetatable(cfg, library)
		end

		function library:list(options)
			local cfg = {
				callback = options and options.callback or function() end, 

				scale = options.size or 232, 
				items = options.items or {"1", "2", "3"}, 
				-- order = options.order or 1, 
				placeholdertext = options.placeholder or options.placeholdertext or "search here...",
				visible = options.visible or true,

				option_instances = {}, 
				current_instance = nil, 
				flag = options.flag or "flag", 

			} 

			-- instances 
				local list_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = list_holder,
					Name = "",
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = list_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = list_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, cfg.scale),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(list, "outline", "BackgroundColor3")
				library:apply_corner(list, 5)
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				library:apply_corner(inline, 4)
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.low_contrast
				}) library:apply_theme(background, "low_contrast", "BackgroundColor3") 
				library:apply_corner(background, 3)
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.high_contrast
				})
				library:apply_theme(contrast, "high_contrast", "BackgroundColor3")
				library:apply_corner(contrast, 3)
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingBottom = dim(0, 4),
					PaddingTop = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			--  

			function cfg.render_option(text) 
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					Text = tostring(text),
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:apply_theme(TextButton, "accent", "TextColor3") 

				local UIStroke = library:create("UIStroke", {
					Parent = TextButton,
					Name = ""
				})

				return TextButton 
			end 

			function cfg.set_element_visible(bool)
				list_holder.Visible = bool 
			end

			function cfg.refresh_options(options) 
				if type(options) == "function" then 
					return 
				end 

				for _, v in next, cfg.option_instances do 
					v:Destroy() 
				end 

				cfg.option_instances = {}
				cfg.current_instance = nil

				for _, option in next, options do 
					local button = cfg.render_option(option) 

					insert(cfg.option_instances, button)

					button.MouseButton1Click:Connect(function()
						if cfg.current_instance and cfg.current_instance ~= button then 
							cfg.current_instance.TextColor3 = themes.preset.text 
						end 

						cfg.current_instance = button 
						button.TextColor3 = themes.preset.accent 

						flags[cfg.flag] = button.Text
						
						cfg.callback(button.Text)
					end)
				end 
			end     

			function cfg.filter_options(text)
				for _, v in next, cfg.option_instances do 
					if string.find(v.Text, text) then 
						v.Visible = true 
					else 
						v.Visible = false
					end
				end
			end 

			function cfg.set(value)
				for _, buttons in next, cfg.option_instances do 
					if buttons.Text == value then 
						buttons.TextColor3 = themes.preset.accent 
					else 
						buttons.TextColor3 = themes.preset.text 
					end 
				end 

				flags[cfg.flag] = value
				cfg.callback(value)
			end 

			cfg.refresh_options(cfg.items) 
			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible
			library.config_flags[cfg.flag] = cfg.set

			library:_attach_element(cfg, list_holder, {type = "list"})

			return setmetatable(cfg, library)
		end

		function library:textbox(options)
			local cfg = {
				name = options.name or nil,
				placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
				default = options.default,
				flag = options.flag or "flag",
				callback = options.callback or function() end,
				visible = options.visible or true,
			}
			
			local textbox_holder = create_row_frame(self.holder, {
				height = cfg.name and ui_tokens.control.labeled_row_height or ui_tokens.control.field_height,
				automatic_size = Enum.AutomaticSize.Y,
			})

			if cfg.name then
				local label = library:create("TextLabel", {
					Parent = textbox_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					Text = cfg.name,
					BackgroundTransparency = 1,
					Position = dim2(0, 2, 0, ui_tokens.control.label_offset_y),
					Size = dim2(0, 0, 0, 14),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = ui_tokens.font.label,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme_once(label, "text", "TextColor3")
			end

			local textbox_frame, _, textbox_fill = create_field_surface(textbox_holder, {
				position = dim2(0, 0, 0, cfg.name and ui_tokens.control.field_offset_y or 0),
				size = dim2(1, -1, 0, ui_tokens.control.field_height),
				fill_theme = "control_surface",
				fill_color = themes.preset.control_surface,
			})

			library:hoverify(textbox_holder, textbox_frame)

			local TextBox = library:create("TextBox", {
				Parent = textbox_fill,
				Name = "",
				CursorPosition = -1,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				PlaceholderColor3 = themes.preset.text_secondary,
				Text = "", 
				Size = dim2(1, -12, 1, 0),
				Position = dim2(0, 6, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				PlaceholderText = cfg.placeholder,
				ClearTextOnFocus = false,
				TextSize = ui_tokens.font.label,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			library:apply_theme_once(TextBox, "text", "TextColor3")
			library:apply_theme_once(TextBox, "text_secondary", "PlaceholderColor3")
					
			TextBox:GetPropertyChangedSignal("Text"):Connect(function()
				flags[cfg.flag] = TextBox.Text
				cfg.callback(TextBox.Text)
			end)

			function cfg.set_element_visible(bool)
				textbox_holder.Visible = bool 
			end

			function cfg.set(text) 
				flags[cfg.flag] = text
				TextBox.Text = text
				cfg.callback(text)
			end 

			if cfg.default then 
				cfg.set(cfg.default) 
			end 

			cfg.set_element_visible(cfg.visible)

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			library:_attach_element(cfg, textbox_holder, {type = "textbox", textbox = TextBox})

			return setmetatable(cfg, library)
		end

		function library:button_holder(options) 
			local cfg = {
				flag = options.flag or "hi", 
				visible = options.visible or true,
			}

			local button_holder = library:create("TextLabel", {
				Parent = self.holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 13,
				BackgroundColor3 = rgb(255, 255, 255), 
			})

			self.current_holder = button_holder

			-- instances 
				library:create("UIStroke", {
					Parent = button_holder,
					Name = ""
				})
				
				library:create("UIListLayout", {
					Parent = button_holder,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 
			
			function cfg.set_element_visible(bool)
				button_holder.Visible = bool 
			end

			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end 

		function library:button(options)
			local cfg = {
				callback = options.callback or function() end, 
				name = options.text or options.name or "Button",
				image = options.image or nil,
			}   

			local button_frame, _, button_fill = create_field_surface(self.current_holder or self.holder, {
				button = true,
				size = dim2(1, 0, 0, ui_tokens.control.field_height),
				fill_theme = "control_surface",
				fill_color = themes.preset.control_surface,
			})

			local hover_fill = library:create("Frame", {
				Parent = button_fill,
				Name = "",
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				BackgroundTransparency = 1
			})
			library:apply_theme_once(hover_fill, "accent", "BackgroundColor3")
			library:apply_corner(hover_fill, ui_tokens.radius.sm)

			local text_offset = 4
			if cfg.image then
				local image_label = library:create("ImageLabel", {
					Parent = button_fill,
					Name = "icon",
					BackgroundTransparency = 1,
					Position = dim2(0, 8, 0.5, -8),
					Size = dim2(0, 16, 0, 16),
					Image = "rbxassetid://" .. (tostring(cfg.image):match("%d+") or tostring(cfg.image)),
					BorderSizePixel = 0,
				})
				text_offset = 32
			end

			local text = library:create("TextLabel", {
				Parent = button_fill,
				Name = "",
				TextWrapped = true,
				TextColor3 = themes.preset.text,
				Text = cfg.name,
				Size = dim2(1, -8, 1, 0),
				Position = dim2(0, text_offset, 0, -1),
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BorderSizePixel = 0,
				FontFace = library.font,
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			library:apply_theme_once(text, "text", "TextColor3")

			button_frame.MouseEnter:Connect(function()
				library:micro_tween(hover_fill, {BackgroundTransparency = 0.92})
			end)

			button_frame.MouseLeave:Connect(function()
				library:micro_tween(hover_fill, {BackgroundTransparency = 1})
			end)

			button_frame.MouseButton1Click:Connect(function()
				cfg.callback()
			end)

			library:_attach_element(cfg, button_frame, {type = "button", text_label = text})

			return setmetatable(cfg, library)
		end

		function library:label(options)
			local cfg = {name = options.text or options.name or "Label"}

			local dropdown = create_row_frame(self.holder, {
				height = ui_tokens.control.label_row_height,
			})
			
			local TextLabel = library:create("TextLabel", {
				Parent = dropdown,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				Text = cfg.name,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = dim2(0, 2, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = dim2(0, 0, 0, ui_tokens.control.label_row_height),
				TextSize = ui_tokens.font.label,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			library:apply_theme(TextLabel, "text", "TextColor3")

			local right_components = library:create("Frame", {
				Parent = dropdown,
				Name = "right_components",
				AnchorPoint = vec2(1, 0),
				Position = dim2(1, -1, 0, 1),
				BorderSizePixel = 0,
				Size = dim2(0, 0, 0, ui_tokens.control.label_row_height),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1
			}) cfg.right_holder = right_components

			local list = library:create("UIListLayout", {
				Parent = right_components,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = dim(0, ui_tokens.spacing.xs),
				Name = "list",
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.set(text)
				TextLabel.Text = text
			end

			library:_attach_element(cfg, dropdown, {type = "label", text_label = TextLabel})

			return setmetatable(cfg, library)
		end

		function library:stats(options)
			options = options or {}

			local raw_name = options.name
			local show_header = raw_name ~= false and tostring(raw_name or "") ~= ""

			local cfg = {
				name = show_header and tostring(raw_name) or "",
				separator = options.separator or ": ",
				visible = options.visible ~= false,
				rows = {},
				order = {}
			}

			local stats_holder = create_row_frame(self.holder, {
				name = "stats_holder",
				size = dim2(1, -8, 0, 0),
				automatic_size = Enum.AutomaticSize.Y,
			})

			local content = library:create("Frame", {
				Parent = stats_holder,
				Name = "stats_content",
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			})

			library:create("UIListLayout", {
				Parent = content,
				Padding = dim(0, ui_tokens.spacing.xs),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})

			local title
			if show_header then
				title = library:create("TextLabel", {
					Parent = content,
					Name = "title",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					Text = cfg.name,
					Size = dim2(1, 0, 0, ui_tokens.control.label_row_height),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextSize = ui_tokens.font.label,
				})
				library:apply_theme(title, "text", "TextColor3")

				local divider = library:create("Frame", {
					Parent = content,
					Name = "divider",
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.separator,
				})
				library:apply_theme(divider, "separator", "BackgroundColor3")
			end

			local rows_holder = library:create("Frame", {
				Parent = content,
				Name = "rows_holder",
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			})

			library:create("UIListLayout", {
				Parent = rows_holder,
				Padding = dim(0, ui_tokens.spacing.xs),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})

			local function normalize_key(key)
				if key == nil then
					return ""
				end

				return tostring(key)
			end

			local function normalize_value(value)
				if value == nil then
					return "nil"
				end

				if type(value) == "table" then
					local parts = {}
					for _, entry in ipairs(value) do
						parts[#parts + 1] = tostring(entry)
					end

					return #parts > 0 and concat(parts, ", ") or "none"
				end

				return tostring(value)
			end

			local function create_stat_row(key)
				local row_root, _, row_fill = create_field_surface(rows_holder, {
					name = "row_" .. key,
					size = dim2(1, 0, 0, ui_tokens.control.field_height),
					fill_theme = "inline",
					fill_color = themes.preset.inline,
					outer_theme = "outline",
					outer_radius = ui_tokens.radius.sm,
					fill_radius = ui_tokens.radius.sm,
					gradient = false,
				})

				local key_label = library:create("TextLabel", {
					Parent = row_fill,
					Name = "key",
					FontFace = library.font,
					TextColor3 = themes.preset.text_secondary,
					Text = key,
					Position = dim2(0, 8, 0, 0),
					Size = dim2(0.45, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = ui_tokens.font.label,
				})
				library:apply_theme(key_label, "text_secondary", "TextColor3")

				local value_label = library:create("TextLabel", {
					Parent = row_fill,
					Name = "value",
					FontFace = library.font,
					TextColor3 = themes.preset.value_text,
					Text = "--",
					AnchorPoint = vec2(1, 0),
					Position = dim2(1, -8, 0, 0),
					Size = dim2(0.55, -8, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = ui_tokens.font.label,
				})
				library:apply_theme(value_label, "value_text", "TextColor3")

				local row = {
					root = row_root,
					key = key_label,
					value = value_label,
				}

				function row.set(new_value)
					value_label.Text = normalize_value(new_value)
				end

				return row
			end

			function cfg.set(key, value)
				local normalized_key = normalize_key(key)
				if normalized_key == "" then
					return
				end

				local row = cfg.rows[normalized_key]
				if not row then
					row = create_stat_row(normalized_key)
					cfg.rows[normalized_key] = row
					insert(cfg.order, normalized_key)
				end

				row.set(value)
			end

			function cfg.update(values)
				if type(values) ~= "table" then
					return
				end

				for key, value in next, values do
					cfg.set(key, value)
				end
			end

			function cfg.get(key)
				local normalized_key = normalize_key(key)
				return cfg.rows[normalized_key]
			end

			function cfg.remove(key)
				local normalized_key = normalize_key(key)
				local row = cfg.rows[normalized_key]
				if not row then
					return
				end

				cfg.rows[normalized_key] = nil
				for index, row_key in ipairs(cfg.order) do
					if row_key == normalized_key then
						remove(cfg.order, index)
						break
					end
				end

				if row.root then
					row.root:Destroy()
				end
			end

			function cfg.clear(replacement)
				local text = replacement
				if text == nil then
					text = "--"
				end

				for _, key in ipairs(cfg.order) do
					local row = cfg.rows[key]
					if row then
						row.set(text)
					end
				end
			end

			function cfg.set_title(text)
				if not title then
					return
				end

				local title_text = tostring(text or "")
				if title_text == "" then
					return
				end

				title.Text = title_text
			end

			function cfg.set_element_visible(bool)
				stats_holder.Visible = bool
			end

			if type(options.initial) == "table" then
				cfg.update(options.initial)
			end

			cfg.set_element_visible(cfg.visible)

			return setmetatable(cfg, library)
		end 

		function library:playerlist(options) 
			local cfg = {
				callback = options.callback or function() end, 

				labels = {
					name,
					display, 
					uid, 
				}
			}

			local selected_button; 

			local patterns = {
				["Priority"] = rgb(255, 255, 0),
				["Enemy"] = rgb(255, 0, 0),
				["Neutral"] = themes.preset.text,
				["Friendly"] = rgb(0, 255, 255)
			}

			-- elements 
				local playerlist_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = playerlist_holder,
					Name = "",
					PaddingBottom = dim(0, -2),
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = playerlist_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = playerlist_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, 232),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(list, "outline", "BackgroundColor3") 
				library:apply_corner(list, 5)
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				library:apply_corner(inline, 4)
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.low_contrast
				})
				library:apply_theme(background, "low_contrast", "BackgroundColor3")
				library:apply_corner(background, 3)
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.high_contrast
				})
				library:apply_theme(contrast, "high_contrast", "BackgroundColor3")
				library:apply_corner(contrast, 3)
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingTop = dim(0, 4),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 

			function cfg.create_player(player) 
				library.playerlist_data[tostring(player)] = {}
				local path = library.playerlist_data[tostring(player)]
				
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local player_name = library:create("TextLabel", {
					Parent = TextButton,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(player),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13,
					LayoutOrder = -100, 
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(player_name, "text", "TextColor3") 
				library:apply_theme(player_name, "accent", "TextColor3") 
								
				-- local TextLabel = library:create("TextLabel", {
				--     Parent = TextButton,
				--     Name = "",
				--     FontFace = library.font,
				--     TextColor3 = themes.preset.text,
				--     BorderColor3 = rgb(0, 0, 0),
				--     Text = "None",
				--     BackgroundTransparency = 1,
				--     TextXAlignment = Enum.TextXAlignment.Left,
				--     BorderSizePixel = 0,
				--     AutomaticSize = Enum.AutomaticSize.Y,
				--     TextSize = 13,
				--     BackgroundColor3 = rgb(255, 255, 255)
				-- })
								
				-- local Frame = library:create("Frame", {
				--     Parent = TextLabel,
				--     Name = "",
				--     Position = dim2(0, -10, 0, 0),
				--     BorderColor3 = rgb(0, 0, 0),
				--     Size = dim2(0, 1, 0, 12),
				--     BorderSizePixel = 0,
				--     BackgroundColor3 = themes.preset.outline
				-- }) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local priority_text = library:create("TextLabel", {
					Parent = TextButton,
					Name = "",
					FontFace = library.font,
					TextColor3 = tostring(player) ~= lp.Name and themes.preset.text or rgb(0, 0, 255),
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(player) ~= lp.Name and "Neutral" or "LocalPlayer",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 13,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local Frame = library:create("Frame", {
					Parent = priority_text,
					Name = "",
					Position = dim2(0, -10, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 1, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(Frame, "outline", "BackgroundColor3")
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = TextButton,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = TextButton,
					Name = "",
					PaddingRight = dim(0, 2),
					PaddingLeft = dim(0, 2)
				})

				local line = library:create("Frame", {
					Parent = ScrollingFrame,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(line, "outline", "BackgroundColor3")

				path.instance = TextButton 
				path.line = line 
				path.priority = "Neutral"
				path.priority_text = priority_text
				-- library.selected_player = players[tostring(player)]
				
				TextButton.MouseButton1Click:Connect(function()
					if player_name == lp.Name then 
						return 
					end 

					if selected_button then 
						selected_button.TextColor3 = themes.preset.text 
						selected_button = nil 
					end     

					selected_button = player_name 
					player_name.TextColor3 = themes.preset.accent 

					library.selected_player = player_name.Text
					library.config_flags["PLAYERLIST_DROPDOWN"](path.priority_text.Text)

					if cfg.labels.name then 
						cfg.labels.name.set("User: " .. player_name.Text)
						cfg.labels.display.set("DisplayName: " .. players[player_name.Text].DisplayName)
						cfg.labels.uid.set("User Id: " .. players[player_name.Text].UserId)
					end
				end)

				return path 
			end 

			function cfg.search(text)
				for _, player in next, players:GetPlayers() do 
					local name = tostring(player)
					local path = library.playerlist_data[name]

					if path then 
						local sanity = string.lower(name):match(string.lower(text)) and true or false
						path.instance.Visible = sanity
						path.line.Visible = sanity
					end 
				end 
			end 

			function cfg.remove_player(player) 
				local path = library.playerlist_data[tostring(player)]
				path.instance:Destroy() 
				path.line:Destroy() 
				path = nil 
			end 

			function library.prioritize(text) 
				if not library.selected_player then 
					return 
				end 

				local path = library.playerlist_data[library.selected_player]
				path.priority_text.Text = text
				path.priority_text.TextColor3 = patterns[text]
				path.priority = text
			end 

			function library.get_priority(player) 
				local path = library.playerlist_data[tostring(player)]

				if path then 
					return path.priority
				end 
			end 

			players.PlayerAdded:Connect(cfg.create_player)
			players.PlayerRemoving:Connect(cfg.remove_player)
			
			for _, player in players:GetPlayers() do 
				local player_object = cfg.create_player(player.Name)
				insert(library.playerlist_data, player_object)
			end 

			self:textbox({name = "Search", callback = function(txt)
				cfg.search(txt)
			end})
			cfg.labels.name = self:label({name = "Name: ??"})
			cfg.labels.display = self:label({name = "Display Name: ??"})
			cfg.labels.uid = self:label({name = "User Id: ??"})

			return setmetatable(cfg, library)
		end 
	-- 
-- 

return library, themes; 
