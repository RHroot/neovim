local ok, snacks = pcall(require, "snacks")
if not ok then
	vim.notify("snacks.nvim not found", vim.log.levels.ERROR)
	return
end

-- ========== SPEED-OPTIMIZED CONFIGURATION (NO ANIMATIONS) ==========
snacks.setup({
	-- ========== CORE MODULES ==========

	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024,
		notify = true,
		setup = function(ctx)
			vim.cmd([[syntax clear]])
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.opt_local.undolevels = -1
			vim.opt_local.swapfile = false
			vim.opt_local.breakindent = false
		end,
	},

	dashboard = {
		enabled = true,
		preset = {
			header = [[      ████ ██████           █████                          
  	      ███████████             █████ ██                            
	      █████████ ███████████████████ ███   ███████████   
	     █████████  ███    █████████████ █████ ██████████████   
	    █████████ ██████████ █████████ █████ █████ ████ █████   
	  ███████████ ███    ███ █████████ █████ █████ ████ █████  
	 ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
		},
		sections = {
			{ section = "header" },
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{ icon = "󰿅 ", key = "q", desc = "Quit", action = ":qa" },
		},
	},

	explorer = {
		enabled = true,
		tree = true,
		watch = true,
		git_status = true,
		git_untracked = false,
		diagnostics = true,
		hidden = true,
		ignored = false,
		follow_file = true,
		exclude = { "node_modules/**", ".git/**", "__pycache__/**" },
		include = { "src/**", "lib/**" },
	},

	indent = {
		enabled = true,
		indent = {
			enabled = true,
			char = "",
			only_scope = false,
			only_current = false,
		},
		scope = {
			enabled = true,
			char = "│",
			underline = true,
			animate = {
				enabled = false,
			},
		},
	},

	input = {
		enabled = true,
		icon = "❯ ",
		win = {
			relative = "editor",
			row = 4,
			col = 18,
			width = 60,
			height = 1,
			border = "rounded",
			title_pos = "center",
		},
	},

	notifier = {
		enabled = true,
		timeout = 3000,
		width = { min = 40, max = 0.4 },
		height = { min = 1, max = 0.6 },
		margin = { top = 0, right = 1, bottom = 0 },
		padding = true,
		sort = { "level", "added" },
		level = vim.log.levels.TRACE,
		icons = {
			error = "",
			warn = "",
			info = "󰋼",
			debug = "",
			trace = "󰴽",
		},
		style = "compact",
	},

	picker = {
		enabled = true,
		hidden = true,
		layout = "left",
		formatters = {
			file = {
				filename_first = true,
			},
			files = {
				hidden = true,
			},
			grep = {
				hidden = true,
			},
			sources = {
				explorer = {
					hidden = true,
					ignored = true,
					auto_close = true,
					git_status = true,
					diagnostics = true,
					follow_file = true,
					watch = true,
					icons = {
						tree = {
							vertical = "│ ",
							middle = "├ ",
							last = "└ ",
						},
					},
					layout = { preset = "sidebar", width = 40 },
				},
			},
		},
		sources = {
			buffers = {
				sort_lastused = true,
			},
		},
		previewers = {
			git = {
				native = true,
			},
		},
	},

	quickfile = {
		enabled = true,
	},

	scope = {
		enabled = true,
		cursor = true,
		treesitter = {
			enabled = true,
			blocks = {
				"function_declaration",
				"function_definition",
				"method_declaration",
				"method_definition",
				"class_declaration",
				"class_definition",
			},
		},
	},

	scroll = {
		enabled = false,
	},

	statuscolumn = {
		enabled = false,
		left = { "mark", "sign" },
		right = { "fold", "git" },
		folds = {
			open = false,
			git_hl = false,
		},
		git = {
			patterns = { "GitSign", "MiniDiffSign" },
		},
		refresh = 60,
	},

	words = {
		enabled = true,
		debounce = 200,
		notify_jump = false,
		notify_end = true,
		foldopen = true,
		jumplist = true,
		modes = { "n" },
	},

	-- ========== OPTIONAL MODULES ==========

	animate = {
		enabled = false,
	},

	dim = {
		enabled = false,
		scope = {
			min_size = 5,
			max_size = 50,
			siblings = true,
		},
		animate = {
			enabled = false,
		},
	},

	git = {
		timeout = 5000,
	},

	gitbrowse = {
		url_patterns = {
			["github.com"] = {
				branch = "/tree/{branch}",
				file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
				commit = "/commit/{commit}",
			},
			["gitlab.com"] = {
				branch = "/-/tree/{branch}",
				file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
				commit = "/-/commit/{commit}",
			},
			["bitbucket.org"] = {
				branch = "/src/{branch}",
				file = "/src/{branch}/{file}#lines-{line_start}:{line_end}",
				commit = "/commits/{commit}",
			},
		},
	},

	image = {
		enabled = true,
		formats = {
			"png",
			"jpg",
			"jpeg",
			"gif",
			"bmp",
			"webp",
			"tiff",
			"heic",
			"avif",
			"mp4",
			"mov",
			"avi",
			"mkv",
			"webm",
			"icns",
		},
		backend = "auto",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = true,
				only_render_image_at_cursor = false,
			},
		},
		max_width = 100,
		max_height = 100,
	},

	lazygit = {
		configure = true,
		win = {
			style = "lazygit",
			position = "float",
			border = "rounded",
			width = 0.9,
			height = 0.9,
			backdrop = 60,
		},
	},

	rename = {
		enabled = true,
		autosave = true,
		notify = true,
	},

	scratch = {
		name = "Scratch",
		ft = "markdown",
		icon = "󱓥",
		root = vim.fn.stdpath("data") .. "/scratch",
		autowrite = true,
		filekey = {
			cwd = true,
			branch = true,
			count = true,
		},
		win = {
			position = "float",
			border = "rounded",
			width = 0.8,
			height = 0.8,
			backdrop = 60,
		},
	},

	terminal = {
		enable = false,
		win = {
			position = "float",
			border = "rounded",
			width = 0.9,
			height = 0.9,
			backdrop = 60,
		},
	},

	toggle = {
		notify = true,
		icon = {
			enabled = "📔",
			disabled = "📓",
		},
	},

	zen = {
		toggles = {
			dim = true,
			git_signs = false,
			mini_diff_signs = false,
			diagnostics = false,
			inlay_hints = false,
		},
		show = {
			statusline = false,
			tabline = false,
		},
		win = {
			width = 120,
			backdrop = 95,
		},
		zoom = {
			toggles = {},
			show = {
				statusline = true,
				tabline = true,
			},
		},
	},

	styles = {
		notification = {
			wo = { wrap = true },
			border = "rounded",
		},
		notification_history = {
			border = "rounded",
			width = 0.6,
			height = 0.6,
		},
	},
})

