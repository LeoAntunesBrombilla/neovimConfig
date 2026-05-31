-- Load only for markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    once = true,
    callback = function()
        require("obsidian").setup({
            workspaces = {
                { name = "personal", path = "~/Documents/Second Brain/" },
            },
            daily_notes = {
                folder = "Journal/%Y/%m",
                date_format = "%Y-%m-%d",
                template = "daily.md",
            },
            templates = {
                folder = "Templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
            },
            new_notes_location = "notes_subdir",
            notes_subdir = "Zettels",
            note_id_func = function(title)
                if title ~= nil then
                    return title:gsub(" ", "-"):gsub("[^a-zA-Z0-9-]", ""):lower()
                else
                    return tostring(os.time())
                end
            end,
            completion = { nvim_cmp = true, min_chars = 2 },
            follow_url_func = function(url)
                vim.fn.jobstart({ "open", url })
            end,
            ui = {
                enable = true,
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                },
            },
            mappings = {
                ["<leader>ol"] = {
                    action = function() return require("obsidian").util.gf_passthrough() end,
                    opts = { noremap = false, expr = true, buffer = true, desc = "Follow link" },
                },
                ["<leader>ob"] = {
                    action = function() return "<cmd>ObsidianBacklinks<CR>" end,
                    opts = { noremap = false, expr = true, buffer = true, desc = "Show backlinks" },
                },
            },
        })
    end,
})

vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Today's daily note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch note" })
vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = "Switch workspace" })
