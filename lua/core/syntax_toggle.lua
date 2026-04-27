local M = {}

local STATE_FILE = vim.fn.stdpath("state") .. "/syntax_highlighting_state"
local DEFAULT_ENABLED = true

local function read_saved_state()
	if vim.fn.filereadable(STATE_FILE) == 0 then
		return nil
	end

	local ok, lines = pcall(vim.fn.readfile, STATE_FILE)
	if not ok or not lines or #lines == 0 then
		return nil
	end

	local raw = (lines[1] or ""):lower()
	if raw == "on" then
		return true
	end
	if raw == "off" then
		return false
	end

	return nil
end

local function write_saved_state(enabled)
	local dir = vim.fn.fnamemodify(STATE_FILE, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local ok, err = pcall(vim.fn.writefile, { enabled and "on" or "off" }, STATE_FILE)
	if not ok then
		vim.notify("Failed to save syntax highlighting state: " .. tostring(err), vim.log.levels.WARN)
	end
end

local function set_treesitter_for_buffer(buf, enabled)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	if vim.bo[buf].buftype ~= "" then
		return
	end

	if vim.fn.exists(":TSBufEnable") == 2 and vim.fn.exists(":TSBufDisable") == 2 then
		local cmd = enabled and "TSBufEnable highlight" or "TSBufDisable highlight"
		pcall(vim.api.nvim_buf_call, buf, function()
			vim.cmd("silent! " .. cmd)
		end)
		return
	end

	if type(vim.treesitter) ~= "table" then
		return
	end

	if enabled then
		pcall(vim.treesitter.start, buf)
	else
		pcall(vim.treesitter.stop, buf)
	end
end

local function set_semantic_tokens_for_buffer(buf, enabled, client_id)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	if vim.bo[buf].buftype ~= "" then
		return
	end

	if not vim.lsp or not vim.lsp.semantic_tokens then
		return
	end

	if type(vim.lsp.semantic_tokens.start) ~= "function" or type(vim.lsp.semantic_tokens.stop) ~= "function" then
		return
	end

	local ids = {}
	if type(client_id) == "number" then
		ids[1] = client_id
	elseif type(vim.lsp.get_clients) == "function" then
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
			local caps = client.server_capabilities or {}
			if caps.semanticTokensProvider then
				ids[#ids + 1] = client.id
			end
		end
	end

	for _, id in ipairs(ids) do
		if enabled then
			pcall(vim.lsp.semantic_tokens.start, buf, id)
		else
			pcall(vim.lsp.semantic_tokens.stop, buf, id)
		end
	end
end

local function apply_treesitter(enabled)
	if vim.fn.exists(":TSEnable") == 2 and vim.fn.exists(":TSDisable") == 2 then
		local cmd = enabled and "TSEnable highlight" or "TSDisable highlight"
		pcall(vim.cmd, "silent! " .. cmd)
	end

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		set_treesitter_for_buffer(buf, enabled)
	end
end

local function apply_semantic_tokens(enabled)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		set_semantic_tokens_for_buffer(buf, enabled)
	end
end

local function apply_vim_syntax(enabled)
	if enabled then
		vim.cmd("silent! syntax enable")
	else
		vim.cmd("silent! syntax off")
	end
end

local augroup = vim.api.nvim_create_augroup("syntax_highlighting_state", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = augroup,
	callback = function(args)
		if vim.g.syntax_highlighting_enabled == false then
			set_treesitter_for_buffer(args.buf, false)
			set_semantic_tokens_for_buffer(args.buf, false)
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		if vim.g.syntax_highlighting_enabled == false then
			local client_id = args.data and args.data.client_id or nil
			set_semantic_tokens_for_buffer(args.buf, false, client_id)
		end
	end,
})

function M.is_enabled()
	if vim.g.syntax_highlighting_enabled == nil then
		return true
	end
	return vim.g.syntax_highlighting_enabled
end

function M.set_enabled(enabled, opts)
	opts = opts or {}
	enabled = not not enabled

	vim.g.syntax_highlighting_enabled = enabled
	apply_vim_syntax(enabled)

	if opts.apply_treesitter ~= false then
		apply_treesitter(enabled)
	end

	if opts.apply_semantic_tokens ~= false then
		apply_semantic_tokens(enabled)
	end

	if opts.persist ~= false then
		write_saved_state(enabled)
	end

	if opts.notify then
		vim.notify("Syntax highlighting: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
	end
end

function M.toggle()
	M.set_enabled(not M.is_enabled(), { persist = true, apply_treesitter = true, notify = true })
end

function M.load()
	local saved = read_saved_state()
	if saved == nil then
		saved = DEFAULT_ENABLED
	end

	M.set_enabled(saved, { persist = false, apply_treesitter = false, notify = false })
end

vim.api.nvim_create_user_command("SyntaxToggle", function()
	M.toggle()
end, { desc = "Toggle syntax highlighting and persist state" })

vim.api.nvim_create_user_command("SyntaxOn", function()
	M.set_enabled(true, { persist = true, notify = true })
end, { desc = "Enable syntax highlighting and persist state" })

vim.api.nvim_create_user_command("SyntaxOff", function()
	M.set_enabled(false, { persist = true, notify = true })
end, { desc = "Disable syntax highlighting and persist state" })

return M
