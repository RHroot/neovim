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
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, noremap = true })
		end

		--- Navigation
		map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "<leader>gr", vim.lsp.buf.references, "Find references")
		map("n", "<leader>gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		--- Diagnostics
		map("n", "<leader>]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, "Next diagnostic")
		map("n", "<leader>[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, "Previous diagnostic")

		--- Workspace
		map("n", "<leader>aw", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("n", "<leader>rw", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
		map("n", "<leader>lw", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Search workspace symbols")

		--- Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>for", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")
	end,
})

--- Diagnostics config
vim.diagnostic.config({
	virtual_text = true,
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
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
})

--- CursorHold diagnostics (non-spammy)
vim.api.nvim_create_autocmd("CursorHold", {
	desc = "Auto-show diagnostics in float",
	callback = function()
		local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		if #diagnostics > 0 then
			vim.diagnostic.open_float({
				scope = "line",
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "if_many",
			})
		end
	end,
})

----------------------------------------------------------
--- OPTS Starts Here
----------------------------------------------------------
--- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes:1"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 9
vim.opt.virtualedit = "all"
vim.opt.cmdheight = 1
vim.g.have_nerd_font = true

--- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.list = true
vim.opt.listchars = "tab:» "

--- Line Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪"
vim.opt.sidescroll = 1

--- Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

--- Files & Backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

--- Persistent Undo Directory Logic
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

--- System & Performance
vim.opt.clipboard = ""
vim.opt.splitbelow = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 250

--- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 0

--- Neovide Specifics
vim.opt.guifont = "JetBrainsMono Nerd Font:h18"
vim.opt.background = "dark"
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_opacity = 0.8
vim.g.transparency = 0.8

----------------------------------------------------------
--- Keymaps Starts Here
----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

--- General
map({ "n", "v", "x" }, ";", ":", { noremap = true, silent = false })
map({ "n", "i", "v", "c", "t", "x", "s", "o" }, "<C-c>", "<Esc>", { noremap = true, silent = false })
map("n", "<leader>w", ":w<CR>", { noremap = true, silent = false })
map("n", "<leader>q", ":q<CR>", { noremap = true, silent = false })
map("n", "<leader>bn", ":bn<CR>", { noremap = true, silent = true })
map("n", "<leader>bp", ":bp<CR>", { noremap = true, silent = true })
map("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })
map("n", "<leader>bc", ":enew<CR>", { noremap = true, silent = true })
map("n", "<F5>", ":edit<CR>", { noremap = true, silent = false })
map("n", "<leader>rt", ":restart<CR>", { noremap = true, silent = false })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
map("n", "<C-c>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
map("n", "<leader>so", ":update<CR> :source<CR>", { noremap = true, silent = false })
map("n", "<leader>si", "<cmd>source ~/.config/nvim/init.lua<CR>", { noremap = true, silent = false })
map({ "v", "x" }, "<C-_>", "gc", { noremap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { noremap = true, silent = true, desc = "Toggle comment" })
map({ "n", "v", "x" }, "<leader>url", function()
	vim.ui.open(vim.fn.expand("<cfile>"))
end, { desc = "Open URL under cursor" })

--- better movement in wrapped text
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (warp-aware)" })
map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (warp-aware)" })

--- To Travel between splits or panes you may call it
map("n", "<C-S-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-S-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-S-l>", "<C-w>l", { noremap = true, silent = true })
map("n", "<C-S-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<leader>sv", ":vsplit<CR>", { noremap = true, silent = true })
map("n", "<leader>sh", ":split<CR>", { noremap = true, silent = true })

--- Prime's remaps
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("n", "J", "mzJ`z", { noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
map("n", "n", "nzzzv", { noremap = true, silent = true })
map("n", "N", "Nzzzv", { noremap = true, silent = true })
map({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, silent = true })
map("n", "<leader>Y", [["+Y]], { noremap = true, silent = true })
map({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true })
map("x", "<leader>p", [["_dP]], { noremap = true, silent = true })

----------------------------------------------------------
--- Plugins Will Added Here
----------------------------------------------------------
vim.pack.add({
	--- Plugins for Colorscheme
	{ src = "https://github.com/folke/tokyonight.nvim" },

	--- Plugins for LSP
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

	--- Plugins for Completion
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },

	--- Plugins for Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	--- Plugins for Parsers
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate", branch = "main" },

	--- Plugins that can be quite useful if you know how to use them from Mini.nvim
	{ src = "https://github.com/nvim-mini/mini.nvim" },

	--- Plugins for AI Completion
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },

	--- Plugins to get Typst Preview
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },

	--- Plugins to get Copilot
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

--------------------------------------------------
--- Colors
--------------------------------------------------
local has_tokyonight, tokyonight = pcall(require, "tokyonight")

if has_tokyonight then
	tokyonight.setup({
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

	vim.cmd.colorscheme("tokyonight")
else
	pcall(vim.cmd.colorscheme, "unokai")
end

--------------------------------------------------
--- LSP Setup
--------------------------------------------------
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		--- LSP's installed through mason
		"zls",
		"nil",
		"jdtls",
		"clangd",
		"rust-analyzer",
		"python-lsp-server",
		"lua-language-server",
		"bash-language-server",
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
		"prettierd",
		"clang-format",
		"google-java-format",
	},
})

--- Define all server configurations manually
local servers = {
	zls = {
		cmd = { "zls" },
		filetypes = { "zig", "zir" },
		root_markers = { "zls.json", "build.zig", ".git" },
	},
	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "templ" },
		root_markers = { "package.json", ".git" },
	},
	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
	},
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
	},
	vtsls = {
		cmd = { "vtsls", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
	},
	pylsp = {
		cmd = { "pylsp" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	},
	jdtls = {
		cmd = { "jdtls" },
		filetypes = { "java" },
		root_markers = { "build.gradle", "pom.xml", ".git" },
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".git" },
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
			},
		},
	},
	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_markers = { ".git", ".shellcheckrc" },
	},
	nil_ls = {
		cmd = { "nil" },
		filetypes = { "nix" },
		root_markers = { "flake.nix", ".git" },
		settings = {
			["nil"] = {
				formatting = {
					command = { "alejandra" },
				},
				diagnostics = {
					ignored = { "unused_binding" },
				},
			},
		},
	},
	clangd = {
		cmd = {
			"clangd",
			"--clang-tidy",
			"--background-index",
			"--header-insertion=never",
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", ".git" },
	},
	tailwindcss = {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = { "html", "css", "javascriptreact", "typescriptreact", "svelte", "vue" },
		root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", ".git" },
	},
	postgres_lsp = {
		cmd = { "postgres_lsp" },
		filetypes = { "sql" },
		root_markers = { ".git" },
	},
	rust_analyzer = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	},
}

--- Setup base blink
local has_blink, blink = pcall(require, "blink.cmp")

--- Apply configurations
for server_name, config in pairs(servers) do
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	config.capabilities = blink.get_lsp_capabilities(capabilities)
	vim.lsp.config(server_name, config)
end

--- Enable all servers
vim.lsp.enable(vim.tbl_keys(servers))

--------------------------------------------------
--- Snippets
--------------------------------------------------
require("mini.snippets").setup({
	snippets = {
		function()
			return {
				{
					prefix = "req",
					body = "local ${1:mod} = require('${1:mod}')",
					desc = "Require module",
					filetype = "lua",
				},
				{
					prefix = "pp",
					body = "print(${1})",
					filetype = "python",
				},
				{
					prefix = "main",
					body = {
						"if __name__ == '__main__':",
						"    ${1:main()}",
					},
					filetype = "python",
				},
				{
					prefix = "cl",
					body = "console.log(${1})",
					filetype = { "javascript", "typescript" },
				},
			}
		end,
	},
})

--------------------------------------------------
--- Completion
--------------------------------------------------
if has_blink then
	blink.build():wait(60000)
	blink.setup({

		sources = {
			default = { "snippets", "lsp", "path", "buffer", "cmdline" },
		},

		snippets = { preset = "mini_snippets" },

		fuzzy = { implementation = "prefer_rust_with_warning" },

		keymap = {
			preset = "none",
			["<CR>"] = { "accept", "fallback" },
			["<Esc>"] = { "hide", "fallback" },
			["<C-e>"] = { "show_documentation", "hide_documentation" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},

		signature = {
			enabled = true,
			window = {
				max_height = 8,
				max_width = 60,
				border = "rounded",
			},
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		completion = {
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
			menu = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			keyword = { range = "full" },
			ghost_text = { enabled = true },
		},
	})
end

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
		fish = { "fishfmt" },
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
		fishfmt = {
			command = "fish_indent",
			args = { "$FILENAME" },
			stdin = true,
		},
		zigfmt = {
			command = "zig",
			args = { "fmt", "$FILENAME" },
			stdin = true,
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
--- Treesitter
--------------------------------------------------
local ts = require("nvim-treesitter")
ts.setup({
	sync_install = true,
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})
ts.install({
	"c",
	"go",
	"cpp",
	"zig",
	"lua",
	"php",
	"css",
	"vim",
	"csv",
	"vue",
	"nix",
	"make",
	"rust",
	"java",
	"bash",
	"ruby",
	"perl",
	"dart",
	"json",
	"html",
	"scss",
	"yaml",
	"toml",
	"diff",
	"just",
	"http",
	"latex",
	"regex",
	"query",
	"vimdoc",
	"swift",
	"cmake",
	"astro",
	"svelte",
	"kotlin",
	"python",
	"elixir",
	"haskell",
	"graphql",
	"markdown",
	"gitcommit",
	"gitignore",
	"javascript",
	"git_rebase",
	"typescript",
	"dockerfile",
	"gitattributes",
	"markdown_inline",
})

--------------------------------------------------
--- Mini ( One line setup Plugins )
--------------------------------------------------
require("mini.ai").setup()
require("mini.icons").setup()
require("mini.extra").setup()
-- require("mini.animate").setup()
require("mini.tabline").setup()
require("mini.surround").setup()
require("mini.operators").setup()
require("mini.cursorword").setup()

--------------------------------------------------
--- Dashboard
--------------------------------------------------
local starter = require("mini.starter")
starter.setup()

--------------------------------------------------
--- Trimming
--------------------------------------------------
require("mini.trailspace").setup()

vim.keymap.set("n", "<Leader>tw", function()
	require("mini.trailspace").trim()
	require("mini.trailspace").trim_last_lines()
end, { desc = "Trim all trailing whitespace & lines" })

--------------------------------------------------
--- Explorer
--------------------------------------------------
local files = require("mini.files")
files.setup({})
map("n", "<leader>e", function()
	files.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open file explorer (Directory of current file)" })
map("n", "<leader>E", function()
	files.open(vim.uv.cwd(), true)
end, { desc = "Open file explorer (cwd)" })

--------------------------------------------------
--- IndentScope
--------------------------------------------------
require("mini.indentscope").setup({
	symbol = "│",
	options = { try_as_border = true },
	draw = {
		delay = 50,
		animation = require("mini.indentscope").gen_animation.none(),
	},
})
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
	fg = "#F09676",
	nocombine = true,
})

--------------------------------------------------
--- MiniMap
--------------------------------------------------
local minimap = require("mini.map")

minimap.setup({
	integrations = {
		minimap.gen_integration.builtin_search(),
		minimap.gen_integration.diagnostic(),
		minimap.gen_integration.gitsigns(),
	},
})

vim.keymap.set("n", "<Leader>mm", minimap.toggle, { desc = "Toggle Minimap" })

--------------------------------------------------
--- Sessions
--------------------------------------------------
local MiniSessions = require("mini.sessions")
MiniSessions.setup({
	autoread = false,
	autowrite = true,
})

vim.keymap.set("n", "<leader>ss", function()
	MiniSessions.select()
end, { desc = "Select Session" })

-- Keybind to save the current state as a new session
vim.keymap.set("n", "<leader>sw", function()
	local name = vim.fn.input("Session name: ")
	if name ~= "" then
		MiniSessions.write(name)
	end
end, { desc = "Write Session" })

vim.keymap.set("n", "<leader>sd", function()
	local name = vim.fn.input("Session name to delete: ")
	if name ~= "" then
		MiniSessions.delete(name)
	end
end, { desc = "Delete Session" })

--------------------------------------------------
--- AutoPairs
--------------------------------------------------
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
		["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },

		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
		[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
	},
})

--------------------------------------------------
--- Notifications
--------------------------------------------------
local ok, mini_notify = pcall(require, "mini.notify")
if not ok then
	vim.notify("mini.notify not found", vim.log.levels.ERROR)
	return
end

mini_notify.setup({
	window = {
		config = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
		max_width_share = 0.382,
	},
	lsp_progress = {
		enable = true,
		duration_last = 1000,
	},
})

vim.notify = mini_notify.make_notify()

map("n", "<leader>nd", mini_notify.clear, { desc = "Dismiss all notifications" })
map("n", "<leader>nh", mini_notify.show_history, { desc = "Notification history" })

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local level_map = {
		[1] = vim.log.levels.ERROR,
		[2] = vim.log.levels.WARN,
		[3] = vim.log.levels.INFO,
		[4] = vim.log.levels.DEBUG,
	}
	local level = level_map[result.type] or vim.log.levels.INFO
	local title = "LSP: " .. (client and client.name or "Unknown")
	local msg = result.message and (title .. "\n" .. result.message) or title

	vim.notify(msg, level)
end

--------------------------------------------------
--- Git
--------------------------------------------------
require("mini.git").setup()
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = {
			add = "+",
			change = "~",
			delete = "_",
		},
	},
})

map("n", "<leader>gs", "<cmd>Git status<CR>", { desc = "Git Status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git Commit" })
map("n", "<leader>gL", "<cmd>Git log --oneline<CR>", { desc = "Git Log" })
map({ "n", "x" }, "<leader>gh", function()
	require("mini.git").show_range_history()
end, { desc = "Git Range History" })
map("n", "]h", function()
	require("mini.diff").goto_hunk("next")
end, { desc = "Next Git Hunk" })
map("n", "[h", function()
	require("mini.diff").goto_hunk("prev")
end, { desc = "Previous Git Hunk" })
map("n", "]H", function()
	require("mini.diff").goto_hunk("last")
end, { desc = "Last Git Hunk" })
map("n", "[H", function()
	require("mini.diff").goto_hunk("first")
end, { desc = "First Git Hunk" })
map("n", "<leader>go", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle Diff Overlay" })

--------------------------------------------------
--- Which Key
--------------------------------------------------
local miniclue = require("mini.clue")

miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },

		-- Built-in commands
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
	},

	clues = {
		miniclue.gen_clues.g(),
		miniclue.gen_clues.z(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
	},
})

--------------------------------------------------
--- Fuzzy Finder
--------------------------------------------------
local pick = require("mini.pick")

-- Auto-generates a config file to force ripgrep to show hidden files (ignoring .git).
local rg_conf = vim.fn.stdpath("data") .. "/ripgrep.conf"
if vim.fn.filereadable(rg_conf) == 0 then
	local f = io.open(rg_conf, "w")
	if f then
		f:write("--hidden\n--glob=!.git/*\n")
		f:close()
	end
end
vim.env.RIPGREP_CONFIG_PATH = rg_conf

pick.setup({
	window = {
		config = function()
			local height = math.floor(0.4 * vim.o.lines)
			return {
				relative = "editor",
				anchor = "SW",
				height = height,
				width = vim.o.columns,
				row = vim.o.lines,
				col = 0,
				border = "solid",
			}
		end,
		prompt_prefix = " 󰍉 => ",
	},
	mappings = {
		toggle_preview = "<M-L>",
		toggle_info = "<M-H>",
		move_down = "<C-j>",
		move_up = "<C-k>",
	},
	options = {
		use_cache = true,
	},
})

vim.ui.select = pick.ui_select

local has_rg = vim.fn.executable("rg") == 1

map("n", "<leader><space>", function()
	if has_rg then
		pick.builtin.files({ command = { "rg" } })
	else
		pick.builtin.files({ command = { "find", ".", "-type", "f", "-not", "-path", "*/.git/*" } })
	end
end, { desc = "Find Files (Hidden)" })
map("n", "<leader>/", function()
	if has_rg then
		pick.builtin.grep_live({ tool = "rg" })
	else
		pick.builtin.grep_live()
	end
end, { desc = "Live Grep" })

map("n", "<leader>bf", "<cmd>Pick buffers<CR>", { desc = "Buffers" })
map("n", "<leader>hp", "<cmd>Pick help<CR>", { desc = "Help Tags" })
map("n", "<leader>rl", "<cmd>Pick resume<CR>", { desc = "Resume Last Picker" })

--------------------------------------------------
--- Statusline
--------------------------------------------------
local statusline = require("mini.statusline")

local function get_lsp()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return "󱏐 "
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return " " .. table.concat(names, "󰇙") --- Using a subtle separator
end

local function get_file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%:p"))
	if size <= 0 then
		return ""
	end
	local units = { "B", "K", "M", "G" }
	local i = 1
	while size > 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	return string.format("󰗮 %.1f%s", size, units[i])
end

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git = statusline.section_git({ trunc_width = 40 })
			local diff = statusline.section_diff({ trunc_width = 75 })
			local diag = statusline.section_diagnostics({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "StatusLineGit", strings = { git } },
				{ hl = "StatusLineDiff", strings = { diff } },
				"%<", --- Truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", --- Right align
				{ hl = "StatusLineLsp", strings = { get_lsp() } },
				{ hl = "StatusLineDiag", strings = { diag } },
				{ hl = "MiniStatuslineFileinfo", strings = { get_file_size(), fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
})

local hi = function(name, opts)
	vim.api.nvim_set_hl(0, name, opts)
end

--- Base background for the whole bar
hi("StatusLine", { bg = "#181825", fg = "#cdd6f4" })
--- Left side: Blue/Peach tones for Project info
hi("StatusLineGit", { fg = "#89b4fa", bg = "#313244", bold = true })
hi("StatusLineDiff", { fg = "#fab387", bg = "#313244" })
--- Middle: Clean and readable
hi("MiniStatuslineFilename", { fg = "#cdd6f4", bg = "#181825", italic = true })
--- Right side: Green/Mauve for Environment info
hi("StatusLineLsp", { fg = "#a6e3a1", bg = "#313244" })
hi("StatusLineDiag", { fg = "#f38ba8", bg = "#313244" })
hi("MiniStatuslineFileinfo", { fg = "#bac2de", bg = "#313244" })
--- Mode Overrides (Optional: Makes mode colors pop more)
hi("MiniStatuslineModeNormal", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
hi("MiniStatuslineModeInsert", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
hi("MiniStatuslineModeVisual", { fg = "#1e1e2e", bg = "#cba6f7", bold = true })
hi("MiniStatuslineModeReplace", { fg = "#1e1e2e", bg = "#f38ba8", bold = true })
hi("MiniStatuslineModeCommand", { fg = "#1e1e2e", bg = "#f9e2af", bold = true })

--------------------------------------------------
--- Mini Hipatterns
--------------------------------------------------
local hipatterns = require("mini.hipatterns")

local function get_luminance(r, g, b)
	local function calc(c)
		return c <= 0.03928 and (c / 12.92) or ((c + 0.055) / 1.055) ^ 2.4
	end
	return 0.2126 * calc(r) + 0.7152 * calc(g) + 0.0722 * calc(b)
end

local cache = {}
local function make_highlight(hex)
	if cache[hex] then
		return cache[hex]
	end

	local name = "MiniHipatterns_" .. hex:sub(2)
	if vim.fn.hlexists(name) == 0 then
		local r = tonumber(hex:sub(2, 3), 16) / 255
		local g = tonumber(hex:sub(4, 5), 16) / 255
		local b = tonumber(hex:sub(6, 7), 16) / 255

		local fg = get_luminance(r, g, b) > 0.179 and "#000000" or "#ffffff"
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = hex })
	end

	cache[hex] = name
	return name
end

--- Color Conversions
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

--- Highlight Group Generators
local function hex_group(_, match)
	return make_highlight(match)
end

local function short_hex_group(_, match)
	local hex = "#" .. match:sub(2):gsub(".", "%1%1")
	return make_highlight(hex)
end

local function alpha_hex_group(_, match)
	local hex = match:sub(1, 7) -- Strip alpha channel for the background color
	return make_highlight(hex)
end

local function rgb_group(_, match)
	local r, g, b = match:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if not r or r > 255 or g > 255 or b > 255 then
		return
	end
	return make_highlight(to_hex(r / 255, g / 255, b / 255))
end

local function hsl_group(_, match)
	local h, s, l = match:match("(%d+%.?%d*)%s*,%s*(%d+%.?%d*)%%?%s*,%s*(%d+%.?%d*)%%?")
	h, s, l = tonumber(h), tonumber(s), tonumber(l)
	if not h or h > 360 or not s or s > 100 or not l or l > 100 then
		return
	end
	return make_highlight(to_hex(hsl_to_rgb(h, s, l)))
end

--- Setup
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w_]()FIXME()%f[^%w_]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w_]()HACK()%f[^%w_]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w_]()TODO()%f[^%w_]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w_]()NOTE()%f[^%w_]", group = "MiniHipatternsNote" },
		hex_alpha = { pattern = "#%x%x%x%x%x%x%x%x%f[%X]", group = alpha_hex_group },
		hex = { pattern = "#%x%x%x%x%x%x%f[%X]", group = hex_group },
		hex_short = { pattern = "#%x%x%x%f[%X]", group = short_hex_group },
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
--- Typst Preview
--------------------------------------------------
require("typst-preview").setup({
	debug = false,
	-- Custom format string to open the output link provided with %s
	-- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
	open_cmd = nil,
	-- Custom port to open the preview server. Default is random.
	port = 8000,
	-- Custom host to bind the preview server to.
	host = "127.0.0.1",
	invert_colors = "never",
	-- Whether the preview will follow the cursor in the source file
	follow_cursor = true,
	dependencies_bin = {
		tinymist = nil,
		websocat = nil,
	},
	-- For example, extra_args = { "--input=ver=draft", "--ignore-system-fonts" }
	extra_args = nil,
	-- This function will be called to determine the root of the typst project
	get_root = function(path_of_main_file)
		local root = os.getenv("TYPST_ROOT")
		if root then
			return root
		end
		-- Look for a project marker so imports from parent dirs stay inside root
		local main_dir = vim.fs.dirname(vim.fn.fnamemodify(path_of_main_file, ":p"))
		local found = vim.fs.find({ "typst.toml", ".git" }, { path = main_dir, upward = true })
		if #found > 0 then
			return vim.fs.dirname(found[1])
		end
		return main_dir
	end,
	get_main_file = function(path_of_buffer)
		return path_of_buffer
	end,
})

--------------------------------------------------
--- AI Completion
--------------------------------------------------
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<M-p>",
		clear_suggestion = "<M-[>",
		accept_word = "<M-w>",
	},
	ignore_filetypes = { "bigfile", "log" },
	log_level = "info",
	disable_inline_completion = false,
	disable_keymaps = false,
	condition = function()
		return false
	end,
})

--------------------------------------------------
--- Copilot
--------------------------------------------------
local has_chat, chat = pcall(require, "CopilotChat")
if has_chat then
	chat.setup({

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
end

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

vim.o.splitbelow = true