-- ========== KEYMAPS (same as before) ==========

local map = vim.keymap.set
local opts = { silent = true }

-- Core Pickers
map("n", "<leader><space>", function()
	snacks.picker.smart()
end, vim.tbl_extend("force", opts, { desc = "Smart Find" }))
map("n", "<leader>,", function()
	snacks.picker.buffers()
end, vim.tbl_extend("force", opts, { desc = "Buffers" }))
map("n", "<leader>/", function()
	snacks.picker.grep()
end, vim.tbl_extend("force", opts, { desc = "Grep" }))
map("n", "<leader>:", function()
	snacks.picker.command_history()
end, vim.tbl_extend("force", opts, { desc = "Command History" }))

-- Find
map("n", "<leader>fb", function()
	snacks.picker.buffers()
end, vim.tbl_extend("force", opts, { desc = "Buffers" }))
map("n", "<leader>fc", function()
	snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, vim.tbl_extend("force", opts, { desc = "Config" }))
map("n", "<leader>ff", function()
	snacks.picker.files()
end, vim.tbl_extend("force", opts, { desc = "Files" }))
map("n", "<leader>fg", function()
	snacks.picker.git_files()
end, vim.tbl_extend("force", opts, { desc = "Git Files" }))
map("n", "<leader>fp", function()
	snacks.picker.projects()
end, vim.tbl_extend("force", opts, { desc = "Projects" }))
map("n", "<leader>fr", function()
	snacks.picker.recent()
end, vim.tbl_extend("force", opts, { desc = "Recent" }))

