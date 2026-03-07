return {
	"github/copilot.vim",
	lazy = false,
	config = function()
		vim.g.copilot_no_tab_map = true

		vim.g.copilot_settings = {
			selectedCompletionModel = "gpt-4o-copilot",
			debounce_ms = 75, -- default ~150
		}

		-- Accept suggestion
		vim.keymap.set("i", "<A-p>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			silent = true,
		})

		-- Navigation
		vim.keymap.set("i", "<A-]>", "<Plug>(copilot-next)")
		vim.keymap.set("i", "<A-[>", "<Plug>(copilot-previous)")
		vim.keymap.set("i", "<A-x>", "<Plug>(copilot-dismiss)")
	end,
}
