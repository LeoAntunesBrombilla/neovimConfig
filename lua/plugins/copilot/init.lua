return {
	"github/copilot.vim",
	config = function()
		-- Disable Copilot suggestions in specific filetypes
		vim.g.copilot_filetypes = {
			python = true,
			javascript = true,
			lua = true,
			markdown = false, -- Disable Copilot for markdown files
		}

		-- Use custom keybindings for Copilot
		vim.api.nvim_set_keymap("i", "<C-j>", "copilot#Accept()", { expr = true, silent = true })

		-- Disable the default Tab mapping for accepting suggestions
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
	end,
}
