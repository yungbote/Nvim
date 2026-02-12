-- lua/plugins/indent-blankline.lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local function set_ibl_hls()
      -- Pick something subtle; you can swap this to a rose-pine palette value later if desired.
      local fg = "#6e6a86" -- muted-ish (works well on rose-pine variants)

      for i = 1, 8 do
        vim.api.nvim_set_hl(0, ("IblIndent%d"):format(i), { fg = fg, nocombine = true })
      end
    end

    -- Ensure they exist now
    set_ibl_hls()

    -- Ensure they get re-applied after every colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("IblCustomHighlights", { clear = true }),
      callback = set_ibl_hls,
    })

    require("ibl").setup({
      indent = {
        char = "▏",
        highlight = {
          "IblIndent1",
          "IblIndent2",
          "IblIndent3",
          "IblIndent4",
          "IblIndent5",
          "IblIndent6",
          "IblIndent7",
          "IblIndent8",
        },
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
        },
      },
    })
  end,
}










