-- File explorer configuration
return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        update_cwd = false,
        update_focused_file = {
          enable = false,
          update_cwd = false,
        },
        view = {
          width = 35,
          side = "left",
          number = false,
          relativenumber = false,
        },
        filters = {
          dotfiles = false,
          git_clean = false,
          git_ignored = false,
          custom = {},
        },
        git = {
          enable = true,
          ignore = false, -- Always show gitignored files
          timeout = 400,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "v", api.node.open.vertical, {
            desc = "nvim-tree: Open in vertical split",
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          })
        end,
      })
    end,
  },
}
