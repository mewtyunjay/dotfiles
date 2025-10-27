return {
  -- Add gruvbox plugin with all variations
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
    end,
  },

  -- Add everforest theme
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      -- Available backgrounds: 'hard', 'medium', 'soft'
      vim.g.everforest_background = "hard"
      -- Available styles: 'default', 'material', 'modus'
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_transparent_background = 2 -- Enable transparency for background and sign column

      -- Custom highlight overrides for better visibility
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "everforest",
        callback = function()
          -- Visual selection - dark background with bright foreground
          vim.api.nvim_set_hl(0, "Visual", { bg = "#3d484d", fg = "#d3c6aa", bold = true })
          -- Search highlight - bright background with dark text
          vim.api.nvim_set_hl(0, "Search", { bg = "#dbbc7f", fg = "#2b3339", bold = true })
          -- Incremental search - even brighter
          vim.api.nvim_set_hl(0, "IncSearch", { bg = "#e69875", fg = "#2b3339", bold = true })
          -- Cursor line (optional, uncomment if needed)
          -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#374247" })
        end,
      })
    end,
  },

  -- Add tokyonight plugin
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in three styles, "storm", "moon", "night" and "day"
        transparent = true,
        terminal_colors = true,
      })
    end,
  },

  -- Configure LazyVim to load everforest
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
