-- Navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Close buffer" })

-- Quickfix
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Terminal
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { noremap = true, silent = true, desc = "Terminal horizontal" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { noremap = true, silent = true, desc = "Terminal vertical" })
vim.keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>", { noremap = true, silent = true, desc = "Terminal tab" })
vim.keymap.set("n", "<leader>tf", ":terminal<CR>", { noremap = true, silent = true, desc = "Terminal here" })

-- Oil file browser
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Copy current path from oil or regular buffer
vim.api.nvim_create_user_command("CopyOilPath", function()
    if vim.bo.filetype == "oil" then
        local dir = require("oil").get_current_dir()
        if dir then
            vim.fn.setreg("+", dir)
            print("Copied: " .. dir)
        end
    else
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        print("Copied: " .. path)
    end
end, {})

-- Book library
vim.keymap.set("n", "<leader>pb", function()
    require("telescope.builtin").find_files({
        prompt_title = "Books",
        cwd = vim.fn.expand("~/Documents/Second Brain/Input/Books"),
        find_command = { "find", ".", "-maxdepth", "1", "-name", "*.md", "-not", "-name", "*.base" },
    })
end, { desc = "Browse book notes" })

vim.keymap.set("n", "<leader>po", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
    for _, line in ipairs(lines) do
        local match = line:match('^pdf_path:%s*"?(.-)"?%s*$')
        if match and match ~= "" then
            vim.fn.jobstart({ "open", "-a", "Preview", match })
            print("Opening: " .. match)
            return
        end
    end
    print("No pdf_path found in frontmatter")
end, { desc = "Open book PDF in Preview" })

-- C++ runner
vim.keymap.set("n", "<leader>r", function()
    local file = vim.fn.expand("%:p")
    local out = "/tmp/cf"
    vim.cmd("w")
    vim.cmd("!/opt/homebrew/bin/g++-15 -O2 -std=c++17 -o " .. out .. " " .. file .. " && " .. out)
end, { desc = "Run C++ file" })
