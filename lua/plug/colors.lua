require("tokyonight").setup({
	style = "night",
	light_style = "night",
	styles = {
		comments = { italic = true },
		keywords = { italic = true },
		functions = { bold = true },
		variables = { bold = true, italic = true },
		sidebars = "transparent",
		floats = "transparent",
	},
})

local function colorscheme_exists(name)
	local colorschemes = vim.fn.getcompletion("", "color")
	for _, scheme in ipairs(colorschemes) do
		if scheme == name then
			return true
		end
	end
	return false
end

if colorscheme_exists("tokyonight") then
	vim.cmd.colorscheme("tokyonight")
else
	vim.cmd.colorscheme("retrobox")
end
