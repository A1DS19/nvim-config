-- LSP, Linting, and Formatting configuration
return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "rust_analyzer", "clangd", "tsserver", "pyright",
          "eslint", "html", "cssls", "tailwindcss", "jsonls", "yamlls",
          "lua_ls", "bashls", "dockerls", "marksman", "taplo", "cmake",
          "omnisharp", "glsl_analyzer"
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript", "javascriptreact", "typescript", "typescriptreact",
              "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "graphql",
              "handlebars"
            },
          }),
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.cmake_format,
          null_ls.builtins.diagnostics.eslint.with({
            condition = function(utils)
              return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
            end,
          }),
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig/util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities for completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Enhanced capabilities for foldingRange
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- OmniSharp configuration for C#
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = {
          "omnisharp",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
        },
        init_options = {
          RoslynExtensionsOptions = {
            enableImportCompletion = true,
            enableRoslynAnalyzers = true,
          },
        },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          MsBuild = {
            LoadProjectsOnDemand = false,
          },
          RoslynExtensionsOptions = {
            enableImportCompletion = true,
            enableRoslynAnalyzers = true,
            documentationProvider = true,
          },
          Sdk = {
            IncludePrereleases = true,
          },
          enableEditorConfigSupport = true,
          enableMsBuildLoadProjectsOnDemand = false,
          enableRoslynAnalyzers = true,
          organizeImportsOnFormat = true,
          enableImportCompletion = true,
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
          dotNetCliPaths = { "/usr/local/share/dotnet/dotnet" },
        },
        on_new_config = function(new_config, new_root_dir)
          if vim.fn.executable("dotnet") == 1 then
            new_config.cmd_env = new_config.cmd_env or {}
            new_config.cmd_env.DOTNET_ROOT = "/usr/local/share/dotnet"
          end
        end,
      })

      -- Other LSP configurations
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--compile-commands-dir=build",
          "--pch-storage=memory",
          "--offset-encoding=utf-16",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        settings = {
          clangd = {
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++23" },
          }
        }
      })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.eslint.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        root_dir = util.root_pattern(
          "tailwind.config.js", "tailwind.config.cjs", "postcss.config.js", "package.json"
        )
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = { json = { schemas = require("schemastore").json.schemas() } },
      })
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.taplo.setup({ capabilities = capabilities })
      lspconfig.cmake.setup({ capabilities = capabilities })
      lspconfig.glsl_analyzer.setup({ capabilities = capabilities })

      -- Auto hover on cursor hold
      vim.o.updatetime = 500
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local clients = vim.lsp.get_active_clients()
          if #clients > 0 then
            vim.lsp.buf.hover()
          end
        end,
      })
    end,
  },
  {
    "b0o/schemastore.nvim",
    lazy = false,
    priority = 1000,
  },
}
