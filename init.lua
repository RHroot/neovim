----------------------------------------------------------
--- AutoCmds Starts Here
----------------------------------------------------------
--- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 120 })
	end,
})

--- Black background theme
local BLACK = "#000000"

local theme_applied = false
local function apply_black_theme()
	if theme_applied then
		return
	end
	theme_applied = true

	--- Core
	vim.api.nvim_set_hl(0, "Normal", { bg = BLACK })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = BLACK })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = BLACK })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = BLACK })

	--- Line numbers
	vim.api.nvim_set_hl(0, "LineNr", {
		fg = "#4a4a4a",
		bg = BLACK,
	})
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		fg = "#F09676",
		bg = BLACK,
		bold = true,
	})

	--- Floats
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = BLACK })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#F09676", bg = BLACK })

	--- Diagnostic floats
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = BLACK })
end

--- Apply only to real code buffers
local function is_code_buffer(buf)
	return vim.bo[buf].buftype == ""
end

--- Autocommands (robust + race-free)
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		theme_applied = false
		apply_black_theme()
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function(ev)
		if is_code_buffer(ev.buf) then
			apply_black_theme()
		end
	end,
})

--- Ensure startup correctness even if colorscheme loads first
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("doautocmd ColorScheme")
	end,
})

--- LSP keymaps
local lsp_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local buf = ev.buf

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
		end

		--- Navigation
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Find references")
		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		--- Workspace
		map("n", "<leader>aw", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("n", "<leader>rw", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
		map("n", "<leader>lw", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Search workspace symbols")

		--- Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>sn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>for", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")

		--- Diagnostics
		map("n", "<leader>fe", vim.diagnostic.open_float, "Show diagnostics")
		map("n", "<leader>ce", vim.diagnostic.setqflist, "Diagnostics to quickfix")
	end,
})

--- Diagnostics config
vim.diagnostic.config({
	virtual_text = false,
	virtual_line = {
		only_current_line = true,
		severity = { min = vim.diagnostic.severity.WARN },
	},
	underline = true,
	severity_sort = true,
	update_in_insert = false,

	float = {
		border = "rounded",
		source = "if_many",
		focusable = false,
	},

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
	},
})

--- CursorHold diagnostics (non-spammy)
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })[1] then
			vim.diagnostic.open_float(nil, {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
				border = "rounded",
				source = "if_many",
			})
		end
	end,
})

----------------------------------------------------------
--- OPTS Starts Here
----------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.title = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.opt.splitbelow = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "↪"
vim.o.sidescroll = 1

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.updatetime = 250

vim.o.swapfile = false
vim.o.backup = false

local undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.fn.mkdir(undodir, "p")
vim.o.undodir = undodir
vim.o.undofile = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.winborder = "rounded"

vim.g.have_nerd_font = true

vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

--- Options for Neovide only
vim.o.guifont = "FiraCode Nerd Font Mono:h22"
vim.o.background = "dark"
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_opacity = 0.5
vim.g.transparency = 0.8

----------------------------------------------------------
--- Keymaps Starts Here
----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = false }

--- better movement in wrapped text
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (warp-aware)" })
map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (warp-aware)" })

