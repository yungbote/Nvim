vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		if vim.o.paste then
			vim.o.paste = false
		end
	end,
})
