-- File: lua/plugins/autoformatting.lua
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensures formatters/linters are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- for setting up formatters
		local diagnostics = null_ls.builtins.diagnostics -- for linters

		-- Specify which external tools should be installed by Mason
		require("mason-null-ls").setup({
			ensure_installed = {
				"clang-format",
				"prettier",
				"stylua",
				"eslint_d",
				"shfmt",
				"checkmake",
				"ruff",
				--"ast-grep",
			},
			automatic_installation = true,
		})

		-- Configure the null-ls sources: formatters & linters
		local sources = {
			diagnostics.checkmake,

			formatting.clang_format.with({
				filetypes = { "c", "cpp", "hpp", "objcpp", "cuda", "proto" },
				extra_args = {
					"--style",
					table.concat({
						"{",
						"BasedOnStyle: llvm,",
						"IndentWidth: 2,",
						"AccessModifierOffset: 2,",
						"IndentAccessModifiers: true,",
						"NamespaceIndentation: All,",
						"BraceWrapping: { AfterNamespace: false }",
						"}",
					}, " "),
					"--fallback-style=none",
				},
			}),

			formatting.prettier.with({
				filetypes = { "html", "json", "yaml", "markdown" },
			}),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,

			-- For Python & ruff
			require("none-ls.formatting.ruff").with({
				extra_args = { "--extend-select", "I" },
			}),
			require("none-ls.formatting.ruff_format"),
		}

		-- Setup null-ls
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
				local block_formatting = {
					cpp = true,
					c = true,
					hpp = true,
					h = true,
				}

				if client.supports_method("textDocument/formatting") and not block_formatting[ft] then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								async = false,
								filter = function(client)
									return client.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})
	end,
}