--- General
map({ "n", "i", "v", "c", "t", "x", "s", "o" }, "<C-c>", "<Esc>", opts)
map({ "n", "v", "x" }, ";", ":", opts)
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
map({ "v", "c", "t", "x", "s", "o" }, "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<leader>cd", ":Explore<CR>", opts)
map("n", "<leader>vd", ":Vexplore<CR>", opts)
map("n", "<leader>sd", ":Sexplore<CR>", opts)
map("n", "<leader>so", ":update<CR> :source<CR>", opts)
map("n", "<leader>si", "<cmd>source ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>rt", ":restart<CR>", opts)
map("n", "<leader>rr", ":ex<CR>", opts)
map("n", "<leader>w", ":w!<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>ex", ":q!<CR>", opts)
map("n", "<leader>bc", ":enew<CR>", opts)
map("n", "<leader>bn", ":bn<CR>", opts)
map("n", "<leader>bp", ":bp<CR>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
map("n", "<C-c>", "<cmd>nohlsearch<CR>", opts)

--- To Travel between splits or panes you may call it
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-S-j>", "<C-w>j", opts)
map("n", "<C-S-k>", "<C-w>k", opts)
map("n", "<C-S-l>", "<C-w>l", opts)
map("n", "<C-S-h>", "<C-w>h", opts)
map("n", "<leader>sv", ":vsplit<CR>", opts)
map("n", "<leader>sh", ":split<CR>", opts)

--- Prime's remaps
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)
map({ "n", "v" }, "<leader>d", '"_d', opts)
map("x", "<leader>p", [["_dP]], opts)

----------------------------------------------------------
--- Plugins Will Added Here
----------------------------------------------------------
vim.pack.add({

	--- Plugins for Colorscheme
	{ src = "https://github.com/folke/tokyonight.nvim" },

	--- Plugins for Completion
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },

	--- Plugins for LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

	--- Plugins for Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	--- Plugins for Explorer
	{ src = "https://github.com/stevearc/oil.nvim" },

	--- Plugins for AutoPairs
	{ src = "https://github.com/windwp/nvim-autopairs" },

	--- Plugins for Parsers
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	--- Plugins for Notifications
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },

	--- Plugins for Git Signs
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	--- Plugins to get keybinds
	{ src = "https://github.com/folke/which-key.nvim" },

	--- Plugins to get Cloak
	{ src = "https://github.com/laytan/cloak.nvim" },

	--- Plugins that can be quite useful if you know how to use them from Mini.nvim
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	--- Plugins to get Copilot
	{ src = "https://github.com/github/copilot.vim" },
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

--------------------------------------------------
--- Colors
--------------------------------------------------
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
	vim.cmd.colorscheme("unokai")
end

--------------------------------------------------
--- BLINK + LUASNIP (lazy on InsertEnter)
--------------------------------------------------
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		local ls = require("luasnip")

		ls.setup({
			history = true,
			delete_check_events = "TextChanged",
			enable_autosnippets = true,
		})

		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})

		vim.keymap.set({ "i", "s" }, "<C-n>", function()
			if ls.jumpable(1) then
				ls.jump(1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-p>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-e>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true })

		require("blink.cmp").setup({
			snippets = { preset = "luasnip" },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						name = "snippets",
						module = "blink.cmp.sources.snippets",
						enabled = true,
						max_items = 8,
						min_keyword_length = 2,
						score_offset = 95,
					},
				},
			},

			fuzzy = { implementation = "lua" },

			keymap = {
				preset = "none",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-Space>"] = { "show", "hide_documentation" },
				["<Esc>"] = { "hide", "fallback" },
				["<C-e>"] = { "show_documentation", "hide_documentation" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
			},

			signature = {
				enabled = true,
				window = {
					max_height = 8,
					max_width = 60,
					border = "rounded",
				},
			},

			appearance = { nerd_font_variant = "mono" },

			completion = {
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
				},
				menu = {
					auto_show = true,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				keyword = { range = "prefix" },
				ghost_text = { enabled = true },
			},
		})
	end,
})

--------------------------------------------------
--- LSP Setup
--------------------------------------------------
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		--- LSP's installed through mason
		"zls",
		"gopls",
		"jdtls",
		"clangd",
		"rust-analyzer",
		"python-lsp-server",
		"lua-language-server",
		"postgres-language-server",
		"vtsls",
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"tailwindcss-language-server",

		--- Formatters installed through mason
		"ruff",
		"shfmt",
		"stylua",
		"sqruff",
		"alejandra",
		"google-java-format",
		"prettierd",
	},
})

--- Safe capability setup (prevents breakage if blink loads late)
local blink = package.loaded["blink.cmp"]

local capabilities = vim.lsp.protocol.make_client_capabilities()
if blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end
local servers = {
	"zls",
	"html",
	"cssls",
	"ts_ls",
	"pylsp",
	"gopls",
	"jdtls",
	"vtsls",
	"lua_ls",
	"clangd",
	"tailwindcss",
	"postgres_lsp",
	"rust_analyzer",
}

for i = 1, #servers do
	local server = servers[i]
	vim.lsp.config(server, {
		capabilities = capabilities,
	})
end

vim.lsp.enable(servers)

--------------------------------------------------
--- Formatter
--------------------------------------------------
local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		--- Core languages
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" },

		--- Web / frontend
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		less = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		markdown = { "prettierd" },
		vue = { "prettierd" },
		svelte = { "prettierd" },
		yaml = { "prettierd" },

		--- Infra / scripts
		sh = { "shfmt" },
		bash = { "shfmt" },
		nix = { "alejandra" },
		dockerfile = { "shfmt" },
		hyprlang = { "shfmt" },

		--- Compiled / typed
		c = { "clang-format" },
		cpp = { "clang-format" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
		java = { "google-java-format" },
		zig = { "zigfmt" },

		--- Data / query
		sql = { "sqruff" },
		toml = { "prettierd" },
	},

	formatters = {
		zigfmt = {
			command = "zig",
			args = { "fmt", "$FILENAME" },
			stdin = false,
		},
		shfmt = {
			command = "shfmt",
			args = { "-i", "2", "-bn", "-ci", "-ln", "bash" },
			stdin = true,
		},
		sqruff = {
			command = "sqruff",
			args = { "format", "-" },
			stdin = true,
		},
	},
})

map({ "n", "v" }, "<leader>fm", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 500,
	})
