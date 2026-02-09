require("noice").setup({
	lsp = {
		signature = {
			auto_open = { enabled = false },
		},
		hover = {
			enabled = true,
			opts = {
				border = "rounded",
				max_height = 10,
				max_width = 60,
			},
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
	views = {
		hover = {
			border = { style = "rounded" },
			size = { max_height = 10, max_width = 60 },
		},
	},
})
