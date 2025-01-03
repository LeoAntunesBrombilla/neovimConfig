-- Set basic options
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.tabstop = 4 -- Number of spaces per tab
vim.opt.shiftwidth = 4 -- Indentation size
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.wrap = false -- Disable line wrap
vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true -- Enable 24-bit color
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.hlsearch = true -- Highlight search results
vim.opt.ignorecase = true -- Ignore case in searches
vim.opt.smartcase = true -- Case-sensitive if uppercase is used
vim.opt.splitright = true -- Vertical split to the right
vim.opt.splitbelow = true -- Horizontal split below
vim.opt.timeoutlen = 500 -- Keymapping timeout
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.opt.clipboard:append("unnamedplus")
