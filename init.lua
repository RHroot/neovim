-- Core settings first
require("core.auto")
require("core.opts")
require("core.maps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Import all plugin specs from lua/plug/ directory
		{ import = "plugins" },
	},
	install = {
		-- Install missing plugins on startup
		missing = true,
		-- Use tokyonight as the colorscheme during install
		colorscheme = { "tokyonight" },
	},
	checker = {
		enabled = true, -- Check for plugin updates periodically
		notify = false, -- Don't spam with update notifications
	},
	change_detection = {
		enabled = true,
		notify = false, -- Don't notify when config changes
	},
	performance = {
		rtp = {
			-- Disable some builtin plugins for faster startup
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		-- Don't show the lazy UI on startup unless needed
		border = "rounded",
	},
})
