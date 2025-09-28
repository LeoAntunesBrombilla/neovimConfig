return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true,
				numhl = false,
				linehl = false,
				word_diff = false,
				watch_gitdir = {
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true, -- Shows git blame on current line
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 300,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				max_file_length = 40000,
				preview_config = {
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})

			-- GitSigns keymaps
			local gitsigns = require("gitsigns")

			-- Navigation
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gitsigns.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next git hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gitsigns.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous git hunk" })

			-- Actions
			vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
			vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[H]unk [S]tage buffer" })
			vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
			vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[H]unk [R]eset buffer" })
			vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review" })
			vim.keymap.set("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "[H]unk [B]lame line" })
			vim.keymap.set(
				"n",
				"<leader>tb",
				gitsigns.toggle_current_line_blame,
				{ desc = "[T]oggle git [B]lame line" }
			)
			vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "[H]unk [D]iff this" })
			vim.keymap.set("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "[H]unk [D]iff this ~" })
			vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle [D]eleted" })

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns select hunk" })
		end,
	},
}
