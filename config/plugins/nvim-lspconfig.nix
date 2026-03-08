{ pkgs, ... }:
{
  lsp = {
    luaConfig.post = ''
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

      local util_custom = {
        find_git_ancestor = function(startpath)
          local dot_git = vim.fs.find(".git", { path = startpath, upward = true })[1]
          return dot_git and vim.fs.dirname(dot_git) or nil
        end,
      }
      local find_repo_root = function(startpath)
        local repo = vim.fs.find(".repo", { path = startpath, upward = true })[1]
        return repo and vim.fs.dirname(repo) or nil
      end
      local filepath = vim.fn.expand("%:p")
      local root_dir = find_repo_root(filepath) or util_custom.find_git_ancestor(filepath)
      if not root_dir then
        if #vim.api.nvim_list_uis() > 0 then
          -- vim.notify("No .repo or Git root directory found!", vim.log.levels.WARN)
        end
      else
        _G.root_dir = root_dir -- Make it globally accessible for server configs
      end

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
    '';

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
    inlayHints.enable = false;
    keymaps =
      let
        key_opts = {
          noremap = true;
          silent = true;
          buffer = true;
        };
      in
      [
        {
          key = "gd";
          lspBufAction = "definition";
          options = key_opts // {
            desc = "Go to definition";
          };
        }
      ];
    servers = {
      "*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
      gopls = {
        enable = true;
        config = {
          cmd = [ "gopls" ];
          filetypes = [
            "go"
            "gomod"
            "gowork"
            "gotmpl"

          ];
          root_markers = [
            "go.mod"
            ".git"
          ];
          settings = {
            gopls = {
              experimentalPostfixCompletions = true;
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
              gofumpt = true;
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
            };
          };
          init_options = {
            usePlaceholders = true;
          };
        };
      };
      nix = {

      };
    };
  };
}
