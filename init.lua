----------------------------------------------------------
--- Auto Commands
----------------------------------------------------------
--- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 120 })
	end,
})

--- Auto-change cwd when entering a buffer
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local dir = vim.fn.expand("%:p:h")
		if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
			vim.cmd("lcd " .. vim.fn.fnameescape(dir))
		end
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

--- Restore Cursor Position on Reopen
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		if vim.bo[args.buf].filetype == "gitcommit" then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)

		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

--- CursorHold diagnostics
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

--- Completion
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

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
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
		map("n", "<leader>gr", vim.lsp.buf.references, "Find references")
		map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "<leader>gi", vim.lsp.buf.implementation, "Go to implementation")

		--- Diagnostics
		map("n", "<leader>d", function()
			vim.diagnostic.setqflist()
			vim.cmd("copen")
		end, "Show Diagnostics")
		map("n", "<leader>]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, "Next Diagnostic")
		map("n", "<leader>[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, "Previous Diagnostic")

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

----------------------------------------------------------
--- Options Starts Here
----------------------------------------------------------
--- UI & Appearance
vim.opt.title = true
vim.opt.cmdheight = 1
vim.opt.scrolloff = 9
vim.opt.number = true
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.virtualedit = "all"
vim.opt.background = "dark"
vim.opt.signcolumn = "yes:1"
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.relativenumber = true
vim.opt.guifont = "FiraCode Nerd Font:h18"

--- Tabs & Indentation
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.listchars = { tab = "» ", space = "·", trail = "✕" }

--- Line Wrapping
vim.opt.wrap = true
vim.opt.showbreak = "↪"
vim.opt.sidescroll = 1
vim.opt.linebreak = true

--- Search Settings
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

--- Files & Backup
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.swapfile = false

--- Spelling
vim.wo.spell = true
vim.opt.spelllang = "en"
vim.opt_global.spell = true

--- Persistent Undo Directory Logic
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

--- System & Performance
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 1000
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"

--- Folding
vim.opt.foldlevel = 0
vim.opt.foldenable = false
vim.opt.foldmethod = "indent"

--- Global Options
vim.g.netrw_banner = 0
vim.g.netrw_altfile = 1
vim.g.netrw_winsize = 25
vim.g.transparency = 0.8
vim.g.netrw_liststyle = 3
vim.g.netrw_browser_split = 0
vim.g.have_nerd_font = true
vim.g.neovide_opacity = 0.8
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_bottom = 0

----------------------------------------------------------
--- Keymaps
----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

--- General
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (warp-aware)" })
map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (warp-aware)" })
map({ "n", "v", "x" }, ";", ":", { noremap = true, silent = false })
map({ "n", "i", "v", "c", "t", "x", "s", "o" }, "<C-c>", "<Esc>", { noremap = true, silent = false })
map("n", "<leader>w", ":w<CR>", { noremap = true, silent = false })
map("n", "<leader>q", ":q<CR>", { noremap = true, silent = false })
map("n", "<leader>bn", ":bn<CR>", { noremap = true, silent = false })
map("n", "<leader>bp", ":bp<CR>", { noremap = true, silent = false })
map("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = false })
map("n", "<leader>bc", ":enew<CR>", { noremap = true, silent = false })
map("n", "<leader>sh", ":split<CR>", { noremap = true, silent = true })
map("n", "<leader>sv", ":vsplit<CR>", { noremap = true, silent = true })
map("n", "<leader>e", ":Lexplore<CR>", { noremap = true, silent = false })
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
map("n", "<leader>sp", function()
	vim.wo.spell = not vim.wo.spell
	vim.notify("Spell " .. (vim.wo.spell and "on" or "off"), vim.log.levels.INFO)
end, { silent = true, desc = "Toggle spellcheck" })
map("n", "<leader>ch", function()
	vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.expand("~")))
	vim.notify("Changed cwd to home", vim.log.levels.INFO)
end, { desc = "Change cwd to home" })
map("n", "<leader>cp", function()
	local dir = vim.fn.input("Change cwd to: ", vim.fn.getcwd(), "dir")
	if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
		vim.cmd("cd " .. vim.fn.fnameescape(dir))
		vim.notify("Changed cwd to: " .. vim.fn.fnamemodify(dir, ":~"), vim.log.levels.INFO)
	elseif dir ~= "" then
		vim.notify("Directory not found: " .. dir, vim.log.levels.ERROR)
	end
end, { desc = "Change cwd to specified directory" })

--- To move around neovim panes and tmux panes
local function tmux_nav(dir)
	local tmux_dir = ({ h = "-L", j = "-D", k = "-U", l = "-R" })[dir]

	if vim.fn.exists("$TMUX") == 1 and vim.fn.winnr() == vim.fn.winnr(dir) then
		vim.fn.system("tmux select-pane " .. tmux_dir)
	else
		vim.cmd("wincmd " .. dir)
	end
end
vim.keymap.set("n", "<C-h>", function()
	tmux_nav("h")
end, { silent = true, desc = "Move to left split/tmux pane" })
vim.keymap.set("n", "<C-j>", function()
	tmux_nav("j")
end, { silent = true, desc = "Move to lower split/tmux pane" })
vim.keymap.set("n", "<C-k>", function()
	tmux_nav("k")
end, { silent = true, desc = "Move to upper split/tmux pane" })
vim.keymap.set("n", "<C-l>", function()
	tmux_nav("l")
end, { silent = true, desc = "Move to right split/tmux pane" })

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

----------------------------------------------------------
--- Colorscheme
----------------------------------------------------------
-- if pcall(vim.cmd.colorscheme, "unokai") then
if pcall(vim.cmd.colorscheme, "catppuccin") then
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

----------------------------------------------------------
--- LSP
----------------------------------------------------------
local servers = {
	sqls = {
		cmd = { "sqls" },
		filetypes = { "sql" },
		root_markers = { ".git" },
	},
	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_markers = { ".git", ".shellcheckrc" },
	},
	rust_analyzer = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	},
	pylsp = {
		cmd = { "pylsp" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	},
	marksman = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown", "markdown.mdx" },
		root_markers = { ".marksman.toml", ".git" },
		cmd_env = { DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1" },
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".git" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = (function()
						-- Improved: only index 'lua' directories to prevent massive performance hits
						local paths = vim.api.nvim_get_runtime_file("lua", true)
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
		init_options = { clangd = { headerInsertion = "never" } },
		env = {
			CPATH = "/run/current-system/sw/include:/usr/include:/usr/local/include",
			C_INCLUDE_PATH = "/run/current-system/sw/include:/usr/include:/usr/local/include",
			CPLUS_INCLUDE_PATH = "/run/current-system/sw/include:/usr/include:/usr/local/include",
		},
	},
}

-- Native capabilities with snippet support enabled
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

--- Apply configurations
for server_name, config in pairs(servers) do
	config.capabilities = capabilities
	vim.lsp.config(server_name, config)
end

--- Enable all servers
vim.lsp.enable(vim.tbl_keys(servers))

----------------------------------------------------------
--- Find Files
----------------------------------------------------------
function _G.native_find(text, _)
	local cmd
	if vim.fn.executable("rg") == 1 then
		cmd = { "rg", "--files", "--hidden", "--glob", "!.git" }
	elseif vim.fn.executable("fd") == 1 then
		cmd = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
	else
		-- POSIX fallback
		cmd = { "find", ".", "-type", "f", "-not", "-path", "*/.git/*", "-not", "-path", "*/node_modules/*" }
	end

	local files = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 then
		return {}
	end

	-- Clean up "./" prefix from POSIX find
	if vim.fn.executable("rg") == 0 and vim.fn.executable("fd") == 0 then
		for i, f in ipairs(files) do
			files[i] = f:sub(1, 2) == "./" and f:sub(3) or f
		end
	end

	return vim.fn.matchfuzzy(files, text)
end
vim.opt.findfunc = "v:lua.native_find"
map("n", "<leader>ff", ":find ", { silent = false })

----------------------------------------------------------
--- Grep Files
----------------------------------------------------------
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
	vim.opt.grepformat = "%f:%l:%c:%m"
else
	vim.opt.grepprg = "grep -Rn --exclude-dir=.git --exclude-dir=node_modules"
	vim.opt.grepformat = "%f:%l:%m"
end
map("n", "<leader>rg", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if not pattern or pattern == "" then
			return
		end

		local cmd, fmt
		if vim.fn.executable("rg") == 1 then
			cmd = { "rg", "--vimgrep", "--smart-case", "--hidden", pattern }
			fmt = "%f:%l:%c:%m"
		else
			-- POSIX fallback
			cmd = { "grep", "-Rn", "--exclude-dir=.git", "--exclude-dir=node_modules", pattern, "." }
			fmt = "%f:%l:%m"
		end

		vim.system(cmd, { text = true }, function(out)
			vim.schedule(function()
				local lines = vim.split(out.stdout or "", "\n")
				if #lines > 0 and lines[#lines] == "" then
					table.remove(lines)
				end

				if #lines > 0 then
					vim.fn.setqflist({}, " ", { title = "Grep: " .. pattern, lines = lines, efm = fmt })
					vim.cmd("copen")
				else
					vim.notify("No matches found for: " .. pattern, vim.log.levels.INFO)
				end
			end)
		end)
	end)
end, { silent = true })

