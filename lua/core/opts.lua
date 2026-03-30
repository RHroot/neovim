local vim = vim

vim.o.number = true
vim.o.relativenumber = true
vim.o.title = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.clipboard = unnamedplus
vim.opt.splitbelow = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "↪"
vim.o.sidescroll = 1

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.updatetime = 250

vim.o.swapfile = false
vim.o.backup = false

local undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.fn.mkdir(undodir, "p")
vim.o.undodir = undodir
vim.o.undofile = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.winborder = "rounded"

vim.g.have_nerd_font = true
vim.g.loaded_netrw = nil
vim.g.loaded_netrwPlugin = nil

vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Options for Neovide only
vim.o.guifont = "FiraCode Nerd Font Mono:h22"
vim.o.background = "dark"
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_opacity = 0.5
vim.g.transparency = 0.8
