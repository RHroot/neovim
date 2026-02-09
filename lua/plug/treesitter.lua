require("nvim-treesitter.configs").setup({
	install = {
		compilers = { "clang", "gcc" },
		prefer_git = true,
	},
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = true },
})
