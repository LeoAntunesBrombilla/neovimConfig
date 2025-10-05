local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<C-p>", ":Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

map("n", "<leader>th", ":split | terminal<CR>", opts) -- horizontal split terminal
map("n", "<leader>tv", ":vsplit | terminal<CR>", opts) -- vertical split terminal
map("n", "<leader>tt", ":tabnew | terminal<CR>", opts) -- new tab terminal
map("n", "<leader>tf", ":terminal<CR>", opts) -- terminal in current window

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts) -- close buffer

-- Center cursor when jumping
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

vim.api.nvim_create_user_command("CopyOilPath", function()
	-- Get the current buffer name (which is the directory path in oil)
	local current_dir = vim.fn.expand("%:p:h")

	-- If we're in an oil buffer, get the oil URL
	if vim.bo.filetype == "oil" then
		local oil = require("oil")
		local current_dir = oil.get_current_dir()
		if current_dir then
			vim.fn.setreg("+", current_dir)
			print("Copied oil directory: " .. current_dir)
		end
	else
		-- Fallback to regular file path
		local path = vim.fn.expand("%:p")
		vim.fn.setreg("+", path)
		print("Copied file path: " .. path)
	end
end, {})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
