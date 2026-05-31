require("claude-code").setup({
    window = {
        position = "vertical",
        split_ratio = 0.4,
    },
})

vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
