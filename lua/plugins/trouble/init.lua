return {
	{
		"folke/trouble.nvim",
		opts = {
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				position = "bottom", -- Set the position to bottom
				height = 10, -- Height of the trouble list
				width = 50, -- Width is less relevant when in bottom position
				icons = true,
				mode = "workspace_diagnostics",
				fold_open = "",
				fold_closed = "",
				group = true,
				padding = true,
				auto_preview = true,
				auto_fold = false,
				use_diagnostic_signs = false,
			},
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
