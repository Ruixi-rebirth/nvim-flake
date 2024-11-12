{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-lspconfig;
  config = ''
    function()
      local nvim_lsp = require("lspconfig")

      -- Add additional capabilities supported by nvim-cmp
      -- nvim hasn't added foldingRange to default capabilities, users must add it manually
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      --Change diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
      })

      local on_attach_common = function(client,bufnr)
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

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)

      vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

      vim.keymap.set("n", "<leader>li", function()
        print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr })))
      end, opts)

      -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
    end
    ---------------------
    -- setup languages --
    ---------------------
    -- nix
    nvim_lsp.nixd.setup({
      cmd = { "${pkgs.nixd}/bin/nixd" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })
    -- golang
    nvim_lsp["gopls"].setup({
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
    })
    --python
    nvim_lsp.pyright.setup({
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
    })

    --lua
    nvim_lsp.lua_ls.setup({
      cmd = { "${pkgs.lua-language-server}/bin/lua-language-server" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
             -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
             version = "LuaJIT",
          },
          diagnostics = {
             -- Get the language server to recognize the `vim` global
             globals = { "vim" },
          },
          workspace = {
             -- Make the server aware of Neovim runtime files
             library = vim.api.nvim_get_runtime_file("", true),
             checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
             enable = false,
          },
        },
      },
    })

    nvim_lsp.rust_analyzer.setup({
      cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
      on_attach = function(client, bufnr)
      on_attach_common(client, bufnr)
      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      end,
      capabilities = capabilities,
    })
    nvim_lsp.html.setup({
      cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })

    nvim_lsp.cssls.setup({
      cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })

    nvim_lsp.ts_ls.setup({
      cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })

    nvim_lsp.volar.setup({
      cmd = { "${pkgs.vue-language-server}/bin/vue-language-server", "--stdio" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })

    nvim_lsp.bashls.setup({
      cmd = { "${pkgs.bash-language-server}/bin/bash-language-server", "start" },
      on_attach = on_attach_common(),
      capabilities = capabilities,
    })

    nvim_lsp.hls.setup({
      cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
      on_attach = function(client, bufnr)
      on_attach_common(client, bufnr)
      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      end,
      capabilities = capabilities,
    })

    -- show diagnostics when InsertLeave
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "go", "rust", "nix", "haskell" },
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
        vim.api.nvim_buf_create_user_command(0, 'InlayHintsToggle', _G.toggle_inlay_hints, {})
      end,
    })

    end
  '';
}
