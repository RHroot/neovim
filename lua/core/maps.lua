vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local vim = vim
local opts = { noremap = true, silent = false }

-- General
map({ "n", "i", "v", "c", "t", "x", "s", "o" }, "<C-c>", "<Esc>", opts)
map({ "n", "v", "c", "t", "x", "s", "o" }, ";", ":", opts)
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
map({ "v", "c", "t", "x", "s", "o" }, "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<leader>cd", ":Explore<CR>", opts)
map("n", "<leader>vd", ":Vexplore<CR>", opts)
map("n", "<leader>sd", ":Sexplore<CR>", opts)
map("n", "<leader>so", ":update<CR> :source<CR>", opts)
map("n", "<leader>si", "source ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>rr", ":ex<CR>", opts)
map("n", "<leader>w", ":w!<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>ex", ":q!<CR>", opts)
map("n", "<leader>bc", ":enew<CR>", opts)
map("n", "<leader>bn", ":bn<CR>", opts)
map("n", "<leader>bp", ":bp<CR>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
map("n", "<C-c>", "<cmd>nohlsearch<CR>", opts)

-- To Travel between splits or panes you may call it
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-S-j>", "<C-w>j", opts)
map("n", "<C-S-k>", "<C-w>k", opts)
map("n", "<C-S-l>", "<C-w>l", opts)
map("n", "<C-S-h>", "<C-w>h", opts)

-- Prime's remaps
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)
map({ "n", "v" }, "<leader>d", '"_d', opts)
map("x", "<leader>p", [["_dP]], opts)

-- Conform
map({ "n", "v" }, "<leader>fm", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 500,
	})
end, { desc = "[F]or[m]at buffer" })
map("v", "<leader>f", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		range = {
			["start"] = vim.api.nvim_buf_get_mark(0, "<"),
			["end"] = vim.api.nvim_buf_get_mark(0, ">"),
		},
	})
end, { desc = "[F]ormat selection" })