----------------------------------------------------------
--- Formatting
----------------------------------------------------------
local fmts = {
	nixfmt = { "nixfmt", "-" },
	stylua = { "stylua", "-" },
	mdformat = { "mdformat", "-" },
	sql_formatter = { "sql-formatter" },
	["clang-format"] = { "clang-format" },
	prettierd = { "prettierd", "%filepath%" },
	rustfmt = { "rustfmt", "--emit", "stdout" },
	shfmt = { "shfmt", "-i", "2", "-bn", "-ci", "-ln", "bash" },
	ruff = { "ruff", "format", "--stdin-filename", "%", "-" },
	ruff_isort = { "ruff", "check", "--select", "I", "--fix", "--silent", "--exit-zero", "--stdin-filename", "%", "-" },
}

local ft_map = {
	sh = { "shfmt" },
	nix = { "nixfmt" },
	lua = { "stylua" },
	bash = { "shfmt" },
	rust = { "rustfmt" },
	c = { "clang-format" },
	cpp = { "clang-format" },
	markdown = { "mdformat" },
	sql = { "sql_formatter" },
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
	python = { "ruff_isort", "ruff" },
}

local function strip_trailing_ws(buf)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local changed = false

	for i, line in ipairs(lines) do
		local stripped = line:gsub("%s+$", "")
		if stripped ~= line then
			lines[i] = stripped
			changed = true
		end
	end

	if changed then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		local safe_row = math.min(cursor[1], #lines)
		local safe_col = math.min(cursor[2], #lines[safe_row] or 0)
		vim.api.nvim_win_set_cursor(0, { safe_row, safe_col })
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local buf, ft = args.buf, vim.bo[args.buf].filetype
		local fname = vim.api.nvim_buf_get_name(buf)
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local input = table.concat(lines, "\n") .. "\n"
		local applied = false

		-- 1. Try custom formatters (if executable)
		if ft_map[ft] then
			for _, name in ipairs(ft_map[ft]) do
				local def = fmts[name]
				if def and vim.fn.executable(def[1]) == 1 then
					local cmd = vim.deepcopy(def)
					for i, v in ipairs(cmd) do
						cmd[i] = v:gsub("%%filepath%%", fname):gsub("%%", fname)
					end
					local out = vim.fn.system(cmd, input)
					if vim.v.shell_error == 0 then
						input, applied = out, true
					end
				end
			end

			if applied then
				local out = vim.split(input, "\n")

				if #out > 0 and out[#out] == "" then
					table.remove(out)
				end
				if #out == 0 then
					table.insert(out, "")
				end

				local cursor = vim.api.nvim_win_get_cursor(0)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)

				local safe_row = math.min(cursor[1], #out)
				local safe_col = math.min(cursor[2], #out[safe_row] or 0)

				vim.api.nvim_win_set_cursor(0, { safe_row, safe_col })
				return
			end
		end

		-- 2. Fallback to LSP
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
			if c:supports_method("textDocument/formatting") then
				vim.lsp.buf.format({ bufnr = buf, async = false })
				return
			end
		end

		-- 3. No formatter found
		if ft ~= "markdown" then
			strip_trailing_ws(buf)
		end
	end,
})

----------------------------------------------------------
--- Status Line
----------------------------------------------------------
local function setup_statusline_highlights()
	local function get_c(name, attr, fallback)
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
		if not ok or not hl then
			return fallback
		end
		return hl[attr] or fallback
	end

	local stl_bg = get_c("StatusLine", "bg", "#1e1e2e")
	local stl_fg = get_c("StatusLine", "fg", "#cdd6f4")

	local mode_colors = {
		StlNormal = get_c("Directory", "fg", "#89b4fa"),
		StlInsert = get_c("String", "fg", "#a6e3a1"),
		StlVisual = get_c("Special", "fg", "#f5c2e7"),
		StlCommand = get_c("Type", "fg", "#f9e2af"),
		StlReplace = get_c("ErrorMsg", "fg", "#f38ba8"),
		StlTerminal = get_c("Title", "fg", "#94e2d5"),
	}
	for group, bg in pairs(mode_colors) do
		vim.api.nvim_set_hl(0, group, { fg = stl_bg, bg = bg, bold = true })
	end

	vim.api.nvim_set_hl(0, "StlGit", {
		fg = "#7287fd",
		bg = stl_bg,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlMacro", {
		fg = stl_bg,
		bg = get_c("Constant", "fg", "#fab387"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlDiagError", {
		fg = stl_bg,
		bg = get_c("Error", "fg", "#f38ba8"),
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StlDiagWarn", {
		fg = stl_bg,
		bg = get_c("Constant", "fg", "#fab387"),
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StlDiagInfo", {
		fg = stl_bg,
		bg = stl_fg,
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StlDiagHint", {
		fg = stl_bg,
		bg = get_c("String", "fg", "#a6e3a1"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlLsp", {
		fg = stl_bg,
		bg = get_c("Keyword", "fg", "#cba6f7"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlFiletype", {
		fg = stl_bg,
		bg = get_c("Operator", "fg", "#89dceb"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlPosition", {
		fg = stl_bg,
		bg = get_c("Character", "fg", "#f2cdcd"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlProgress", {
		fg = stl_bg,
		bg = get_c("String", "fg", "#a6e3a1"),
		bold = true,
	})

	vim.api.nvim_set_hl(0, "StlPath", { fg = stl_fg, bg = stl_bg })
end

setup_statusline_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_statusline_highlights })

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
	callback = function(ev)
		local clients = vim.lsp.get_clients({ bufnr = ev.buf })
		local names = {}
		for _, c in ipairs(clients) do
			table.insert(names, c.name)
		end
		vim.b[ev.buf].lsp_names = #names > 0 and table.concat(names, ",") or ""
	end,
})

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

function _G._statusline()
	local raw_mode = vim.fn.mode()
	local mode = modes[raw_mode] or raw_mode:upper()

	local base = raw_mode:sub(1, 1)
	local hl = "StlNormal"
	if base == "i" then
		hl = "StlInsert"
	elseif base == "v" or base == "V" or base == "\22" or base == "s" or base == "S" or base == "\19" then
		hl = "StlVisual"
	elseif base == "c" then
		hl = "StlCommand"
	elseif base == "R" then
		hl = "StlReplace"
	elseif base == "t" then
		hl = "StlTerminal"
	end

	local mode_str = "%#" .. hl .. "# " .. mode .. " %*"
	local branch = vim.b.git_branch and "%#StlGit#  " .. vim.b.git_branch .. " %*" or ""
	local path = "%#StlPath# " .. (vim.b.rel_path or "%f") .. " %m%r%h%w %*"

	local macro = ""
	local reg = vim.fn.reg_recording()
	if reg ~= "" then
		macro = "%#StlMacro# 󰑋 @" .. reg .. " %*"
	end

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local diag_map = {
		{ sev = 1, icon = "󰅚", group = "StlDiagError" },
		{ sev = 2, icon = "󰀪", group = "StlDiagWarn" },
		{ sev = 3, icon = "󰋽", group = "StlDiagInfo" },
		{ sev = 4, icon = "󰌶", group = "StlDiagHint" },
	}
	for _, d in ipairs(diag_map) do
		if counts[d.sev] and counts[d.sev] > 0 then
			diag = diag .. "%#" .. d.group .. "# " .. d.icon .. " " .. counts[d.sev] .. " %*"
		end
	end

	local lsp = ""
	if vim.b.lsp_names and vim.b.lsp_names ~= "" then
		lsp = "%#StlLsp# 󰒋 " .. vim.b.lsp_names .. " %*"
	end

	local ft = "%#StlFiletype# " .. (vim.bo.filetype ~= "" and vim.bo.filetype or "plain") .. " %*"

	local pos = "%#StlPosition#  " .. "%l:%c %*"

	local progress = "%#StlProgress# %p%% %*"

	return mode_str .. branch .. path .. "%=" .. macro .. diag .. lsp .. ft .. pos .. progress
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.b.git_root ~= nil then
			return
		end
		local filepath = vim.fn.expand("%:p")
		local filedir = vim.fn.fnamemodify(filepath, ":h")
		local root = vim.fn.system({ "git", "-C", filedir, "rev-parse", "--show-toplevel" }):gsub("%s+$", "")
		if root ~= "" and not root:match("^fatal:") then
			vim.b.git_root = root
			vim.b.git_branch = vim.fn.system({ "git", "-C", root, "branch", "--show-current" }):gsub("%s+$", "")
			vim.b.rel_path = filepath:sub(#root + 2)
		else
			vim.b.git_root = ""
			vim.b.git_branch = nil
			vim.b.rel_path = vim.fn.expand("%:p:~")
		end
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"

----------------------------------------------------------
--- Highlighting Colors Formats
----------------------------------------------------------
local color_ns = vim.api.nvim_create_namespace("native_colorizer")

local function clamp(v, lo, hi)
	return math.max(lo, math.min(hi, v))
end

local function rgb_to_hex(r, g, b)
	r = clamp(tonumber(r) or 0, 0, 255)
	g = clamp(tonumber(g) or 0, 0, 255)
	b = clamp(tonumber(b) or 0, 0, 255)
	return string.format("#%02x%02x%02x", r, g, b)
end

local function hsl_to_hex(h, s, l)
	h = (tonumber(h) or 0) % 360 / 360
	s = clamp(tonumber(s) or 0, 0, 100) / 100
	l = clamp(tonumber(l) or 0, 0, 100) / 100

	if s == 0 then
		local v = math.floor(l * 255)
		return rgb_to_hex(v, v, v)
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
	return rgb_to_hex(hue2rgb(p, q, h + 1 / 3) * 255, hue2rgb(p, q, h) * 255, hue2rgb(p, q, h - 1 / 3) * 255)
end

local function get_contrast(hex_color)
	local r = tonumber(hex_color:sub(2, 3), 16)
	local g = tonumber(hex_color:sub(4, 5), 16)
	local b = tonumber(hex_color:sub(6, 7), 16)
	local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
	if luminance > 0.5 then
		return "#1e1e2e"
	else
		return "#cdd6f4"
	end
end

local function paint(buf, row, col_s, col_e, color)
	local ok, err = pcall(function()
		local hl = "NC_" .. color:sub(2)
		vim.api.nvim_set_hl(0, hl, {
			bg = color,
			fg = get_contrast(color),
			bold = true,
		})
		vim.api.nvim_buf_set_extmark(buf, color_ns, row, col_s, {
			end_col = col_e,
			hl_group = hl,
		})
	end)
	if not ok then
		vim.notify("Colorizer error: " .. tostring(err), vim.log.levels.DEBUG)
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "ColorScheme" }, {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_clear_namespace(buf, color_ns, 0, -1)
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		for i, line in ipairs(lines) do
			local row = i - 1
			local pos = 1

			-- ── HEX: #RGB, #RGBA, #RRGGBB, #RRGGBBAA ──
			while true do
				local s, e, hex = line:find("(#[0-9a-fA-F]+)", pos)
				if not s then
					break
				end
				pos = e + 1

				local digits = hex:sub(2)
				local len = #digits
				if len == 3 or len == 4 or len == 6 or len == 8 then
					if len == 3 or len == 4 then
						local expanded = ""
						for j = 1, len do
							expanded = expanded .. digits:sub(j, j):rep(2)
						end
						digits = expanded
					end
					paint(buf, row, s - 1, e, "#" .. digits:sub(1, 6))
				end
			end

			-- ── RGB / RGBA ──
			pos = 1
			while true do
				local s, e, r, g, b = line:find("rgba?%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)[^)]*%)", pos)
				if not s then
					break
				end
				pos = e + 1
				paint(buf, row, s - 1, e, rgb_to_hex(r, g, b))
			end

			-- ── HSL / HSLA ──
			pos = 1
			while true do
				local s, e, h, sat, l = line:find("hsla?%(%s*(%d+)%s*,%s*(%d+)%s*%%%s*,%s*(%d+)%s*%%[^)]*%)", pos)
				if not s then
					break
				end
				pos = e + 1
				paint(buf, row, s - 1, e, hsl_to_hex(h, sat, l))
			end
		end
	end,
})

----------------------------------------------------------
--- Indent Scope
----------------------------------------------------------
local indent_ns = vim.api.nvim_create_namespace("native_indentscope")

local function setup_indentscope_hl()
	local function get_fg(name)
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
		return (ok and hl and hl.fg) and hl.fg or nil
	end
	local fg = get_fg("CursorLineNr") or get_fg("Special") or get_fg("Comment") or "#a6adc8"
	vim.api.nvim_set_hl(0, "IndentScopeLine", { fg = fg, bold = true })
end

setup_indentscope_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_indentscope_hl })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "WinEnter", "TextChanged", "TextChangedI" }, {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_clear_namespace(buf, indent_ns, 0, -1)

		local row = vim.api.nvim_win_get_cursor(0)[1] - 1
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local total = #lines

		local function indent_of(l)
			if not l or l:match("^%s*$") then
				return nil
			end
			return #(l:match("^(%s*)"))
		end

		local ci = indent_of(lines[row + 1])
		if not ci or ci == 0 then
			return
		end

		local function compute(level)
			local top = row
			while top > 0 do
				local ind = indent_of(lines[top])
				if ind and ind < level then
					break
				end
				top = top - 1
			end
			local bottom = row
			while bottom < total - 1 do
				local ind = indent_of(lines[bottom + 2])
				if ind and ind < level then
					break
				end
				bottom = bottom + 1
			end
			return top, bottom
		end

		local top, bottom = compute(ci)

		if top == bottom then
			local parent = nil
			for i = row, 1, -1 do
				local ind = indent_of(lines[i])
				if ind and ind < ci then
					parent = ind
					break
				end
			end
			if parent and parent > 0 then
				ci = parent
				top, bottom = compute(ci)
			end
		end

		local col = ci - 1

		for i = top, bottom do
			local l = lines[i + 1]
			if l and #l > col then
				vim.api.nvim_buf_set_extmark(buf, indent_ns, i, col, {
					virt_text = { { "┃", "IndentScopeLine" } },
					virt_text_pos = "overlay",
					priority = 100,
				})
			end
		end
	end,
})

