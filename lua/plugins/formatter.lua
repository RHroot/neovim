return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Core languages
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },

				-- Web / frontend
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				less = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				markdown = { "prettierd" },
				vue = { "prettierd" },
				svelte = { "prettierd" },
				yaml = { "prettierd" },

				-- Infra / scripts
				sh = { "shfmt" },
				bash = { "shfmt" },
				fish = { "fish_indent" },
				nix = { "alejandra" },
				dockerfile = { "shfmt" },
				hyprlang = { "shfmt" },

				-- Compiled / typed
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "gofumpt", "goimports" },
				rust = { "rustfmt" },
				java = { "google-java-format" },
				zig = { "zigfmt" },

				-- Data / query
				sql = { "sqruff" },
				toml = { "prettierd" },
			},

			formatters = {
				zigfmt = {
					command = "zig",
					args = { "fmt", "$FILENAME" },
					stdin = false,
				},
				shfmt = {
					command = "shfmt",
					args = { "-i", "2", "-bn", "-ci", "-ln", "bash" },
					stdin = true,
				},
				fish_indent = {
					command = "fish_indent",
					args = { "-" },
					stdin = true,
				},
				sqruff = {
					command = "sqruff",
					args = { "format", "-" },
					stdin = true,
				},
			},
		})
	end,
}
