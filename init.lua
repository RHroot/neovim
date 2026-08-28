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

--- VirtualEdit Mode (for better cursor placement)
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if vim.fn.mode() == "n" then
			vim.opt.virtualedit = "all"
		else
			vim.opt.virtualedit = ""
		end
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
vim.opt.listchars = { tab = "» ", space = "·", trail = "✕" }

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
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 1000

--- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 0

--- Neovide Specifics
vim.opt.guifont = "FiraCode Nerd Font:h18"
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
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
map("t", "<C-c>", "<C-c>", { noremap = true, silent = true })
map("n", "<leader>tt", ":terminal<CR>", { noremap = true, silent = true })
map("n", "<leader>so", ":update<CR> :source<CR>", { noremap = true, silent = false })
map({ "v", "x" }, "<C-_>", "gc", { noremap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { noremap = true, silent = true, desc = "Toggle comment" })

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
map("n", "J", "mzJ`z", { noremap = true, silent = true })
map("n", "n", "nzzzv", { noremap = true, silent = true })
map("n", "N", "Nzzzv", { noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
map("n", "<leader>Y", [["+Y]], { noremap = true, silent = true })
map("x", "<leader>p", [["_dP]], { noremap = true, silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true })
map({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, silent = true })

----------------------------------------------------------
--- Plugins Will Added Here
----------------------------------------------------------
vim.pack.add({
	--- Plugins for Colorscheme
	{ src = "https://github.com/folke/tokyonight.nvim" },

	--- Undo Tree
	{ src = "https://github.com/mbbill/undotree" },

	--- Plugins for Completion
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },

	--- Plugins for Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	--- Plugins that can be quite useful if you know how to use them from Mini.nvim
	{ src = "https://github.com/nvim-mini/mini.nvim" },

	--- Plugins for AI Completion
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },

	--- Plugins for Markdown Preview
	{ src = "https://github.com/vihu/penview.nvim" },
})

--------------------------------------------------
--- Undo Tree
--------------------------------------------------
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

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
			variables = { bold = true },
			sidebars = "transparent",
			floats = "transparent",
		},
	})

	vim.cmd.colorscheme("tokyonight")
else
	pcall(vim.cmd.colorscheme, "unokai")
end

--------------------------------------------------
--- Markdown Rendering
--------------------------------------------------
local bin_exists = false
local bin_paths = {
	"bin/penview",
	"penview",
	"target/release/penview",
}

for _, path in ipairs(bin_paths) do
	if #vim.api.nvim_get_runtime_file(path, false) > 0 then
		bin_exists = true
		break
	end
end

if not bin_exists then
	print("Building penview binary... (This should only happen once)")
	require("penview.build").install()
end

require("penview").setup({
	browser = vim.env.BROWSER or "brave",
})

map("n", "<leader>po", "<cmd>PenviewStart<CR>", { desc = "[P]review [O]pen" })
map("n", "<leader>pc", "<cmd>PenviewStop<CR>", { desc = "[P]review [C]lose" })
--------------------------------------------------
--- LSP Setup
--------------------------------------------------
local servers = {
	pylsp = {
		cmd = { "pylsp" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	},
	sqls = {
		cmd = { "sqls" },
		filetypes = { "sql" },
		root_markers = { ".git" },
	},
	rust_analyzer = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	},
	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_markers = { ".git", ".shellcheckrc" },
	},
	marksman = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown", "markdown.mdx" },
		root_markers = { ".marksman.toml", ".git" },
		cmd_env = {
			DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1",
		},
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".git" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = (function()
						local paths = vim.api.nvim_get_runtime_file("", true)
						local hypr_paths = {
							"/run/current-system/sw/share/hypr/stubs",
							"/usr/share/hypr/stubs",
							"/usr/local/share/hypr/stubs",
							vim.fn.expand("~/.local/share/hypr/stubs"),
						}
						for _, p in ipairs(hypr_paths) do
							if vim.fn.isdirectory(p) == 1 then
								table.insert(paths, p)
							end
						end
						return paths
					end)(),
					checkThirdParty = false,
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
			"--query-driver=/run/current-system/sw/bin/gcc,/run/current-system/sw/bin/clang,/usr/bin/gcc,/usr/bin/clang",
			"--compile-commands-dir=.",
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", ".git" },
		init_options = {
			clangd = {
				headerInsertion = "never",
			},
		},
		env = {
			CPATH = "/run/current-system/sw/include:/nix/store/*-glibc-*/include:/usr/include:/usr/local/include",
			C_INCLUDE_PATH = "/run/current-system/sw/include:/nix/store/*-glibc-*/include:/usr/include:/usr/local/include",
			CPLUS_INCLUDE_PATH = "/run/current-system/sw/include:/nix/store/*-glibc-*/include:/usr/include:/usr/local/include",
		},
	},
}

--- Setup base blink
local has_blink, blink = pcall(require, "blink.cmp")
--
-- --- Apply configurations
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
		--- Data / query
		sql = { "sql_formatter" },

		--- Markdown
		markdown = { "mdformat" },

		--- Infra / scripts
		sh = { "shfmt" },
		bash = { "shfmt" },
		nix = { "nixfmt" },

		--- Core languages
		lua = { "stylua" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		python = { "ruff_organize_imports", "ruff_format" },

		--- Web / frontend
		css = { "prettierd" },
		vue = { "prettierd" },
		html = { "prettierd" },
		scss = { "prettierd" },
		less = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		toml = { "prettierd" },
		jsonc = { "prettierd" },
		svelte = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		dockerfile = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
	},

	formatters = {
		shfmt = {
			command = "shfmt",
			args = { "-i", "2", "-bn", "-ci", "-ln", "bash" },
			stdin = true,
		},
	},
	default_format_opts = {
		lsp_format = "fallback",
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
--- Notifications
--------------------------------------------------
local ok, mini_notify = pcall(require, "mini.notify")
if not ok then
	vim.notify("mini.notify not found", vim.log.levels.ERROR)
	return
end

mini_notify.setup({
	window = {
		config = {
			row = 1,
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
		max_width_share = 0.400,
	},
	lsp_progress = {
		enable = true,
		duration_last = 1000,
	},
})

vim.notify = mini_notify.make_notify({
	ERROR = { duration = 5000 },
	WARN = { duration = 4000 },
	INFO = { duration = 3000 },
})

map("n", "<leader>nd", mini_notify.clear, { desc = "Dismiss all notifications" })
map("n", "<leader>nh", mini_notify.show_history, { desc = "Notification history" })

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
		prompt_prefix = "󰍉=> ",
	},
	mappings = {
		move_up = "<C-k>",
		move_down = "<C-j>",
		move_up = "<S-Tab>",
		move_down = "<Tab>",
		toggle_info = "<M-H>",
		toggle_preview = "<M-L>",
	},
	options = {
		use_cache = false,
	},
})

vim.ui.select = pick.ui_select

local has_rg = vim.fn.executable("rg") == 1

local function pick_cli_with_icons(command)
	pick.builtin.cli({
		command = command,
		postprocess = function(lines)
			local items = {}
			for _, line in ipairs(lines) do
				if line ~= "" then
					table.insert(items, { path = line, text = line })
				end
			end
			return items
		end,
	}, {
		source = {
			show = function(buf_id, items, query)
				pick.default_show(buf_id, items, query, { show_icons = true })
			end,
		},
	})
end

map("n", "<leader><space>", function()
	if has_rg then
		pick_cli_with_icons({
			"sh",
			"-c",
			"rg --files --no-ignore --hidden --glob=!.git/* --glob=!.cache/* --glob=!.local/* --glob=!node_modules/*",
		})
	else
		pick_cli_with_icons({
			"sh",
			"-c",
			"find -L . -type f -not -path '*/.git/*' -not -path '*/.cache/*' -not -path '*/.local/*' -not -path '*/node_modules/*'",
		})
	end
end, { desc = "Find Files" })

local function static_grep_with_icons()
	local cmd_str
	if has_rg then
		cmd_str =
			'rg --line-number --no-heading --color=never --hidden --no-messages --glob=!.git/* --glob=!.cache/* --glob=!.local/* --glob=!node_modules/* --no-ignore "" . 2>/dev/null || true'
	else
		cmd_str =
			'grep -Rna --exclude-dir=.git --exclude-dir=.cache --exclude-dir=.local --exclude-dir=node_modules "" . 2>/dev/null || true'
	end

	pick.builtin.cli({
		command = { "sh", "-c", cmd_str },
		postprocess = function(lines)
			local items = {}
			for _, line in ipairs(lines) do
				if line ~= "" then
					local file, lnum, text = line:match("^(.-):(%d+):(.*)$")
					if file and lnum then
						file = file:gsub("^%./", "")
						table.insert(items, {
							path = file,
							lnum = tonumber(lnum),
							text = line,
						})
					end
				end
			end
			return items
		end,
	}, {
		source = {
			show = function(buf_id, items, query)
				pick.default_show(buf_id, items, query, { show_icons = true })
			end,
		},
	})
end
map("n", "<leader>/", static_grep_with_icons, { desc = "Static Grep" })

map("n", "<leader>bf", "<cmd>Pick buffers<CR>", { desc = "Buffers" })
map("n", "<leader>hp", "<cmd>Pick help<CR>", { desc = "Help Tags" })
map("n", "<leader>rl", "<cmd>Pick resume<CR>", { desc = "Resume Last Picker" })

--------------------------------------------------
--- Mini Statusline
--------------------------------------------------
local st = require("mini.statusline")

-- Tokyonight colors
local sbg = "#1a1b26"
local sbg_alt = "#24283b"
local sfg = "#c0caf5"
local scomment = "#3b4261"

-- Accent colors
local cyan = "#7dcfff"
local blue = "#7aa2f7"
local purple = "#bb9af7"
local green = "#9ece6a"
local orange = "#ff9e64"
local red = "#f7768e"

-- Set highlights
vim.api.nvim_set_hl(0, "StatusLine", { bg = sbg, fg = sfg })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = sbg_alt, fg = scomment })
vim.api.nvim_set_hl(0, "StatusLineGit", { fg = orange, bg = sbg })
vim.api.nvim_set_hl(0, "StatusLineDiff", { fg = green, bg = sbg })
vim.api.nvim_set_hl(0, "StatusLineLsp", { fg = blue, bg = sbg })
vim.api.nvim_set_hl(0, "StatusLineDiag", { fg = red, bg = sbg, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = purple, bg = sbg, bold = true })

