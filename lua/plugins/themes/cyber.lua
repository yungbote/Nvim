-- ~/.config/nvim/lua/themes/cyber.lua
return {
  "git@github.com:yungbote/cyber.nvim.git",
  config = function()
    require("cyber").setup({
      transparent = true,
    })
    vim.cmd("colorscheme cyber")
  end
}
