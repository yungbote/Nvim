return {
	"yungbote/gravity.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Load the module first
		require("gravity").setup()
		-- Then try to set colorscheme
		vim.schedule(function()
			vim.cmd("colorscheme gravity")
		end)
	end,
}