-- Mode colors (high contrast)
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = sbg, bg = blue, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = sbg, bg = green, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = sbg, bg = purple, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = sbg, bg = cyan, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = sbg, bg = red, bold = true })

-- Helper functions
local function lsp()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return " " .. table.concat(names, " ")
end

local function size()
	local s = vim.fn.getfsize(vim.fn.expand("%:p"))
	if s <= 0 then
		return ""
	end
	local units = { "B", "K", "M", "G" }
	local i = 1
	while s > 1024 and i < #units do
		s = s / 1024
		i = i + 1
	end
	return string.format("󰗮 %.1f%s", s, units[i])
end

-- Setup
st.setup({
	content = {
		active = function()
			local mode, mode_hl = st.section_mode({ trunc_width = 120 })
			return st.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "StatusLineGit", strings = { st.section_git({ trunc_width = 40 }) } },
				{ hl = "StatusLineDiff", strings = { st.section_diff({ trunc_width = 75 }) } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { st.section_filename({ trunc_width = 140 }) } },
				"%=",
				{ hl = "StatusLineLsp", strings = { lsp() } },
				{ hl = "StatusLineDiag", strings = { st.section_diagnostics({ trunc_width = 75 }) } },
				{ hl = "MiniStatuslineFileinfo", strings = { size() } },
				{ hl = mode_hl, strings = { st.section_location({ trunc_width = 75 }) } },
			})
		end,
	},
})

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
		note = { pattern = "%f[%w_]()NOTE()%f[^%w_]", group = "MiniHipatternsNote" },
		todo = { pattern = "%f[%w_]()TODO()%f[^%w_]", group = "MiniHipatternsTodo" },
		hack = { pattern = "%f[%w_]()HACK()%f[^%w_]", group = "MiniHipatternsHack" },
		fixme = { pattern = "%f[%w_]()FIXME()%f[^%w_]", group = "MiniHipatternsFixme" },
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
})

--------------------------------------------------
--- For running files inside neovim
--------------------------------------------------
local runners = {
	python = "python %",
	lua = "lua %",
	sh = "bash %",
	javascript = "node %",
	typescript = "ts-node %",
	c = "clang % -o %< && ./%<",
	cpp = "clang++ % -std=c++17 -O2 -o %< && ./%<",
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
	local cmd_template = runners[vim.bo.filetype]

	if not cmd_template then
		print("No runner for " .. vim.bo.filetype)
		return
	end

	local file = vim.fn.expand("%")
	local file_no_ext = vim.fn.expand("%<")

	local cmd = cmd_template:gsub("%%<", file_no_ext):gsub("%%", file)

	vim.cmd("split | resize 12 | terminal " .. cmd)
	vim.cmd("startinsert")
end)

vim.o.splitbelow = true
