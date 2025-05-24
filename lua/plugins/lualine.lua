--[[

return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local solarized_palette = require("solarized.utils")
			local colors = solarized_palette.get_colors()

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

			ins_config("a", {
				{
					"mode",
					icon = icons.vim,
					separator = { left = icons.block.left, right = icons.default.right },
					right_padding = 2,
				},
			})

			ins_config("b", {
				{
					"filename",
					fmt = function(filename)
						local icon = "󰈚"

						local devicons_present, devicons = pcall(require, "nvim-web-devicons")

						if devicons_present then
							local ft_icon = devicons.get_icon(filename)
							icon = (ft_icon ~= nil and ft_icon) or icon
						end

						return string.format("%s %s", icon, filename)
					end,
				},
			})

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

			ins_config("x", {})

			ins_config("y", {
				{
					"progress",
					fmt = function(progress)
						local spinners = { "󰚀", "󰪞", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰚀" }

						if string.match(progress, "%a+") then
							return progress
						end

						local p = tonumber(string.match(progress, "%d+"))

						if p ~= nil then
							local index = math.floor(p / (100 / #spinners)) + 1
							return "  " .. spinners[index]
						end
					end,
					separator = { left = icons.default.left },
					cond = hide_in_width,
				},
				{
					"location",
					cond = hide_in_width,
				},
			})

			ins_config("z", {
				{
					function()
						local msg = "No Lsp"
						local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
						local clients = vim.lsp.get_clients()
						if next(clients) == nil then
							return msg
						end
						for _, client in ipairs(clients) do
							local filetypes = client.config.filetypes
							if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
								if client.name ~= "null-ls" then
									return client.name
								end
							end
						end
						return msg
					end,
				},
			})

			require("lualine").setup({
				options = {
					theme = solarized,
					component_separators = "",
					section_separators = { left = icons.default.right, right = icons.default.left },
					disabled_filetypes = {
						"NvimTree",
						"starter",
					},
					refresh = {  -- 🚀 Fastest possible updates
						statusline = 50, -- Instant updates when switching modes
						tabline = 100, -- Smooth tab switching
						winbar = 150, -- Faster floating windows & UI elements
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
--]]

-- ⬇️ Copy–paste straight into your plugins table
return {
	{
		"nvim-lualine/lualine.nvim",
		-- make sure the GitHub theme is available
		dependencies = { "projekt0n/github-nvim-theme" },
		config = function()
			--------------------------------------------------------------------------
			-- GitHub Dark High-Contrast palette (WCAG-AA compliant)
			--------------------------------------------------------------------------
			local colors = {
				bg      = "#0A0C10",
				fg      = "#F0F6FC",
				red     = "#FF7B72",
				green   = "#3FB950",
				yellow  = "#D29922",
				blue    = "#58A6FF",
				magenta = "#BC8CFF",
				cyan    = "#39C5CF",
				orange  = "#F0883E",
			}

			--------------------------------------------------------------------------
			-- Helpers
			--------------------------------------------------------------------------
			local hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end

			local sections = {}

			local icons = {
				vim     = "",
				git     = "",
				diff    = { added = "󰐕", modified = "󰧞", removed = "󰍴" },
				default = { left = "", right = " " },
				round   = { left = "", right = "" },
				block   = { left = "█", right = "█" },
				arrow   = { left = "", right = "" },
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
					icon          = icons.vim,
					separator     = { left = icons.block.left, right = icons.default.right },
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
						added    = { fg = colors.green },
						modified = { fg = colors.orange },
						removed  = { fg = colors.red },
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
							if client.name ~= "null-ls" and client.config.filetypes
									and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
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
				options           = {
					theme                = "github_dark_high_contrast",
					component_separators = "",
					section_separators   = { left = icons.default.right, right = icons.default.left },
					disabled_filetypes   = { "NvimTree", "starter" },
					refresh              = { -- ultra-fast updates
						statusline = 50,
						tabline    = 100,
						winbar     = 150,
					},
				},
				sections          = sections,
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline           = {},
				extensions        = {},
			})
		end,
	},
}
