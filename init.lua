require("core.options")
require("core.keymaps")

vim.g.loaded_matchparen = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local default_color_scheme = "paper"
local env_var_nvim_theme = os.getenv("NVIM_THEME") or default_color_scheme
local themes = {
	cyber = "plugins.themes.cyber",
	paper = "plugins.themes.paper",
	solarized = "plugins.themes.solarized"
}

require("lazy").setup({
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				"gzip", "zipPlugin", "tarPlugin", "getscript", "vimball", "vimballPlugin",
				"matchit", "matchparen", "logiPat", "netrw", "netrwPlugin"
			}
		}
	},
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
