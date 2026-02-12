return {
	"shaunsingh/solarized.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Configure all solarized options
		vim.g.solarized_italic_comments = true
		vim.g.solarized_italic_keywords = true
		vim.g.solarized_italic_functions = true
		vim.g.solarized_italic_variables = true
		vim.g.solarized_contrast = true
		vim.g.solarized_borders = true
		vim.g.solarized_disable_background = false

		-- Enable termguicolors for proper colors
		vim.opt.termguicolors = true

		-- IMPORTANT: Set to light mode for Solarized Light
		vim.opt.background = "light"

		-- Apply the colorscheme
		vim.cmd.colorscheme("solarized")
	end,
}
