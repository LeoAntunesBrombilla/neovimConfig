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
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    update_debounce = 100,
    max_file_length = 40000,
    preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    diff_opts = { internal = true },
})

local gs = require("gitsigns")

-- Navigation
vim.keymap.set("n", "]h", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gs.nav_hunk() end)
    return "<Ignore>"
end, { expr = true, desc = "Next git hunk" })

vim.keymap.set("n", "[h", function()
    if vim.wo.diff then return "[c" end
    vim.schedule(function() gs.nav_hunk() end)
    return "<Ignore>"
end, { expr = true, desc = "Previous git hunk" })

-- Stage / reset
vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "[G]it [A]dd/stage hunk" })
vim.keymap.set("v", "<leader>ga", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "[G]it [A]dd/stage selected" })

vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it [U]nstage hunk" })
vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "[G]it [R]eset hunk" })
vim.keymap.set("v", "<leader>gr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "[G]it [R]eset selected" })

vim.keymap.set("n", "<leader>gA", gs.stage_buffer, { desc = "[G]it [A]dd entire file" })
vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "[G]it [R]eset entire file" })

-- Preview
vim.keymap.set("n", "<leader>gp", gs.preview_hunk_inline, { desc = "[G]it [P]review inline" })
vim.keymap.set("n", "<leader>gP", gs.preview_hunk, { desc = "[G]it [P]review popup" })
vim.keymap.set("n", "<leader>gd", function() gs.diffthis() end, { desc = "[G]it [D]iff file" })
vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "[G]it [D]iff last commit" })

-- Blame
vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "[G]it toggle [B]lame" })
vim.keymap.set("n", "<leader>gbl", function()
    gs.blame_line({ full = true })
end, { desc = "[G]it [B]lame full" })

-- Toggle
vim.keymap.set("n", "<leader>gt", gs.preview_hunk_inline, { desc = "[G]it [T]oggle deleted" })
vim.keymap.set("n", "<leader>gT", gs.toggle_signs, { desc = "[G]it [T]oggle signs" })

-- Text objects
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
