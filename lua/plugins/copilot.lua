return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			vim.g.copilot_no_tab_map = true

			vim.g.copilot_settings = {
				selectedCompletionModel = "copilot-codex",
				debounce_ms = 20,
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
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
		config = function()
			local runners = {
				python = "python %",
				lua = "lua %",
				sh = "bash %",
				javascript = "node %",
				typescript = "ts-node %",
				c = "gcc % -o %< && ./%<",
				cpp = "g++ % -std=c++17 -O2 -o %< && ./%<",
				rust = "rustc % -o %< && ./%<",
				go = "go run %",
				java = "javac % && java %<",
				ruby = "ruby %",
				php = "php %",
				perl = "perl %",
				zig = "zig run %",
			}

			vim.keymap.set("n", "<leader>rn", function()
				vim.cmd("w")
				local cmd = runners[vim.bo.filetype]

				if not cmd then
					print("No runner for " .. vim.bo.filetype)
					return
				end

				vim.cmd("split | resize 12 | terminal " .. cmd)
				vim.cmd("startinsert")
			end)

			vim.opt.splitbelow = true
		end,
	},
}
