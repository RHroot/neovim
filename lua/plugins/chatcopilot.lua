return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"github/copilot.vim",
		"nvim-lua/plenary.nvim",
	},

	cmd = {
		"CopilotChat",
		"CopilotChatToggle",
		"CopilotChatOpen",
	},

	keys = {
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
	},

	config = function()
		require("CopilotChat").setup({

			model = "claude-sonnet-4.5",
			temperature = 0.2,

			auto_insert_mode = true,
			context = "buffers",

			window = {
				layout = "float",
				relative = "editor",
				width = 0.85,
				height = 0.85,
				border = "rounded",
				title = " AI Assistant ",
				zindex = 100,
			},

			headers = {
				user = "You",
				assistant = "Copilot",
				tool = "Tool",
			},

			separator = "━━━━━━━━━━━━━━━━",

			auto_fold = true,

			mappings = {
				submit = "<CR>",
				close = "<Esc>",
				reset = "<C-l>",
			},
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.signcolumn = "no"
				vim.opt_local.wrap = true
				vim.opt_local.linebreak = true
			end,
		})
	end,
}