-- Git
map("n", "<leader>gb", function()
	snacks.picker.git_branches()
end, vim.tbl_extend("force", opts, { desc = "Branches" }))
map("n", "<leader>gl", function()
	snacks.picker.git_log()
end, vim.tbl_extend("force", opts, { desc = "Log" }))
map("n", "<leader>gL", function()
	snacks.picker.git_log_line()
end, vim.tbl_extend("force", opts, { desc = "Log (Line)" }))
map("n", "<leader>gf", function()
	snacks.picker.git_log_file()
end, vim.tbl_extend("force", opts, { desc = "File History" }))
map("n", "<leader>gs", function()
	snacks.picker.git_status()
end, vim.tbl_extend("force", opts, { desc = "Status" }))
map("n", "<leader>gS", function()
	snacks.picker.git_stash()
end, vim.tbl_extend("force", opts, { desc = "Stash" }))
map("n", "<leader>gd", function()
	snacks.picker.git_diff()
end, vim.tbl_extend("force", opts, { desc = "Diff" }))
map("n", "<leader>gB", function()
	snacks.gitbrowse()
end, vim.tbl_extend("force", opts, { desc = "Browse" }))
map("v", "<leader>gB", function()
	snacks.gitbrowse()
end, vim.tbl_extend("force", opts, { desc = "Browse" }))
map("n", "<leader>gg", function()
	snacks.lazygit()
end, vim.tbl_extend("force", opts, { desc = "LazyGit" }))

-- Search
map("n", "<leader>sb", function()
	snacks.picker.lines()
end, vim.tbl_extend("force", opts, { desc = "Buffer Lines" }))
map("n", "<leader>sB", function()
	snacks.picker.grep_buffers()
end, vim.tbl_extend("force", opts, { desc = "Grep Buffers" }))
map("n", "<leader>sg", function()
	snacks.picker.grep()
end, vim.tbl_extend("force", opts, { desc = "Grep" }))
map("n", "<leader>sw", function()
	snacks.picker.grep_word()
end, vim.tbl_extend("force", opts, { desc = "Word" }))
map("x", "<leader>sw", function()
	snacks.picker.grep_word()
end, vim.tbl_extend("force", opts, { desc = "Selection" }))
map("n", '<leader>s"', function()
	snacks.picker.registers()
end, vim.tbl_extend("force", opts, { desc = "Registers" }))
map("n", "<leader>sa", function()
	snacks.picker.autocmds()
end, vim.tbl_extend("force", opts, { desc = "Autocmds" }))
map("n", "<leader>sc", function()
	snacks.picker.command_history()
end, vim.tbl_extend("force", opts, { desc = "Commands" }))
map("n", "<leader>sC", function()
	snacks.picker.commands()
end, vim.tbl_extend("force", opts, { desc = "All Commands" }))
map("n", "<leader>sd", function()
	snacks.picker.diagnostics()
end, vim.tbl_extend("force", opts, { desc = "Diagnostics" }))
map("n", "<leader>sD", function()
	snacks.picker.diagnostics_buffer()
end, vim.tbl_extend("force", opts, { desc = "Buffer Diag" }))
map("n", "<leader>sh", function()
	snacks.picker.help()
end, vim.tbl_extend("force", opts, { desc = "Help" }))
map("n", "<leader>sH", function()
	snacks.picker.highlights()
end, vim.tbl_extend("force", opts, { desc = "Highlights" }))
map("n", "<leader>si", function()
	snacks.picker.icons()
end, vim.tbl_extend("force", opts, { desc = "Icons" }))
map("n", "<leader>sj", function()
	snacks.picker.jumps()
end, vim.tbl_extend("force", opts, { desc = "Jumps" }))
map("n", "<leader>sk", function()
	snacks.picker.keymaps()
end, vim.tbl_extend("force", opts, { desc = "Keymaps" }))
map("n", "<leader>sl", function()
	snacks.picker.loclist()
end, vim.tbl_extend("force", opts, { desc = "Loclist" }))
map("n", "<leader>sm", function()
	snacks.picker.marks()
end, vim.tbl_extend("force", opts, { desc = "Marks" }))
map("n", "<leader>sM", function()
	snacks.picker.man()
end, vim.tbl_extend("force", opts, { desc = "Man Pages" }))
map("n", "<leader>sq", function()
	snacks.picker.qflist()
end, vim.tbl_extend("force", opts, { desc = "Quickfix" }))
map("n", "<leader>sR", function()
	snacks.picker.resume()
end, vim.tbl_extend("force", opts, { desc = "Resume" }))
map("n", "<leader>su", function()
	snacks.picker.undo()
end, vim.tbl_extend("force", opts, { desc = "Undo" }))
map("n", "<leader>sn", function()
	snacks.picker.notifications()
end, vim.tbl_extend("force", opts, { desc = "Notifications" }))

