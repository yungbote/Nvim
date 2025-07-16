require("core.options")
require("core.keymaps")
require("core.paste_guard")
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
		opt.cindent = true
		opt.cinoptions = ":0,l1,g0,(0"
		opt.cinwords = "if,else,while,do,for,switch,case,default,public,private,protected"
		opt.indentkeys:append(":") -- ← triggers indent when `:` is typed
		opt.autoindent = true
		opt.smarttab = true
		opt.tabstop = 2
		opt.shiftwidth = 2
		opt.softtabstop = 2
		opt.expandtab = true
	end,
})

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
local env_var_nvim_theme = default_color_scheme -- or os.getenv("NVIM_THEME")
local themes = {
	github = "plugins.themes.github",
	cyber = "plugins.themes.cyber",
	paper = "plugins.themes.paper",
	solarized = "plugins.themes.solarized",
	rosepine = "plugins.themes.rose-pine",
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
})

vim.cmd([[syntax off]])
vim.cmd([[set nohlsearch]])
