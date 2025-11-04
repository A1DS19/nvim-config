-- Utilities and other tools configuration
return {
  -- General utilities
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({ input = { enabled = false } })
    end,
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
    priority = 1000,
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  
  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.stdpath("data") .. "/sessions/",
        options = { "buffers", "curdir", "tabpages", "winsize" },
        autoload = true,
        autosave = {
          enabled = true,
          events = { "BufLeave", "VimLeavePre" },
          last_session = true,
        },
        telescope = { enabled = true, open_cmd = "Telescope" },
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Git integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
    keys = { { "<leader>gg" } },
    config = function()
      vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
    end,
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    ft = "norg",
    config = true,
  },

  -- CMake tools
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmake-tools").setup({
        cmake_command = "cmake",
        cmake_regenerate_on_save = true,
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_build_directory = "build/${variant:buildType}",
        cmake_soft_link_compile_commands = true,
        cmake_compile_commands_from_lsp = false,
        cmake_kits_path = nil,
        cmake_variants_message = {
          short = { show = true },
          long = { show = true, max_length = 40 }
        },
        cmake_dap_configuration = {
          name = "cpp",
          type = "codelldb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = true,
          console = "integratedTerminal",
        },
        cmake_executor = {
          name = "quickfix",
          opts = {},
          default_opts = {
            quickfix = {
              show = "always",
              position = "belowright",
              size = 10,
              encoding = "utf-8",
              auto_close_when_success = true,
            },
          }
        },
        cmake_runner = {
          name = "terminal",
          opts = {},
          default_opts = {
            quickfix = {
              show = "always",
              position = "belowright",
              size = 10,
              encoding = "utf-8",
              auto_close_when_success = true,
            },
            terminal = {
              name = "Main Terminal",
              prefix_name = "[CMakeTools]: ",
              split_direction = "horizontal",
              split_size = 11,
            }
          }
        }
      })
    end,
  },

  -- Nu shell support
  {
    "LhKipp/nvim-nu",
    ft = "nu",
    config = function()
      require("nu").setup()
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
      local wk = require("which-key")
      wk.register({
        f = {
          name = "Find",
          f = { "<cmd>Telescope find_files<CR>", "Find Files" },
          g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
          b = { "<cmd>Telescope buffers<CR>", "Buffers" },
          h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
        },
        e = { "<cmd>Telescope file_browser<CR>", "File Browser" },
        s = {
          name = "Sessions",
          s = { "<cmd>lua require('persistence').save()<CR>", "Save Session" },
          r = { "<cmd>lua require('persistence').load()<CR>", "Restore Session" },
          l = { "<cmd>lua require('persistence').load({ last = true })<CR>", "Load Last Session" },
          n = { "<cmd>lua require('persistence').stop()<CR>", "Stop Session" },
        },
      }, { prefix = "<leader>" })
    end,
  },
}
