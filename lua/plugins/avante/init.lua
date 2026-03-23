return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	opts = {
		provider = "copilot",
		providers = {
			copilot = {
				model = "gpt-4o",
			},
		},
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
		},
		windows = {
			position = "right",
			wrap = true,
			width = 35,
			sidebar_header = {
				enabled = true,
				align = "center",
				rounded = true,
			},
		},
		mappings = {
			ask = "<leader>aa",
			edit = "<leader>ae",
			refresh = "<leader>ar",
			toggle = {
				default = "<leader>at",
				debug = "<leader>ad",
				hint = "<leader>ah",
				suggestion = "<leader>as",
			},
			diff = {
				ours = "co",
				theirs = "ct",
				both = "cb",
				next = "]x",
				prev = "[x",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
