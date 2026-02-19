return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_settings = {
				selectedCompletionModel = "gpt-4o-copilot",
			}
			vim.keymap.set("i", "<A-p>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
		},
		config = function()
			require("CopilotChat").setup({
				model = "claude-sonnet-4.5",
				temperature = 0.5,
				auto_insert_mode = true,
				window = {
					layout = "float",
					width = 90,
					height = 20,
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
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
					vim.opt_local.conceallevel = 0
				end,
			})
		end,
	},
}
