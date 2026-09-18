{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    package = pkgs.vimPlugins.nvim-lspconfig; # provide some predefined lsp config
    lazyLoad.settings = {
      before.__raw = ''
        function()
          local lzn = require('lz.n')
          lzn.trigger_load({
            'blink.cmp',
          })
        end
      '';
    };
  };
  lsp = {
    luaConfig.post = ''
      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        update_in_insert = false,
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
      _G.current_project_root = function()
        local filepath = vim.fn.expand("%:p:h")
        return find_repo_root(filepath) or util_custom.find_git_ancestor(filepath) or vim.fn.getcwd()
      end

      -- update_in_insert=false lets Neovim defer display until InsertLeave.

      _G.toggle_inlay_hints = function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end

      -- Format through gopls without organizing imports. Import changes stay
      -- explicit through code actions instead of happening on every save.
      _G.lsp_format = function(bufnr)
        if not bufnr or bufnr == 0 then
          bufnr = vim.api.nvim_get_current_buf()
        end

        local gopls_clients = vim.lsp.get_clients({
          bufnr = bufnr,
          name = "gopls",
        })
        local gopls = gopls_clients[1]

        if gopls then
          vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            id = gopls.id,
          })
          return
        end

        local clients = vim.lsp.get_clients({
          bufnr = bufnr,
          method = "textDocument/formatting",
        })
        -- Prefer the configured none-ls formatter; never run two formatters.
        table.sort(clients, function(a, b)
          if (a.name == "null-ls") ~= (b.name == "null-ls") then
            return a.name == "null-ls"
          end
          return a.id < b.id
        end)
        if clients[1] then
          vim.lsp.buf.format({ async = false, bufnr = bufnr, id = clients[1].id })
        else
          vim.notify("No formatter attached to this buffer", vim.log.levels.WARN)
        end
      end

      -- Explicit formatting also organizes Go imports. This is intentionally
      -- separate from the save hook, which only calls lsp_format.
      _G.organize_imports_and_format = function(bufnr)
        if not bufnr or bufnr == 0 then
          bufnr = vim.api.nvim_get_current_buf()
        end

        local gopls = vim.lsp.get_clients({
          bufnr = bufnr,
          name = "gopls",
        })[1]

        if gopls then
          local params = vim.lsp.util.make_range_params(0, gopls.offset_encoding)
          params.context = {
            only = { "source.organizeImports" },
            diagnostics = {},
          }

          local response = gopls:request_sync(
            "textDocument/codeAction",
            params,
            3000,
            bufnr
          )

          for _, action in ipairs((response or {}).result or {}) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(
                action.edit,
                gopls.offset_encoding
              )
            end
            if action.command then
              gopls:exec_cmd(action.command, { bufnr = bufnr })
            end
          end
        end

        _G.lsp_format(bufnr)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "go", "nix" },
        callback = function()
          vim.api.nvim_buf_create_user_command(0, "InlayHintsToggle", _G.toggle_inlay_hints, {})
        end,
      })

      -- Function to manually generate .clangd file
      _G.gen_clangd_config = function()
        -- Reuse existing root_dir logic, find root if not available
        local filepath = vim.fn.expand("%:p")
        local root = _G.current_project_root()
        
        if not root then
          vim.notify("Project root directory (.git or .repo) not found!", vim.log.levels.ERROR)
          return
        end

        local path = root .. "/.clangd"
        local content = {
          "CompileFlags:",
          "  Add: [",
          -- Disable compiler extensions, to enforce standard C/C++
          '    "-pedantic-errors",',
          -- Increasing warning levels
          '    "-Wall",',
          '    "-Weffc++",',
          '    "-Wextra",',
          '    "-Wconversion",',
          '    "-Wsign-conversion",',
          -- Treat warnings as errors
          '    "-Werror",',
          '    "-std=c++20"',
          "  ]"
        }

        -- If file exists, ask for confirmation to overwrite
        if vim.fn.filereadable(path) == 1 then
          local choice = vim.fn.confirm(".clangd already exists. Overwrite?", "&Yes\n&No", 2)
          if choice ~= 1 then return end
        end

        vim.fn.writefile(content, path)
        vim.notify("Generated .clangd in " .. root, vim.log.levels.INFO)
        
        -- Restart clangd to apply changes
        vim.lsp.enable("clangd", false)
        vim.lsp.enable("clangd", true)
      end

      -- Register command :GenClangdConfig
      vim.api.nvim_create_user_command("GenClangdConfig", _G.gen_clangd_config, { desc = "Manually generate .clangd configuration file" })
    '';

    onAttach = ''
      local diagnostic_float_group = vim.api.nvim_create_augroup(
        "LspDiagnosticFloat",
        { clear = false }
      )
      vim.api.nvim_clear_autocmds({
        group = diagnostic_float_group,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = diagnostic_float_group,
        buffer = bufnr,
        callback = function()
          -- Do not cover hover documentation or another active popup.
          for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local config = vim.api.nvim_win_get_config(winid)
            if config.relative ~= ""
              and not vim.wo[winid].winhighlight:find("TreesitterContext", 1, true)
            then
              return
            end
          end

          local opts = {
            -- Do not steal focus when it appears, but allow entering it with
            -- normal window navigation to select/copy the message.
            focusable = true,
            close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "line",
          }
          vim.diagnostic.show()
          local _, diagnostic_win = vim.diagnostic.open_float(nil, opts)
          vim.b[bufnr].lsp_diagnostic_float_win = diagnostic_win
        end,
      })

      local auto_format_servers = { "rust_analyzer", "hls", "mesonlsp", "taplo" }
      if vim.tbl_contains(auto_format_servers, client.name) then
        local group = vim.api.nvim_create_augroup("LspSaveFormat_" .. client.name, { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, bufnr = bufnr, id = client.id })
          end,
        })
      end

      if client.name == "gopls" then
        local augroup = vim.api.nvim_create_augroup("GoplsFormatting", { clear = false })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            _G.lsp_format(bufnr)
          end,
        })
      end
    '';
    inlayHints.enable = true;
    keymaps =
      let
        key_opts = {
          noremap = true;
          silent = true;
          buffer = true;
        };
      in
      (map (mapping: { mode = "n"; } // mapping) [
        {
          key = "gd";
          mode = "n";
          lspBufAction = "definition";
          options = key_opts // {
            desc = "Go to definition";
          };
        }
        {
          key = "gD";
          mode = "n";
          lspBufAction = "declaration";
          options = key_opts // {
            desc = "Go to declaration";
          };
        }
        {
          key = "gi";
          mode = "n";
          lspBufAction = "implementation";
          options = key_opts // {
            desc = "Go to implementation";
          };
        }
        {
          key = "gr";
          mode = "n";
          lspBufAction = "references";
          options = key_opts // {
            desc = "Find references";
          };
        }
        {
          key = "K";
          action.__raw = ''
            function()
              local current_buf = vim.api.nvim_get_current_buf()
              local diagnostic_win = vim.b[current_buf].lsp_diagnostic_float_win
              if diagnostic_win and vim.api.nvim_win_is_valid(diagnostic_win) then
                vim.api.nvim_win_close(diagnostic_win, true)
              end
              vim.b[current_buf].lsp_diagnostic_float_win = nil
              vim.lsp.buf.hover()
            end
          '';
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
          action.__raw = "function() _G.organize_imports_and_format(0) end";
          mode = [
            "n"
            "x"
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
      ]);
    servers = {
      gopls = {
        enable = true;
        packageFallback = true;
        config = {
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
        packageFallback = true;
        config = {
          settings = {
            nixd = {
              formatting = {
                command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              };
            };
          };
        };
      };
      taplo = {
        enable = true;
        packageFallback = true;
      };
      pyright = {
        enable = true;
        config = {
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
        packageFallback = true;
        config = {
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
        packageFallback = true;
      };
      html = {
        enable = true;
        packageFallback = true;
      };
      cssls = {
        enable = true;
        packageFallback = true;
      };
      ts_ls = {
        enable = true;
        packageFallback = true;
        config = {
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "vue"
          ];
          init_options.plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
              languages = [ "vue" ];
            }
          ];
        };
      };
      vue_ls = {
        enable = true;
        packageFallback = true;
      };
      bashls = {
        enable = true;
        packageFallback = true;
      };
      hls = {
        enable = true;
        packageFallback = true;
      };
      cmake = {
        enable = true;
        packageFallback = true;
      };
      mesonlsp = {
        enable = true;
        packageFallback = true;
      };
      clangd = {
        enable = true;
        packageFallback = true;
        config = {
          cmd.__raw = ''
            function(dispatchers, config)
              local function get_compile_commands_dir()
                local dir = os.getenv("COMPILE_COMMANDS_DIR")
                if dir and vim.fn.isdirectory(dir) == 1 then
                  return dir
                end
                local build = (config.root_dir or vim.fn.getcwd()) .. "/build"
                if vim.fn.filereadable(build .. "/compile_commands.json") == 1 then
                  return build
                end
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

              local function get_query_drivers()
                local detected = {
                  vim.fn.exepath("clang"),
                  vim.fn.exepath("clang++"),
                  vim.fn.exepath("gcc"),
                  vim.fn.exepath("g++"),
                  vim.fn.exepath("c++"),
                  os.getenv("CLANG_PATH") or "",
                  os.getenv("CXX") or "",
                }

                local valid = {}
                local seen = {}
                for _, d in ipairs(detected) do
                  if d and d ~= "" and not seen[d] then
                    table.insert(valid, d)
                    seen[d] = true
                  end
                end

                if #valid == 0 then
                  return "${pkgs.clang}/bin/clang,${pkgs.clang}/bin/clang++,${pkgs.gcc}/bin/gcc,${pkgs.gcc}/bin/g++"
                end

                return table.concat(valid, ",")
              end

              local cmd = {
                get_clangd_path(),
                "--enable-config",
                "--pch-storage=memory",
                "--background-index",
                "--clang-tidy",
                "--log=verbose",
                "--all-scopes-completion",
                "--header-insertion=iwyu",
                "--fallback-style=LLVM",
                "--completion-style=detailed",
                "--function-arg-placeholders=true",
                "--pretty",
                "--query-driver=" .. get_query_drivers(),
              }
              local compile_commands_dir = get_compile_commands_dir()
              if compile_commands_dir then
                table.insert(cmd, "--compile-commands-dir=" .. compile_commands_dir)
              end
              return vim.lsp.rpc.start(cmd, dispatchers, {
                cwd = config.cmd_cwd or config.root_dir,
                env = config.cmd_env,
                detached = config.detached,
              })
            end
          '';
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
