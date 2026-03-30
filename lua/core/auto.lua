-----------------------------------------------------------
-- Yank highlight
-----------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 120 })
	end,
})

-----------------------------------------------------------
-- Black background theme (TokyoNight-safe)
-----------------------------------------------------------
local BLACK = "#000000"

local function apply_black_theme()
	-- Core
	vim.api.nvim_set_hl(0, "Normal", { bg = BLACK })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = BLACK })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = BLACK })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = BLACK })

	-- Line numbers
	vim.api.nvim_set_hl(0, "LineNr", {
		fg = "#4a4a4a",
		bg = BLACK,
	})
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		fg = "#F09676",
		bg = BLACK,
		bold = true,
	})

	-- Floats
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = BLACK })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = BLACK })

	-- Diagnostic floats
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = BLACK })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = BLACK })
end

-----------------------------------------------------------
-- Apply only to real code buffers
-----------------------------------------------------------
local function is_code_buffer(buf)
	return vim.bo[buf].buftype == ""
end

-----------------------------------------------------------
-- Autocommands (robust + race-free)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_black_theme,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function(ev)
		if is_code_buffer(ev.buf) then
			apply_black_theme()
		end
	end,
})

-- Ensure startup correctness even if colorscheme loads first
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("doautocmd ColorScheme")
	end,
})

-----------------------------------------------------------
-- LSP keymaps
-----------------------------------------------------------
local lsp_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local buf = ev.buf

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
		end

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Find references")
		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

		-- Workspace
		map("n", "<leader>aw", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("n", "<leader>rw", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
		map("n", "<leader>lw", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Search workspace symbols")

		-- Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>sn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>for", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")

		-- Diagnostics
		map("n", "<leader>fe", vim.diagnostic.open_float, "Show diagnostics")
		map("n", "<leader>ce", vim.diagnostic.setqflist, "Diagnostics to quickfix")
	end,
})

-----------------------------------------------------------
-- Diagnostics config
-----------------------------------------------------------
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

-----------------------------------------------------------
-- CursorHold diagnostics (non-spammy)
-----------------------------------------------------------
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
