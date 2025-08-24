-- Save this as ~/.config/nvim/lua/plugins/iron.lua (or wherever your plugins are)
return {
	"Vigemus/iron.nvim",
	cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
	config = function()
		local iron = require("iron.core")
		iron.setup({
			config = {
				-- Should the repl be opened in a vertical split
				repl_definition = {
					rust = {
						command = { "evcxr" },
					},
				},
				-- How the repl window will be displayed
				repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "<space>qwer",
				-- visual_send = "<F2>", -- DISABLED - we'll use our fixed version
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_until_cursor = "<space>ccc",
				send_mark = "<F4>",
				mark_motion = "<space>mc",
				mark_visual = "<F3>",
				remove_mark = "<space>md",
				cr = "<space>s<cr>",
				interrupt = "<space>s<space>",
				exit = "<space>sq",
				clear = "<space>cl",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
		})

		-- ACTUALLY WORKING visual send that captures CURRENT selection
		vim.keymap.set("v", "<F5>", function()
			-- Get the ACTUAL current selection positions
			local start_row, start_col = unpack(vim.fn.getpos("v"), 2, 3)
			local end_row, end_col = unpack(vim.fn.getpos("."), 2, 3)

			-- Make sure start comes before end
			if start_row > end_row or (start_row == end_row and start_col > end_col) then
				start_row, end_row = end_row, start_row
				start_col, end_col = end_col, start_col
			end

			-- Get the lines
			local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

			-- Handle partial line selection
			if #lines > 0 then
				if #lines == 1 then
					-- Single line selection
					lines[1] = string.sub(lines[1], start_col, end_col)
				else
					-- Multi-line selection
					lines[1] = string.sub(lines[1], start_col)
					lines[#lines] = string.sub(lines[#lines], 1, end_col)
				end
			end

			-- Send to REPL
			require("iron.core").send("rust", lines)
		end, { desc = "Send CURRENT visual selection" })

		-- Alternative: Send using yank register (also works)
		vim.keymap.set("v", "<F6>", function()
			vim.cmd('normal! "zy')
			local selection = vim.fn.getreg("z")
			local lines = vim.split(selection, "\n", { plain = true })
			require("iron.core").send("rust", lines)
		end, { desc = "Send using yank method" })

		-- iron also has a list of commands, see :h iron-commands for all available commands
		vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
		vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
	end,
}
