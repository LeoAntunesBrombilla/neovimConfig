return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"b0o/schemastore.nvim", -- JSON schemas for better json LSP
	},
	config = function()
		-- ============================================
		-- PERFORMANCE OPTIMIZATIONS
		-- ============================================

		-- Reduce update time for faster diagnostics
		vim.o.updatetime = 250 -- Default is 4000ms

		-- Configure diagnostics globally
		vim.diagnostic.config({
			virtual_text = false, -- Disable inline diagnostics for performance
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

		-- Optimize hover handler
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = 80,
			focus_id = "textDocument/hover",
		})

		-- Optimize signature help
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focus_id = "textDocument/signatureHelp",
		})

		-- ============================================
		-- CAPABILITIES SETUP (for all servers)
		-- ============================================
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Add nvim-cmp capabilities if you have it installed
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if has_cmp then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
		end

		-- Optimize file watching
		capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

		-- ============================================
		-- COMMON LSP KEYMAPS
		-- ============================================
		local function setup_keymaps(client, bufnr)
			local opts = { buffer = bufnr, noremap = true, silent = true }

			-- Navigation
			vim.keymap.set(
				"n",
				"gD",
				vim.lsp.buf.declaration,
				vim.tbl_extend("force", opts, { desc = "Go to declaration" })
			)
			vim.keymap.set(
				"n",
				"gd",
				vim.lsp.buf.definition,
				vim.tbl_extend("force", opts, { desc = "Go to definition" })
			)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
			vim.keymap.set(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				vim.tbl_extend("force", opts, { desc = "Go to implementation" })
			)
			vim.keymap.set(
				"n",
				"<C-k>",
				vim.lsp.buf.signature_help,
				vim.tbl_extend("force", opts, { desc = "Signature help" })
			)
			vim.keymap.set(
				"n",
				"gr",
				vim.lsp.buf.references,
				vim.tbl_extend("force", opts, { desc = "[G]o to [R]eferences" })
			)
			vim.keymap.set(
				"n",
				"gt",
				vim.lsp.buf.type_definition,
				vim.tbl_extend("force", opts, { desc = "[G]o to [T]ype definition" })
			)

			-- Workspace
			vim.keymap.set(
				"n",
				"<leader>wa",
				vim.lsp.buf.add_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "[W]orkspace [A]dd folder" })
			)
			vim.keymap.set(
				"n",
				"<leader>wr",
				vim.lsp.buf.remove_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "[W]orkspace [R]emove folder" })
			)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, vim.tbl_extend("force", opts, { desc = "[W]orkspace [L]ist folders" }))

			-- Actions
			vim.keymap.set(
				"n",
				"<leader>rn",
				vim.lsp.buf.rename,
				vim.tbl_extend("force", opts, { desc = "[R]e[n]ame" })
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				vim.tbl_extend("force", opts, { desc = "[C]ode [A]ction" })
			)

			-- Format (only if the server supports it and you want to use it)
			if client.server_capabilities.documentFormattingProvider then
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", opts, { desc = "[F]ormat" }))
			end

			-- Diagnostics
			vim.keymap.set("n", "<leader>e", function()
				vim.diagnostic.open_float(nil, { scope = "cursor" })
			end, vim.tbl_extend("force", opts, { desc = "Show diagnostic [E]rror" }))
			vim.keymap.set(
				"n",
				"[d",
				vim.diagnostic.goto_prev,
				vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
			)
			vim.keymap.set(
				"n",
				"]d",
				vim.diagnostic.goto_next,
				vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
			)
			vim.keymap.set(
				"n",
				"<leader>q",
				vim.diagnostic.setloclist,
				vim.tbl_extend("force", opts, { desc = "Diagnostic [Q]uickfix" })
			)
		end

		-- ============================================
		-- TYPESCRIPT/JAVASCRIPT (Using ts_ls)
		-- ============================================
		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
			init_options = {
				hostInfo = "neovim",
				preferences = {
					-- Disable inlay hints for performance
					includeInlayParameterNameHints = "none",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = false,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = false,
					-- Import module specifier
					importModuleSpecifierPreference = "shortest",
					-- Enable auto imports
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeAutomaticOptionalChainCompletions = true,
					-- Code preferences
					quotePreference = "auto",
					allowIncompleteCompletions = true,
					allowTextChangesInNewFiles = true,
				},
				maxTsServerMemory = 4096, -- Limit memory to 4GB
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
					format = {
						enable = false, -- Use prettier/conform instead
					},
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
					format = {
						enable = false, -- Use prettier/conform instead
					},
					suggest = {
						completeFunctionCalls = true,
						includeCompletionsForImportStatements = true,
						includeAutomaticOptionalChainCompletions = true,
					},
					preferences = {
						importModuleSpecifier = "shortest",
					},
				},
				completions = {
					completeFunctionCalls = true,
				},
			},
			on_attach = function(client, bufnr)
				-- Disable formatting (use conform/prettier instead)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				-- Disable semantic tokens for performance
				client.server_capabilities.semanticTokensProvider = nil

				setup_keymaps(client, bufnr)
			end,
			flags = {
				debounce_text_changes = 150, -- Debounce typing by 150ms
			},
			-- Find the root directory
			root_dir = function(fname)
				local util = require("lspconfig.util")
				return util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
					or util.find_git_ancestor(fname)
					or vim.fn.getcwd()
			end,
			single_file_support = true, -- Support single JS/TS files without project
		})

		-- ============================================
		-- PYTHON (Pyright)
		-- ============================================
		require("lspconfig").pyright.setup({
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly", -- Performance: only analyze open files
						typeCheckingMode = "basic", -- Use "strict" for more checks
						autoImportCompletions = true,
						completeFunctionParens = true,
					},
				},
			},
			on_attach = setup_keymaps,
			flags = {
				debounce_text_changes = 150,
			},
		})

		-- ============================================
		-- LUA
		-- ============================================
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						globals = { "vim" },
						disable = { "missing-fields" }, -- Avoid annoying warnings
					},
					workspace = {
						library = {
							vim.api.nvim_get_runtime_file("", true),
						},
						checkThirdParty = false, -- Faster startup
						maxPreload = 2000,
						preloadFileSize = 1000,
					},
					telemetry = { enable = false },
					hint = {
						enable = false, -- Disable hints for performance
					},
					completion = {
						callSnippet = "Replace",
						showWord = "Disable", -- Don't show text matches
					},
					format = {
						enable = false, -- Use stylua instead
					},
				},
			},
			on_attach = setup_keymaps,
			flags = {
				debounce_text_changes = 150,
			},
		})

		-- ============================================
		-- JSON (with schemastore)
		-- ============================================
		require("lspconfig").jsonls.setup({
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
			on_attach = setup_keymaps,
		})

		-- ============================================
		-- HTML/CSS
		-- ============================================
		require("lspconfig").html.setup({
			capabilities = capabilities,
			on_attach = setup_keymaps,
		})

		require("lspconfig").cssls.setup({
			capabilities = capabilities,
			on_attach = setup_keymaps,
		})

		-- ============================================
		-- TAILWIND CSS (if you use it)
		-- ============================================
		-- require("lspconfig").tailwindcss.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = setup_keymaps,
		-- 	settings = {
		-- 		tailwindCSS = {
		-- 			experimental = {
		-- 				classRegex = {
		-- 					{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
		-- 					{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- ============================================
		-- AUTO COMMANDS FOR PERFORMANCE
		-- ============================================
		local lsp_group = vim.api.nvim_create_augroup("LspPerformance", { clear = true })

		-- Disable LSP for large files
		vim.api.nvim_create_autocmd("BufReadPre", {
			group = lsp_group,
			callback = function(args)
				local max_filesize = 500 * 1024 -- 500 KB
				local ok, stats = pcall(vim.loop.fs_stat, args.file)
				if ok and stats and stats.size > max_filesize then
					vim.b[args.buf].large_file = true
				end
			end,
		})

		-- Attach LSP only if not a large file
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_group,
			callback = function(args)
				local bufnr = args.buf
				if vim.b[bufnr].large_file then
					vim.schedule(function()
						vim.lsp.buf_detach_client(bufnr, args.data.client_id)
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

		-- Highlight references on cursor hold
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_group,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = args.buf,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = args.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})
	end,
}
