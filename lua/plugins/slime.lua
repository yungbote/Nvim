return {
	"jpalardy/vim-slime",
	config = function()
		vim.g.slime_target = "neovim"
		vim.g.slime_no_mappings = 1

		-- Auto-find evcxr terminal
		vim.g.slime_get_jobid = function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf].buftype == "terminal" then
					local name = vim.api.nvim_buf_get_name(buf)
					if name:match("evcxr") then
						return vim.b[buf].terminal_job_id
					end
				end
			end
		end

		vim.keymap.set("x", "<F3>", "<Plug>SlimeRegionSend")
		vim.keymap.set("n", "<F2>", "<Plug>SlimeLineSend")
	end,
}
