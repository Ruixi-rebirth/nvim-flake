{
  config = {
    plugins.nvim-cmp.enable = true;
    plugins.lsp = {
      enable = true;
      onAttach = ''
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
      '';
      preConfig = ''
        -- add additional capabilities supported by nvim-cmp
        -- nvim has not added foldingRange to default capabilities, users must add it manually
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
      '';
      postConfig = ''
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
      '';
      servers = {
        nixd = {
          enable = true;
          installLanguageServer = true;
        };
        nil_ls = {
          enable = false;
          installLanguageServer = false;
        };
        gopls = {
          enable = true;
          installLanguageServer = true;
          extraOptions = {
            settings = {
              experimentalPostfixCompletions = true;
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
            };
            init_options = {
              usePlaceholders = true;
            };
          };
        };
        rust-analyzer = {
          enable = true;
          installLanguageServer = true;
          installCargo = true;
          installRustc = true;
        };
        bashls = {
          enable = true;
          installLanguageServer = true;
        };
        clangd = {
          enable = true;
          installLanguageServer = false;
        };
        pyright = {
          enable = true;
          installLanguageServer = false;
        };
        hls = {
          enable = true;
          installLanguageServer = true;
        };
        html = {
          enable = true;
          installLanguageServer = true;
        };
        cssls = {
          enable = true;
          installLanguageServer = true;
        };
        tsserver = {
          enable = true;
          installLanguageServer = true;
        };
      };
    };
    extraConfigLua = ''
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
      -- Enable inlay_hint for specific languages
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust" },
          callback = function()
            vim.lsp.inlay_hint(0, true)
          end,
      })
    '';
  };
}
