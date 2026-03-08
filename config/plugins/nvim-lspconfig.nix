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

      local auto_format_servers = { "rust_analyzer", "hls", "mesonlsp" }
      if vim.tbl_contains(auto_format_servers, client.name) then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, id = client.id })
          end,
        })
      end
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
        {
          key = "gD";
          lspBufAction = "declaration";
          options = key_opts // {
            desc = "Go to declaration";
          };
        }
        {
          key = "gi";
          lspBufAction = "implementation";
          options = key_opts // {
            desc = "Go to implementation";
          };
        }
        {
          key = "gr";
          lspBufAction = "references";
          options = key_opts // {
            desc = "Find references";
          };
        }
        {
          key = "K";
          lspBufAction = "hover";
          options = key_opts // {
            desc = "Hover documentation";
          };
        }
        {
          key = "<leader>D";
          lspBufAction = "type_definition";
          options = key_opts // {
            desc = "Go to type definition";
          };
        }
        {
          key = "<leader>s";
          lspBufAction = "signature_help";
          options = key_opts // {
            desc = "Show signature help";
          };
        }
        {
          key = "<leader>wa";
          lspBufAction = "add_workspace_folder";
          options = key_opts // {
            desc = "Add workspace folder";
          };
        }
        {
          key = "<leader>wr";
          lspBufAction = "remove_workspace_folder";
          options = key_opts // {
            desc = "Remove workspace folder";
          };
        }
        {
          key = "<leader>wl";
          action.__raw = "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end";
          options = key_opts // {
            desc = "List workspace folders";
          };
        }
        {
          key = "<leader>n";
          lspBufAction = "rename";
          options = key_opts // {
            desc = "Rename symbol";
          };
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
          options = key_opts // {
            desc = "Code actions";
          };
        }
        {
          key = "<leader>f";
          lspBufAction = "format";
          mode = [
            "n"
            "v"
          ];
          options = key_opts // {
            desc = "Format code";
          };
        }
        {
          key = "[d";
          action.__raw = "vim.diagnostic.goto_prev";
          options = key_opts // {
            desc = "Go to previous diagnostic";
          };
        }
        {
          key = "]d";
          action.__raw = "vim.diagnostic.goto_next";
          options = key_opts // {
            desc = "Go to next diagnostic";
          };
        }
        {
          key = "<leader>L";
          action.__raw = "function() print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr }))) end";
          options = key_opts // {
            desc = "List LSP clients";
          };
        }
      ];
    servers = {
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
      nixd = {
        enable = true;
        config = {
          cmd = [ "${pkgs.nixd}/bin/nixd" ];
          filetypes = [ "nix" ];
          root_markers = [
            "flake.nix"
            ".git"
          ];
          settings = {
            nixd = {
              formatting = {
                command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              };
            };
          };
        };
      };
      pyright = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.pyright}/bin/pyright-langserver"
            "--stdio"
          ];
          filetypes = [ "python" ];
          root_markers = [
            "pyproject.toml"
            "setup.py"
            "setup.cfg"
            "requirements.txt"
            "Pipfile"
            "pyrightconfig.json"
            ".git"
          ];
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true;
                diagnosticMode = "workspace";
                useLibraryCodeForTypes = true;
                typeCheckingMode = "off";
              };
            };
          };
        };
      };
      lua_ls = {
        enable = true;
        config = {
          cmd = [ "${pkgs.lua-language-server}/bin/lua-language-server" ];
          filetypes = [ "lua" ];
          root_markers = [
            ".luarc.json"
            ".luarc.jsonc"
            ".luacheckrc"
            ".stylua.toml"
            "stylua.toml"
            "selene.toml"
            "selene.yml"
            ".git"
          ];
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT";
              };
              diagnostics = {
                globals = [ "vim" ];
              };
              workspace = {
                checkThirdParty = false;
              };
              telemetry = {
                enable = false;
              };
            };
          };
        };
      };
      rust_analyzer = {
        enable = true;
        config = {
          cmd = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
          filetypes = [ "rust" ];
          root_markers = [
            "Cargo.toml"
            "rust-project.json"
          ];
        };
      };
      html = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
            "--stdio"
          ];
          filetypes = [
            "html"
            "templ"
          ];
          root_markers = [
            "package.json"
            ".git"
          ];
        };
      };
      cssls = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server"
            "--stdio"
          ];
          filetypes = [
            "css"
            "scss"
            "less"
          ];
          root_markers = [
            "package.json"
            ".git"
          ];
        };
      };
      ts_ls = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.typescript-language-server}/bin/typescript-language-server"
            "--stdio"
          ];
          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
          ];
          root_markers = [
            "tsconfig.json"
            "jsconfig.json"
            "package.json"
            ".git"
          ];
        };
      };
      volar = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.vue-language-server}/bin/vue-language-server"
            "--stdio"
          ];
          filetypes = [ "vue" ];
          root_markers = [
            "package.json"
            ".git"
          ];
        };
      };
      bashls = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.bash-language-server}/bin/bash-language-server"
            "start"
          ];
          filetypes = [
            "sh"
            "bash"
          ];
          root_markers = [ ".git" ];
        };
      };
      hls = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper"
            "--lsp"
          ];
          filetypes = [
            "haskell"
            "lhaskell"
            "cabal"
          ];
          root_markers = [
            "hie.yaml"
            "cabal.project"
            "cabal.project.local"
            "cabal.project.freeze"
            "package.yaml"
            ".git"
          ];
        };
      };
      cmake = {
        enable = true;
        config = {
          cmd = [ "${pkgs.cmake-language-server}/bin/cmake-language-server" ];
          filetypes = [ "cmake" ];
          root_markers = [
            "CMakeLists.txt"
            ".git"
          ];
        };
      };
      mesonlsp = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.mesonlsp}/bin/mesonlsp"
            "--lsp"
          ];
          filetypes = [ "meson" ];
          root_markers = [
            "meson.build"
            "meson_options.txt"
            ".git"
          ];
        };
      };
      clangd = {
        enable = true;
        config = {
          cmd.__raw = ''
            (function()
              local function get_compile_commands_dir()
                local dir = os.getenv("COMPILE_COMMANDS_DIR")
                if dir and vim.fn.isdirectory(dir) == 1 then
                  return dir
                end
                return (_G.root_dir or vim.fn.getcwd()) .. "/build"
              end

              local function get_clangd_path()
                local path = os.getenv("CLANGD_PATH")
                if path and vim.fn.filereadable(path) == 1 then
                  return path
                end
                local system_path = vim.fn.exepath("clangd")
                if system_path ~= "" then
                  return system_path
                end
                return "${pkgs.clang-tools}/bin/clangd"
              end

              local function get_clang_path()
                local path = os.getenv("CLANG_PATH")
                if path and vim.fn.filereadable(path) == 1 then
                  return path
                end
                local system_path = vim.fn.exepath("clang")
                if system_path ~= "" then
                  return system_path
                end
                return "${pkgs.clang}/bin/clang"
              end

              return {
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
              }
            end)()
          '';
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
            "proto"
          ];
          root_markers = [
            ".clangd"
            ".clang-tidy"
            ".clang-format"
            "compile_commands.json"
            "compile_flags.txt"
            "configure.ac"
            ".git"
          ];
          capabilities = {
            offsetEncoding = [
              "utf-8"
              "utf-16"
            ];
            textDocument = {
              completion = {
                editsNearCursor = true;
              };
            };
          };
        };
      };
    };
  };
}
