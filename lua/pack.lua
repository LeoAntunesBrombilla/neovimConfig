-- Native Neovim 0.11+ package management
-- vim.pack.add() installs/updates plugins to site/pack/core/opt/
-- Then we add them ALL to runtimepath at once (no ordering issues).

vim.pack.add({
    -- Core dependencies
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/echasnovski/mini.nvim" },

    -- Colorscheme
    { src = "https://github.com/folke/tokyonight.nvim" },

    -- LSP
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/b0o/schemastore.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },

    -- Completion
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },

    -- Treesitter (run :TSUpdate after first install)
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- Formatting & Linting
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/mfussenegger/nvim-lint" },

    -- Telescope (fzf-native: run `make` in its plugin dir once for faster sorting)
    { src = "https://github.com/nvim-telescope/telescope.nvim", branch = "0.1.x" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },

    -- UI & Status
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },

    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- File navigation
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },

    -- Editor utilities
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/kylechui/nvim-surround" },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },

    -- Lua dev
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/Bilal2453/luvit-meta" },

    -- Notes (markdown-preview: run `cd app && npm install` in plugin dir once)
    { src = "https://github.com/epwalsh/obsidian.nvim" },
    { src = "https://github.com/iamcco/markdown-preview.nvim" },

    -- AI
    { src = "https://github.com/greggh/claude-code.nvim" },
})

-- Add ALL installed plugins to runtimepath at once.
-- Direct rtp manipulation is used instead of packadd so that ALL plugins
-- are in the rtp before any require() or setup() is called, avoiding
-- dependency ordering issues.
local pack_opt = vim.fn.stdpath("data") .. "/site/pack/core/opt"
if vim.fn.isdirectory(pack_opt) == 1 then
    for name, ftype in vim.fs.dir(pack_opt) do
        if ftype == "directory" then
            local path = pack_opt .. "/" .. name
            vim.opt.rtp:prepend(path)
            local after = path .. "/after"
            if vim.fn.isdirectory(after) == 1 then
                vim.opt.rtp:append(after)
            end
        end
    end
end
