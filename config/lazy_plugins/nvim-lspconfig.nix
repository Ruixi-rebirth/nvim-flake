{ pkgs, inputs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-lspconfig;
  dependencies = with pkgs.vimPlugins; [
    # nvim-cmp
    inputs.blink-cmp.packages.${pkgs.system}.default
  ];
  config = ''
    function()
      -- Add additional capabilities supported by blink-cmp
      local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
      -- Add additional capabilities supported by nvim-cmp
      -- local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- nvim hasn't added foldingRange to default capabilities, users must add it manually
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
        signs = {
          text = {
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.WARN]  =" "
          }
        },
      })

      local on_attach_common = function(client, bufnr)
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always",
              prefix = " ",
              scope = "line",
            }
            vim.diagnostic.show()
            vim.diagnostic.open_float(nil, opts)
          end,
        })

        -- keymap
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, vim.tbl_extend("force", { desc = "Go to definition" }, opts or {}))
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, vim.tbl_extend("force", { desc = "Go to declaration" }, opts or {}))
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, vim.tbl_extend("force", { desc = "Go to implementation" }, opts or {}))
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, vim.tbl_extend("force", { desc = "Find references" }, opts or {}))
        vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end, vim.tbl_extend("force", { desc = "Go to type definition" }, opts or {}))
        vim.keymap.set("n", "K", function() return vim.lsp.buf.hover() end, vim.tbl_extend("force", { desc = "Hover documentation" }, opts or {}))
        vim.keymap.set("n", "<leader>s", function() vim.lsp.buf.signature_help() end, vim.tbl_extend("force", { desc = "Show signature help" }, opts or {}))
        vim.keymap.set("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end, vim.tbl_extend("force", { desc = "Add workspace folder" }, opts or {}))
        vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end, vim.tbl_extend("force", { desc = "Remove workspace folder" }, opts or {}))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", { desc = "List workspace folders" }, opts or {}))
        vim.keymap.set("n", "<leader>n", function() vim.lsp.buf.rename() end, vim.tbl_extend("force", { desc = "Rename symbol" }, opts or {}))
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, vim.tbl_extend("force", { desc = "Code actions" }, opts or {}))
        vim.keymap.set({"n","v"}, "<leader>f", function() vim.lsp.buf.format() end, vim.tbl_extend("force", { desc = "Format code" }, opts or {}))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, vim.tbl_extend("force", { desc = "Go to previous diagnostic" }, opts or {}))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, vim.tbl_extend("force", { desc = "Go to next diagnostic" }, opts or {}))
        vim.keymap.set("n", "<leader>L", function()
          print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr })))
        end, vim.tbl_extend("force", { desc = "List LSP clients" }, opts or {}))

        -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]] -- use none-ls
      end

      local nvim_lsp = vim.lsp
      vim.lsp.enable({
        'nixd',           -- nix
        'gopls',          -- golang
        'pyright',        -- python
        'lua_ls',         -- lua
        'rust_analyzer',  -- rust
        'html',           -- html
        'cssls',          -- css
        'ts_ls',          -- typescript
        'volar',          -- vue
        'bashls',         -- bash
        'hls',            -- haskell
        'clangd',         -- c/c++
        'cmake',          -- cmake
        'mesonlsp'        -- meson
      })
      ---------------------
      -- config languages --
      ---------------------
      -- nix
      nvim_lsp.config.nixd = {
        cmd = { "${pkgs.nixd}/bin/nixd" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- golang
      nvim_lsp.config.gopls = {
        cmd = { "${pkgs.gopls}/bin/gopls" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        init_options = {
          usePlaceholders = true,
        },
      }

      -- python
      nvim_lsp.config.pyright = {
        cmd = { "${pkgs.pyright}/bin/pyright-langserver", "--stdio" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off",
            },
          },
        },
      }

      -- lua
      nvim_lsp.config.lua_ls = {
        cmd = { "${pkgs.lua-language-server}/bin/lua-language-server" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- rust
      nvim_lsp.config.rust_analyzer = {
        cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = capabilities,
      }

      -- html
      nvim_lsp.config.html = {
        cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- css
      nvim_lsp.config.cssls = {
        cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- typescript
      nvim_lsp.config.ts_ls = {
        cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- vue
      nvim_lsp.config.volar = {
        cmd = { "${pkgs.vue-language-server}/bin/vue-language-server", "--stdio" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- bash
      nvim_lsp.config.bashls = {
        cmd = { "${pkgs.bash-language-server}/bin/bash-language-server", "start" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- haskell
      nvim_lsp.config.hls = {
        cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = capabilities,
      }

      -- clangd
      local function get_compile_commands_dir()
        local dir = os.getenv("CCD")
        if dir and vim.fn.isdirectory(dir) == 1 then
          return dir
        end
        return "''${workspaceFolder}/build"
      end

      local function get_clangd_path()
        local path = os.getenv("CLANGD_PATH")
        if path and vim.fn.filereadable(path) == 1 then
          return path
        end
        return "${pkgs.clang-tools}/bin/clangd"
      end

      local function get_clang_path()
        local path = os.getenv("CLANG_PATH")
        if path and vim.fn.filereadable(path) == 1 then
          return path
        end
        return "${pkgs.clang}/bin/clang"
      end

      nvim_lsp.config.clangd = {
        cmd = {
          get_clangd_path(),
          "--enable-config",
          "--pch-storage=memory",
          "--compile-commands-dir=" .. get_compile_commands_dir(),
          "--background-index",
          "--clang-tidy",
          "--log=verbose",
          "--all-scopes-completion",
          "--header-insertion=iwyu",
          "--fallback-style=LLVM",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--pretty",
          "--query-driver=" .. get_clang_path(),
        },
        on_attach = on_attach_common(),
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
      }

      -- cmake
      nvim_lsp.config.cmake = {
        cmd = { "${pkgs.cmake-language-server}/bin/cmake-language-server" },
        on_attach = on_attach_common(),
        capabilities = capabilities,
      }

      -- meson
      nvim_lsp.config.mesonlsp = {
        cmd = { "${pkgs.mesonlsp}/bin/mesonlsp", "--lsp" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = capabilities,
      }
      -- show diagnostics when InsertLeave
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "rust", "nix", "haskell", "cpp", "c" },
        callback = function(args)
          vim.api.nvim_create_autocmd("DiagnosticChanged", {
            buffer = args.buf,
            callback = function()
              vim.diagnostic.hide()
            end,
          })
          vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
            buffer = args.buf,
            callback = function()
              vim.diagnostic.show()
            end,
          })
        end,
      })

      _G.toggle_inlay_hints = function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "go", "nix" },
        callback = function()
          vim.api.nvim_buf_create_user_command(0, "InlayHintsToggle", _G.toggle_inlay_hints, {})
        end,
      })
    end
  '';
}