-- LSP
map("n", "gd", function()
	snacks.picker.lsp_definitions()
end, vim.tbl_extend("force", opts, { desc = "Definition" }))
map("n", "gD", function()
	snacks.picker.lsp_declarations()
end, vim.tbl_extend("force", opts, { desc = "Declaration" }))
map("n", "gr", function()
	snacks.picker.lsp_references()
end, vim.tbl_extend("force", opts, { desc = "References" }))
map("n", "gI", function()
	snacks.picker.lsp_implementations()
end, vim.tbl_extend("force", opts, { desc = "Implementation" }))
map("n", "gy", function()
	snacks.picker.lsp_type_definitions()
end, vim.tbl_extend("force", opts, { desc = "Type Def" }))
map("n", "<leader>ss", function()
	snacks.picker.lsp_symbols()
end, vim.tbl_extend("force", opts, { desc = "Symbols" }))
map("n", "<leader>sS", function()
	snacks.picker.lsp_workspace_symbols()
end, vim.tbl_extend("force", opts, { desc = "Workspace Symbols" }))

-- Other
map("n", "<leader>e", function()
	snacks.explorer()
end, vim.tbl_extend("force", opts, { desc = "Toggle Explorer" }))
map("n", "<leader>.", function()
	snacks.scratch()
end, vim.tbl_extend("force", opts, { desc = "Scratch" }))
map("n", "<leader>S", function()
	snacks.scratch.select()
end, vim.tbl_extend("force", opts, { desc = "Select Scratch" }))
map("n", "<leader>n", function()
	snacks.notifier.show_history()
end, vim.tbl_extend("force", opts, { desc = "Notifications" }))
map("n", "<leader>un", function()
	snacks.notifier.hide()
end, vim.tbl_extend("force", opts, { desc = "Dismiss Notifs" }))
map("n", "<leader>bd", function()
	snacks.bufdelete()
end, vim.tbl_extend("force", opts, { desc = "Delete Buffer" }))
map("n", "<leader>cR", function()
	snacks.rename.rename_file()
end, vim.tbl_extend("force", opts, { desc = "Rename File" }))
map("n", "<leader>z", function()
	snacks.zen()
end, vim.tbl_extend("force", opts, { desc = "Zen" }))
map("n", "<leader>Z", function()
	snacks.zen.zoom()
end, vim.tbl_extend("force", opts, { desc = "Zoom" }))
map("n", "<leader>uC", function()
	snacks.picker.colorschemes()
end, vim.tbl_extend("force", opts, { desc = "Colorscheme" }))

-- Word navigation
map("n", "]]", function()
	snacks.words.jump(vim.v.count1)
end, vim.tbl_extend("force", opts, { desc = "Next Ref" }))
map("n", "[[", function()
	snacks.words.jump(-vim.v.count1)
end, vim.tbl_extend("force", opts, { desc = "Prev Ref" }))

-- Neovim News
map("n", "<leader>N", function()
	snacks.win({
		file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
		width = 0.9,
		height = 0.9,
		wo = {
			spell = false,
			wrap = true,
			signcolumn = "yes",
			statuscolumn = " ",
			conceallevel = 3,
		},
	})
end, vim.tbl_extend("force", opts, { desc = "Neovim News" }))

-- ========== TOGGLES (NO ANIMATION TOGGLES) ==========

vim.schedule(function()
	snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	snacks.toggle.option("number", { name = "Line Numbers" }):map("<leader>ul")
	snacks.toggle.diagnostics():map("<leader>ud")
	snacks.toggle.line_number():map("<leader>uN")
	snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal" }):map("<leader>uc")
	snacks.toggle.treesitter():map("<leader>uT")
	snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Mode" }):map("<leader>ub")
	snacks.toggle.inlay_hints():map("<leader>uh")
	snacks.toggle.indent():map("<leader>ug")
	snacks.toggle.dim():map("<leader>uD")
	snacks.toggle.zen():map("<leader>uz")
	snacks.toggle.zoom():map("<leader>uZ")
end)

-- ========== DEBUG UTILITIES ==========

_G.dd = function(...)
	snacks.debug.inspect(...)
end

_G.bt = function()
	snacks.debug.backtrace()
end

vim.print = _G.dd

-- ========== PERFORMANCE AUTOCMDS ==========
-- LSP attach notification
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			snacks.notify(client.name, { title = "LSP Attached", level = "info" })
		end
	end,
})
