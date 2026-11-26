-- Omarchy's original pointed at gthelding/monokai-pro.nvim, which no longer
-- exists; loctvl842/monokai-pro.nvim is the upstream it was forked from.
-- Upstream's plain "monokai-pro" colorscheme forces filter=pro, so use the
-- filter-specific name.
return {
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    opts = {
      filter = "ristretto",
      override = function()
        return {
          NonText = { fg = "#948a8b" },
          MiniIconsGrey = { fg = "#948a8b" },
          MiniIconsRed = { fg = "#fd6883" },
          MiniIconsBlue = { fg = "#85dacc" },
          MiniIconsGreen = { fg = "#adda78" },
          MiniIconsYellow = { fg = "#f9cc6c" },
          MiniIconsOrange = { fg = "#f38d70" },
          MiniIconsPurple = { fg = "#a8a9eb" },
          MiniIconsAzure = { fg = "#a8a9eb" },
          MiniIconsCyan = { fg = "#85dacc" },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro-ristretto",
    },
  },
}
