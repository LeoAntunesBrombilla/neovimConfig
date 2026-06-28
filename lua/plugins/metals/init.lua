local metals = require("metals")
local metals_config = metals.bare_config()

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
metals_config.capabilities = has_cmp
    and vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())
    or vim.lsp.protocol.make_client_capabilities()

metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    showImplicitConversionsAndClasses = true,
    excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
    },
}

local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
        metals.initialize_or_attach(metals_config)
    end,
    group = group,
})
