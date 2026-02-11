-- Core settings first
require("core.auto")
require("core.opts")
require("core.maps")

-- Prefer config/autoload, fall back to data/site/autoload
local cfg = vim.fn.stdpath("config") .. "/autoload/plug.vim"
local data = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"

if vim.fn.empty(vim.fn.glob(cfg)) > 0 and vim.fn.empty(vim.fn.glob(data)) > 0 then
	vim.api.nvim_echo({ { "vim-plug missing: place plug.vim at " .. cfg .. " or " .. data, "WarningMsg" } }, false, {})
end

-- Needed because plug.vim lives in a custom place (INTENTIONAL)
vim.opt.rtp:prepend(vim.fn.stdpath("config"))

-- vim-plug (Lua)
local Plug = vim.fn["plug#"]
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")

-- NOTE: ColorScheme
Plug("folke/tokyonight.nvim")

-- NOTE: UI / Notifications
Plug("MunifTanjim/nui.nvim")
Plug("folke/noice.nvim")
Plug("rcarriga/nvim-notify")

-- NOTE: Git
Plug("lewis6991/gitsigns.nvim")

-- NOTE: LSP
Plug("neovim/nvim-lspconfig")

-- NOTE: Snippets
Plug("L3MON4D3/LuaSnip")
Plug("rafamadriz/friendly-snippets")

-- NOTE: Formatting
Plug("stevearc/conform.nvim")

-- NOTE: Completion
Plug("saghen/blink.cmp")

-- NOTE: Mini plugins
Plug("nvim-mini/mini.ai")
Plug("nvim-mini/mini.icons")
Plug("nvim-mini/mini.statusline")
Plug("nvim-mini/mini.hipatterns")

-- NOTE: Utility plugins
Plug("folke/snacks.nvim")
Plug("folke/which-key.nvim")
Plug("windwp/nvim-autopairs")

-- NOTE: TreeSitter
Plug("nvim-treesitter/nvim-treesitter", { ["tag"] = "v0.9.2", ["do"] = ":TSUpdate" })

-- NOTE: Icons
Plug("nvim-tree/nvim-web-devicons")

-- NOTE: MongoDB
Plug("jrop/mongo.nvim")
Plug("nvim-lua/plenary.nvim")

-- NOTE: Copilot
Plug("github/copilot.vim")
Plug("CopilotC-Nvim/CopilotChat.nvim")

-- NOTE: Conceal Secrets
Plug("laytan/cloak.nvim")

vim.call("plug#end")

-- Safe requires (won’t error on first install)
pcall(require, "plug.git")
pcall(require, "plug.mini")
pcall(require, "plug.cloak")
pcall(require, "plug.notify")
pcall(require, "plug.snacks")
pcall(require, "plug.colors")
pcall(require, "plug.copilot")
pcall(require, "plug.lsp-cmp")
pcall(require, "plug.whichkey")
pcall(require, "plug.formatter")
pcall(require, "plug.autopairs")
pcall(require, "plug.treesitter")
