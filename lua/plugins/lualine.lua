-- ⬇️ Copy–paste straight into your plugins table
return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			--------------------------------------------------------------------------
			-- Moonlight palette (washed / pastel variant)
			--------------------------------------------------------------------------
			local colors = {
				bg = "#232136", -- base
				fg = "#dad8ec", -- text
				red = "#e58098", -- love
				green = "#a3b0ac", -- leaf
				yellow = "#f5e0c5", -- gold (unused but defined for completeness)
				blue = "#6099b8", -- pine
				magenta = "#c5b0e5", -- iris
				cyan = "#a8c8d5", -- foam
				orange = "#f5e0c5", -- gold (alias for modified diff state)
				muted = "#807c98", -- muted
				surface = "#2a273f", -- surface
			}

			--------------------------------------------------------------------------
			-- Minimal Moonlight-matching Lualine theme table
			--------------------------------------------------------------------------
			local moon = {
				normal = {
					a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface },
					c = { fg = colors.fg, bg = colors.bg },
				},
				insert = {
					a = { fg = colors.bg, bg = colors.green, gui = "bold" },
				},
				visual = {
					a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
				},
				replace = {
					a = { fg = colors.bg, bg = colors.red, gui = "bold" },
				},
				command = {
					a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
				},
				inactive = {
					a = { fg = colors.muted, bg = colors.bg, gui = "bold" },
					b = { fg = colors.muted, bg = colors.bg },
					c = { fg = colors.muted, bg = colors.bg },
				},
			}

			--------------------------------------------------------------------------
			-- Helpers
			--------------------------------------------------------------------------
			local hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end

			local sections = {}

			local icons = {
				vim = "",
				git = "",
				diff = { added = "󰐕", modified = "󰧞", removed = "󰍴" },
				default = { left = "", right = " " },
				round = { left = "", right = "" },
				block = { left = "█", right = "█" },
				arrow = { left = "", right = "" },
			}

			local function ins_config(location, component)
				sections["lualine_" .. location] = component
			end

			--------------------------------------------------------------------------
			-- A section (mode)
			--------------------------------------------------------------------------
			ins_config("a", {
				{
					"mode",
					icon = icons.vim,
					separator = { left = icons.block.left, right = icons.default.right },
					right_padding = 2,
				},
			})

			--------------------------------------------------------------------------
			-- B section (filename)
			--------------------------------------------------------------------------
			ins_config("b", {
				{
					"filename",
					fmt = function(filename)
						local icon = "󰈚"
						local ok, devicons = pcall(require, "nvim-web-devicons")
						if ok then
							icon = devicons.get_icon(filename) or icon
						end
						return string.format("%s %s", icon, filename)
					end,
				},
			})

			--------------------------------------------------------------------------
			-- C section (git branch + diff)
			--------------------------------------------------------------------------
			ins_config("c", {
				{
					"branch",
					icon = { icons.git, color = { fg = colors.magenta } },
					cond = hide_in_width,
				},
				{
					"diff",
					symbols = icons.diff,
					colored = true,
					diff_color = {
						added = { fg = colors.green },
						modified = { fg = colors.orange },
						removed = { fg = colors.red },
					},
					cond = hide_in_width,
				},
			})

			--------------------------------------------------------------------------
			-- X section (empty to keep spacing consistent)
			--------------------------------------------------------------------------
			ins_config("x", {})

			--------------------------------------------------------------------------
			-- Y section (progress + location)
			--------------------------------------------------------------------------
			ins_config("y", {
				{
					"progress",
					fmt = function(progress)
						local spinners = { "󰚀", "󰪞", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰚀" }
						if progress:match("%a+") then
							return progress
						end
						local p = tonumber(progress:match("%d+"))
						if p then
							local index = math.floor(p / (100 / #spinners)) + 1
							return "  " .. spinners[index]
						end
					end,
					separator = { left = icons.default.left },
					cond = hide_in_width,
				},
				{ "location", cond = hide_in_width },
			})

			--------------------------------------------------------------------------
			-- Z section (active LSP name)
			--------------------------------------------------------------------------
			ins_config("z", {
				{
					function()
						local msg = "No Lsp"
						local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
						for _, client in ipairs(vim.lsp.get_clients()) do
							if
								client.name ~= "null-ls"
								and client.config.filetypes
								and vim.fn.index(client.config.filetypes, buf_ft) ~= -1
							then
								return client.name
							end
						end
						return msg
					end,
				},
			})

			--------------------------------------------------------------------------
			-- Lualine setup
			--------------------------------------------------------------------------
			require("lualine").setup({
				options = {
					theme = moon, -- apply the custom Moonlight theme
					component_separators = "",
					section_separators = { left = icons.default.right, right = icons.default.left },
					disabled_filetypes = { "NvimTree", "starter" },
					refresh = { -- ultra-fast updates
						statusline = 50,
						tabline = 100,
						winbar = 150,
					},
				},
				sections = sections,
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline = {},
				extensions = {},
			})
		end,
	},
}
