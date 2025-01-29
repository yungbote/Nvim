-- ~/.config/nvim/lua/themes/cyber.lua
return {
  "git@github.com:yungbote/paper.nvim.git",
  config = function()
    require("paper").setup({
      transparent = true,
    })
    vim.cmd("colorscheme paper")
  end
}
