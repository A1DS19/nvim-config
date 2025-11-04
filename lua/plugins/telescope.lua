-- Telescope configuration
return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      require("telescope").setup({
        defaults = {
          mappings = {
            n = {
              ["s"] = actions.select_horizontal,
              ["v"] = actions.select_vertical,
            },
            i = {
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
            },
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
            hijack_netrw = false,
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.8,
              height = 0.9,
              prompt_position = "bottom",
              mirror = false,
            },
            mappings = {
              ["n"] = {
                ["<A-c>"] = fb_actions.create,
                ["<S-CR>"] = fb_actions.create_from_prompt,
                ["<A-r>"] = fb_actions.rename,
                ["<A-m>"] = fb_actions.move,
                ["<A-y>"] = fb_actions.copy,
                ["<A-d>"] = fb_actions.remove,
                ["<C-o>"] = fb_actions.open,
                ["<C-g>"] = fb_actions.goto_parent_dir,
                ["<C-e>"] = fb_actions.goto_home_dir,
                ["<C-w>"] = fb_actions.goto_cwd,
                ["<C-t>"] = fb_actions.change_cwd,
                ["<C-f>"] = fb_actions.toggle_browser,
                ["<C-h>"] = fb_actions.toggle_hidden,
                ["<C-s>"] = fb_actions.toggle_all,
                ["<BS>"] = fb_actions.backspace,
              },
            },
          },
        },
      })
      pcall(require("telescope").load_extension, "file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
    priority = 1000,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = false,
    priority = 1000,
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
