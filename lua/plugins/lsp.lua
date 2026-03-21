return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			-- Safe capability setup (prevents breakage if blink loads late)
			local ok, blink = pcall(require, "blink.cmp")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			if ok then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.enable({
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
			})
		end,
	},
}
