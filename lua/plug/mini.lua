--=== AI ===
require("mini.ai").setup({ n_lines = 500, custom_textobjects = nil })

-- === Statusline ===
local statusline = require("mini.statusline")

local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients > 0 then
		local names = {}
		for _, c in ipairs(clients) do
			table.insert(names, c.name)
		end
		return "%#MiniStatuslineLspOn# " .. table.concat(names, ",") .. "%*"
	else
		return "%#MiniStatuslineLspOff# off%*"
	end
end

vim.api.nvim_set_hl(0, "MiniStatuslineLspOn", { fg = "#a6e3a1", bg = "#1e1e2e", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineLspOff", { fg = "#f38ba8", bg = "#1e1e2e" })

statusline.setup({
	use_icons = true,
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git = statusline.section_git({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics, lsp_status() } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
})

-- ===== Extra: Visual Enhancements =====
vim.cmd([[hi MiniIndentscopeSymbol guifg=#89b4fa]])
vim.cmd([[hi MiniPickPrompt guifg=#f5c2e7]])
vim.cmd([[hi MiniStatuslineDevinfo guifg=#89b4fa]])
vim.cmd([[hi MiniStatuslineFilename guifg=#f38ba8]])
vim.cmd([[hi MiniStatuslineFileinfo guifg=#cba6f7]])

-- === Hilighting ===
local hipatterns = require("mini.hipatterns")

-- Expand 3/4-digit hex to 6/8-digit
local function expand_hex(hex)
	hex = hex:gsub("^#", "")

	if #hex == 3 then
		local r, g, b = hex:match("(%x)(%x)(%x)")
		return "#" .. r .. r .. g .. g .. b .. b
	elseif #hex == 4 then
		local r, g, b, a = hex:match("(%x)(%x)(%x)(%x)")
		return "#" .. r .. r .. g .. g .. b .. b .. a .. a
	elseif #hex == 6 or #hex == 8 then
		return "#" .. hex
	end

	return "#" .. hex
end

-- HSL to RGB
local function hsl_to_rgb(h, s, l)
	h, s, l = h / 360, s / 100, l / 100
	if s == 0 then
		return l, l, l
	end

	local function hue2rgb(p, q, t)
		if t < 0 then
			t = t + 1
		end
		if t > 1 then
			t = t - 1
		end
		if t < 1 / 6 then
			return p + (q - p) * 6 * t
		end
		if t < 1 / 2 then
			return q
		end
		if t < 2 / 3 then
			return p + (q - p) * (2 / 3 - t) * 6
		end
		return p
	end

	local q = l < 0.5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	return hue2rgb(p, q, h + 1 / 3), hue2rgb(p, q, h), hue2rgb(p, q, h - 1 / 3)
end

-- Convert to hex
local function to_hex(r, g, b)
	return string.format(
		"#%02x%02x%02x",
		math.floor(r * 255 + 0.5),
		math.floor(g * 255 + 0.5),
		math.floor(b * 255 + 0.5)
	)
end

-- Create highlight with smart foreground
local function make_highlight(hex)
	hex = expand_hex(hex)
	-- Handle 8-digit hex (with alpha) - use first 6 digits for display
	local display_hex = hex
	if #hex == 9 then -- #RRGGBBAA
		display_hex = hex:sub(1, 7) -- Use #RRGGBB only
	end

	local hl_name = "MiniHipatterns" .. display_hex:gsub("#", "")

	if vim.fn.hlexists(hl_name) == 0 then
		local r = tonumber(display_hex:sub(2, 3), 16) / 255
		local g = tonumber(display_hex:sub(4, 5), 16) / 255
		local b = tonumber(display_hex:sub(6, 7), 16) / 255
		local lum = 0.299 * r + 0.587 * g + 0.114 * b
		local fg = lum > 0.5 and "#000000" or "#ffffff"
		vim.api.nvim_set_hl(0, hl_name, { fg = fg, bg = display_hex })
	end

	return hl_name
end

hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		numbers = { pattern = "%d+", group = "Number" },
		important = { pattern = "IMPORTANT", group = "WarningMsg" },
		comment_todo = {
			pattern = "%f[%w](TODO|FIXME|BUG):",
			group = "Comment",
			callback = function(text)
				return text:match("^%s*[%#/%-%s]+") ~= nil
			end,
		},
		-- 8-digit hex with alpha (#RRGGBBAA) - check BEFORE 6-digit
		hex_alpha = {
			pattern = "#%x%x%x%x%x%x%x%x%f[%W]",
			group = function(_, match)
				return make_highlight(match)
			end,
		},
		-- Standard 6-digit hex
		hex = {
			pattern = "#%x%x%x%x%x%x%f[%W]",
			group = function(_, match)
				return make_highlight(match)
			end,
		},
		-- 3-digit hex
		hex_short = {
			pattern = "#%x%x%x%f[%W]",
			group = function(_, match)
				return make_highlight(match)
			end,
		},
		-- Hex in rgba() notation: rgba(161217ff)
		rgba_hex = {
			pattern = "rgba?%(%x%x%x%x%x%x%x?%x?%)",
			group = function(_, match)
				local hex = match:match("rgba?%((%x+)%)")
				if hex and (#hex == 6 or #hex == 8) then
					return make_highlight(hex)
				end
				return nil
			end,
		},
		-- Hex without # (Android style): 161217ff
		hex_no_hash = {
			pattern = "%f[%w]%x%x%x%x%x%x%x%x%f[%W]",
			group = function(_, match)
				-- Verify it's all hex digits
				if match:match("^[0-9a-fA-F]+$") then
					return make_highlight(match)
				end
				return nil
			end,
		},
		-- Standard RGB/RGBA
		rgb = {
			pattern = "rgba?%(%s*%d+%s*,%s*%d+%s*,%s*%d+[^%)]*%)",
			group = function(_, match)
				local r, g, b = match:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
				if not r then
					return nil
				end
				r, g, b = tonumber(r), tonumber(g), tonumber(b)
				if not r or r > 255 or g > 255 or b > 255 then
					return nil
				end
				return make_highlight(to_hex(r / 255, g / 255, b / 255))
			end,
		},
		-- HSL/HSLA
		hsl = {
			pattern = "hsla?%(%s*%d+%.?%d*%s*,%s*%d+%.?%d*%%?%s*,%s*%d+%.?%d*%%?[^%)]*%)",
			group = function(_, match)
				local h, s, l = match:match("(%d+%.?%d*)%s*,%s*(%d+%.?%d*)%%?%s*,%s*(%d+%.?%d*)%%?")
				if not h then
					return nil
				end
				h, s, l = tonumber(h), tonumber(s), tonumber(l)
				if not h or not s or not l then
					return nil
				end
				if h > 360 or s > 100 or l > 100 then
					return nil
				end
				local r, g, b = hsl_to_rgb(h, s, l)
				return make_highlight(to_hex(r, g, b))
			end,
		},
	},
})
