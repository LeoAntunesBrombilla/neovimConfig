return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"b0o/schemastore.nvim",
	},
	config = function()
		-- ============================================
		-- PERFORMANCE OPTIMIZATIONS
		-- ============================================
		vim.o.updatetime = 250

		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = 80,
			focus_id = "textDocument/hover",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focus_id = "textDocument/signatureHelp",
		})

		-- ============================================
		-- CAPABILITIES
		-- ============================================
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if has_cmp then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
		end
		capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

		-- ============================================
		-- KEYMAPS (single LspAttach handles all servers)
		-- ============================================
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf
				local opts = { buffer = bufnr, noremap = true, silent = true }

				-- ts_ls: disable formatting (use conform) and semantic tokens
				if client and client.name == "ts_ls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					client.server_capabilities.semanticTokensProvider = nil
				end

				-- Navigation
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
				vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

				-- Workspace
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "[W]orkspace [A]dd folder" }))
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "[W]orkspace [R]emove folder" }))
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, vim.tbl_extend("force", opts, { desc = "[W]orkspace [L]ist folders" }))

				-- Actions
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "[R]ename" }))
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "[C]ode [A]ction" }))

				-- Diagnostics
				vim.keymap.set("n", "<leader>e", function()
					vim.diagnostic.open_float(nil, { scope = "cursor" })
				end, vim.tbl_extend("force", opts, { desc = "Show diagnostic [E]rror" }))
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

				-- Document highlight
				if client and client.server_capabilities.documentHighlightProvider then
					local hl_group = vim.api.nvim_create_augroup("LspDocHighlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = bufnr,
						group = hl_group,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = bufnr,
						group = hl_group,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- ============================================
		-- TYPESCRIPT / JAVASCRIPT
		-- ============================================
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			root_markers = { "package.json", "tsconfig.json", ".git" },
			single_file_support = true,
			flags = { debounce_text_changes = 150 },
			init_options = {
				hostInfo = "neovim",
				maxTsServerMemory = 4096,
				preferences = {
					includeInlayParameterNameHints = "none",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = false,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = false,
					importModuleSpecifierPreference = "shortest",
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeAutomaticOptionalChainCompletions = true,
					quotePreference = "auto",
					allowIncompleteCompletions = true,
					allowTextChangesInNewFiles = true,
				},
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "none",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = false,
						includeInlayVariableTypeHints = false,
						includeInlayPropertyDeclarationTypeHints = false,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = false,
					},
					format = { enable = false },
					suggest = {
						completeFunctionCalls = true,
						includeCompletionsForImportStatements = true,
						includeAutomaticOptionalChainCompletions = true,
					},
					preferences = {
						importModuleSpecifier = "shortest",
						preferTypeOnlyAutoImports = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "none",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = false,
						includeInlayVariableTypeHints = false,
						includeInlayPropertyDeclarationTypeHints = false,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = false,
					},
					format = { enable = false },
					suggest = {
						completeFunctionCalls = true,
						includeCompletionsForImportStatements = true,
						includeAutomaticOptionalChainCompletions = true,
					},
					preferences = { importModuleSpecifier = "shortest" },
				},
				completions = { completeFunctionCalls = true },
			},
		})
		vim.lsp.enable("ts_ls")

		-- ============================================
		-- PYTHON
		-- ============================================
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			flags = { debounce_text_changes = 150 },
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						typeCheckingMode = "basic",
						autoImportCompletions = true,
						completeFunctionParens = true,
					},
				},
			},
		})
		vim.lsp.enable("pyright")

		-- ============================================
		-- LUA
		-- ============================================
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			flags = { debounce_text_changes = 150 },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "vim" },
						disable = { "missing-fields" },
					},
					workspace = {
						library = { vim.api.nvim_get_runtime_file("", true) },
						checkThirdParty = false,
						maxPreload = 2000,
						preloadFileSize = 1000,
					},
					telemetry = { enable = false },
					hint = { enable = false },
					completion = {
						callSnippet = "Replace",
						showWord = "Disable",
					},
					format = { enable = false },
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- ============================================
		-- JSON
		-- ============================================
		vim.lsp.config("jsonls", {
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
		vim.lsp.enable("jsonls")

		-- ============================================
		-- HTML / CSS
		-- ============================================
		vim.lsp.config("html", { capabilities = capabilities })
		vim.lsp.enable("html")

		vim.lsp.config("cssls", { capabilities = capabilities })
		vim.lsp.enable("cssls")

		-- ============================================
		-- C++
		-- ============================================
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			flags = { debounce_text_changes = 150 },
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
		})
		vim.lsp.enable("clangd")

		-- ============================================
		-- AUTO COMMANDS
		-- ============================================
		local lsp_group = vim.api.nvim_create_augroup("LspPerformance", { clear = true })

		-- Disable LSP for large files
		vim.api.nvim_create_autocmd("BufReadPre", {
			group = lsp_group,
			callback = function(args)
				local ok, stats = pcall(vim.loop.fs_stat, args.file)
				if ok and stats and stats.size > 500 * 1024 then
					vim.b[args.buf].large_file = true
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_group,
			callback = function(args)
				if vim.b[args.buf].large_file then
					vim.schedule(function()
						vim.lsp.buf_detach_client(args.buf, args.data.client_id)
					end)
					vim.notify("LSP detached for large file", vim.log.levels.INFO)
				end
			end,
		})

		-- Show diagnostics on hover
		vim.api.nvim_create_autocmd("CursorHold", {
			group = lsp_group,
			callback = function()
				if not vim.b.large_file then
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always",
						prefix = " ",
						scope = "cursor",
					})
				end
			end,
		})
	end,
}