----------------------------------------------------------
--- Notifications
----------------------------------------------------------
local default_notify = vim.notify
local notif_stack = {}
local notif_history = {}

local icons = {
	[vim.log.levels.ERROR] = "❌",
	[vim.log.levels.WARN] = "⚠️",
	[vim.log.levels.INFO] = "ℹ️",
	[vim.log.levels.DEBUG] = "💡",
	[vim.log.levels.TRACE] = "💡",
}

local sev = {
	[vim.log.levels.ERROR] = { name = "ERROR", hl = "DiagnosticError" },
	[vim.log.levels.WARN] = { name = "WARN", hl = "DiagnosticWarn" },
	[vim.log.levels.INFO] = { name = "INFO", hl = "DiagnosticInfo" },
	[vim.log.levels.DEBUG] = { name = "DEBUG", hl = "DiagnosticHint" },
	[vim.log.levels.TRACE] = { name = "TRACE", hl = "DiagnosticHint" },
}

local function reposition()
	local row = 1
	for _, n in ipairs(notif_stack) do
		if vim.api.nvim_win_is_valid(n.win) then
			pcall(vim.api.nvim_win_set_config, n.win, { row = row, col = vim.o.columns - 1 })
			row = row + vim.api.nvim_win_get_height(n.win) + 1
		end
	end
