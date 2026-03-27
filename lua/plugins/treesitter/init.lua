return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.install").prefer_git = true

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"css",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"typescript",
					"javascript",
					"tsx",
					"python",
					"json",
					"jsonc",
					"yaml",
					"toml",
					"kotlin",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			})
		end,
	},
}
