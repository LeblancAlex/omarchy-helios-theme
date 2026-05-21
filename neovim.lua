return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#000000",
        dark_bg    = "#000000",
        darker_bg  = "#000000",
        lighter_bg = "#4A3818",

        fg         = "#F5E1A4",
        dark_fg    = "#B0741F",
        light_fg   = "#F5E1A4",
        bright_fg  = "#FFD23F",
        muted      = "#8B6F2B",

        red        = "#F4C430",
        yellow     = "#E8A33D",
        orange     = "#FFB938",
        green      = "#8B6F2B",
        cyan       = "#B0741F",
        blue       = "#8B6F2B",
        purple     = "#B0741F",
        brown      = "#4A3818",

        bright_red    = "#FFB938",
        bright_yellow = "#FFD23F",
        bright_green  = "#C9990A",
        bright_cyan   = "#E8A33D",
        bright_blue   = "#B0741F",
        bright_purple = "#F4C430",

        accent               = "#FFD23F",
        cursor               = "#FFB938",
        foreground           = "#F5E1A4",
        background           = "#000000",
        selection            = "#4A3818",
        selection_foreground = "#F5E1A4",
        selection_background = "#4A3818",
      },
    },
    config = function(_, opts)
      require("aether").setup(opts)
      vim.cmd.colorscheme("aether")
      require("aether.hotreload").setup()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
