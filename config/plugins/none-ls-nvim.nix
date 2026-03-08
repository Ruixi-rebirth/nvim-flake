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
  };
}
