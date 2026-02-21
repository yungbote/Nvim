-- FILE: lua/plugins/lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- Auto-installs LSPs
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} }, -- LSP status updates
		"saghen/blink.cmp",
	},
	config = function()
		------------------------------------------------------------------------------
		-- IMPORTS
		------------------------------------------------------------------------------
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local has_blink, blink = pcall(require, "blink.cmp")
		if has_blink then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		------------------------------------------------------------------------------
		-- CLANGD SPECIFIC CONFIG
		------------------------------------------------------------------------------
		-- We rely on null-ls for formatting; disable clangd’s built-in formatting
		-- so they don't clash. Also set offsetEncoding for clangd to avoid issues.
		local clangd_config = {
			capabilities = vim.tbl_deep_extend("force", capabilities or {}, { offsetEncoding = { "utf-16" } }),
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		}

		------------------------------------------------------------------------------
		-- LSP SERVERS
		------------------------------------------------------------------------------
		local servers = {
			["typescript-language-server"] = {},
			pyright = {
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			},
			gopls = {},
			clangd = clangd_config,
			["clojure-lsp"] = {},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = { "${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true)) },
						},
						diagnostics = { disable = { "missing-fields" } },
					},
				},
			},
			bashls = {},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			jsonls = {},
			hls = {},
		}

		------------------------------------------------------------------------------
		-- LSP KEYMAPS + INLAY HINTS
		------------------------------------------------------------------------------
		local lsp_attach_group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
		local function map_lsp(bufnr, mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(args)
				local bufnr = args.buf
				local client = args.data and vim.lsp.get_client_by_id(args.data.client_id) or nil

				map_lsp(bufnr, "n", "K", vim.lsp.buf.hover, "LSP Hover")
				map_lsp(bufnr, "n", "gd", vim.lsp.buf.definition, "LSP Go To Definition")
				map_lsp(bufnr, "n", "gr", vim.lsp.buf.references, "LSP References")
				map_lsp(bufnr, "n", "gri", vim.lsp.buf.implementation, "LSP Go To Implementation")
				map_lsp(bufnr, "n", "grt", vim.lsp.buf.type_definition, "LSP Go To Type Definition")
				map_lsp(bufnr, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
				map_lsp(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename Symbol")


				if client and client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					map_lsp(bufnr, "n", "<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "LSP Toggle Inlay Hints")
				end
			end,
		})

		------------------------------------------------------------------------------
		-- MASON + MASON-TOOL-INSTALLER + MASON-LSPCONFIG
		------------------------------------------------------------------------------
		require("mason").setup()

		require("mason-tool-installer").setup({
			-- You can ensure that each of the servers above is installed by listing them:
			ensure_installed = {
				"typescript-language-server",
				"pyright",
				"gopls",
				"clangd",
				"clojure-lsp",
				"lua-language-server",
				"bash-language-server",
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"haskell-language-server",
				-- ... plus any formatters or linters you want for your other languages
			},
		})

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					-- If we have custom per-server configs, merge them:
					local base_config = servers[server_name] or {}
					base_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, base_config.capabilities or {})
					lspconfig[server_name].setup(base_config)
				end,
			},
		})
	end,
}
