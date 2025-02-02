return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- Hints keybinds
		-- 'folke/which-key.nvim',
	},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"mikesmithgh/kitty-scrollback.nvim",
		lazy = false,
		config = function()
			require("kitty-scrollback").setup({
				visual_selection_highlight_mode = "nvim",
			})
		end,
	},
	--{
	-- Highlight todo, notes, etc in comments
	-- 'folke/todo-comments.nvim',
	--event = 'VimEnter',
	--dependencies = { 'nvim-lua/plenary.nvim' },
	--opts = { signs = false },
	--},
}
