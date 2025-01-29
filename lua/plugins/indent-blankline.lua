return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = function()
    -- 1) Define custom highlights for each indent level (or just one if you prefer).
    vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent3", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent4", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent5", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent6", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent7", { fg = "#eee8d5", nocombine = true })
    vim.api.nvim_set_hl(0, "IblIndent8", { fg = "#eee8d5", nocombine = true })

    -- 2) Return your ibl config table, telling ibl which highlight groups to use:
    return {
      indent = {
        char = "▏",
        -- Use multiple highlight groups to get a rainbow effect
        highlight = { "IblIndent1", "IblIndent2", "IblIndent3", "IblIndent4", "IblIndent5", "IblIndent6", "IblIndent7", "IblIndent8" },
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
    }
  end,
}

