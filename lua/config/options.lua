vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Ensure npm global bin is in PATH so tree-sitter-cli and other npm tools are found
local npm_prefix = vim.trim(vim.fn.system("npm prefix -g 2>/dev/null"))
if npm_prefix ~= "" then
    vim.env.PATH = npm_prefix .. "/bin:" .. vim.env.PATH
end
