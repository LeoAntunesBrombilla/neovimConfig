-- New nvim-treesitter API for Neovim 0.11+
-- Parsers are compiled from source — requires tree-sitter CLI:
--   brew install tree-sitter

require("nvim-treesitter").setup()

local langs = {
    "bash", "c", "diff", "html", "css", "lua", "luadoc",
    "markdown", "markdown_inline", "query", "vim", "vimdoc",
    "typescript", "javascript", "tsx", "python",
    "json", "jsonc", "yaml", "toml",
}

vim.schedule(function()
    pcall(require("nvim-treesitter").install, langs)
end)

-- UI/plugin filetypes that have no treesitter parser
local skip_ft = {
    [""] = true, fidget = true, oil = true, ["neo-tree"] = true,
    ["neo-tree-popup"] = true, trouble = true, TelescopePrompt = true,
    mason = true, lazy = true, ["which-key"] = true, help = true,
    qf = true, prompt = true, nofile = true,
}

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        if skip_ft[ft] then return end

        if not pcall(vim.treesitter.start, ev.buf) then
            -- Parser missing — try to install it (needs tree-sitter CLI)
            vim.schedule(function()
                pcall(require("nvim-treesitter").install, { ft })
            end)
        end
    end,
})