end

local function close(n)
	if n.timer then
		pcall(function()
			n.timer:stop()
		end)
	end
	if n.win and vim.api.nvim_win_is_valid(n.win) then
		pcall(vim.api.nvim_win_close, n.win, true)
	end
	for i, v in ipairs(notif_stack) do
		if v == n then
			table.remove(notif_stack, i)
			break
		end
	end
	reposition()
end

local function close_all()
	for i = #notif_stack, 1, -1 do
		close(notif_stack[i])
	end
end

local function show_history()
	local lines = {}
	if #notif_history == 0 then
		lines = { "(no notifications yet)" }
	else
		for i = #notif_history, 1, -1 do
			local h = notif_history[i]
			table.insert(lines, string.format("%s  [%-5s] %s", h.time, h.name, h.msg))
		end
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(80, vim.o.columns - 4)
	local height = math.max(1, math.min(#lines, vim.o.lines - 6))

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.max(0, math.floor((vim.o.lines - height) / 2)),
		col = math.max(0, math.floor((vim.o.columns - width) / 2)),
		style = "minimal",
		border = "rounded",
		title = " Notification History ",
	})
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end

---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
	level = level or vim.log.levels.INFO
	local info = sev[level] or sev[vim.log.levels.INFO]

	-- Record history (keep last 100)
	notif_history[#notif_history + 1] = {
		time = vim.fn.strftime("%H:%M:%S"),
		name = info.name,
		msg = msg,
	}
	if #notif_history > 100 then
		table.remove(notif_history, 1)
	end

	local ok = pcall(function()
		local lines = vim.split(msg, "\n")
		lines[1] = (icons[level] or "ℹ️") .. " " .. lines[1]

		local width = 0
		for _, l in ipairs(lines) do
			width = math.max(width, vim.fn.strdisplaywidth(l))
		end
		width = math.min(width + 2, vim.o.columns - 4)

		local height = 0
		for _, l in ipairs(lines) do
			height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(l) / width))
		end

		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].bufhidden = "wipe"

		while #notif_stack >= 5 do
			close(notif_stack[1])
		end

		local win = vim.api.nvim_open_win(buf, false, {
			relative = "editor",
			anchor = "NE",
			row = 1,
			col = vim.o.columns - 1,
			width = width,
			height = height,
			style = "minimal",
			border = "rounded",
			title = " " .. info.name .. " ",
			title_pos = "left",
		})

		local n = { buf = buf, win = win }
		notif_stack[#notif_stack + 1] = n

		n.timer = vim.defer_fn(function()
			close(n)
		end, level == vim.log.levels.ERROR and 8000 or 4000)

		pcall(function()
			vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:" .. info.hl
			vim.wo[win].wrap = true
		end)
		reposition()
	end)

	if not ok then
		default_notify(msg, level, opts)
	end
