require("neo-tree").setup({
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
        indent = { indent_size = 2 },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
        },
        git_status = {
            symbols = {
                added = "✚", modified = "", deleted = "✖",
                renamed = "➜", untracked = "★", ignored = "◌",
                unstaged = "✗", staged = "✓", conflict = "",
            },
        },
    },
    window = {
        position = "left",
        width = 35,
        mappings = { ["<space>"] = "none" },
    },
    filesystem = {
        -- Don't open automatically for any reason
        hijack_netrw_behavior = "disabled",
        follow_current_file = { enabled = false },
        use_libuv_file_watcher = false,
        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
        },
    },
})

-- Secondary file tree — toggle manually only, oil (-) is primary
vim.keymap.set("n", "<leader>E", "<cmd>Neotree filesystem left toggle<cr>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree filesystem left reveal<cr>", { desc = "Reveal file in tree" })