end, { desc = "[F]or[m]at buffer" })
map("v", "<leader>f", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		range = {
			["start"] = vim.api.nvim_buf_get_mark(0, "<"),
			["end"] = vim.api.nvim_buf_get_mark(0, ">"),
		},
	})
end, { desc = "[F]ormat selection" })

--------------------------------------------------
--- Explorer
--------------------------------------------------
require("oil").setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
	},
})
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

--------------------------------------------------
--- AutoPairs
--------------------------------------------------
require("nvim-autopairs").setup({
	disable_in_replace_mode = true,
	check_ts = true,
	fast_wrap = {
		map = "<M-e>",
		chars = { "(", "[", "{", "'", '"', "`" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		end_key = "$",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
	map_cr = true,
})

--------------------------------------------------
--- Treesitter
--------------------------------------------------
require("nvim-treesitter").setup({
	install = {
		compilers = { "clang", "gcc" },
		prefer_git = true,
	},
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = true },
})

--------------------------------------------------
--- Notifications
--------------------------------------------------
local ook, notify = pcall(require, "notify")
if not ook then
	vim.notify("nvim-notify not found", vim.log.levels.ERROR)
else
	vim.notify = notify
	notify.setup({
		stages = "slide",
		timeout = 3000,
		background_colour = "#1e222a",
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
		level = vim.log.levels.INFO,
		max_width = 50,
		top_down = true,
	})

	map("n", "<leader>nd", notify.dismiss, { desc = "Dismiss all notifications" })
	map("n", "<leader>nh", notify.history, {
		desc = "Notification history",
	})

	--- LSP integration
	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local level_map = {
			[1] = vim.log.levels.ERROR,
			[2] = vim.log.levels.WARN,
			[3] = vim.log.levels.INFO,
			[4] = vim.log.levels.DEBUG,
		}
		local level = level_map[result.type] or vim.log.levels.INFO

		notify(result.message, level, {
			title = "LSP: " .. (client and client.name or "Unknown"),
			timeout = 4000,
			on_open = function(win)
				pcall(vim.api.nvim_set_option_value, "winblend", 20, { scope = "local", win = win })
			end,
		})
	end

	--- Notify when LSP attaches
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client then
				notify(client.name, vim.log.levels.INFO, {
					title = "LSP Connected",
					timeout = 2500,
				})
			end
		end,
	})
end

--------------------------------------------------
--- Git Signs
--------------------------------------------------
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 1000,
	},
	attach_to_untracked = true,
	watch_gitdir = {
		follow_files = true,
	},
})

--------------------------------------------------
--- Cloak
--------------------------------------------------
require("cloak").setup({
	enabled = true,
	cloak_character = "",
	highlight_group = "Comment",
	cloak_length = nil,
	try_all_patterns = true,
	cloak_telescope = true,
	cloak_on_leave = false,
	patterns = {
		{
			file_pattern = {
				".env*",
				"*.env",
				".dev.vars",
				".prod.vars",
			},
			cloak_pattern = "=.+",
			replace = nil,
		},
	},
})

--------------------------------------------------
--- Neovim ( One line setup Plugins )
--------------------------------------------------
require("which-key").setup()
require("mini.icons").setup()
require("mini.ai").setup({ n_lines = 500, custom_textobjects = nil })

--------------------------------------------------
--- Fuzzy Finder
--------------------------------------------------
local pick = require("mini.pick")
pick.setup()

map("n", "<leader><leader>", function()
	pick.builtin.files()
end, { desc = "Find files" })

map("n", "<leader>/", function()
	pick.builtin.grep_live()
end, { desc = "Live grep" })

map("n", "<leader>fb", function()
	pick.builtin.buffers()
end, { desc = "Buffers" })

map("n", "<leader>hp", function()
	pick.builtin.help()
end, { desc = "Help tags" })

--------------------------------------------------
--- IndentScope
--------------------------------------------------
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
	fg = "#F09676",
	nocombine = true,
})
require("mini.indentscope").setup({
	symbol = "│",
	options = { try_as_border = true },
	draw = {
		delay = 50,
		animation = require("mini.indentscope").gen_animation.none(),
	},
})

--------------------------------------------------
--- MINI.HIPATTERNS (clean + compact)
--------------------------------------------------
local hipatterns = require("mini.hipatterns")

--- Utils
local function expand_hex(hex)
	hex = hex:gsub("^#", "")
	if #hex == 3 or #hex == 4 then
		hex = hex:gsub(".", "%1%1")
	end
	return "#" .. hex
end

local function to_hex(r, g, b)
	return string.format(
		"#%02x%02x%02x",
		math.floor(r * 255 + 0.5),
		math.floor(g * 255 + 0.5),
		math.floor(b * 255 + 0.5)
	)
end