end

vim.keymap.set("n", "<leader>nh", show_history, { silent = true, desc = "Notification history" })
vim.keymap.set("n", "<leader>nk", close_all, { silent = true, desc = "Dismiss all notifications" })

----------------------------------------------------------
--- Git Blame
----------------------------------------------------------
local function git_root(buf)
	local r = vim.b[buf].git_root
	if r ~= nil then
		return (r ~= "" and r or nil)
	end
	local filepath = vim.api.nvim_buf_get_name(buf)
	local filedir = vim.fn.fnamemodify(filepath, ":h")
	r = vim.fn.system({ "git", "-C", filedir, "rev-parse", "--show-toplevel" }):gsub("%s+$", "")
	vim.b[buf].git_root = (r ~= "" and not r:match("^fatal:")) and r or ""
	return vim.b[buf].git_root ~= "" and vim.b[buf].git_root or nil
end

local function blame_current_line()
	local buf = vim.api.nvim_get_current_buf()
	local fname = vim.api.nvim_buf_get_name(buf)
	if fname == "" then
		return
	end
	local root = git_root(buf)
	local cwd = root or vim.fn.getcwd()
	local lnum = vim.fn.line(".")
	vim.system(
		{ "git", "blame", "-L", lnum .. "," .. lnum, "--porcelain", "--", fname },
		{ text = true, cwd = cwd },
		function(out)
			vim.schedule(function()
				if out.code ~= 0 then
					vim.notify("git blame failed", vim.log.levels.WARN)
					return
				end
				local s = out.stdout or ""
				local sha = s:match("^(%x+)") or ""
				local author = s:match("author ([^\n]+)") or "unknown"
				local t = s:match("author%-time (%d+)")
				local summary = s:match("summary ([^\n]+)") or ""
				local date = t and os.date("%Y-%m-%d", tonumber(t)) or ""
				vim.notify(
					string.format("%s • %s • %s (%s)", author, date, summary, sha:sub(1, 7)),
					vim.log.levels.INFO
				)
			end)
		end
	)
