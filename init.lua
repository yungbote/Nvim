-- File: init.lua
require("core.options")
require("core.keymaps")
vim.g.loaded_matchparen = 1

vim.filetype.add({
	filename = {
		["Tiltfile"] = "starlark",
		["tiltfile"] = "starlark",
	},
	pattern = {
		[".*%.bzl"] = "starlark",
		[".*%.star"] = "starlark",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h", "hpp" },
	callback = function()
		local opt = vim.opt_local
		opt.cindent = false
		opt.cinoptions = ":0,l1,g0,(0"
		opt.cinwords = "if,else,while,do,for,switch,case,default,public,private,protected"
		opt.autoindent = true
		opt.smarttab = true

		opt.tabstop = 4
		opt.shiftwidth = 4
		opt.softtabstop = 4
		opt.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

if vim.fn.has("wsl") == 0 and vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline",
		},
		cache_enabled = 1,
	}
end
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local default_color_scheme = "rosepine"
local env_var_nvim_theme = default_color_scheme
local themes = {
	gravity = "plugins.themes.gravity",
	gruvdark = "plugins.themes.gruvdark",
	solarized = "plugins.themes.solarized-light",
	zenbones = "plugins.themes.zenbones",
	catpuccinlatte = "plugins.themes.catpuccinlatte",
	jupyter = "plugins.themes.jupyter",
	github = "plugins.themes.github",
	cyber = "plugins.themes.cyber",
	paper = "plugins.themes.paper",
	rosepine = "plugins.themes.rosepine",
}

require("lazy").setup({
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				"gzip",
				"zipPlugin",
				"tarPlugin",
				"getscript",
				"vimball",
				"vimballPlugin",
				"matchit",
				"matchparen",
				"logiPat",
				"netrw",
				"netrwPlugin",
				"netrwPlugin",
			},
		},
	},
	require("plugins.jup"),
	require("plugins.treesitter"),
	require("plugins.lsp"),
	require("plugins.telescope"),
	require("plugins.neo-tree"),
	require("plugins.nvim-colorizer"),
	require(themes[env_var_nvim_theme]),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.autoformatting"),
	require("plugins.gitsigns"),
	require("plugins.alpha"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.iron"),
	require("plugins.slime"),
})

--vim.cmd([[syntax off]])
vim.cmd([[set nohlsearch]])

local function ensure_blank_lines_below(min_blank_lines)
	local buf = vim.api.nvim_get_current_buf()

	if not vim.bo[buf].modifiable or vim.bo[buf].buftype ~= "" then
		return
	end

	if vim.bo[buf].readonly or vim.bo[buf].filetype == "help" then
		return
	end

	local total_lines = vim.api.nvim_buf_line_count(buf)
	local current_line = vim.fn.line(".")

	if current_line < total_lines - (min_blank_lines * 2) then
		return
	end

	local last_content_line = 0
	local lines_to_check = math.min(total_lines, min_blank_lines + 10)
	local start_check = math.max(1, total_lines - lines_to_check + 1)

	for i = total_lines, start_check, -1 do
		local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
		if line and line:match("%S") then
			last_content_line = i
			break
		end
	end

	if last_content_line == 0 and start_check > 1 then
		for i = start_check - 1, 1, -1 do
			local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if line and line:match("%S") then
				last_content_line = i
				break
			end
		end
	end

	if last_content_line == 0 then
		last_content_line = 0
	end

	if current_line >= last_content_line then
		local existing_blank_lines = total_lines - last_content_line
		local lines_to_add = min_blank_lines - existing_blank_lines

		if lines_to_add > 0 then
			local ok = pcall(function()
				local blank_lines = {}
				for i = 1, lines_to_add do
					blank_lines[i] = ""
				end
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, blank_lines)
			end)
			if not ok then
				return
			end
		elseif lines_to_add < 0 then
			local lines_to_remove = -lines_to_add
			local ok = pcall(function()
				vim.api.nvim_buf_set_lines(buf, total_lines - lines_to_remove, total_lines, false, {})
			end)
			if not ok then
				return
			end
		end
	end
end

local BLANK_LINES_BELOW = 10
local timer = vim.loop.new_timer()

local function debounced_ensure_blank_lines()
	timer:stop()
	timer:start(
		50,
		0,
		vim.schedule_wrap(function()
			ensure_blank_lines_below(BLANK_LINES_BELOW)
		end)
	)
end

vim.api.nvim_create_autocmd({
	"CursorMoved",
	"CursorMovedI",
	"InsertEnter",
	"TextChanged",
	"TextChangedI",
	"InsertLeave",
}, {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		debounced_ensure_blank_lines()
	end,
	desc = "Ensure exact blank lines at end of file",
})
