return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- Auto-installs LSPs
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} }, -- LSP status updates
		"hrsh7th/nvim-cmp", -- Autocompletion
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local cmp = require("cmp")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require("lspconfig")
		local servers = {
			["typescript-language-server"] = {},
			pyright = {},
			gopls = {},
			clangd = {},
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

		-- Optimized Completion Setup
		cmp.setup({
			completion = {
				autocomplete = false,
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

		-- Mason & LSP Config
		require("mason").setup()
		require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers) })
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					lspconfig[server_name].setup(
						vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server_name] or {})
					)
				end,
			},
		})
	end,
}