end

vim.keymap.set("n", "<leader>gb", blame_current_line, { silent = true, desc = "Blame current line" })

----------------------------------------------------------
--- Highlighting Keywords (TODO/NOTE/FIXME/...)
----------------------------------------------------------
local kw_ns = vim.api.nvim_create_namespace("native_keywords")

local kw_groups = {
	TODO = { hl = "KwTodo", theme = "Directory", fb = "#89b4fa" },
	NOTE = { hl = "KwNote", theme = "Operator", fb = "#89dceb" },
	WARN = { hl = "KwWarn", theme = "Constant", fb = "#fab387" },
	HACK = { hl = "KwHack", theme = "Type", fb = "#f9e2af" },
	FIXME = { hl = "KwFixme", theme = "Error", fb = "#f38ba8" },
	HINT = { hl = "KwHint", theme = "String", fb = "#a6e3a1" },
}

local function setup_kw_hl()
	local function get_fg(name, fb)
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
		return (ok and hl and hl.fg) and hl.fg or fb
	end
	for _, def in pairs(kw_groups) do
		vim.api.nvim_set_hl(0, def.hl, { fg = get_fg(def.theme, def.fb), bold = true })
	end
end
setup_kw_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_kw_hl })

local function is_word_boundary(line, s, e)
	local before = s > 1 and line:sub(s - 1, s - 1) or ""
	local after = line:sub(e + 1, e + 1) or ""
	return not before:match("[%w_]") and not after:match("[%w_]")
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "ColorScheme" }, {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_clear_namespace(buf, kw_ns, 0, -1)
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		for i, line in ipairs(lines) do
			local row = i - 1
			for kw, def in pairs(kw_groups) do
				local pos = 1
				while true do
					local s, e = line:find(kw, pos, true)
					if not s then
						break
					end
					pos = e + 1
					if is_word_boundary(line, s, e) then
						vim.api.nvim_buf_set_extmark(buf, kw_ns, row, s - 1, {
							end_col = e,
							hl_group = def.hl,
						})
					end
				end
			end
		end
	end,
})

