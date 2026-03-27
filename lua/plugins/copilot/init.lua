return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- handled by copilot-cmp
				panel = { enabled = false }, -- handled by copilot-cmp
				filetypes = {
					-- blocklist: disable only where it's noise
					markdown = false,
					help = false,
					TelescopePrompt = false,
					["*"] = true, -- enable for everything else
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix code" },
			{ "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review code" },
		},
	},
}
