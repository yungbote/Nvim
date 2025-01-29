return {
	"nvim-neo-tree/neo-tree.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
			keys = {
				{ "<leader>w", ":Neotree toggle float<CR>",         silent = true, desc = "Float File Explorer" },
				{ "<leader>e", ":Neotree toggle position=left<CR>", silent = true, desc = "Left File Explorer" },
				{
					"<leader>ngs",
					":Neotree float git_status<CR>",
					silent = true,
					desc = "Neotree Open Git Status Window",
				},
			},
		},
	},
	config = function()
		local signs = {
			Error = " ",
			Warn = " ",
			Info = " ",
			Hint = "󰌵",
		}
		for type, icon in pairs(signs) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		require("neo-tree").setup({
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
			sort_case_insensitive = false,
			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = { symbol = "[+]", highlight = "NeoTreeModified" },
				name = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
				git_status = {
					symbols = {
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "left",
				width = 30,
				mapping_options = { noremap = true, nowait = true },
				mappings = {
					["<space>"] = { "toggle_node", nowait = false },
					["<cr>"] = "open",
					["l"] = "open",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = { "add", config = { show_path = "none" } },
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["i"] = "show_file_details",
				},
			},
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
					hide_by_name = { ".DS_Store", "thumbs.db", "node_modules", "__pycache__", ".git", ".venv" },
				},
				follow_current_file = { enabled = false, leave_dirs_open = false },
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = false,
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["D"] = "fuzzy_finder_directory",
						["#"] = "fuzzy_sorter",
						["f"] = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
					},
				},
			},
			buffers = {
				follow_current_file = { enabled = true, leave_dirs_open = false },
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
					},
				},
			},
		})

		vim.cmd([[nnoremap \ :Neotree reveal<CR>]])

		-- Set highlights
		local highlights = {
			NeoTreeDirectoryName = "#657b83",
			NeoTreeDirectoryIcon = "#657b83",
			NeoTreeFileName = "#657b83",
			NeoTreeFileIcon = "#657b83",
		}
		for group, color in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, { fg = color })
		end

		-- Fix nvim-web-devicons highlights safely
		local devicons = require("nvim-web-devicons")
		for name, _ in pairs(devicons.get_icons()) do
			if type(name) == "string" then -- Prevent errors from number indexes
				local hl_group = "DevIcon" .. name:gsub("%W", "_")
				vim.api.nvim_set_hl(0, hl_group, { link = "NeoTreeFileIcon" })
			end
		end
	end,
}
