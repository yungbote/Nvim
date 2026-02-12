-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	config = function()
		require("rose-pine").setup({

			variant = "moon",
			dark_variant = "main",

			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = {
				terminal = true,
				legacy_highlights = true,
				migrations = true,
			},

			styles = {
				bold = false,
				italic = true,
				transparency = true,
			},

			palette = {
				moon = {
					text = "#b8b8c2",
					muted = "#8c8c97",
					subtle = "#74747f",
					iris = "#9087a8",
					foam = "#7f9aa0",
					pine = "#688785",
					pine2 = "#626c53",
					rust = "#8a6f5c",
					steel = "#5f7c86",
					slate = "#6d7391",
					love = "#a87480",
					gold = "#958a78",
					rose = "#a98098",
				},
			},

			highlight_groups = {

				-- =====================
				-- Base
				-- =====================

				Normal = { fg = "text" },

				-- =====================
				-- Identifiers
				-- =====================

				Identifier = { fg = "subtle" },
				["@variable"] = { fg = "subtle" },
				["@variable.parameter"] = { fg = "muted" },
				["@parameter"] = { fg = "muted" },
				["@variable.member"] = { fg = "foam" },
				["@variable.builtin"] = { fg = "iris" },

				-- =====================
				-- Functions
				-- =====================

				Function = { fg = "rose" },
				["@function"] = { fg = "rose" },
				["@function.method"] = { fg = "rose" },
				["@function.builtin"] = { fg = "iris" },
				["@function.call"] = { fg = "rose" },
				["@method"] = { fg = "rose" },

				-- =====================
				-- Types
				-- =====================

				["@type.builtin"] = { fg = "muted" },
				["@type"] = { fg = "pine2" },
				["@type.definition"] = { fg = "pine2" },
				["@type.parameter"] = { fg = "slate" },
				["@class"] = { fg = "pine2" },
				["@struct"] = { fg = "pine2" },
				["@interface"] = { fg = "pine2" },
				["@enum"] = { fg = "rust" },
				["@enum.member"] = { fg = "gold" },
				["@constructor"] = { fg = "pine2" },

				-- =====================
				-- Keywords
				-- =====================

				["@keyword.control"] = { fg = "pine2" },
				["@keyword.return"] = { fg = "pine2" },
				["@keyword.repeat"] = { fg = "pine2" },
				["@keyword.conditional"] = { fg = "pine2" },

				["@keyword.function"] = { fg = "iris" },
				["@keyword.storage"] = { fg = "iris" },
				["@keyword.type"] = { fg = "iris" },
				["@keyword.operator"] = { fg = "muted" },
				["@keyword"] = { fg = "iris" },

				-- =====================
				-- Namespaces / Modules
				-- =====================

				["@namespace"] = { fg = "steel" },
				["@module"] = { fg = "steel" },
				["@module.builtin"] = { fg = "steel" },

				-- =====================
				-- Constants / Literals
				-- =====================

				Constant = { fg = "gold" },
				["@constant"] = { fg = "gold" },
				["@constant.builtin"] = { fg = "gold" },
				["@constant.macro"] = { fg = "love" },
				["@number"] = { fg = "gold" },
				["@boolean"] = { fg = "gold" },
				["@float"] = { fg = "gold" },
				["@string"] = { fg = "gold" },
				["@string.escape"] = { fg = "iris" },
				["@string.special"] = { fg = "iris" },

				-- =====================
				-- Operators / Punctuation
				-- =====================

				Operator = { fg = "muted" },
				["@operator"] = { fg = "muted" },
				["@operator.assignment"] = { fg = "muted" },
				["@punctuation"] = { fg = "muted" },
				["@punctuation.bracket"] = { fg = "muted" },
				["@punctuation.delimiter"] = { fg = "muted" },

				-- =====================
				-- Fields / Properties
				-- =====================

				["@field"] = { fg = "foam" },
				["@property"] = { fg = "foam" },

				-- =====================
				-- Preprocessor / Macros
				-- =====================

				PreProc = { fg = "love" },
				["@macro"] = { fg = "love" },
				["@include"] = { fg = "love" },

				-- =====================
				-- Attributes
				-- =====================

				["@attribute"] = { fg = "iris" },

				-- =====================
				-- Comments
				-- =====================

				Comment = { fg = "subtle", italic = true },
				["@comment"] = { fg = "subtle", italic = true },

				-- =====================
				-- LSP Semantic Tokens
				-- =====================

				["@lsp.type.class"] = { fg = "pine2" },
				["@lsp.type.struct"] = { fg = "pine2" },
				["@lsp.type.enum"] = { fg = "rust" },
				["@lsp.type.enumMember"] = { fg = "gold" },
				["@lsp.type.interface"] = { fg = "pine2" },
				["@lsp.type.namespace"] = { fg = "steel" },
				["@lsp.type.property"] = { fg = "foam" },
				["@lsp.type.parameter"] = { fg = "slate" },
				["@lsp.type.typeParameter"] = { fg = "slate" },
				["@lsp.type.variable"] = { fg = "subtle" },
				["@lsp.type.function"] = { fg = "rose" },
				["@lsp.type.method"] = { fg = "rose" },
				["@lsp.type.keyword"] = { fg = "pine2" },
				["@lsp.type.type"] = { fg = "pine2" },

				["@lsp.typemod.keyword"] = { fg = "pine2" },
				["@lsp.typemod.keyword.control"] = { fg = "pine2" },

				-- =====================
				-- UI
				-- =====================

				LineNr = { fg = "muted" },
				CursorLineNr = { fg = "text" },
				VertSplit = { fg = "muted" },
				MatchParen = { fg = "iris" },

				NormalFloat = { bg = "surface" },
				FloatBorder = { fg = "muted", bg = "surface" },
				Pmenu = { bg = "surface" },
				PmenuSel = { bg = "highlight_med", fg = "text", inherit = false },

				Visual = { bg = "highlight_med", inherit = false },

				-- =====================
				-- Diagnostics
				-- =====================

				DiagnosticVirtualTextError = { fg = "love", bg = "love", blend = 92 },
				DiagnosticVirtualTextWarn = { fg = "gold", bg = "gold", blend = 92 },
				DiagnosticVirtualTextInfo = { fg = "foam", bg = "foam", blend = 92 },
				DiagnosticVirtualTextHint = { fg = "iris", bg = "iris", blend = 92 },
			},

			before_highlight = function(group, hl, palette)
				if group == "Comment" then
					hl.fg = palette.subtle
				end
			end,
		})

		vim.cmd("colorscheme rose-pine")
	end,
}
