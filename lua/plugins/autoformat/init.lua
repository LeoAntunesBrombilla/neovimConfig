require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
            timeout_ms = 500,
            lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
        }
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        cpp = { "clang_format" },
    },
})

vim.keymap.set("", "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
