return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true

			-- Function to set theme based on system time
			local function set_theme_by_time()
				local hour = tonumber(os.date("%H"))

				if hour >= 6 and hour < 18 then
					-- Daytime: light mode
					vim.opt.background = "light"
					vim.cmd("colorscheme tokyonight-day")
					vim.notify("☀️  Theme: TokyoNight Day (Hour: " .. hour .. ")", vim.log.levels.INFO)
				else
					-- Nighttime: dark mode
					vim.opt.background = "dark"
					vim.cmd("colorscheme tokyonight")
					vim.notify("🌙 Theme: TokyoNight (Hour: " .. hour .. ")", vim.log.levels.INFO)
				end
			end

			-- Apply theme on startup
			set_theme_by_time()

			-- Automatically update theme every 30 minutes (1800000 ms)
			vim.fn.timer_start(1800000, function()
				set_theme_by_time()
			end, { ["repeat"] = -1 })

			-- Manual update command
			vim.api.nvim_create_user_command("UpdateTheme", function()
				set_theme_by_time()
			end, { desc = "Update theme based on current time" })

			-- ============================================
			-- KEYMAPS
			-- ============================================

			-- Toggle between dark/light manually
			vim.keymap.set("n", "<leader>tt", function()
				if vim.o.background == "dark" then
					vim.opt.background = "light"
					vim.cmd("colorscheme tokyonight-day")
					vim.notify("☀️  Switched to TokyoNight Day", vim.log.levels.INFO)
				else
					vim.opt.background = "dark"
					vim.cmd("colorscheme tokyonight")
					vim.notify("🌙 Switched to TokyoNight", vim.log.levels.INFO)
				end
			end, { desc = "[T]oggle [T]heme (light/dark)" })

			-- Force light mode
			vim.keymap.set("n", "<leader>tl", function()
				vim.opt.background = "light"
				vim.cmd("colorscheme tokyonight-day")
				vim.notify("☀️  Forced TokyoNight Day", vim.log.levels.INFO)
			end, { desc = "[T]heme [L]ight (for sunlight)" })

			-- Force dark mode
			vim.keymap.set("n", "<leader>td", function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme tokyonight")
				vim.notify("🌙 Forced TokyoNight", vim.log.levels.INFO)
			end, { desc = "[T]heme [D]ark (TokyoNight)" })

			-- Show current theme info
			vim.keymap.set("n", "<leader>ts", function()
				local hour = tonumber(os.date("%H"))
				local auto_theme = (hour >= 6 and hour < 18) and "light" or "dark"
				local current_theme = vim.o.background

				local info = string.format(
					"Current: %s\nTime-based: %s (Hour: %d)\nStatus: %s",
					current_theme == "dark" and "TokyoNight" or "TokyoNight Day",
					auto_theme == "dark" and "TokyoNight" or "TokyoNight Day",
					hour,
					current_theme == auto_theme and "Auto ✓" or "Manual Override"
				)
				vim.notify(info, vim.log.levels.INFO, { title = "Theme Status" })
			end, { desc = "[T]heme [S]tatus" })

			-- Reset to automatic time-based theme
			vim.keymap.set("n", "<leader>ta", function()
				set_theme_by_time()
				vim.notify("🔄 Reset to time-based theme", vim.log.levels.INFO)
			end, { desc = "[T]heme [A]uto (time-based)" })
		end,
	},
}
