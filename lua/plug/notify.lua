local ok, notify = pcall(require, "notify")
if not ok then
	vim.notify("nvim-notify not found", vim.log.levels.ERROR)
	return
end

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

vim.notify = notify

-- Keymap to dismiss notifications
vim.keymap.set("n", "<leader>nd", notify.dismiss, { desc = "Dismiss all notifications" })

---------------------------------------------------------------------
-- LSP integration
---------------------------------------------------------------------
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

-- Notify when LSP attaches
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
