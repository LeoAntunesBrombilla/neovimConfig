require("pack")

require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Safe loader: if a plugin isn't installed yet (first run), skip it gracefully
local function load(mod)
    local ok, err = pcall(require, mod)
    if not ok then
        vim.schedule(function()
            vim.notify("Plugin not ready: " .. mod .. "\nRestart nvim after pack installs.", vim.log.levels.WARN)
        end)
    end
end

-- Order matters: deps before consumers
load("plugins.colorscheme")
load("plugins.mason")
load("plugins.misc")
load("plugins.treesitter")
load("plugins.autocompletion")
load("plugins.autopairs")
load("plugins.lsp")
load("plugins.fidget")
load("plugins.autoformat")
load("plugins.lint")
load("plugins.telescope")
load("plugins.luavim")
load("plugins.gitSigns")
load("plugins.wichKey")
load("plugins.oil")
load("plugins.tree")
load("plugins.trouble")
load("plugins.surround")
load("plugins.tmux")
load("plugins.claude")
load("plugins.obsidian")
