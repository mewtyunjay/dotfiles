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

          -- Make terminal background transparent to match overall theme
          vim.api.nvim_set_hl(0, "Terminal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "TerminalNormal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "TerminalNormalNC", { bg = "NONE" })
          -- For floating terminals (snacks.nvim)
          vim.api.nvim_set_hl(0, "SnacksTerminal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "SnacksTerminalBorder", { bg = "NONE" })
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

  -- Override sidekick chat to match normal buffer background (applies to all themes)
  -- This must be set after sidekick loads and after colorscheme is applied
  {
    "folke/sidekick.nvim",
    optional = true,
    opts = function()
      -- Set transparent highlights after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.schedule(function()
            -- Make all sidekick-related highlights transparent
            vim.api.nvim_set_hl(0, "SidekickChat", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "SidekickChatBorder", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "SidekickNormal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "SidekickBorder", { bg = "NONE" })

            -- Make terminal within sidekick transparent
            vim.api.nvim_set_hl(0, "Terminal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TerminalNormal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TerminalNormalNC", { bg = "NONE" })

            -- Also ensure floating windows are transparent
            local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
            if not normal_bg then
              vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
              vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
            end
          end)
        end,
      })

      -- Also set immediately in case sidekick is already loaded
      vim.schedule(function()
        vim.api.nvim_set_hl(0, "SidekickChat", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SidekickChatBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SidekickNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SidekickBorder", { bg = "NONE" })
        -- Make terminal transparent immediately too
        vim.api.nvim_set_hl(0, "Terminal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "TerminalNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "TerminalNormalNC", { bg = "NONE" })
      end)

      -- Add terminal mode mappings for jj and jk to exit insert mode
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          -- Map jj to exit terminal insert mode
          vim.keymap.set("t", "jj", [[<C-\><C-n>]], { buffer = buf, desc = "Exit terminal mode" })
          -- Map jk to exit terminal insert mode
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = buf, desc = "Exit terminal mode" })
        end,
      })

      return {}
    end,
  },
}
