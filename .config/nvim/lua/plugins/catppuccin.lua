return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },
  { "folke/tokyonight.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim" },
  { "sainnhe/everforest" },
  { "shaunsingh/nord.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = vim.fn.filereadable(vim.fn.expand("~/.local/state/desktop-theme/current")) == 1
          and ({
            catppuccin = "catppuccin",
            ["catppuccin-latte"] = "catppuccin-latte",
            everforest = "everforest",
            gruvbox = "gruvbox",
            kanagawa = "kanagawa",
            nord = "nord",
            ["rose-pine"] = "rose-pine",
            ["tokyo-night"] = "tokyonight",
          })[vim.fn.readfile(vim.fn.expand("~/.local/state/desktop-theme/current"))[1]]
        or "catppuccin",
    },
  },
}
