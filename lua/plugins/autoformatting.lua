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

		-- Custom formatter: fourmolu (some none-ls builds don't ship a builtin)
		local h = require("null-ls.helpers")
		local methods = require("null-ls.methods")
		local fourmolu = h.make_builtin({
			name = "fourmolu",
			meta = {
				url = "https://github.com/fourmolu/fourmolu",
				description = "Haskell code formatter",
			},
			method = methods.internal.FORMATTING,
			filetypes = { "haskell" },
			generator_opts = {
				command = "fourmolu",
				args = { "--stdin-input-file", "$FILENAME" },
				to_stdin = true,
			},
			factory = h.formatter_factory,
		})

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
				"fourmolu",
				--"ast-grep",
			},
			automatic_installation = true,
		})

		-- Configure the null-ls sources: formatters & linters
		local sources = {
			diagnostics.checkmake,

			-- Haskell
			fourmolu,

			formatting.clang_format.with({
				filetypes = { "c", "cpp", "hpp", "objcpp", "cuda", "proto" },
				extra_args = {
					"--style",
					table.concat({
						"{",
						"BasedOnStyle: llvm,",
						"IndentWidth: 4,",
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

		-- Setup null-ls without format-on-save hooks.
		null_ls.setup({
			sources = sources,
		})
		end,
	}
