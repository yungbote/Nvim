return {
	dir = "~/.config/nvim/lua/rose-pine-washed",
	name = "rose-pine",
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			styles = {
				italic = false,
				transparency = true,
			},
			disable_background = true,
		})
		vim.cmd("colorscheme rose-pine")

		-- Remove ALL backgrounds
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
		vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
	end,
}
