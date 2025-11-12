return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Use 'super-tab' for mappings similar to vscode (tab to accept)
    keymap = { preset = "super-tab" },
  },
}
