return {
	"nvim-treesitter/nvim-treesitter",
	version = "v0.9.2",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			install = {
				compilers = { "clang", "gcc" },
				prefer_git = true,
			},
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = true },
		})
	end,
}
