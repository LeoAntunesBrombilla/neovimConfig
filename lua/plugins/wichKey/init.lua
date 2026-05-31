require("which-key").setup({
    delay = 0,
    icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
            Up = "<Up> ", Down = "<Down> ", Left = "<Left> ", Right = "<Right> ",
            C = "<C-…> ", M = "<M-…> ", D = "<D-…> ", S = "<S-…> ",
            CR = "<CR> ", Esc = "<Esc> ", NL = "<NL> ", BS = "<BS> ",
            Space = "<Space> ", Tab = "<Tab> ",
        },
    },
    spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>g", group = "[G]it" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        { "<leader>x", group = "Trouble" },
        { "<leader>o", group = "[O]bsidian" },
    },
})
