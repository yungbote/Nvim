return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			enabled = function()
				return vim.g.completion_enabled ~= false
			end,
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"stevearc/aerial.nvim",
		opts = {
			backends = { "lsp", "treesitter", "markdown", "man" },
			layout = {
				default_direction = "prefer_left",
				min_width = 30,
				max_width = { 40, 0.3 },
			},
			attach_mode = "global",
			show_guides = true,
			filter_kind = false,
		},
		keys = {
			{ "<leader>so", "<cmd>AerialToggle!<CR>", desc = "Symbols Outline (Aerial)" },
			{ "]s", "<cmd>AerialNext<CR>", desc = "Next Symbol" },
			{ "[s", "<cmd>AerialPrev<CR>", desc = "Prev Symbol" },
		},
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "LSP References (Trouble)" },
			{ "<leader>xd", "<cmd>Trouble lsp_definitions toggle<CR>", desc = "LSP Definitions (Trouble)" },
			{ "<leader>xi", "<cmd>Trouble lsp_implementations toggle<CR>", desc = "LSP Implementations (Trouble)" },
			{ "<leader>xt", "<cmd>Trouble lsp_type_definitions toggle<CR>", desc = "LSP Type Definitions (Trouble)" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					timeout = 2500,
					max_width = function()
						return math.floor(vim.o.columns * 0.55)
					end,
					top_down = false,
				},
				config = function(_, opts)
					local notify = require("notify")
					notify.setup(opts)
					vim.notify = notify
				end,
			},
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
				hover = {
					enabled = true,
				},
				signature = {
					enabled = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		keys = {
			{ "<leader>nh", "<cmd>Noice history<CR>", desc = "Noice History" },
			{ "<leader>nl", "<cmd>Noice last<CR>", desc = "Noice Last Message" },
			{ "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Noice Dismiss" },
		},
	},
}
