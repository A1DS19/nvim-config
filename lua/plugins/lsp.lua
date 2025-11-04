-- Modern LSP configuration for Neovim 0.11+ using vim.lsp.config
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
          "rust_analyzer", "clangd", "ts_ls", "pyright", -- Updated tsserver to ts_ls
          "eslint", "html", "cssls", "tailwindcss", "jsonls", "yamlls",
          "lua_ls", "bashls", "dockerls", "marksman", "taplo", "cmake",
          "omnisharp", "glsl_analyzer"
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
              return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc", "eslint.config.js" })
            end,
          }),
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Configure LSP servers using the new vim.lsp.config API

      -- Rust Analyzer
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json" },
        capabilities = capabilities,
      }

      -- Clangd
      vim.lsp.config.clangd = {
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
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
        capabilities = capabilities,
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
      }

      -- TypeScript Language Server
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx"
        },
        root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }

      -- Python (Pyright)
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        capabilities = capabilities,
      }

      -- Lua Language Server
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              }
            },
          }
        },
      }

      -- JSON Language Server
      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }

      -- YAML Language Server
      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        root_markers = { ".git" },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            completion = true,
            hover = true,
          },
        },
      }

      -- HTML Language Server
      vim.lsp.config.html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      }

      -- CSS Language Server
      vim.lsp.config.cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      }

      -- Tailwind CSS Language Server
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte" },
        root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts", "postcss.config.js", "postcss.config.cjs", "postcss.config.mjs", "postcss.config.ts", "package.json", "node_modules", ".git" },
        capabilities = capabilities,
      }

      -- Bash Language Server
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- ESLint Language Server
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
        root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts", "eslint.config.mts", "eslint.config.cts", "package.json" },
        capabilities = capabilities,
      }

      -- Docker Language Server
      vim.lsp.config.dockerls = {
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { "Dockerfile", ".git" },
        capabilities = capabilities,
      }

      -- Markdown Language Server
      vim.lsp.config.marksman = {
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        root_markers = { ".marksman.toml", ".git" },
        capabilities = capabilities,
      }

      -- TOML Language Server
      vim.lsp.config.taplo = {
        cmd = { "taplo", "lsp", "stdio" },
        filetypes = { "toml" },
        root_markers = { "*.toml", ".git" },
        capabilities = capabilities,
      }

      -- CMake Language Server
      vim.lsp.config.cmake = {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
        capabilities = capabilities,
      }

      -- GLSL Language Server
      vim.lsp.config.glsl_analyzer = {
        cmd = { "glsl_analyzer" },
        filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- OmniSharp (C#)
      vim.lsp.config.omnisharp = {
        cmd = {
          "omnisharp",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
        },
        filetypes = { "cs", "vb" },
        root_markers = { "*.csproj", "*.sln", "*.fsproj", "omnisharp.json", "function.json" },
        capabilities = capabilities,
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
      }

      -- Auto hover on cursor hold
      vim.o.updatetime = 500
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local clients = vim.lsp.get_clients()
          if #clients > 0 then
            vim.lsp.buf.hover()
          end
        end,
      })

      -- Setup automatic starting of LSP servers
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          -- This will automatically start servers that are configured above
          -- The actual configuration is handled by vim.lsp.config above
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
