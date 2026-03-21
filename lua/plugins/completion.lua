return {
	{
		"saghen/blink.cmp",
		version = "v0.*",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
				config = function()
					local ls = require("luasnip")

					ls.setup({
						history = true,
						delete_check_events = "TextChanged",
						enable_autosnippets = true,
					})

					-- Load snippets
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})

					-- Keymaps
					vim.keymap.set({ "i", "s" }, "<C-n>", function()
						if ls.jumpable(1) then
							ls.jump(1)
						end
					end, { silent = true })

					vim.keymap.set({ "i", "s" }, "<C-p>", function()
						if ls.jumpable(-1) then
							ls.jump(-1)
						end
					end, { silent = true })

					vim.keymap.set({ "i", "s" }, "<C-e>", function()
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end, { silent = true })
				end,
			},
		},

		config = function()
			require("blink.cmp").setup({
				snippets = { preset = "luasnip" },

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					providers = {
						snippets = {
							name = "snippets",
							module = "blink.cmp.sources.snippets",
							enabled = true,
							max_items = 8,
							min_keyword_length = 2,
							score_offset = 95,
						},
					},
				},

				fuzzy = { implementation = "lua" },

				keymap = {
					preset = "none",
					["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
					["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
					["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
					["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					["<C-Space>"] = { "show", "hide_documentation" },
					["<Esc>"] = { "hide", "fallback" },
					["<C-e>"] = { "show_documentation", "hide_documentation" },
					["<C-u>"] = { "scroll_documentation_up", "fallback" },
					["<C-d>"] = { "scroll_documentation_down", "fallback" },
				},

				signature = {
					enabled = true,
					window = {
						max_height = 8,
						max_width = 60,
						border = "rounded",
					},
				},

				appearance = { nerd_font_variant = "mono" },

				completion = {
					trigger = {
						show_on_keyword = true,
						show_on_trigger_character = true,
					},
					menu = {
						auto_show = true,
					},
					list = {
						selection = {
							preselect = true,
							auto_insert = false,
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
					keyword = { range = "prefix" },
					ghost_text = { enabled = true },
				},
			})
		end,
	},
}
