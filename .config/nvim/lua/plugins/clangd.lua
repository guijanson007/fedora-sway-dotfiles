return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--header-insertion=iwyu",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--experimental-modules-support",
          },
          init_options = {
            completeUnimported = true,
          },
        },
      },
    },
  },
}
