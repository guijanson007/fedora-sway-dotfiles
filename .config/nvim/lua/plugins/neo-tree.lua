return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "right",
    },
    filesystem = {
      filtered_items = {
        visible = true, -- Show all items
        hide_dotfiles = false, -- Show hidden files
        hide_gitignored = false, -- Optionally hide gitignored files
      },
    },
  },
}
