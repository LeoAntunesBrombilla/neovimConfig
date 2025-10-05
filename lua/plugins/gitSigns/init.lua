-- gitsigns.lua - Enhanced GitSigns configuration with VSCode-like features
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
				current_line_blame = false, -- Start with blame off, toggle with keybind
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
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				-- Enable inline preview of changes
				diff_opts = {
					internal = true,
				},
			})

			local gitsigns = require("gitsigns")

			-- ============================================
			-- NAVIGATION BETWEEN HUNKS
			-- ============================================
			vim.keymap.set("n", "]h", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gitsigns.nav_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next git hunk" })

			vim.keymap.set("n", "[h", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gitsigns.nav_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous git hunk" })

			-- ============================================
			-- STAGING/UNSTAGING (VSCode-like)
			-- ============================================
			-- Stage/unstage hunk (works in normal and visual mode)
			vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "[G]it [A]dd/stage hunk" })
			vim.keymap.set("v", "<leader>ga", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[G]it [A]dd/stage selected" })

			-- Unstage hunk
			vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[G]it [U]nstage hunk" })

			-- Reset/discard changes (like VSCode's discard)
			vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[G]it [R]eset/discard hunk" })
			vim.keymap.set("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[G]it [R]eset selected" })

			-- Stage/unstage entire file
			vim.keymap.set("n", "<leader>gA", gitsigns.stage_buffer, { desc = "[G]it [A]dd entire file" })
			vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[G]it [R]eset entire file" })

			-- ============================================
			-- PREVIEW CHANGES (See how it was before)
			-- ============================================
			-- Preview hunk changes inline (shows before/after)
			vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "[G]it [P]review changes inline" })

			-- Preview hunk in floating window
			vim.keymap.set("n", "<leader>gP", gitsigns.preview_hunk, { desc = "[G]it [P]review in popup" })

			-- Show diff for the whole file (split view)
			vim.keymap.set("n", "<leader>gd", function()
				gitsigns.diffthis()
			end, { desc = "[G]it [D]iff file" })

			-- Compare with last commit
			vim.keymap.set("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, { desc = "[G]it [D]iff with last commit" })

			-- ============================================
			-- GIT BLAME
			-- ============================================
			-- Toggle blame for current line
			vim.keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "[G]it toggle [B]lame" })

			-- Show full blame info in floating window
			vim.keymap.set("n", "<leader>gB", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "[G]it [B]lame full info" })

			-- ============================================
			-- GIT HISTORY
			-- ============================================
			-- Note: These require Telescope integration (see telescope config below)
			vim.keymap.set("n", "<leader>gh", ":Telescope git_bcommits<CR>", { desc = "[G]it [H]istory (file)" })
			vim.keymap.set(
				"v",
				"<leader>gh",
				":Telescope git_bcommits_range<CR>",
				{ desc = "[G]it [H]istory (selection)" }
			)

			-- ============================================
			-- QUICK ACTIONS
			-- ============================================
			-- Toggle showing deleted lines
			vim.keymap.set("n", "<leader>gt", gitsigns.preview_hunk_inline, { desc = "[G]it [T]oggle deleted lines" })

			-- Toggle signs in gutter
			vim.keymap.set("n", "<leader>gT", gitsigns.toggle_signs, { desc = "[G]it [T]oggle signs" })

			-- Text object for selecting hunks
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
			vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
		end,
	},
}
