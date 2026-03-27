return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.opt.background = "dark"
			vim.cmd("colorscheme tokyonight")
		end,
	},
}
