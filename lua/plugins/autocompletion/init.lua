return {
	{
		"doums/darcula",
		lazy = false,
		priority = 1000,
		config = function()
			-- Enable true colors
			vim.opt.termguicolors = true

			-- Function to set theme based on time of day
			local function set_theme_by_time()
				local hour = tonumber(os.date("%H"))

				-- 6 AM to 6 PM: Light theme for daytime/sunlight
				-- 6 PM to 6 AM: Dark theme for evening/night
				if hour >= 6 and hour < 18 then
					vim.opt.background = "light"
					-- JetBrains doesn't have a built-in light variant, so we'll use a different approach
					-- We'll use the default light colorscheme for daytime
					vim.cmd("colorscheme default")
					vim.cmd("set background=light")

					-- Optional: Enhance the default light theme
					vim.cmd("highlight Normal guibg=#ffffff guifg=#000000")
					vim.cmd("highlight Comment guifg=#808080 gui=italic")
					vim.cmd("highlight Function guifg=#0033cc gui=bold")
					vim.cmd("highlight Keyword guifg=#0033cc gui=bold")
					vim.cmd("highlight String guifg=#008000")
					vim.cmd("highlight Type guifg=#0033cc gui=bold")

					local theme_name = "☀️  Light (Day Mode)"
					vim.notify("Theme: " .. theme_name .. " (Hour: " .. hour .. ")", vim.log.levels.INFO)
				else
					vim.opt.background = "dark"
					vim.cmd("colorscheme darcula")

					local theme_name = "🌙 Dark (Darcula)"
					vim.notify("Theme: " .. theme_name .. " (Hour: " .. hour .. ")", vim.log.levels.INFO)
				end
			end

			-- Set initial theme based on current time
			set_theme_by_time()

			-- Update theme every 30 minutes (1800000 ms)
			vim.fn.timer_start(1800000, function()
				set_theme_by_time()
			end, { ["repeat"] = -1 })

			-- Create a user command to check/update theme
			vim.api.nvim_create_user_command("UpdateTheme", function()
				set_theme_by_time()
			end, { desc = "Update theme based on current time" })

			-- ============================================
			-- KEYMAPS FOR MANUAL CONTROL
			-- ============================================

			-- Toggle between light and dark themes
			vim.keymap.set("n", "<leader>tt", function()
				if vim.o.background == "dark" then
					vim.opt.background = "light"
					vim.cmd("colorscheme default")
					vim.cmd("set background=light")
					-- Apply light theme enhancements
					vim.cmd("highlight Normal guibg=#ffffff guifg=#000000")
					vim.cmd("highlight Comment guifg=#808080 gui=italic")
					vim.cmd("highlight Function guifg=#0033cc gui=bold")
					vim.cmd("highlight Keyword guifg=#0033cc gui=bold")
					vim.cmd("highlight String guifg=#008000")
					vim.notify("☀️  Switched to Light Mode", vim.log.levels.INFO)
				else
					vim.opt.background = "dark"
					vim.cmd("colorscheme darcula")
					vim.notify("🌙 Switched to Darcula", vim.log.levels.INFO)
				end
			end, { desc = "[T]oggle [T]heme (light/dark)" })

			-- Force light theme (for sunny conditions)
			vim.keymap.set("n", "<leader>tl", function()
				vim.opt.background = "light"
				vim.cmd("colorscheme default")
				vim.cmd("set background=light")
				-- Apply light theme enhancements
				vim.cmd("highlight Normal guibg=#ffffff guifg=#000000")
				vim.cmd("highlight Comment guifg=#808080 gui=italic")
				vim.cmd("highlight Function guifg=#0033cc gui=bold")
				vim.cmd("highlight Keyword guifg=#0033cc gui=bold")
				vim.cmd("highlight String guifg=#008000")
				vim.notify("☀️  Forced Light Theme (for sunlight)", vim.log.levels.INFO)
			end, { desc = "[T]heme [L]ight (for sunlight)" })

			-- Force dark theme (for evening/low light)
			vim.keymap.set("n", "<leader>td", function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme darcula")
				vim.notify("🌙 Forced Darcula Theme", vim.log.levels.INFO)
			end, { desc = "[T]heme [D]ark (Darcula)" })

			-- Show current theme info
			vim.keymap.set("n", "<leader>ts", function()
				local hour = tonumber(os.date("%H"))
				local auto_theme = (hour >= 6 and hour < 18) and "light" or "dark"
				local current_theme = vim.o.background

				local info = string.format(
					"Current: %s\nTime-based: %s (Hour: %d)\nStatus: %s",
					current_theme == "dark" and "Darcula" or "Light",
					auto_theme == "dark" and "Darcula" or "Light",
					hour,
					current_theme == auto_theme and "Auto ✓" or "Manual Override"
				)
				vim.notify(info, vim.log.levels.INFO, { title = "Theme Status" })
			end, { desc = "[T]heme [S]tatus" })

			-- Reset to automatic (time-based) theme
			vim.keymap.set("n", "<leader>ta", function()
				set_theme_by_time()
				vim.notify("🔄 Reset to time-based theme", vim.log.levels.INFO)
			end, { desc = "[T]heme [A]uto (time-based)" })
		end,
	},
}
