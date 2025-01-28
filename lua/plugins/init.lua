return {
	"folke/lazy.nvim",
	require("plugins.mason"),
	require("plugins.telescope"),
	require("plugins.wichKey"),
	require("plugins.lsp"),
	require("plugins.autoformat"),
	require("plugins.autocompletion"),
	require("plugins.treesitter"),
	require("plugins.colorscheme"),
	require("plugins.lint"),
	require("plugins.copilot"),
	require("plugins.oil"),
	{
		"MunifTanjim/nui.nvim",
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
