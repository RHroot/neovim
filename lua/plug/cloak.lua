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
