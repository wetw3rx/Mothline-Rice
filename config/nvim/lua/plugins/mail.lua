return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      {
        "<leader>z",
        "<cmd>ZenMode<cr>",
        desc = "Toggle Zen Mode",
      },
    },
    opts = {
      window = {
        width = 88,
      },
    },
  },
}