--------------------------------------------------
--- For running coding files inside neovim
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

----------------------------------------------------------
--- Grapple (Project File Marks)
----------------------------------------------------------
local grapple = {
	save_path = vim.fn.stdpath("data") .. "/grapple.json",
}

local function load_data()
	if vim.fn.filereadable(grapple.save_path) == 1 then
		local content = table.concat(vim.fn.readfile(grapple.save_path), "\n")
		local ok, data = pcall(vim.json.decode, content)
		if ok and type(data) == "table" then
			return data
		end
	end
	return {}
end

local function save_data(data)
	local ok, json = pcall(vim.json.encode, data)
	if ok then
		vim.fn.writefile({ json }, grapple.save_path)
	end
end

local function get_project_key()
	local root = vim.b.git_root
	if root and root ~= "" then
		return root
	end

	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		return vim.fn.getcwd()
	end

	local filedir = vim.fn.fnamemodify(filepath, ":h")
	local r = vim.fn.system({ "git", "-C", filedir, "rev-parse", "--show-toplevel" }):gsub("%s+$", "")
	if r ~= "" and not r:match("^fatal:") then
		return r
	end
	return vim.fn.getcwd()
end

local function get_marks()
	local data = load_data()
	return data[get_project_key()] or {}
end

local function set_marks(marks)
	local data = load_data()
	local key = get_project_key()
	if #marks == 0 then
		data[key] = nil
	else
		data[key] = marks
	end
	save_data(data)
