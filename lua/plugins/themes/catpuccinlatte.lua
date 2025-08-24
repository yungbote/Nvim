return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "latte", -- Light theme like Jupyter
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
