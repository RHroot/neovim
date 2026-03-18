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

			model = "claude-haiku-4.5",
			temperature = 0.1,

			auto_insert_mode = true,
			context = "buffers",
			window = {
				layout = "float",
				width = 80,
				height = 80,
				border = "rounded",
				title = "🤖 AI Assistant",
				zindex = 100,
			},

			headers = {
				user = "👤 You",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},

			separator = "━━",
			auto_fold = true,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				vim.opt_local.number = true
				vim.opt_local.relativenumber = true
				vim.opt_local.signcolumn = "no"
				vim.opt_local.wrap = true
				vim.opt_local.linebreak = true
			end,
		})
	end,
}