end

local function get_relative_path(filepath, root)
	if not root or root == "" then
		return vim.fn.fnamemodify(filepath, ":~")
	end
	local rel = filepath:match("^" .. vim.pesc(root) .. "[/\\](.*)$")
	if rel then
		return rel
	end
	return vim.fn.fnamemodify(filepath, ":~")
end

function grapple.toggle()
	local marks = get_marks()
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)

	for i, mark in ipairs(marks) do
		if mark.file == current_file then
			table.remove(marks, i)
			set_marks(marks)
			vim.notify("Grapple: Unhooked " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
			return
		end
	end

	table.insert(marks, { file = current_file, row = cursor[1], col = cursor[2] })
	set_marks(marks)
	vim.notify("Grapple: Hooked " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
end

function grapple.nav(index)
	local marks = get_marks()
	local mark = marks[index]
	if not mark then
		vim.notify("Grapple: Slot " .. index .. " is empty", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(mark.file) == 0 then
		vim.notify("Grapple: File not found", vim.log.levels.ERROR)
		return
	end

	vim.cmd("edit " .. vim.fn.fnameescape(mark.file))
	pcall(vim.api.nvim_win_set_cursor, 0, { mark.row, mark.col })
end

function grapple.menu()
	local marks = get_marks()
	if #marks == 0 then
		vim.notify("Grapple: No hooks set for this project", vim.log.levels.INFO)
		return
	end

	local key = get_project_key()
	local lines = {}
	for i, mark in ipairs(marks) do
		local short = get_relative_path(mark.file, key)
		table.insert(lines, string.format("%d. %s", i, short))
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false

	local width = 0
	for _, l in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end
	width = math.min(width + 4, vim.o.columns - 4)
	local height = #lines

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Grapple ",
		title_pos = "center",
	})

	vim.api.nvim_set_hl(0, "GrappleTitle", { fg = "#89b4fa", bold = true })
	vim.api.nvim_set_hl(0, "GrappleNum", { fg = "#f38ba8", bold = true })
	vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Title:GrappleTitle"

	vim.cmd("syntax match GrappleNum '^\\d\\+\\.'")

	local function close_menu()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "q", close_menu, { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", close_menu, { buffer = buf, silent = true })

	vim.keymap.set("n", "<CR>", function()
		local line = vim.fn.getline(".")
		local idx = tonumber(line:match("^(%d+)"))
		close_menu()
		if idx then
			grapple.nav(idx)
		end
	end, { buffer = buf, silent = true })

	vim.keymap.set("n", "d", function()
		local line_num = vim.fn.line(".")
		if marks[line_num] then
			local removed = table.remove(marks, line_num)
			set_marks(marks)
			vim.notify("Grapple: Unhooked " .. vim.fn.fnamemodify(removed.file, ":t"), vim.log.levels.INFO)
			close_menu()
			grapple.menu()
		end
	end, { buffer = buf, silent = true, desc = "Delete mark" })

	vim.keymap.set("n", "C", function()
		set_marks({})
		vim.notify("Grapple: Cleared all hooks", vim.log.levels.INFO)
		close_menu()
	end, { buffer = buf, silent = true, desc = "Clear all marks" })
end

vim.keymap.set("n", "<leader>ha", grapple.toggle, { desc = "Grapple: Toggle file" })
vim.keymap.set("n", "<leader>hh", grapple.menu, { desc = "Grapple: Menu" })

for i = 1, 5 do
	vim.keymap.set("n", "<leader>h" .. i, function()
		grapple.nav(i)
	end, { desc = "Grapple: Nav " .. i })
end
