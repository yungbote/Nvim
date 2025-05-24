return {
	{
		"bfredl/nvim-ipy",
		-- you can pin a specific commit if you want:
		-- commit = "some_commit_hash",
		config = function()
			-- Example keybindings (optional):
			-- Send a line or selection to the IPython REPL
			vim.api.nvim_set_keymap("v", "<leader>r", ":IPyRun<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>r", ":IPyRun<CR>", { noremap = true })

			-- Start/stop the IPython REPL
			vim.api.nvim_set_keymap("n", "<leader>is", ":IPythonStart<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>iq", ":IPythonStop<CR>", { noremap = true })
		end,
	},
}
