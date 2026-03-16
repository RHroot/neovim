return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter").setup({
			install = {
				compilers = { "clang", "gcc" },
				prefer_git = true,
			},
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = true },
		})
	end,
}
