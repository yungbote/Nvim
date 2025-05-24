-- FILE: lua/plugins/lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- Auto-installs LSPs
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim",       opts = {} }, -- LSP status updates
		"hrsh7th/nvim-cmp",               -- Autocompletion
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		------------------------------------------------------------------------------
		-- IMPORTS
		------------------------------------------------------------------------------
		local cmp = require("cmp")
		local lspconfig = require("lspconfig")
		local mason_lsp = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
			pyright = {},
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
		}

		------------------------------------------------------------------------------
		-- NVIM-CMP COMPLETION SETUP
		------------------------------------------------------------------------------
		cmp.setup({
			completion = {
				autocomplete = false, -- Start turned OFF by default (toggle with <leader>co).
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
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
				-- ... plus any formatters or linters you want for your other languages
			},
		})

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					-- If we have custom per-server configs, merge them:
					local base_config = servers[server_name] or {}
					lspconfig[server_name].setup(base_config)
				end,
			},
		})
	end,
}
