{ pkgs, ... }:
{
  plugins.none-ls = {
    enable = true;

    sources = {
      formatting = {
        black.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        gofumpt.enable = true;
        nixfmt.enable = true;
        shfmt.enable = true;
        stylua = {
          enable = true;
          settings = {
            extra_args = [
              "--indent-type"
              "Spaces"
              "--indent-width"
              "2"
            ];
          };
        };
        clang_format.enable = true;
        cmake_format.enable = true;
        gn_format.enable = true;
      };
    };

    settings = {
      on_attach = ''
        function(client, bufnr)
          local exclude_ft = { "c", "cpp", "h" }
          local filetype = vim.bo[bufnr].filetype

          if client:supports_method("textDocument/formatting") and not vim.tbl_contains(exclude_ft, filetype) then
            local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end
      '';
    };

    luaConfig.post = ''
      _G.gen_clangformat_config = function()
        local root = _G.root_dir or vim.fn.getcwd()

        if not root then
          vim.notify("Could not determine project root!", vim.log.levels.ERROR)
          return
        end

        local path = root .. "/.clang-format"

        local content = {
          "---",
          "Language: Cpp",
          "BasedOnStyle: LLVM",
          "ColumnLimit: 100",
          "",
          "# Align trailing comments continuously, allowing 1 empty line gap",
          "AlignTrailingComments:",
          "  Kind: Always",
          "  OverEmptyLines: 1",
          "",
          "# Pointer alignment: int* a instead of int *a",
          "PointerAlignment: Left",
          "",
          "# Allow very short functions on a single line",
          "AllowShortFunctionsOnASingleLine: Inline",
          "..."
        }

        if vim.fn.filereadable(path) == 1 then
          local choice = vim.fn.confirm(".clang-format already exists. Overwrite?", "&Yes\n&No", 2)
          if choice ~= 1 then return end
        end

        vim.fn.writefile(content, path)
        vim.notify("Generated .clang-format in " .. root, vim.log.levels.INFO)
      end

      vim.api.nvim_create_user_command("GenClangFormatConfig", _G.gen_clangformat_config, { desc = "Manually generate optimal .clang-format configuration file" })
    '';
  };
}
