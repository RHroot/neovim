-- ============================================================================
-- LUASNIP SETUP
-- ============================================================================

local ls = require("luasnip")

ls.setup({
	history = true,
	delete_check_events = "TextChanged",
	enable_autosnippets = true,
})

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom snippets if they exist
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- ============================================================================
-- LUASNIP KEYMAPS
-- ============================================================================

-- Jump forward in snippet
vim.keymap.set({ "i", "s" }, "<C-n>", function()
	if ls.jumpable(1) then
		ls.jump(1)
	end
end, { silent = true })

-- Jump backward in snippet
vim.keymap.set({ "i", "s" }, "<C-p>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- Change choice in choice node
vim.keymap.set({ "i", "s" }, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

-- ============================================================================
-- BLINK.CMP SETUP (PyCharm-like behavior)
-- ============================================================================

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
		preset = "none", -- Start with no default mappings for full control
		-- Tab to select next item (navigate down)
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
		-- Shift+Tab to select previous item (navigate up)
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
		-- Enter to accept the selected completion
		["<CR>"] = { "accept", "fallback" },
		-- Ctrl+Space to manually trigger completion (PyCharm style)
		["<C-Space>"] = { "show", "hide_documentation" },
		-- Escape to close the menu
		["<Esc>"] = { "hide", "fallback" },
		-- Ctrl+e for documentation (similar to PyCharm's quick doc)
		["<C-e>"] = { "show_documentation", "hide_documentation" },
		-- Scroll documentation
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
		-- Only show suggestions when you start typing (not on blank lines)
		trigger = {
			show_on_keyword = true, -- Show after typing keyword characters
			show_on_trigger_character = true, -- Show on LSP trigger characters (like . or ::)
		},
		menu = {
			auto_show = true, -- Automatically show menu when triggered
		},
		list = {
			selection = {
				preselect = true, -- Preselect first item (PyCharm behavior)
				auto_insert = false, -- Don't auto-insert, require Enter key
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		keyword = { range = "prefix" },
		-- Ghost text disabled for PyCharm-like experience (optional, can enable if you like)
		ghost_text = { enabled = true },
	},
})

-- ============================================================================
-- LSP SETUP
-- ============================================================================

-- Set capabilities globally for ALL LSP servers
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Enable your LSP servers
vim.lsp.enable({
	"zls",
	"html",
	"cssls",
	"ts_ls",
	"pylsp",
	"gopls",
	"jdtls",
	"vtsls",
	"lua_ls",
	"clangd",
	"tailwindcss",
	"postgres_lsp",
	"rust_analyzer",
})
