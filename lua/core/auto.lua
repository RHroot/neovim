vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#4a4a4a", bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fffacd", bg = "none", bold = true })
	end,
})

-- Create a single LspAttach autocmd for keymaps + completion
local lsp_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local buf = ev.buf
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
		end

		-- ===== LSP Navigation & Actions =====
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Find references")
		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "gk", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<C-S-k>", vim.lsp.buf.signature_help, "Signature help")

		-- Workspace
		map("n", "<leader>aw", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("n", "<leader>rw", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
		map("n", "<leader>lw", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List workspace folders")
		map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Search workspace symbols")

		-- Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>for", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")

		-- Diagnostics
		map("n", "<leader>fe", vim.diagnostic.open_float, "Show diagnostics in float")
		map("n", "<leader>ce", vim.diagnostic.setqflist, "Send diagnostics to quickfix")
	end,
})

vim.diagnostic.config({
	virtual_line = {
		only_current_line = true,
		severity = { min = vim.diagnostic.severity.WARN },
	},
	virtual_text = false,
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

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
			border = "rounded",
			source = "if_many",
		})
	end,
})
