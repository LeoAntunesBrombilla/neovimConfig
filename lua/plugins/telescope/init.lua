-- telescope.lua - Enhanced Telescope configuration with Git features
return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					-- Add keybindings for Telescope windows
					mappings = {
						i = {
							-- Stage/unstage files directly from Telescope
							["<C-a>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								if selection then
									-- Stage the file
									vim.fn.system("git add " .. selection.value)
									print("Staged: " .. selection.value)
								end
							end,
							["<C-r>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								if selection then
									-- Unstage the file
									vim.fn.system("git reset " .. selection.value)
									print("Unstaged: " .. selection.value)
								end
							end,
						},
					},
				},
				pickers = {
					git_status = {
						-- Custom git status picker with actions
						initial_mode = "normal",
						mappings = {
							n = {
								["a"] = function(prompt_bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									if selection then
										vim.fn.system("git add " .. selection.value)
										print("Staged: " .. selection.value)
										-- Refresh the picker
										vim.cmd("Telescope git_status")
									end
								end,
								["r"] = function(prompt_bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									if selection then
										vim.fn.system("git reset " .. selection.value)
										print("Unstaged: " .. selection.value)
										-- Refresh the picker
										vim.cmd("Telescope git_status")
									end
								end,
								["d"] = function(prompt_bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									if selection then
										-- Show diff for selected file
										actions.close(prompt_bufnr)
										vim.cmd("Gdiffsplit " .. selection.value)
									end
								end,
							},
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Load extensions
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			-- ============================================
			-- SEARCH KEYMAPS
			-- ============================================
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- ============================================
			-- GIT KEYMAPS (Enhanced)
			-- ============================================
			-- Git status with custom actions (stage/unstage with 'a' and 'r' keys)
			vim.keymap.set("n", "<leader>gs", function()
				builtin.git_status({
					initial_mode = "normal",
					prompt_title = "Git Status (a=add, r=reset, d=diff, Enter=open)",
				})
			end, { desc = "[G]it [S]tatus - changed files" })

			-- Git commits history
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits history" })

			-- Git branches
			vim.keymap.set("n", "<leader>gB", builtin.git_branches, { desc = "[G]it [B]ranches" })

			-- Git files (tracked files)
			vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "[G]it [F]iles (tracked)" })

			-- Git stash
			vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "[G]it [S]tash list" })

			-- File history (requires telescope to be in a git repo)
			vim.keymap.set("n", "<leader>gh", builtin.git_bcommits, { desc = "[G]it [H]istory (current file)" })

			-- Selection history (visual mode)
			vim.keymap.set("v", "<leader>gh", function()
				builtin.git_bcommits_range({ from = vim.fn.line("'<"), to = vim.fn.line("'>") })
			end, { desc = "[G]it [H]istory (selection)" })

			-- ============================================
			-- OTHER KEYMAPS
			-- ============================================
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			vim.keymap.set("n", "<leader>so", function()
				builtin.find_files({ cwd = "~/Documents/Second Brain" })
			end, { desc = "[S]earch [O]bsidian notes" })
		end,
	},
}