local function hsl_to_rgb(h, s, l)
	h, s, l = h / 360, s / 100, l / 100
	if s == 0 then
		return l, l, l
	end

	local function f(p, q, t)
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
	return f(p, q, h + 1 / 3), f(p, q, h), f(p, q, h - 1 / 3)
end

local cache = {}
local function make_highlight(hex)
	hex = expand_hex(hex)
	local base = (#hex == 9) and hex:sub(1, 7) or hex

	if cache[base] then
		return cache[base]
	end

	local name = "MiniHipatterns" .. base:sub(2)

	if vim.fn.hlexists(name) == 0 then
		local r = tonumber(base:sub(2, 3), 16) / 255
		local g = tonumber(base:sub(4, 5), 16) / 255
		local b = tonumber(base:sub(6, 7), 16) / 255
		local fg = (0.299 * r + 0.587 * g + 0.114 * b) > 0.5 and "#000000" or "#ffffff"
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = base })
	end

	cache[base] = name
	return name
end

--- Pattern helpers
local function hex_group(_, m)
	return make_highlight(m)
end

local function rgb_group(_, m)
	local r, g, b = m:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if not r or r > 255 or g > 255 or b > 255 then
		return
	end
	return make_highlight(to_hex(r / 255, g / 255, b / 255))
end

local function hsl_group(_, m)
	local h, s, l = m:match("(%d+%.?%d*)%s*,%s*(%d+%.?%d*)%%?%s*,%s*(%d+%.?%d*)%%?")
	h, s, l = tonumber(h), tonumber(s), tonumber(l)
	if not h or h > 360 or not s or s > 100 or not l or l > 100 then
		return
	end
	return make_highlight(to_hex(hsl_to_rgb(h, s, l)))
end

--- Setup
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

		--- Colors
		hex_alpha = { pattern = "#%x%x%x%x%x%x%x%x%f[%W]", group = hex_group },
		hex = { pattern = "#%x%x%x%x%x%x%f[%W]", group = hex_group },
		hex_short = { pattern = "#%x%x%x%f[%W]", group = hex_group },

		hex_no_hash = {
			pattern = "%f[%w]%x%x%x%x%x%x%x%x%f[%W]",
			group = function(_, m)
				return m:match("^[%da-fA-F]+$") and make_highlight(m)
			end,
		},

		rgba_hex = {
			pattern = "rgba?%((%x+)%)",
			group = function(_, m)
				return (#m == 6 or #m == 8) and make_highlight(m)
			end,
		},

		rgb = {
			pattern = "rgba?%(%s*%d+%s*,%s*%d+%s*,%s*%d+[^%)]*%)",
			group = rgb_group,
		},

		hsl = {
			pattern = "hsla?%(%s*%d+%.?%d*%s*,%s*%d+%.?%d*%%?%s*,%s*%d+%.?%d*%%?[^%)]*%)",
			group = hsl_group,
		},
	},
})

--------------------------------------------------
--- Copilot
--------------------------------------------------
require("CopilotChat").setup({

	model = "claude-haiku-4.5",
	temperature = 0.1,

	auto_insert_mode = true,
	context = "buffers",
	window = {
		layout = "float",
		width = 80,
		height = 80,
		border = "rounded",
		title = "🤖 AI Assistant",
		zindex = 100,
	},

	headers = {
		user = "👤 You",
		assistant = "🤖 Copilot",
		tool = "🔧 Tool",
	},

	separator = "━━",
	auto_fold = true,
})

map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
		vim.opt_local.signcolumn = "no"
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.g.copilot_no_tab_map = true

vim.g.copilot_settings = {
	selectedCompletionModel = "copilot-codex",
	debounce_ms = 20,
}

--- Accept suggestion
vim.keymap.set("i", "<A-p>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
	silent = true,
})

--- Navigation
vim.keymap.set("i", "<A-]>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<A-[>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<A-x>", "<Plug>(copilot-dismiss)")

--------------------------------------------------
--- For running files inside neovim
--------------------------------------------------
local runners = {
	python = "python %",
	lua = "lua %",
	sh = "bash %",
	javascript = "node %",
	typescript = "ts-node %",
	c = "gcc % -o %< && ./%<",
	cpp = "g++ % -std=c++17 -O2 -o %< && ./%<",
	rust = "rustc % -o %< && ./%<",
	go = "go run %",
	java = "javac % && java %<",
	ruby = "ruby %",
	php = "php %",
	perl = "perl %",
	zig = "zig run %",
}

vim.keymap.set("n", "<leader>rn", function()
	vim.cmd("w")
	local cmd = runners[vim.bo.filetype]

	if not cmd then
		print("No runner for " .. vim.bo.filetype)
		return
	end

	vim.cmd("split | resize 12 | terminal " .. cmd)
	vim.cmd("startinsert")
end)

vim.opt.splitbelow = true
